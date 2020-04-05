function [hasilprediksi]=prediksiiikan(spl,sal,ch,nday,hasilprediksi)
idata=1;

%Normalisasi data input
min_spl = 28.37541297;
max_spl = 29.75967485;
min_s = 33.73162676;
max_s = 34.61056303;
min_ch = 0;
max_ch = 0.976675974;

Nspl = ((0.8*(spl-min_spl))/(max_spl-min_spl))+0.1;
Ns = ((0.8*(sal-min_s))/(max_s-min_s))+0.1;
Nch = ((0.8*(ch-min_ch))/(max_ch-min_ch))+0.1;

variabelinput = [Nspl Ns Nch];

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%IKAN CUCUT

%Bobot ikan cucut
min_design_variabel3 = [0.193415826	0.327903107	0.360915528	0.548434781	0.755815273	-0.361045228	0.329892473	0.44257683	0.908035191	-0.856422287	-0.609906778	-0.749955893	-0.803046992	-0.773481153	0.46697375	0.778293398	0.777326372	0.393580812	-0.260962735	0.243920559	0.212594235	0.226517893	0.431058341	-0.565442625	-0.363379825	0.562821925	-0.618966693	0.55785137	0.677217176	0.890931979	-0.467076747	0.341668455	0.794414324	-0.384763131	0.023610138	-0.841977922	0.651214267	-0.058356341	-0.262067091	0.523324512	0.894723792	-0.550008345	0.592937081	-0.739129771	0.987195956	-0.283223422];

% 1 individu = seluruh bobot     
v1=min_design_variabel3(:,1)';     %input variabel independen SPL ke hidden node 1
v2=min_design_variabel3(:,2)';     %input variabel independen Salinintas ke hidden node 1
v3=min_design_variabel3(:,3)';     %input variabel independen Curah Hujan ke hidden node 1
v4=min_design_variabel3(:,4)';     %bias ke hidden node 1

v5=min_design_variabel3(:,5)';     %input variabel independen SPL ke hidden node 2
v6=min_design_variabel3(:,6)';     %input variabel independen Salinintas ke hidden node 2
v7=min_design_variabel3(:,7)';     %input variabel independen Curah Hujan ke hidden node 2
v8=min_design_variabel3(:,8)';     %bias ke hidden node 2

v9=min_design_variabel3(:,9)';     %input variabel independen SPL ke hidden node 3
v10=min_design_variabel3(:,10)';   %input variabel independen Salinintas ke hidden node 3
v11=min_design_variabel3(:,11)';   %input variabel independen Curah Hujan ke hidden node 3
v12=min_design_variabel3(:,12)';   %bias ke hidden node 3

v13=min_design_variabel3(:,13)';   %input variabel independen SPL ke hidden node 4
v14=min_design_variabel3(:,14)';   %input variabel independen Salinintas ke hidden node 4
v15=min_design_variabel3(:,15)';   %input variabel independen Curah Hujan ke hidden node 4
v16=min_design_variabel3(:,16)';   %bias ke hidden node 4

v17=min_design_variabel3(:,17)';   %input variabel independen SPL ke hidden node 5
v18=min_design_variabel3(:,18)';   %input variabel independen Salinintas ke hidden node 5
v19=min_design_variabel3(:,19)';   %input variabel independen Curah Hujan ke hidden node 5
v20=min_design_variabel3(:,20)';   %bias ke hidden node 5

v21=min_design_variabel3(:,21)';   %input variabel independen SPL ke hidden node 6
v22=min_design_variabel3(:,22)';   %input variabel independen Salinintas ke hidden node 6
v23=min_design_variabel3(:,23)';   %input variabel independen Curah Hujan ke hidden node 6
v24=min_design_variabel3(:,24)';   %bias ke hidden node 6

v25=min_design_variabel3(:,25)';   %input variabel independen SPL ke hidden node 7
v26=min_design_variabel3(:,26)';   %input variabel independen Salinintas ke hidden node 7
v27=min_design_variabel3(:,27)';   %input variabel independen Curah Hujan ke hidden node 7
v28=min_design_variabel3(:,28)';   %bias ke hidden node 7

