function [keterangan,hasilprediksi]=klasifikasi(hasilprediksi)

%% Klasifikasi curah hujan
for nday=1:8
if hasilprediksi(nday,5)<=5
    keterangan{nday,1}='Cerah';
elseif (hasilprediksi(nday,5)>5) && (hasilprediksi(nday,5)<=20)
        keterangan{nday,1}='Hujan Ringan';
elseif (hasilprediksi(nday,5)>20) && (hasilprediksi(nday,5)<=50)
    keterangan{nday,1}='Hujan Sedang';
elseif hasilprediksi(nday,5)>50
    keterangan{nday,1}='Hujan Lebat';
end


%% Klasifikasi arah angin
if (hasilprediksi(nday,7)>337.5)||(hasilprediksi(nday,7)<=22.5)
    keterangan{nday,2}='Utara';
elseif (hasilprediksi(nday,7)>22.5)&&(hasilprediksi(nday,7)<=67.5)
    keterangan{nday,2}='Timur Laut';
elseif (hasilprediksi(nday,7)>67.5)&&(hasilprediksi(nday,7)<=112.5)
    keterangan{nday,2}='Timur';
elseif (hasilprediksi(nday,7)>112.5)&&(hasilprediksi(nday,7)<=157.5)
    keterangan{nday,2}='Tenggara';
elseif (hasilprediksi(nday,7)>157.5)&&(hasilprediksi(nday,7)<=202.5)
    keterangan{nday,2}='Selatan';
elseif (hasilprediksi(nday,7)>202.5)&&(hasilprediksi(nday,7)<=247.5)
    keterangan{nday,2}='Barat Daya';
elseif (hasilprediksi(nday,7)>247.5)&&(hasilprediksi(nday,7)<=292.5)
    keterangan{nday,2}='Barat';
elseif (hasilprediksi(nday,7)>292.5)&&(hasilprediksi(nday,7)<=337.5)
    keterangan{nday,2}='Barat Laut';
end

%% Klasifikasi ketinggian gelombang
if hasilprediksi(nday,8)<1.25
   keterangan{nday,3}='Rendah';
elseif (hasilprediksi(nday,8)>=1.25)&&(hasilprediksi(nday,8)<2.5)
    keterangan{nday,3}='Sedang';
elseif (hasilprediksi(nday,8)>=2.5)&&(hasilprediksi(nday,8)<=4)
    keterangan{nday,3}='Tinggi';
elseif (hasilprediksi(nday,8)>4)
    keterangan{nday,3}='Sangat Tinggi';
end

end

%% Pembulatan
var=11;
for nday=1:8
    for nvar=1:var
        if nvar==5 
            hasilprediksi(nday,nvar)=round(hasilprediksi(nday,nvar),1);
        elseif nvar==8
            hasilprediksi(nday,nvar)=round(hasilprediksi(nday,nvar),2);
        else
            hasilprediksi(nday,nvar)=round(hasilprediksi(nday,nvar),0);
        end
    end
end