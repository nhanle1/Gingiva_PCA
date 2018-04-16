function varargout = HDcamReg(varargin)
% HDCAMREG MATLAB code for HDcamReg.fig
%      HDCAMREG, by itself, creates a new HDCAMREG or raises the existing
%      singleton*.
%
%      H = HDCAMREG returns the handle to a new HDCAMREG or the handle to
%      the existing singleton*.
%
%      HDCAMREG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HDCAMREG.M with the given input arguments.
%
%      HDCAMREG('Property','Value',...) creates a new HDCAMREG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HDcamReg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HDcamReg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HDcamReg

% Last Modified by GUIDE v2.5 13-Apr-2018 18:22:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @HDcamReg_OpeningFcn, ...
    'gui_OutputFcn',  @HDcamReg_OutputFcn, ...
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


% --- Executes just before HDcamReg is made visible.
function HDcamReg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HDcamReg (see VARARGIN)
camList = webcamlist;

%% Set up Connection to Webcam
% Connect to the webcam.
cam = webcam(1);
cam.ExposureMode='manual';
cam.Exposure=-5;


%% Acquire a Frame
% To acquire a single frame, use the |snapshot| function.
img = snapshot(cam);

axes(handles.axes1);
% Display the frame in a figure window.
imshow(imcrop(snapshot(cam),[400 0 1080 1080]));

% Choose default command line output for HDcamReg
handles.output = hObject;
handles.runStat     =true;
handles.cam     =cam;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HDcamReg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HDcamReg_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Stop,'userdata',1);
temp='Stopped';
set(handles.status, 'String', temp);


[filename, foldername] = uiputfile('*.jpg;*.tif;*.png;*.gif;*.tiff',...
    'Where do you want the file saved?');
complete_name = fullfile(foldername, filename);
imwrite(handles.img, complete_name);


% --- Executes on button press in Open.
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName,~] = uigetfile(...
    '*.jpg;*.tif;*.png;*.gif;*.tiff','All Image Files');
handles.refimg  =imread([PathName,FileName]);
guidata(hObject,handles)



% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcbo,'userdata',1);
temp='Stopped';
set(handles.status, 'String', temp);
% handles.Stop    =1;



% --- Executes on button press in Preview.
function Preview_Callback(hObject, eventdata, handles)
% hObject    handle to Preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
temp='Running...';
set(handles.status, 'String', temp);
set(handles.Stop,'userdata',0);
while handles.runStat==true
%     drawnow();
%     handles=guidata(hObject);
    img = imcrop(snapshot(handles.cam),[400 0 1080 1080]);
    if isfield(handles, 'refimg')
        imshow(imadd(img/2,handles.refimg/2))
    else
            imshow(img);
    end

    handles.img=img;
    guidata(hObject,handles);
    if get(handles.Stop,'userdata') 
        break;
    end
end
