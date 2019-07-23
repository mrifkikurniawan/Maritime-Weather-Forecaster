clc ; close all; clear;

%%% UJI JST

mkdir('C:\Users\Kaka\Documents\MATLAB\Hybrid Prediktor')
addpath(genpath('C:\Users\Kaka\Documents\MATLAB\Hybrid Prediktor'));
Lokasi='E:\Data Kaka\Kuliah\Teknik Fisika\Tugas Akhir\Tugas Akhir Kaka\Data-Data\Data Siap\Dengan Uji Outlier\UJI JST.xlsx';
run('C:\Users\Kaka\Documents\MATLAB\Add-Ons\Collections\type-2-fuzzy-logic-systems-matlab-toolbox-master\fuzzyt2.m');
var=7;  %Jumlah Variabel

%% Load best net
load('Trata2.mat');
net(1)=bestnetTrata2;
load('Tmin.mat');
net(2)=bestnetTmin;
load('Tmax.mat');
net(3)=bestnetTmax;
load('RH.mat');
net(4)=bestnetRH;
load('CH.mat');
net(5)=bestnetCH;
load('WS.mat');
net(6)=bestnetWS;
load('WD.mat');
net(7)=bestnetWD;

%% Load Data Max Min
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

net(1).datamax=datamaksT;
net(1).datamin=dataminT;
net(2).datamax=datamaksTmin;
net(2).datamin=dataminTmin;
net(3).datamax=datamaksTmax;
net(3).datamin=dataminTmax;
net(4).datamax=datamaksRH;
net(4).datamin=dataminRH;
net(5).datamax=datamaksCH;
net(5).datamin=dataminCH;
net(6).datamax=datamaksWS;
net(6).datamin=dataminWS;
net(7).datamax=datamaksWD;
net(7).datamin=dataminWD;

%% PROSES UJI JST & PEMBACAAN DATA I/T
for sheet=1:7               %Letak sheet pada excel                     
DataIO=xlsread(Lokasi,sheet);   %Proses pembacaan data excel
[r,s]=size(DataIO);             %Ukuran matriks database
JumlahVarInput=s-1;
JumlahVarTarget=1;
Input=zeros(s-1,r);             %Inisialisasi Input dengan nilai 0
Target=zeros(1,r);              %Inisialisasi Output dengan nilai 0


%Penentuan dan penataaan matriks input 
for xin=1:JumlahVarInput
    for yin=1:r
       Input(xin,yin)=DataIO(yin,xin);
    end
end

%Penentuan dan penataaan matriks output
for xtar=JumlahVarInput+1:JumlahVarInput+JumlahVarTarget
    for ytar=1:r
        Target(xtar-JumlahVarInput,ytar)=DataIO(ytar,xtar);
    end
end

net(sheet).input=Input;
net(sheet).target=Target;
%% NORMALISASI
%Normalisasi Data Input dan Target

[m,n]=size(net(sheet).input);
[o,p]=size(net(sheet).target);
inputnorm=zeros(m,n);

for xin=1:m
    for yin=1:n
        inputnorm(xin,yin)=(Input(xin,yin)-net(sheet).datamin)/(net(sheet).datamax-net(sheet).datamin);
    end
end

targetnorm=zeros(o,p);
for xtar=1:o
    for ytar=1:p
        targetnorm(xtar,ytar)=(Target(xtar,ytar)-net(sheet).datamin)/(net(sheet).datamax-net(sheet).datamin); 
    end
end

net(sheet).inputnorm=inputnorm;
net(sheet).targetnorm=targetnorm;

%Proses Uji Prediksi
net(sheet).keluarannorm=sim(net(sheet).net{1,1},net(sheet).inputnorm);

%Denormalisasi
net(sheet).keluaran = ((net(sheet).keluarannorm))*(net(sheet).datamax-net(sheet).datamin)+net(sheet).datamin;
 
%Pembulatan hasil
net(sheet).keluaran=round(net(sheet).keluaran,1);
 
 %RMSE dan MAPE
 errortot =net(sheet).keluaran-net(sheet).target;
 net(sheet).MAPE=(100/n)*sum(abs(errortot./net(sheet).target));
 net(sheet).RMSE= sqrt((1/n)*sum(errortot.^2));
