function varargout = prediktorgui(varargin)

% PREDIKTORGUI MATLAB code for prediktorgui.fig
%      PREDIKTORGUI, by itself, creates a new PREDIKTORGUI or raises the existing
%      singleton*.
%
%      H = PREDIKTORGUI returns the handle to a new PREDIKTORGUI or the handle to
%      the existing singleton*.
%
%      PREDIKTORGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREDIKTORGUI.M with the given input arguments.
%
%      PREDIKTORGUI('Property','Value',...) creates a new PREDIKTORGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prediktorgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prediktorgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prediktorgui

% Last Modified by GUIDE v2.5 16-Jul-2018 14:13:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prediktorgui_OpeningFcn, ...
                   'gui_OutputFcn',  @prediktorgui_OutputFcn, ...
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


% --- Executes just before prediktorgui is made visible.
function prediktorgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prediktorgui (see VARARGIN)

% Choose default command line output for prediktorgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prediktorgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = prediktorgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mkdir('C:\Users\Kaka\Documents\MATLAB\Prediktor Buoy\Prediktor Buoy\Prediktor Buoy')
addpath(genpath('C:\Users\Kaka\Documents\MATLAB\Prediktor Buoy\Prediktor Buoy\Prediktor Buoy'));

%% Konek ke server dan import data
[conn,textout{1}]=connect();                %Konek ke server
set(handles.text6,'string', textout{1});  
drawnow;

conn1=conn{1};
conn2=conn{2};

[data,dataid,iddate,idprediksi,textout{length(textout)+1}]=getdata(conn1,conn2);    %Pengambilan data dari webserver
set(handles.text7,'string', textout{length(textout)});  
drawnow;

%% Load model 
[jst,it2fis,wh,de,textout{length(textout)+1}]=model();
set(handles.text8,'string', textout{length(textout)});
drawnow;

%% Input arrangement
[dataset,id,textout{length(textout)+1}]=inputarrange(data,dataid);
    if day(dataset{1})==day(datetime('tomorrow')) && id==1
    set(handles.text9,'string', textout{length(textout)});
    drawnow;
    return
    end
%% Prediksi 
nday=7;     %jumlah prediksi hari
[hasilprediksi,textout{length(textout)+1}]=prediksi(dataset,jst,it2fis,de,nday,wh,dataset(5,:));
set(handles.text9,'string', textout{length(textout)}); 
drawnow;

%% KLASIFIKASI
[keterangan,hasilprediksi]=klasifikasi(hasilprediksi);

%% OUTPUT ARRANGEMENT
[prediksicuaca,prediksicuaca2]=outputarr(hasilprediksi,keterangan,nday,id);

id=prediksicuaca{2,9};

prediksiikan={'Biji Nangka'  hasilprediksi(2,11) id ; 'Cucut' hasilprediksi(2,9) id ;'Grobyak' hasilprediksi(2,10) id };
prediksiikan2={'Biji Nangka'  hasilprediksi(2,11); 'Cucut' hasilprediksi(2,9);'Grobyak' hasilprediksi(2,10)};

colnames1={'rata_suhu' 'rata_kelembapan' 'hujan_max' 'rata_kec_angin' 'mata_angin' 'rata_gelombang' 'cuaca' 'datetime' 'id'};
colnames2={'nama_ikan' 'berat' 'prediksicuaca_id'};
colnames1update={'rata_suhu' 'rata_kelembapan' 'hujan_max' 'rata_kec_angin' 'mata_angin' 'rata_gelombang' 'cuaca' 'datetime'};
colnames2update={'nama_ikan' 'berat'};

prediksi1=cell2table(prediksicuaca,'VariableNames',colnames1);
prediksi1_2=cell2table(prediksicuaca2,'VariableNames',colnames1update);
prediksi2=cell2table(prediksiikan,'VariableNames',colnames2); 
prediksi2_2=cell2table(prediksiikan2,'VariableNames',colnames2update); 