v29=min_design_variabel3(:,29)';   %input variabel independen SPL ke hidden node 8
v30=min_design_variabel3(:,30)';   %input variabel independen Salinintas ke hidden node 8
v31=min_design_variabel3(:,31)';   %input variabel independen Curah Hujan ke hidden node 8
v32=min_design_variabel3(:,32)';   %bias ke hidden node 8

v33=min_design_variabel3(:,33)';   %input variabel independen SPL ke hidden node 9
v34=min_design_variabel3(:,34)';   %input variabel independen Salinintas ke hidden node 9
v35=min_design_variabel3(:,35)';   %input variabel independen Curah Hujan ke hidden node 9
v36=min_design_variabel3(:,36)';   %bias ke hidden node 9

v37=min_design_variabel3(:,37)';   %hidden node 1 ke outputc
v38=min_design_variabel3(:,38)';   %hidden node 2 ke outputc
v39=min_design_variabel3(:,39)';   %hidden node 3 ke outputc
v40=min_design_variabel3(:,40)';   %hidden node 4 ke outputc
v41=min_design_variabel3(:,41)';   %hidden node 5 ke outputc
v42=min_design_variabel3(:,42)';   %hidden node 6 ke outputc 
v43=min_design_variabel3(:,43)';   %hidden node 7 ke outputc
v44=min_design_variabel3(:,44)';   %hidden node 8 ke outputc
v45=min_design_variabel3(:,45)';   %hidden node 9 ke outputc
v46=min_design_variabel3(:,46)';   %bias ke outputc
      
%Input ke hidden         
a1c = variabelinput(1:idata,1)*v1;
b1c = variabelinput(1:idata,2)*v2;
c1c = variabelinput(1:idata,3)*v3;        %
d1c = ones(idata,1)*v4;                   %outputc bias
hn1c = [a1c b1c c1c d1c];

a2c = variabelinput(1:idata,1)*v5;
b2c = variabelinput(1:idata,2)*v6;
c2c = variabelinput(1:idata,3)*v7;
d2c = ones(idata,1)*v8;
hn2c = [a2c b2c c2c d2c];

a3c = variabelinput(1:idata,1)*v9;
b3c = variabelinput(1:idata,2)*v10;
c3c = variabelinput(1:idata,3)*v11;
d3c = ones(idata,1)*v12;
hn3c = [a3c b3c c3c d3c];

a4c = variabelinput(1:idata,1)*v13;
b4c = variabelinput(1:idata,2)*v14;
c4c = variabelinput(1:idata,3)*v15;
d4c = ones(idata,1)*v16;
hn4c = [a4c b4c c4c d4c];

a5c = variabelinput(1:idata,1)*v17;
b5c = variabelinput(1:idata,2)*v18;
c5c = variabelinput(1:idata,3)*v19;
d5c = ones(idata,1)*v20;
hn5c = [a5c b5c c5c d5c];

a6c = variabelinput(1:idata,1)*v21;
b6c = variabelinput(1:idata,2)*v22;
c6c = variabelinput(1:idata,3)*v23;
d6c = ones(idata,1)*v24;
hn6c = [a6c b6c c6c d6c];

a7c = variabelinput(1:idata,1)*v25;
b7c = variabelinput(1:idata,2)*v26;
c7c = variabelinput(1:idata,3)*v27;
d7c = ones(idata,1)*v28;
hn7c = [a7c b7c c7c d7c];

a8c = variabelinput(1:idata,1)*v29;
b8c = variabelinput(1:idata,2)*v30;
c8c = variabelinput(1:idata,3)*v31;
d8c = ones(idata,1)*v32;
hn8c = [a8c b8c c8c d8c];

a9c = variabelinput(1:idata,1)*v33;
b9c = variabelinput(1:idata,2)*v34;
c9c = variabelinput(1:idata,3)*v35;
d9c = ones(idata,1)*v36;
hn9c = [a9c b9c c9c d9c];