end

%%% UJI IT2FIS
%% Load Fuzzy
it2fis(1).model=readt2fis('it2fisT.t2fis');
it2fis(2).model=readt2fis('it2fisTmin.t2fis');
it2fis(3).model=readt2fis('it2fisTmax.t2fis');
it2fis(4).model=readt2fis('it2fisRH.t2fis');
it2fis(5).model=readt2fis('it2fisCH.t2fis');
it2fis(6).model=readt2fis('it2fisWS.t2fis');
it2fis(7).model=readt2fis('it2fisWD.t2fis');

Lokasi='E:\Data Kaka\Kuliah\Teknik Fisika\Tugas Akhir\Tugas Akhir Kaka\Data-Data\Data Siap\Dengan Uji Outlier\UJI IT2FIS.xlsx';
for v=1:var

%% Input data IT2FIS
DataIO=xlsread(Lokasi,v);
[r,s]=size(DataIO);             %Ukuran matriks database
JumlahVarTarget=1;
JumlahVarInput=s-JumlahVarTarget;
Input=zeros(r,JumlahVarInput);             %Inisialisasi Input dengan nilai 0
Target=zeros(r,JumlahVarTarget);              %Inisialisasi Output dengan nilai 0

%Penentuan dan penataaan matriks input 
for xin=1:JumlahVarInput
    for yin=1:r
       Input(yin,xin)=DataIO(yin,xin);
    end
end

%Penentuan dan penataaan matriks output
for xtar=JumlahVarInput+1:JumlahVarInput+JumlahVarTarget
    for ytar=1:r
        Target(ytar,xtar-JumlahVarInput)=DataIO(ytar,xtar);
    end
end

it2fis(v).input=Input;
it2fis(v).target=Target;

[o,p]=size(it2fis(v).target);
[m,n]=size(it2fis(v).input);

%Proses Running Input
it2fis(v).keluaran=evalt2(it2fis(v).input,it2fis(v).model);
it2fis(v).keluaran=round(it2fis(v).keluaran,1);

RMSE = sqrt((1/m)*sum((it2fis(v).keluaran-it2fis(v).target).^2));
MAPE=(100/m)*sum(abs((it2fis(v).keluaran-Target)./it2fis(v).target));

it2fis(v).rmse=RMSE;
it2fis(v).mape=MAPE;
end


%%% UJI HYBRID PREDIKTOR
load('bestDE.mat');

for nvar=1:var
A=transpose(net(nvar).keluaran);
B=it2fis(nvar).keluaran;
Prediksi=[A B];
hybrid(nvar).aktual=it2fis(nvar).target;

[m,n]=size(hybrid(nvar).aktual);
Data=m;
    
hybrid(nvar).keluaran=Prediksi*bestpop(nvar).bobot;
hybrid(nvar).keluaran=round(hybrid(nvar).keluaran,1);
error=hybrid(nvar).keluaran-hybrid(nvar).aktual;
hybrid(nvar).rmse=sqrt((1/Data)*sum(error.^2));
hybrid(nvar).mape=(100/Data)*sum(abs((error)./hybrid(nvar).aktual));

if nvar==1
   Variabel='Suhu Rata-Rata';
elseif nvar==2
   Variabel='Suhu Minimum';
elseif nvar==3
   Variabel='Suhu Maksimum';
elseif nvar==4
   Variabel='Kelembaban';
elseif nvar==5
   Variabel='Curah Hujan';
elseif nvar==6
    Variabel='Kecepatan Angin';
elseif nvar==7
    Variabel='Arah Angin';
end

figure,
plot(hybrid(nvar).keluaran,'b')
hold on
plot(it2fis(nvar).keluaran,'y')
plot(it2fis(nvar).target,'k')
hold off
grid on
title(strcat(['(VALIDASI) Grafik Keluaran Hybri vs JST vs IT2FIS dengan nilai RMSE = ',...
num2str(hybrid(nvar).rmse), ' MAPE= ',...
num2str(hybrid(nvar).mape),'%']))
xlabel('Data Ke-')
ylabel(Variabel)
legend('Keluaran Hybrid','JST','IT2FIS','Target','Location','Best')
end