tablename{1,1}='prediksicuacas';
tablename{1,2}='prediksiikans';
coltypes1 = ["numeric" "numeric" "numeric" "numeric" "varchar" "double" "varchar" "timestamp" "numeric"];
coltypes1_2 = ["numeric" "numeric" "numeric" "numeric" "varchar" "double" "varchar" "timestamp"];
coltypes2 = ["varchar" "numeric" "numeric"];


conn1.Message
conn2.Message

%% Pengiriman Data ke Localhost

for nday=1:7
    coltypes=coltypes1;
    sqlwrite(conn1,tablename{1,1},prediksi1(nday,:),'ColumnType',coltypes);     
end

for nikan=1:3
    coltypes=coltypes2;
    sqlwrite(conn1,tablename{1,2},prediksi2(nikan,:),'ColumnType',coltypes);     
end

textout{(length(textout)+1)}='Insert Data ke Localhost Sukses';
set(handles.text10,'string', textout{length(textout)}); 
drawnow;



%% Pengiriman Data ke Server
date=transpose(datetime('now')+days(0:7));

% Insert data jika data pada hari ini tidak ada di database
a=0;
for i=1:height(iddate)
    id2{i}=iddate{i,1};
end

for i=1:height(iddate)
    date2{i}=datetime(iddate{i,2},'InputFormat','yyyy-MM-dd HH:mm:ss');
    if (day(date2{i})==day(date(1))) && (month(date2{i})==month(date(1))) && (year(date2{i})==year(date(1)))
        a=a+1;
    end
end

if a==0
for nday=1:8
    coltypes=coltypes1;
    sqlwrite(conn2,tablename{1,1},prediksi1(nday,:),'ColumnType',coltypes);  
end

for nikan=1:3
    coltypes=coltypes2;
    sqlwrite(conn2,tablename{1,2},prediksi2(nikan,:),'ColumnType',coltypes);     
end
textout{(length(textout)+1)}='Insert Data ke Webserver Sukses';
set(handles.text11,'string', textout{length(textout)});
drawnow;


% Update data jika tanggal hari ini ada di database
else
for i=1:8
    nrata(i)=0;
end


for n=1:height(iddate)
    for j=1:8
        
    if (day(date2{n})==day(date(j))) && (month(date2{n})==month(date(j))) && (year(date2{n})==year(date(j)))
        nrata(j)=nrata(j)+1;
        update(conn2,tablename{1,1},colnames1update,prediksi1_2(j,:),['WHERE id = ', num2str(id2{n})]);
        
        if (day(date2{n})==day(date(1))) && (month(date2{n})==month(date(1))) && (year(date2{n})==year(date(1)))
            coltypes=coltypes2;
            
            if id2{n+1}==idprediksi{height(idprediksi),1}
                for nikan=1:3
                update(conn2,tablename{1,2},colnames2update,prediksi2_2(j,:),['WHERE id = ',num2str(id2{n})]);
                end
            else
                for nikan=1:3
                    prediksi2(nikan,3)={[id2{n}+1]};
                    sqlwrite(conn2,tablename{1,2},prediksi2(nikan,:),'ColumnType',coltypes); 
                end
            end
        end
    end
        
    end
    end


for j=1:8
    if nrata(j)==0
       coltypes=coltypes1_2;
       prediksi1(j,9)=id2(n);
       sqlwrite(conn2,tablename{1,1},prediksi1_2(j,:),'ColumnType',coltypes)
    end
end
textout{(length(textout)+1)}='Insert Data ke Webserver Sukses';
set(handles.text11,'string', textout{length(textout)});
drawnow;

clear
end






% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton1 and none of its controls.
function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function statictext1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to statictext1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text6,'string','');
set(handles.text7,'string','');
set(handles.text8,'string','');
set(handles.text9,'string','');
set(handles.text10,'string','');
set(handles.text11,'string','');

clc


