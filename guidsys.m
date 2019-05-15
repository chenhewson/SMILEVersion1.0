function varargout = guidsys(varargin)
% GUIDSYS MATLAB code for guidsys.fig
%      GUIDSYS, by itself, creates a new GUIDSYS or raises the existing
%      singleton*.
%
%      H = GUIDSYS returns the handle to a new GUIDSYS or the handle to
%      the existing singleton*.
%
%      GUIDSYS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDSYS.M with the given input arguments.
%
%      GUIDSYS('Property','Value',...) creates a new GUIDSYS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guidsys_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guidsys_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guidsys

% Last Modified by GUIDE v2.5 11-May-2019 23:58:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guidsys_OpeningFcn, ...
                   'gui_OutputFcn',  @guidsys_OutputFcn, ...
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


% --- Executes just before guidsys is made visible.
function guidsys_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guidsys (see VARARGIN)

% Choose default command line output for guidsys
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guidsys wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(gcf,'numbertitle','off','name','算法对比系统');
axes(handles.axes10);
imshow(imread('.\UIfile\logo.jpg'));


% --- Outputs from this function are returned to the command line.
function varargout = guidsys_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    cla(handles.axes4);
    cla(handles.axes1);
    cla(handles.axes3);
%     cla(handles);
    global dataset;%数据集名称

    %----------------------------------------------------读取图像文件
    path=['.\Image\',dataset];
    impath=[path,'\img\*.jpg'];
%     addpath(path);
    img_dir = dir(impath);
    num = length(img_dir);

    %----------------------------------------------------读取各算法txt文件
    Boosting=['.\result\BoostingResult\',dataset,'\BoostingTracker.txt'];
    CSK=['.\result\CSKResult\',dataset,'.txt'];
    CT=['.\result\CTResult\',dataset,'\results.txt'];
    MIL=['.\result\MILResult\',dataset,'\results.txt'];
    Semi=['.\result\Semi-BoostingResult\',dataset,'\SemiBoostingTracker\SemiBoostingTracker.txt'];
    SMILE=['.\result\SMILEresult\',dataset,'\ALLresults.txt'];

    %----------------------------------------------------抽取txt内容
    [Boostinga,Boostingb,Boostingc,Boostingd]=textread(Boosting,'%d %d %d %d');
    [CSKa,CSKb,CSKc,CSKd]=textread(CSK,'%d %d %d %d');
    [CTa,CTb,CTc,CTd]=textread(CT,'%d %d %d %d');
    [MILa,MILb,MILc,MILd]=textread(MIL,'%d %d %d %d');
    [Semia,Semib,Semic,Semid]=textread(Semi,'%d %d %d %d');
    [SMILEa,SMILEb,SMILEc,SMILEd]=textread(SMILE,'%d %d %d %d');
    
    
    %--------------------------------------------------------抽取动态曲线数据
        which=['\',dataset,'.txt'];%选择测试集
        a='KCF';
        b='CSK';
        c='OLB';
        d='C.T';
        e='Sem';
        f='MIL';
        g='SMI';
        h='TLD';
        Datasets=[a;b;c;d;e;f;g;h];
        Dist=[];        
        for i=2:7
            dispath=['.\OTB\',Datasets(i,1:3),which];%跟踪结果Dist目录
            distance=textread(dispath);
            distance=distance(1:num-1,:);
            Dist=[Dist,distance];
        end


%-------------------------------------------显示图片和动态曲线
    
    global xxx;%判断是否跳出循环
    xxx=1;%点击按钮时，保证每次点击按钮都能执行for
    for i=2:num
        if(xxx==0)
            break;
        end
        if(i==num)
            xxx=0;
        end
        fprintf('%d,%d\n',num,i)
        image = imread([path,'\img\',img_dir(i).name]);
        axes(handles.axes1);
        imshow(image);%显示图片
        text(5, 18, strcat('#',num2str(i)), 'Color','r', 'FontWeight','bold', 'FontSize',25);
        %显示矩形框
        rectangle('Position',[SMILEa(i-1),SMILEb(i-1),SMILEc(i-1),SMILEd(i-1)],'LineWidth',2,'EdgeColor','r');
        rectangle('Position',[Boostinga(i-1),Boostingb(i-1),Boostingc(i-1),Boostingd(i-1)],'LineWidth',2,'EdgeColor','m');
        rectangle('Position',[CSKa(i-1),CSKb(i-1),CSKc(i-1),CSKd(i-1)],'LineWidth',2,'EdgeColor','c');
        rectangle('Position',[MILa(i-1),MILb(i-1),MILc(i-1),MILd(i-1)],'LineWidth',2,'EdgeColor','y');
        rectangle('Position',[Semia(i-1),Semib(i-1),Semic(i-1),Semid(i-1)],'LineWidth',2,'EdgeColor','b');
        rectangle('Position',[CTa(i-1),CTb(i-1),CTc(i-1),CTd(i-1)],'LineWidth',2,'EdgeColor','g');
        hold off;
%         cla reset;

%___________________________________________动态绘制曲线
        axes(handles.axes3);
        % set(gcf,'PaperUnits','centimeters','PaperPosition',[0,0,16.115,16.115*3/4],'PaperPositionMode', 'manual');
        plot(Dist(1:i-1,1),'cyan','LineWidth',2);
        hold on;
        plot(Dist(1:i-1,2),'magenta','LineWidth',2);
        hold on;
        plot(Dist(1:i-1,3),'green','LineWidth',2);
        hold on;
        plot(Dist(1:i-1,4),'blue','LineWidth',2);
        hold on;
        plot(Dist(1:i-1,5),'yellow','LineWidth',2);
        hold on;
        plot(Dist(1:i-1,6),'red','LineWidth',2);
        axis([0 length(Dist) 0 250]);%坐标轴的范围
        pause(0.00000001);
        hold off;
%         m(i)=getframe;%将当前图形存入矩阵m中
%         which=which(1,2:length(which)-4);
        drawnow();
        if i==num
             %-------------------------------------------显示精度图
            axes(handles.axes4);
            P=getPrecision('.\Image\','.\OTB\',dataset);
            plot(P(:,1),'cyan','LineWidth',2);
            hold on;
            plot(P(:,2),'magenta','LineWidth',2);
            hold on;
            plot(P(:,3),'green','LineWidth',2);
            hold on;
            plot(P(:,4),'blue','LineWidth',2);
            hold on;
            plot(P(:,5),'yellow','LineWidth',2);
            hold on;
            plot(P(:,6),'red','LineWidth',2);
            hold off;
%             pause();
        end
    end
   

   
        
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
val=get(handles.popupmenu1, 'value');

global dataset;
% clearvars -except val
switch val
    case 1
         h=dialog('name','无效数据集！','position',[200 200 200 70]);
         uicontrol('parent',h,'style','text','string','无效数据集！','position',[50 40 120 20],'fontsize',12);  
         uicontrol('parent',h,'style','pushbutton','position',[80 10 50 20],'string','确定','callback','delete(gcbf)');  
    case 2
        dataset='CarScale';
    case 3
        dataset='Crossing';
    case 4
        dataset='David3';
    case 5
        dataset='Deer';
    case 6
        dataset='Dog1';
    case 7
        dataset='Doll';
    case 8
        dataset='FaceOcc1';
end
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
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


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)%暂停按钮
uiwait();
% pause();
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)%继续按钮
uiresume();
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)


% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
clear all
cla reset

% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes7_CreateFcn(hObject, eventdata, handles)
imshow(logo);%显示图片
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes7


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)

% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes8_CreateFcn(hObject, eventdata, handles)
logo=imread('.\UIfile\logo.jpg');
imshow(logo);
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes8




function axes4_CreateFcn(hObject, eventdata, handles)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
