clc;
clear;
close all;

mkdir('C:\Users\Kaka\Documents\MATLAB\Hybrid Prediktor')
addpath(genpath('C:\Users\Kaka\Documents\MATLAB\Hybrid Prediktor'));
Lokasi='E:\Data Kaka\Kuliah\Teknik Fisika\Tugas Akhir\Tugas Akhir Kaka\Data-Data\Data Siap\Dengan Uji Outlier\TRAINING (DE).xlsx';
run('C:\Users\Kaka\Documents\MATLAB\Add-Ons\Collections\type-2-fuzzy-logic-systems-matlab-toolbox-master\fuzzyt2.m');

varjst=7;          %variable JST
varit2fis=7;

%%Training Optimasi Differential Evolution
% 1. Running JST dengan data training & validasi
% 2. Running IT2FIS
% 3. Training DE berdasarkan output JST dan IT2FIS

%%% JST
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

%Running JST
for v=1:varjst

%% Input data JST
DataIOjst=xlsread(Lokasi,v);
[r,s]=size(DataIOjst);             %Ukuran matriks database
JumlahVarTarget=1;
JumlahVarInput=s-JumlahVarTarget;
Input=zeros(s-JumlahVarTarget,r);             %Inisialisasi Input dengan nilai 0
Target=zeros(JumlahVarTarget,r);              %Inisialisasi Output dengan nilai 0

%Penentuan dan penataaan matriks input 
for xin=1:JumlahVarInput
    for yin=1:r
       Input(xin,yin)=DataIOjst(yin,xin);
    end
end

%Penentuan dan penataaan matriks output
for xtar=JumlahVarInput+1:JumlahVarInput+JumlahVarTarget
    for ytar=1:r
        Target(xtar-JumlahVarInput,ytar)=DataIOjst(ytar,xtar);
    end
end

net(v).input=Input;
net(v).target=Target;

%% NORMALISASI
%Normalisasi Data Input dan Target

[m,n]=size(net(v).input);
[o,p]=size(net(v).target);
inputnorm=zeros(m,n);

for xin=1:m
    for yin=1:n
        inputnorm(xin,yin)=(Input(xin,yin)-net(v).datamin)/(net(v).datamax-net(v).datamin);
    end
end

targetnorm=zeros(o,p);
for xtar=1:o
    for ytar=1:p
        targetnorm(xtar,ytar)=(Target(xtar,ytar)-net(v).datamin)/(net(v).datamax-net(v).datamin); 
    end
end

net(v).inputnorm=inputnorm;
net(v).targetnorm=targetnorm;

%Proses Uji Prediksi
net(v).keluarannorm=sim(net(v).net{1,1},net(v).inputnorm);

%Denormalisasi
net(v).keluaran = ((net(v).keluarannorm))*(net(v).datamax-net(v).datamin)+net(v).datamin;
 
%Pembulatan hasil
net(v).keluaran=round(net(v).keluaran,1);
 
 %RMSE dan MAPE
 errortot =net(v).keluaran-net(v).target;
 net(v).MAPE=(100/n)*sum(abs(errortot./net(v).target));
 net(v).RMSE= sqrt((1/n)*sum(errortot.^2));
end

%%% IT2FIS

%Load IT2FIS Model
it2fis(1).model=readt2fis('it2fisT.t2fis');
it2fis(2).model=readt2fis('it2fisTmin.t2fis');
it2fis(3).model=readt2fis('it2fisTmax.t2fis');
it2fis(4).model=readt2fis('it2fisRH.t2fis');
it2fis(5).model=readt2fis('it2fisCH.t2fis');
it2fis(6).model=readt2fis('it2fisWS.t2fis');
it2fis(7).model=readt2fis('it2fisWD.t2fis');


for v=1:varit2fis

%% Input data IT2FIS
DataIO=xlsread(Lokasi,v+varjst);
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
 
Gen=2000;       %Jumlah iterasi berdasarkan generasi
NP=1000;          %Jumlah populasi
D=2;            %Jumlah koefisien
mf=0.5;         %Mutation Factor
UpPar=1;        %Konstrain atas keofisien
LowPar=0;       %Konstrain bawah koefisien
CR=0.1;         %Crossover Ratio


for nv=1:varjst
A=transpose(net(nv).keluaran);
B=it2fis(nv).keluaran;
Prediksi=[A B];
Aktual=it2fis(nv).target;

bestpop(nv).bobot=inf;
bestpop(nv).rmse=inf;
bestpop(nv).keluaran=inf;
bestpop(nv).mape=inf;


[nx,ny]=size(it2fis(nv).keluaran);
Data=nx;         %Jumlah data training

%% Inisialisasi

emptyindividu.bobot=[];
emptyindividu.rmse=[];
emptyindividu.mape=[];
emptyindividu.keluaran=[];
pop=repmat(emptyindividu,NP,1);

mf1=repmat(mf,1,D);

for p=1:NP
  pop(p).bobot=unifrnd(LowPar,UpPar,[D 1]);
  error=Aktual-(round(Prediksi*pop(p).bobot,1));
  pop(p).rmse=sqrt((1/Data)*sum(error.^2));
  pop(p).keluaran=round(Prediksi*pop(p).bobot,1);
  pop(p).mape=(100/Data)*sum(abs((error)./Aktual));
  if pop(p).rmse<bestpop(nv).rmse
     bestpop(nv)=pop(p);  
  end
end

for It=1:Gen
    for i=1:NP 
        x=pop(i).bobot;
        Perm=randperm(NP);
        a=Perm(1);
        b=Perm(2);
        
        
        %% Mutasi
        v=(bestpop(nv).bobot)+(mf1*(pop(a).bobot-pop(b).bobot));

        %% Crossover
        u=zeros(D,1);
        jrand=unifrnd(1,D);
        for j=1:D
            if jrand==j || rand<=CR
                u(j)=v(j);
            else
                u(j)=x(j);
            end
        end
        
        newpop.bobot=u;
        newpop.rmse=sqrt((1/Data)*(sum((Aktual-(round(Prediksi*newpop.bobot,1))).^2)));
        newpop.keluaran=Prediksi*newpop.bobot;
        newpop.mape=(100/Data)*sum(abs((Aktual-(round(Prediksi*newpop.bobot,1))./Aktual)));
        
        
    
        %% Seleksi
        if newpop.rmse<pop(i).rmse
           pop(i)=newpop;
        end
        if pop(i).rmse<bestpop(nv).rmse
            bestpop(nv)=pop(i);
        end
        
    end
    
    popterbaik(It).bobot=bestpop(nv).bobot;
    popterbaik(It).rmse=bestpop(nv).rmse;
    
    
    disp(['Iteration' num2str(It) ': Best RMSE = ' num2str(popterbaik(It).rmse)]);
  
end
    popbest(nv).var=popterbaik;
    bestpop(nv).mape=(100/Data)*sum(abs((Aktual-(round(Prediksi*bestpop(nv).bobot,1)))./Aktual));
    bestpop(nv).keluaran=round(Prediksi*bestpop(nv).bobot,1);
end