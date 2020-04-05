clc;clear;close all;

%Perancangan Neural Network Back Propagation

%Inisialisasi Input dan Output data Excel
Lokasi='E:\Data Kaka\Kuliah\Teknik Fisika\Tugas Akhir\Tugas Akhir Kaka\Data-Data\Data Siap\Dengan Uji Outlier\TRAINING & VALIDASI (JST).xlsx';
Variabel='Suhu Minimum';
Sheet=2;                        %Letak sheet pada excel

                     
DataIO=xlsread(Lokasi,Sheet);   %Proses pembacaan data excel
JumlahVarInput=4;               %Jumlah Variabel Input
JumlahVarOutput=1;              %Jumlah Variabel Output

[r,s]=size(DataIO);                              %Ukuran matriks database
Input=zeros(JumlahVarInput,r);                   %Inisialisasi Input dengan nilai 0
Target=zeros(JumlahVarOutput,r);                 %Inisialisasi Output dengan nilai 0


%Penentuan dan penataaan matriks input 
for xin=1:JumlahVarInput
    for yin=1:r
       Input(xin,yin)=DataIO(yin,xin);
    end
end

%Penentuan dan penataaan matriks output
for xtar=JumlahVarInput+1:JumlahVarInput+JumlahVarOutput
    for ytar=1:r
        Target(xtar-JumlahVarInput,ytar)=DataIO(ytar,xtar);
    end
end

%Perhitungan jumlah baris dan kolom matriks pada Input dan Target
[m,n]=size(Input);
[o,p]=size(Target);

%% NORMALISASI
%Normalisasi Data Input dan Target
data_normalisasiinput=zeros(m,n);
datamaksTmin=max(max(Input));
dataminTmin=min(min(Input));

for xin=1:m
    for yin=1:n
        data_normalisasiinput(xin,yin)=(Input(xin,yin)-dataminTmin)/(datamaksTmin-dataminTmin);
    end
end

data_normalisasitarget=zeros(o,p);
for xtar=1:o
    for ytar=1:p
        data_normalisasitarget(xtar,ytar)=(Target(xtar,ytar)-dataminTmin)/(datamaksTmin-dataminTmin); 
    end
end

Target=data_normalisasitarget;
Input=data_normalisasiinput;



%% SPESIFIKASI NN
training='trainlm';
ParameterGoal = 0.0001;
FailMaks=100;
RasioTraining=80;
RasioValidasi=20;
ParameterKonvergensi=0.001;
LearningRate=0.1;
AF1='tansig';                   %Fungsi Aktivasi Hidden Layer
AF2='tansig';                   %Fungsi Aktivasi output

k=0;                            %Insialisasi variabel k
pop=1;

bestnetTmin.net=inf;
bestnetTmin.rmse=inf;


%% TRAINING
%Proses Training
for epoch=[1000 2000 4000]       %Variasi Jumlah Epoch

    k=k+1;
    j=0;                    %Inisialisasi variabel j
    
    for i=[10 20 30 40 50]      %Variasi jumlah hidden 
    hiddenLayerSize = i;    %Jumlah hidden layer
    j=j+1;
    
    %Merancang neural network
    net = fitnet(hiddenLayerSize,training); 
    net.layers{1}.transferFcn = AF1;
    net.layers{2}.transferFcn = AF2;
    net.trainParam.lr=LearningRate;                     %Learning Rate
    net.trainFcn=training;
    net.trainParam.mu=ParameterKonvergensi;
    net.trainParam.goal = ParameterGoal;
    net.trainParam.max_fail=FailMaks;
    net.trainParam.epochs = epoch;                      %Jumlah epoch
    net.divideParam.trainRatio = RasioTraining/100;     %Menentukan rasio training data 
    net.divideParam.valRatio = RasioValidasi/100;       %Rasio validasi data
    net.divideParam.testRatio = 0/100;                  %Rasio test data
    
   
    [netoutput{k,j},tr,~,E] = train(net,Input,Target);  % Proses training
   
    
    %Inisialisasi Bobot masukan, hidden layer, dan bias NN hasil training
    weightsinput{k,j}= netoutput{k,j}.IW;
    weightshidden{k,j}= netoutput{k,j}.LW;
    biases{k,j}= netoutput{k,j}.b;
    
    % Proses prediksi
    hasil_latih = sim(netoutput{k,j},Input);
    
    % Denormalisasi
    HasilKeluaran = ((hasil_latih)*(datamaksTmin-dataminTmin))+dataminTmin;
    TargetAsli=((Target)*(datamaksTmin-dataminTmin))+dataminTmin;
    
    %Pembulatan hasil
    HasilKeluaran = round(HasilKeluaran,1);
    
    
    %% Perhitungan RMSE
    % RMSE Total
    errortot =HasilKeluaran-TargetAsli;
    MAPE(j,k)=(100/r)*sum(abs(errortot./TargetAsli));
    RMSE(j,k) = sqrt((1/r)*sum(errortot.^2));
    
    %% PENENTUAN BEST NET
    pop=pop;
    fullnetoutput(pop).rmse=RMSE(j,k);
    fullnetoutput(pop).MAPE=MAPE(j,k);
    fullnetoutput(pop).net=netoutput(k,j);
    
    
    if fullnetoutput(pop).rmse<bestnetTmin.rmse
       bestnetTmin=fullnetoutput(pop);
    end
    
        %% Grafik
    
    % Menampilkan grafik hasil pelatihan
    figure,
    plot(HasilKeluaran,'b')
    hold on
    plot(TargetAsli,'r')
    hold off
    grid on
    title(strcat(['Grafik Keluaran JST vs Target dengan nilai RMSE= ',...
    num2str(RMSE(j,k)),' MAPE= ',...
    num2str(MAPE(j,k)),'%']))
    xlabel('Hari Ke-')
    ylabel(Variabel)
    legend('Keluaran JST','Target','Location','Best')
    
    pop=pop+1;
    
    nhidden(j,:)=i;
    end  
 