% Fungsi aktivasi hidden node         
for i = 1:idata
    nilaihn1c(i,1) = sum(hn1c(i,1:4));     %Langkah 4 JST
end         

for i = 1:idata
    nilaihn2c(i,1) = sum(hn2c(i,1:4));     %Langkah 4 JST
end      

for i = 1:idata
    nilaihn3c(i,1) = sum(hn3c(i,1:4));     %Langkah 4 JST
end   

for i = 1:idata
    nilaihn4c(i,1) = sum(hn4c(i,1:4));     %Langkah 4 JST
end  

for i = 1:idata
    nilaihn5c(i,1) = sum(hn5c(i,1:4));     %Langkah 4 JST
end   

for i = 1:idata
    nilaihn6c(i,1) = sum(hn6c(i,1:4));     %Langkah 4 JST
end   

for i = 1:idata
    nilaihn7c(i,1) = sum(hn7c(i,1:4));     %Langkah 4 JST
end   

for i = 1:idata
    nilaihn8c(i,1) = sum(hn8c(i,1:4));     %Langkah 4 JST
end   

for i = 1:idata
    nilaihn9c(i,1) = sum(hn9c(i,1:4));     %Langkah 4 JST
end   

% Hidden ke outputc          
fhn1c = tansig(nilaihn1c)*v37;
fhn2c = tansig(nilaihn2c)*v38;
fhn3c = tansig(nilaihn3c)*v39;
fhn4c = tansig(nilaihn4c)*v40;
fhn5c = tansig(nilaihn5c)*v41;
fhn6c = tansig(nilaihn6c)*v42;
fhn7c = tansig(nilaihn7c)*v43;
fhn8c = tansig(nilaihn8c)*v44;
fhn9c = tansig(nilaihn9c)*v45;
fhn10c = ones(idata,1)*v46; %bias pada outputc layer  

matrixc =[fhn1c,fhn2c,fhn3c,fhn4c,fhn5c,fhn6c,fhn7c,fhn8c,fhn9c,fhn10c];

for i = 1:idata         
    nilaionc(i,1)= sum(matrixc(i,1:10));      %Langkah 5 JST   
end                             

% Fungsi aktivasi outputc layer                          
prediksic = purelin(nilaionc);     

max_datac = 9205;           %Ganti nilai max
min_datac = 0;               %Ganti nilai min
outputcut = ((prediksic-0.1)*(max_datac-min_datac)/0.8)+min_datac;
disp(['Prediksi ikan cucut = ' num2str(outputcut)])

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%IKAN GROBYAK

min_design_variabel2 = [-0.507598407	0.939872684	0.237139928	-0.434527812	-0.478143194	0.243947262];

% 1 individu = seluruh bobot     
u1=min_design_variabel2(:,1)';     %input variabel independen
u2=min_design_variabel2(:,2)';     %input variabel independen
u3=min_design_variabel2(:,3)';     %input variabel independen
u4=min_design_variabel2(:,4)';     %bias ke hidden node

u5=min_design_variabel2(:,5)';     %hidden node 1
u6=min_design_variabel2(:,6)';     %bias ke outputb
      

%Input ke hidden         
a1b = variabelinput(1:idata,1)*u1;
b1b = variabelinput(1:idata,2)*u2;
c1b = variabelinput(1:idata,3)*u3;
d1b = ones(idata,1)*u4;                  
hn1b = [a1b b1b c1b d1b];

% Fungsi aktivasi hidden node         
for i = 1:idata
    nilaihn1b(i,1) = sum(hn1b(i,1:4));     %Langkah 4 JST
end         

% Hidden ke outputb          
fhn1b = tansig(nilaihn1b)*u5;         
fhn2b = ones(idata,1)*u6; %bias pada outputb layer  

matrixb =[fhn1b,fhn2b];

for i = 1:idata         
    nilaionb(i,1)= sum(matrixb(i,1:2));      %Langkah 5 JST   
end                            

% Fungsi aktivasi outputb layer                          
prediksib = purelin(nilaionb);     

