function varargout = GetDataset(varargin)
% GETDATASET MATLAB code for GetDataset.fig
%      GETDATASET, by itself, creates a new GETDATASET or raises the existing
%      singleton*.
%
%      H = GETDATASET returns the handle to a new GETDATASET or the handle to
%      the existing singleton*.
%
%      GETDATASET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GETDATASET.M with the given input arguments.
%
%      GETDATASET('Property','Value',...) creates a new GETDATASET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GetDataset_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GetDataset_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GetDataset

% Last Modified by GUIDE v2.5 11-May-2019 19:50:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GetDataset_OpeningFcn, ...
                   'gui_OutputFcn',  @GetDataset_OutputFcn, ...
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


% --- Executes just before GetDataset is made visible.
function GetDataset_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GetDataset (see VARARGIN)

% Choose default command line output for GetDataset
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(gcf,'numbertitle','off','name','数据集采集系统');
axes(handles.axes2);
imshow(imread('.\UIfile\logo.jpg'));

% UIWAIT makes GetDataset wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GetDataset_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global filepath;
filepath = uigetdir('*.*','请选择文件夹');
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global filepath;
global flag;
flag=1;
if isempty(filepath)==1
    msgbox('请先选择正确路径！','Error','error');
else
    axes(handles.axes1);
    Videopath=[filepath,'\TempVideo.avi'];

    if exist(Videopath,'file')==2
       delete(Videopath);
    end
    vid = videoinput('winvideo',1,'YUY2_640x480');
    set(vid,'ReturnedColorSpace','rgb');
    vidRes = get(vid, 'VideoResolution');%获得分辨率参数
    nBands = get(vid, 'NumberOfBands');%获得维度参数
    hImage = image( zeros(vidRes(2), vidRes(1), nBands) );%axes1是我定义的坐标轴
    preview(vid,hImage);
    writerObj = VideoWriter(Videopath);
    % writerObj.FrameRate = 30;
    open(writerObj);
    % figure;
    set(handles.edit3,'string','数据集采集中...');
    while flag
        frame = getsnapshot(vid);
    %     imshow(frame);
        f.cdata = frame;
        f.colormap = [];
        writeVideo(writerObj,f);
    end
    objects = imaqfind %find video input objects in memory
    delete(objects)
    close(writerObj);
    set(handles.edit3,'String',['视频已存放于：',filepath]);
    a=msgbox('采集完成', 'help');
    pause(2);
try
    close(a);
catch
end
end

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on edit1 and none of its controls.
% hObject    handle to edit1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global filepath;
global flag;
flag=0;




% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
