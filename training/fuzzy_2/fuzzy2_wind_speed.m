clc;clear;close all;
%Prediktor Suhu - Interval Type 2 Fuzzy Inference System

%Import input data
%Inisialisasi Input dan Output data Excel
mkdir('C:\Users\Kaka\Documents\MATLAB\Hybrid Prediktor')
addpath(genpath('C:\Users\Kaka\Documents\MATLAB\Hybrid Prediktor'));
run('C:\Users\Kaka\Documents\MATLAB\Add-Ons\Collections\type-2-fuzzy-logic-systems-matlab-toolbox-master\fuzzyt2.m');
Lokasitrain='E:\Data Kaka\Kuliah\Teknik Fisika\Tugas Akhir\Tugas Akhir Kaka\Data-Data\Data Siap\Dengan Uji Outlier\TRAINING IT2FIS.xlsx';
Sheettrain=6;
suhut2fis=readt2fis('it2fisWS.t2fis');
Variabel='Kecepatan Angin';

DataIOtrain=xlsread(Lokasitrain,Sheettrain);   %Proses pembacaan data excel
JumlahVarInput=3;               %Jumlah Variabel Input
JumlahVarOutput=1;              %Jumlah Variabel Output

[r,s]=size(DataIOtrain);                 %Ukuran matriks database
Inputtrain=zeros(r,JumlahVarInput);      %Inisialisasi Input dengan nilai 0
Targettrain=zeros(r,JumlahVarOutput);    %Inisialisasi Output dengan nilai 0

%Penentuan dan penataaan matriks input 
for xin=1:JumlahVarInput
    for yin=1:r
       Inputtrain(yin,xin)=DataIOtrain(yin,xin);
    end
end

%Penentuan dan penataaan matriks target
for xtar=s-(JumlahVarOutput-1):s
    for ytar=1:r
        Targettrain(ytar,xtar-JumlahVarInput)=DataIOtrain(ytar,xtar);
    end
end

%Perhitungan jumlah baris dan kolom matriks pada Input dan Target
[o,p]=size(Targettrain);
[m,n]=size(Inputtrain);

Keluarantrain=evalt2(Inputtrain,suhut2fis);
Keluarantrain=round(Keluarantrain,1);

RMSEtrain = sqrt((1/m)*sum((Keluarantrain-Targettrain).^2));
MAPEtrain=(100/m)*sum(abs((Keluarantrain-Targettrain)./Targettrain));

% Menampilkan grafik hasil pelatihan
    figure,
    plot(Keluarantrain,'b')
    hold on
    plot(Targettrain,'r')
    hold off
    grid on
    title(strcat(['(TRAINING) Grafik Type 2 FIS vs Target dengan nilai RMSE = ',...
    num2str(RMSEtrain), ' MAPE= ',...
    num2str(MAPEtrain)]))
    xlabel('Hari Ke-')
    ylabel(Variabel)
    legend('Keluaran IT2FIS','Target','Location','Best')
    
%% UJI
%Inisialisasi Input dan Output data Excel
run('C:\Users\Kaka\Documents\MATLAB\Add-Ons\Collections\type-2-fuzzy-logic-systems-matlab-toolbox-master\fuzzyt2.m');
Lokasiuji='E:\Data Kaka\Kuliah\Teknik Fisika\Tugas Akhir\Tugas Akhir Kaka\Data-Data\Data Siap\Dengan Uji Outlier\UJI IT2FIS.xlsx';
Sheetuji=6;

DataIOuji=xlsread(Lokasiuji,Sheetuji);   %Proses pembacaan data excel

[k,l]=size(DataIOuji);                 %Ukuran matriks database
Inputuji=zeros(k,JumlahVarInput);      %Inisialisasi Input dengan nilai 0
Targetuji=zeros(k,JumlahVarOutput);    %Inisialisasi Output dengan nilai 0

%Penentuan dan penataaan matriks input 
for xin=1:JumlahVarInput
    for yin=1:k
       Inputuji(yin,xin)=DataIOuji(yin,xin);
    end
end

%Penentuan dan penataaan matriks target
for xtar=l-(JumlahVarOutput-1):l
    for ytar=1:k
        Targetuji(ytar,xtar-JumlahVarInput)=DataIOuji(ytar,xtar);
    end
end

%Perhitungan jumlah baris dan kolom matriks pada Input dan Target
[w,s]=size(Targetuji);
[a,b]=size(Inputuji);


Keluaranuji=evalt2(Inputuji,suhut2fis);
Keluaranuji=round(Keluaranuji,1);

RMSEuji = sqrt((1/a)*sum((Keluaranuji-Targetuji).^2));
MAPEuji=(100/a)*sum(abs((Keluaranuji-Targetuji)./Targetuji));

% Menampilkan grafik hasil pelatihan
    figure,
    plot(Keluaranuji,'b')
    hold on
    plot(Targetuji,'r')
    hold off
    grid on
    title(strcat(['(UJI) Grafik Type 2 FIS vs Target dengan nilai RMSE = ',...
    num2str(RMSEuji), ' MAPE= ',...
    num2str(MAPEuji)]))
    xlabel('Hari Ke-')
    ylabel(Variabel)
    legend('Keluaran IT2FIS','Target','Location','Best')