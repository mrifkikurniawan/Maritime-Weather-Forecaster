%clc; clear; close all;
%%% PREDIKSI N HARI KE DEPAN

day=7;   %Jumlah hari ke depan yang diprediksi
nvar=7;  %Jumlah variabel yang diprediksi
mkdir('C:\Users\Kaka\Documents\MATLAB\Hybrid Prediktor')
addpath(genpath('C:\Users\Kaka\Documents\MATLAB\Hybrid Prediktor'));
run('C:\Users\Kaka\Documents\MATLAB\Add-Ons\Collections\type-2-fuzzy-logic-systems-matlab-toolbox-master\fuzzyt2.m');

%% Load Dataset
%lokasi='E:\Data Kaka\Kuliah\Teknik Fisika\Tugas Akhir\Tugas Akhir Kaka\Data-Data\Data Siap\Dengan Uji Outlier\DATA FULL.xlsx';
%dataset=xlsread(lokasi,2);
%datasetasli=dataset;
%[m,n]=size(dataset);

% Load Data Max Min (untuk normalisasi JST)
load('maxTrata2.mat');
load('maxTmin.mat');
load('maxTmax.mat');
load('maxRH.mat');
load('maxCH.mat');
load('maxWS.mat');
load('maxWD.mat');

load('minTrata2.mat');
load('minTmin.mat');
load('minTmax.mat');
load('minRH.mat');
load('minCH.mat');
load('minWS.mat');
load('minWD.mat');
disp('Load data berhasil')

jst(1).datamax=datamaksT;
jst(1).datamin=dataminT;
jst(2).datamax=datamaksTmin;
jst(2).datamin=dataminTmin;
jst(3).datamax=datamaksTmax;
jst(3).datamin=dataminTmax;
jst(4).datamax=datamaksRH;
jst(4).datamin=dataminRH;
jst(5).datamax=datamaksCH;
jst(5).datamin=dataminCH;
jst(6).datamax=datamaksWS;
jst(6).datamin=dataminWS;
jst(7).datamax=datamaksWD;
jst(7).datamin=dataminWD;

%% Load model JST
load('Trata2.mat');
jst(1).net=bestnetTrata2.net{1,1};
load('Tmin.mat');
jst(2).net=bestnetTmin.net{1,1};
load('Tmax.mat');
jst(3).net=bestnetTmax.net{1,1};
load('RH.mat');
jst(4).net=bestnetRH.net{1,1};
load('CH.mat');
jst(5).net=bestnetCH.net{1,1};
load('WS.mat');
jst(6).net=bestnetWS.net{1,1};
load('WD.mat');
jst(7).net=bestnetWD.net{1,1};
disp('Load model JST berhasil');


%% LOAD MODEL IT2FIS
it2fis(1).model=readt2fis('it2fisT.t2fis');
it2fis(2).model=readt2fis('it2fisTmin.t2fis');
it2fis(3).model=readt2fis('it2fisTmax.t2fis');
it2fis(4).model=readt2fis('it2fisRH.t2fis');
it2fis(5).model=readt2fis('it2fisCH.t2fis');
it2fis(6).model=readt2fis('it2fisWS.t2fis');
it2fis(7).model=readt2fis('it2fisWD.t2fis');
disp('Load model IT2FIS berhasil');

%% LOAD MODEL HYBRID
load('bestDE.mat');
disp('Load model Hybrid berhasil');

