%% This script is used for extracting spiking and LFP data for Putative 
%  Purkinje cells identified in Phy GUI after Spyking-Circus spike sorting.
%  The output of this script is fed into CS_Label_GUI for labeling Complex Spikes
%  Author - Aamir Abbasi
%  0 based index [0   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15];
%  Polytrode 0 - [21 17 53 18 57 22 23 30 55 61 32 63 59 19 20 28];
%  Polytrode 1 - [27 26 52 49 48 25 50 58 54 62 56 29 60 24 51 64];
%  Polytrode 2 - [5   8 44 47  1  7 31 40 42 36 46  3 38 10 45 34];
%  Polytrode 3 - [11 15 43 16 39 12  9  4 41 35  2 33 37 13 14  6];
% -------------------------------------------------------------------------------------------
%% DEFINE VARIABLES
clc; close all; clear;
% ON GOOGLE SHEET: Phy Channel ID refers to the polytrode channel where the
% spike was strongest. Make equal to Phy Channel ID on google sheet
good_cluster = 11;
%RS_Channel refers to channel in current polytrode as defined by reference
%chart above -OR- make RS_Channel equal to n on Google sheet
RS_Channel = 35;

% Script will ask for four file inputs
% 1. LFP SEV folder
% 2. FOLDER containing npy file for desired polytrode
% 4. Saving folder

%% READ LFP DATA FROM SEV FILES OF RS4 (NOT from DAT file)
disp('Extracting LFPs...');
%Select LFP SEV folder
PATHNAME = uigetdir;
addpath(genpath('C:\Users\DanielsenN\Documents\MATLAB\TDTSDK\TDTbin2mat'));
addpath(genpath('C:\Users\DanielsenN\Documents\MATLAB\npy-matlab-master\npy-matlab'));
Channel_id = RS_Channel+32; 
r = SEV2mat(PATHNAME,'CHANNEL',Channel_id);
% Extract M1 single units continous data
data = r.RSn1.data;
% Get ampling frequency
Fs = 24414;
% Get Nyquist frequency
Fn = Fs/2;
% ---- Filter LFP data ----
% Low pass filter
CutOff_freqs = [30, 400];
Wn = CutOff_freqs./Fn;
filterOrder = 2;
[b,a] = butter(filterOrder,Wn);
lfp_data = filtfilt(b,a,double(data));

disp('Extracting high pass spike continous data...'); 
% ---- Filter Spike data ----
% Low pass filter
CutOff_freqs = [30, 3000];
Wn = CutOff_freqs./Fn;
filterOrder = 2;
[b,a] = butter(filterOrder,Wn);
cont_data = filtfilt(b,a,double(data));
disp('Done!!!');

%% ---- Get Simple Spike Timestamps from Spyking-Circus ----
% Select gui folder w/ .npy file
disp('Extracting spike timestamps...');
disp('Select FOLDER containing npy file for desired polytrode')
NPY_filepath = uigetdir;
files = dir([NPY_filepath,'\spike*.npy']);
spike_times    = double(readNPY([NPY_filepath,'\',files(3).name]));
spike_clusters = readNPY([NPY_filepath,'\',files(1).name]);
spike_timestamps = spike_times(spike_clusters==good_cluster)';
disp('Done!!!');

%% ---- Save ----
disp('Saving...');
disp('Select folder you want to save in')
fid = fopen('PC_ID.txt','r'); 
pc_id = fscanf(fid,'%d');
savepath = uigetdir; % !!!-Pay attendtion to change the PC number in the savepath-!!!
save([savepath,'\PC',num2str(pc_id),'.mat'],'lfp_data','cont_data','spike_timestamps','Fs');
fid = fopen('PC_ID.txt','w');
fwrite(fid,num2str(pc_id+1));
disp('Done!!!');

%%