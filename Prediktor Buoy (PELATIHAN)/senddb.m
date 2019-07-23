clc; clear; close all;

dbname='buoyweather_prediction';    %Nama database/datasource
conn = database(dbname, '', '');    %Koneksi ke database ('nama','user','password')
conn.Message

%% Inisialisasi tablename
dbtable(1).name='h1';
dbtable(2).name='h2';
dbtable(3).name='h3';
dbtable(4).name='h4';
dbtable(5).name='h5';
dbtable(6).name='h6';
dbtable(7).name='h7';

%% Data Prediksi 1 hari
% Penataan Data
id=1;
t=2;
rh=3;
ch=4;
ws=5;
wd=6;
wh=7;
ikan1=8;
ikan2=9;
ikan3=10;
data=table(id,t,rh,ch,ws,wd,wh,ikan1,ikan2,ikan3);
colnames={'id' 't' 'rh' 'ch' 'ws' 'wd' 'wh' 'ikan1' 'ikan2' 'ikan3'};

% Export data ke database
fastinsert(conn,dbtable(1).name,colnames,data)
disp('Insert Prediksi 1 Sukses');

%% Data Prediksi 2-7 hari
for ntable=2:7
    data=table(id,t,rh,ch,ws,wd);
    sqlwrite(conn,dbtable(ntable).name,colnames);
    
end