%for ndata=5:m  
   %dataset=datasetasli;
   %disp(['Data ke ' num2str(ndata)])
   ndata=5;
   for nday=1:day
    disp(['Prediksi hari ke ' num2str(nday)]) 
    
    %Inisialisasi variabel input
    t=dataset(ndata,1);         %T(t)
    t24=dataset(ndata-1,1);     %T(t-24)
    tmin=dataset(ndata,2);      %Tmin(t)
    tmax=dataset(ndata,3);      %Tmax(t)
    rh=dataset(ndata,4);        %RH(t)
    rh24=dataset(ndata-1,4);    %RH(t-24)
    rh48=dataset(ndata-2,4);    %RH(t-48)
    ch=dataset(ndata,5);        %CH(t)
    ws=dataset(ndata,6);        %WS(t)
    ws24=dataset(ndata-1,6);    %WS(t-24)
    ws48=dataset(ndata-2,6);    %WS(t-48)
    ws72=dataset(ndata-3,6);    %WS(t-72)
    ws96=dataset(ndata-4,6);    %WS(t-96)
    wd=dataset(ndata,7);        %WD(t)
    wd24=dataset(ndata-1,7);    %WD(t-24)
    wd48=dataset(ndata-2,7);    %WD(t-48)
    wd72=dataset(ndata-3,7);    %WD(t-72)
    wd96=dataset(ndata-4,7);    %WD(t-96)
    
    %Inisialisasi input prediktor pada JST
    jst(1).input=[t;rh;tmax];
    jst(2).input=[t;t24;rh;tmin];
    jst(3).input=[t;t24;rh;tmax];
    jst(4).input=[t;rh;rh24;rh48;tmax];
    jst(5).input=[t;rh;wd24;wd48;wd72;wd96];
    jst(6).input=[ws;ws24;ws48;ws72;ws96];
    jst(7).input=[wd;wd24;wd48;wd72;wd96;ws24;ws48];
    
    %Inisialisasi input prediktor pada IT2FIS
    it2fis(1).input=[t rh];
    it2fis(2).input=[t tmin rh];
    it2fis(3).input=[t tmax rh];
    it2fis(4).input=[rh t rh24];
    it2fis(5).input=[ch rh t];
    it2fis(6).input=[ws48 ws24 ws];
    it2fis(7).input=[wd wd24 wd48 wd72];

    for v=1:nvar
           %% Proses JST
           %Normalisasi
           [xin,yin]=size(jst(v).input);
           datamax=repmat(jst(v).datamax,xin,1);
           datamin=repmat(jst(v).datamin,xin,1);
           inputjst=(jst(v).input-datamin)./(datamax-datamin);
           
           %Proses
           keluaranjst=sim(jst(v).net,inputjst);

           %Denormalisasi
           keluaranjst=(keluaranjst*(jst(v).datamax-jst(v).datamin))+jst(v).datamin;
           keluaranjst=round(keluaranjst,1);
           prediksijst(nday).keluaran(ndata,v)=keluaranjst;
           
           %% Processing IT2FIS
           keluaranit2fis=evalt2(it2fis(v).input,it2fis(v).model);
           keluaranit2fis=round(keluaranit2fis,1);
           prediksiit2fis(nday).keluaran(ndata,v)=keluaranit2fis;
                                 
           %% Proses Prediktor Hybrid
           output=[keluaranjst keluaranit2fis]*bestpop(v).bobot;
           output=round(output,1);
           if v==7
               if output<0
                   output=output+360;
               end
           end
           dataset(ndata+1,v)=output;
           hasilprediksi(nday).keluaran(ndata,v)=output;    
           
           if v==1
               disp(['keluaran prediktor suhu rata-rata= ' num2str(output)])
            elseif v==2
               disp(['keluaran prediktor suhu minimum= ' num2str(output)])
            elseif v==3
                disp(['keluaran prediktor suhu maksimum= ' num2str(output)])
            elseif v==4
                disp(['keluaran prediktor kelembaban= ' num2str(output)])
            elseif v==5
                disp(['keluaran prediktor curah hujan= ' num2str(output)])
            elseif v==6
                disp(['keluaran prediktor kecepatan angin= ' num2str(output)])
            elseif v==7
                disp(['keluaran prediktor arah angin= ' num2str(output)])
            end
                
    end
    ndata=ndata+1;
   end
    
