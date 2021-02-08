function varargout = CS_Label_GUI(varargin)
% CS_LABEL_GUI MATLAB code for CS_Label_GUI.fig
%      CS_LABEL_GUI, by itself, creates a new CS_LABEL_GUI or raises the existing
%      singleton*.
%
%      H = CS_LABEL_GUI returns the handle to a new CS_LABEL_GUI or the handle to
%      the existing singleton*.
%
%      CS_LABEL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CS_LABEL_GUI.M with the given input arguments.
%
%      CS_LABEL_GUI('Property','Value',...) creates a new CS_LABEL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CS_Label_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CS_Label_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CS_Label_GUI

% Last Modified by GUIDE v2.5 21-Jan-2021 12:59:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CS_Label_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CS_Label_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before CS_Label_GUI is made visible.
function CS_Label_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CS_Label_GUI (see VARARGIN)

% Choose default command line output for CS_Label_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set a plot counter
global plotCounter;
plotCounter = 0;

% Set toolbar visible
set(hObject,'toolbar','figure');

% This sets up the initial plot - only do when we are invisible
% so window can get raised using CS_Label_GUI.
clc;
if strcmp(get(hObject,'Visible'),'off')
    axes(handles.axes1);
    zoom on;
    plot(sin(1:0.01:25.99));    
    axes(handles.axes4);
    zoom on;
    plot(sin(1:0.01:25.99));  
    linkaxes([handles.axes1 handles.axes4],'x')
end

% UIWAIT makes CS_Label_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = CS_Label_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});

% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pc_trace;
global timestamps;
global lfp_trace;
global fs;
global labels;
global PATHNAME;
global FILENAME;
[FILENAME, PATHNAME,~] = uigetfile;
load([PATHNAME,FILENAME]);
pc_trace = cont_data;
timestamps = spike_timestamps;
lfp_trace = lfp_data;
fs = Fs;
labels = zeros(1,length(pc_trace));
disp(FILENAME);
disp(PATHNAME);


% --- Executes on button press in plotbutton.
function plotbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plotbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pc_trace;
global timestamps;
global lfp_trace;
global fs;
global plotCounter;
axes(handles.axes1);
cla;
if round(1*fs)*(plotCounter+1)<length(pc_trace)
  ts = timestamps(timestamps>round(1*fs)*plotCounter & timestamps<round(1*fs)*(plotCounter+1))';
  time = (round(1*fs)*plotCounter+1:round(1*fs)*(plotCounter+1))./fs;
  plot(time, pc_trace(round(1*fs)*plotCounter+1:round(1*fs)*(plotCounter+1))); hold on;
  scatter(ts/fs,(-1*ones(1,length(ts)))/10000,'ro'); 
  axes(handles.axes4);
  cla;  
  plot(time, lfp_trace(round(1*fs)*plotCounter+1:round(1*fs)*(plotCounter+1))); hold on;  
  plotCounter = plotCounter+1;  
end

% --- Executes on button press in markbutton.
function markbutton_Callback(hObject, eventdata, handles)
% hObject    handle to markbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X;
[X,~] = ginput(2);
axes(handles.axes1);
%vline(X,'k--');
disp(X);
axes(handles.axes1);
zoom on 

% --- Executes on button press in updatebutton.
function updatebutton_Callback(hObject, eventdata, handles)
% hObject    handle to updatebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global labels;
global X;
labels(round(X(1)*24414):round(X(2)*24414)) = 1;
axes(handles.axes1);
zoom on 

% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global labels;
global X;
labels(round(X(1)*24414):round(X(2)*24414)) = 0;
axes(handles.axes1);
zoom on 

% --- Executes on button press in clearallbutton.
function clearallbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearallbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global labels;
global pc_trace;
labels = zeros(1,length(pc_trace));
axes(handles.axes1);
zoom on 


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global labels;
global pc_trace;
global lfp_trace;
global FILENAME;
global PATHNAME;
HIGH = pc_trace;
Labels = logical(labels);
RAW = lfp_trace;
savepath = [PATHNAME,'Marked\'];
if ~exist(savepath, 'dir')
    mkdir(savepath);
end
save([savepath,FILENAME],'HIGH','Labels','RAW');
axes(handles.axes1);
disp('Saving done!');
zoom on 
