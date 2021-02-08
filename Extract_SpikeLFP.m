%% This script is used for extracting spiking and LFP data for Putative 
%  Purkinje cells identified in Phy GUI after Spyking-Circus spike sorting.
%  The output of this script is fed into CS_Label_GUI for labeling Complex Spikes
%  Author - Aamir Abbasi
%% -------------------------------------------------------------------------------------------
clc; close all; clear;
PATHNAME = uigetdir;
%Get channel_id from Phy GUI: Channel id on Phy GUI + 1 + number of M1 channels eg. 4+1+32=37
Channel_id = 35+32; %n+32 get n from the google sheet!
r = SEV2mat(PATHNAME,'CHANNEL',Channel_id);

% Extract M1 single units continous data
data = r.RSn1.data;

% Get sampling frequency
Fs = 24414;

% Get Nyquist frequency
Fn = Fs/2;

% ---- Filter LFP data ----
% High pass filter
CutOff_freqs = [30, 400];
Wn = CutOff_freqs./Fn;
filterOrder = 2;
[b,a] = butter(filterOrder,Wn);
lfp_data = filtfilt(b,a,double(data));

% Notch filter parameters to remove 60Hz line noise
% d = designfilt('bandstopiir','FilterOrder',2, ...
%   'HalfPowerFrequency1',59.9,'HalfPowerFrequency2',60.1, ...
%   'DesignMethod','butter','SampleRate',Fs);
lfp_data = filtfilt(b,a,lfp_data);

%% ---- Get Spike data ----
nChans = 16; % 16 for polytrodes and 4 for tetrodes
phy_Chan = 11+1; % n+1 to convert python into matlab indicies get n from the google sheet
[FILENAME,PATHNAME] = uigetfile;
fiD = fopen([PATHNAME,FILENAME],'r');
cont_data = fread(fiD,'float32');
cont_data = reshape(cont_data,nChans,length(cont_data)/nChans);
cont_data = cont_data(phy_Chan,:);

%% ---- Get Simple Spike Timestamps from Spyking-Circus ----
NPY_filepath = uigetdir;
files = dir([NPY_filepath,'\spike*.npy']);
spike_times    = double(readNPY([NPY_filepath,'\',files(3).name]));
spike_clusters = readNPY([NPY_filepath,'\',files(1).name]);
good_cluster = 9; % Get this info from Phy GUI
spike_timestamps = spike_times(spike_clusters==good_cluster)';

%% ---- Save ----
savepath = uigetdir; % !!!-Pay attendtion to change the PC number in the savepath-!!!
save([savepath,'\PC9','.mat'],'lfp_data','cont_data','spike_timestamps','Fs');