max_datab = 5126;           %Ganti nilai max
min_datab = 0;               %Ganti nilai min
outputgrob = ((prediksib-0.1)*(max_datab-min_datab)/0.8)+min_datab;
disp(['Prediksi ikan grobyak = ' num2str(outputgrob)])

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%IKAN BIJI NANGKA

min_design_variabel = [0.493691915	-0.813865484	0.054120115	0.455768066	-0.626115442	-0.666536013	-0.909290227	-0.530120401	0.880729562	-0.063723625	0.857292039	-0.323405574	0.726035811	-0.817924326	-0.380086308	-0.517060773];
% 1 individu = seluruh bobot     
t1=min_design_variabel(:,1)';     %input variabel independen SPL ke hidden node 1
t2=min_design_variabel(:,2)';     %input variabel independen Salinintas ke hidden node 1
t3=min_design_variabel(:,3)';     %input variabel independen Curah Hujan ke hidden node 1
t4=min_design_variabel(:,4)';     %bias ke hidden node 1

t5=min_design_variabel(:,5)';     %input variabel independen SPL ke hidden node 2
t6=min_design_variabel(:,6)';     %input variabel independen Salinintas ke hidden node 2
t7=min_design_variabel(:,7)';     %input variabel independen Curah Hujan ke hidden node 2
t8=min_design_variabel(:,8)';     %bias ke hidden node 2

t9=min_design_variabel(:,9)';     %input variabel independen SPL ke hidden node 3
t10=min_design_variabel(:,10)';   %input variabel independen Salinintas ke hidden node 3
t11=min_design_variabel(:,11)';   %input variabel independen Curah Hujan ke hidden node 3
t12=min_design_variabel(:,12)';   %bias ke hidden node 3

t13=min_design_variabel(:,13)';   %hidden node 1 ke output
t14=min_design_variabel(:,14)';   %hidden node 2 ke output
t15=min_design_variabel(:,15)';   %hidden node 3 ke output
t16=min_design_variabel(:,16)';   %bias ke output
      

%Input ke hidden         
a1 = variabelinput(1:idata,1)*t1;
b1 = variabelinput(1:idata,2)*t2;
c1 = variabelinput(1:idata,3)*t3;
d1 = ones(idata,1)*t4;                  
hn1 = [a1 b1 c1 d1];

a2 = variabelinput(1:idata,1)*t5;
b2 = variabelinput(1:idata,2)*t6;
c2 = variabelinput(1:idata,3)*t7;
d2 = ones(idata,1)*t8;
hn2 = [a2 b2 c2 d2];

a3 = variabelinput(1:idata,1)*t9;
b3 = variabelinput(1:idata,2)*t10;
c3 = variabelinput(1:idata,3)*t11;
d3 = ones(idata,1)*t12;
hn3 = [a3 b3 c3 d3];

% Fungsi aktivasi hidden node         
for i = 1:idata
    nilaihn1(i,1) = sum(hn1(i,1:4));     %Langkah 4 JST
end        

for i = 1:idata
    nilaihn2(i,1) = sum(hn2(i,1:4));     %Langkah 4 JST
end        

for i = 1:idata
    nilaihn3(i,1) = sum(hn3(i,1:4));     %Langkah 4 JST
end  

% Hidden ke output          
fhn1 = tansig(nilaihn1)*t13;
fhn2 = tansig(nilaihn2)*t14;
fhn3 = tansig(nilaihn3)*t15;
fhn4 = ones(idata,1)*t16; %bias pada output layer  

matrix =[fhn1,fhn2,fhn3,fhn4];

for i = 1:idata         
    nilaion(i,1)= sum(matrix(i,1:4));      %Langkah 5 JST   
end                             

% Fungsi aktivasi output layer                          
prediksi = purelin(nilaion);     

max_data = 41090;           %Ganti nilai max
min_data = 0;               %Ganti nilai min
outputbn = ((prediksi-0.1)*(max_data-min_data)/0.8)+min_data;       
disp(['Prediksi ikan biji nangka = ' num2str(outputbn)])
            
hasilprediksi(nday,9)=outputcut;
hasilprediksi(nday,10)=outputgrob;
hasilprediksi(nday,11)=outputbn;
