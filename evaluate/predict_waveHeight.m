function [hasilprediksi]=prediksiwh(ws,p,dsuhu,netwh,hasilprediksi)
%% Prediksi Ketinggian Gelombang
nday=7;           %Jumlah hari prediksi
%Inisialisasi min max untuk normalisasi
min_angin=1;
max_angin=9;

min_airpress=1003.659;
max_airpress=1014.3;

min_bedasuhu=0.002743325;
max_bedasuhu=4.636413636;

min_gelomb=-0.11583;
max_gelomb=0.27417;

%Proses Normalisasi
whmin=[];
whmax=[];
norm_angin=(0.8*(ws-min_angin)/(max_angin-min_angin))+0.1;
norm_airpress=(0.8*(p-min_airpress)/(max_airpress-min_airpress))+0.1;
norm_bedasuhu=(0.8*(dsuhu-min_bedasuhu)/(max_bedasuhu-min_bedasuhu))+0.1;
inputnorm=[norm_angin;norm_airpress;norm_bedasuhu];

for nwh=1:nday
%Prses prediksi
keluaranjst=sim(netwh(nwh).net,inputnorm);

% Proses Denormalisasi
norm_gelomb=keluaranjst;
gelomb=abs(((norm_gelomb-0.1)*(max_gelomb-min_gelomb)/0.8)+min_gelomb);

hasilprediksi(nwh,8)=gelomb;  
disp(['Prediksi ketinggian gelombang ',num2str(nwh),' hari ke depan = ' num2str(gelomb)])
end