end

%% PLOTTING
% Menampilkan grafik hasil terakhir
figure,
plot(HasilKeluaran,'b')
hold on
plot(TargetAsli,'r')
hold off
grid on
title(strcat(['Grafik Keluaran JST vs Target dengan nilai RMSE = ',...
num2str(RMSE(j,k)),' MAPE= ',...
num2str(MAPE(j,k)),'%']))
xlabel('Hari Ke-')
ylabel(Variabel)
legend('Keluaran JST','Target','Location','Best')

%Plot Grafik RMSE
plot(nhidden,RMSE);
title(strcat(['Nilai RMSE']));
xlabel('Jumlah Hidden Node')
ylabel('RMSE')
legend('Epoch 1000','Epoch 2000','Epoch 4000')


%% SIMULASI BEST NET
bestnetTmin.output = sim(bestnetTmin.net{1,1},Input);
    
% Denormalisasi
bestnetTmin.output = ((bestnetTmin.output)*(datamaksTmin-dataminTmin))+dataminTmin;
TargetBest=((data_normalisasitarget)*(datamaksTmin-dataminTmin))+dataminTmin;
%Pembulatan hasil
bestnetTmin.output = round(bestnetTmin.output,1);

%Penentuan Data Training
train=round(RasioTraining/100*r,0);
    for v=1:train
        outputrain(:,v)=bestnetTmin.output(:,v);    
    end

    for l=1:train
        targetrain(:,l)=TargetBest(:,l);
    end

    %Penentuan Data Validasi
    for v2=train+1:n
        outputval(:,v2-train)=bestnetTmin.output(:,v2);
    end
    for l2=train+1:n
        targetval(:,l2-train)=TargetBest(:,l2);
    end
    
% RMSE dan MAPE Training
error_train =outputrain-targetrain;
rmse_train = sqrt((1/train)*sum(error_train.^2));
mape_train=(100/train)*sum(abs(error_train./targetrain));

% RMSE dan MAPE Validasi
error_val=outputval-targetval;
rmse_val=sqrt((1/(r-train))*sum(error_val.^2));
mape_val=(100/(r-train))*sum(abs(error_val./targetval));
        
%% PLOTTING
% Menampilkan grafik hasil terakhir
figure,
plot(outputrain,'b')
hold on
plot(targetrain,'r')
hold off
grid on
title(strcat(['(TRAINING) Grafik Keluaran JST vs Target dengan nilai RMSE = ',...
num2str(rmse_train), ' MAPE= ',...
num2str(mape_train),'%']))
xlabel('Hari Ke-')
ylabel(Variabel)
legend('Keluaran JST','Target','Location','Best')

figure,
plot(outputval,'b')
hold on
plot(targetval,'r')
hold off
grid on
title(strcat(['(VALIDASI) Grafik Keluaran Best JST vs Target dengan nilai RMSE = ',...
num2str(rmse_val),' MAPE= ',...
num2str(mape_val),'%']))
xlabel('Hari Ke-')
ylabel(Variabel)
legend('Keluaran Best JST','Target','Location','Best')




