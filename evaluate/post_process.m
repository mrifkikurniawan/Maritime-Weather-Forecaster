function [prediksicuaca,prediksicuaca2]=outputarr(hasilprediksi,keterangan,day,id)
%%Output arrangement

np=1;

for nvar=[1 4 5 6]
    for nday=1:8
    prediksicuaca{nday,np}=hasilprediksi(nday,nvar);
    prediksicuaca2{nday,np}=hasilprediksi(nday,nvar);
    end
    np=np+1;
end

for nday=1:8
prediksicuaca{nday,5}=keterangan(nday,2);
prediksicuaca{nday,6}=hasilprediksi(nday,8);
prediksicuaca{nday,7}=keterangan(nday,1);
prediksicuaca2{nday,5}=keterangan(nday,2);
prediksicuaca2{nday,6}=hasilprediksi(nday,8);
prediksicuaca2{nday,7}=keterangan(nday,1);
end

date=transpose(datetime('now')+days(0:7));
for nday=1:8
prediksicuaca{nday,8}=date(nday,1);
prediksicuaca2{nday,8}=datestr(date(nday,1),'yyyy-mm-dd HH:MM:SS');
end


for nday=1:8
prediksicuaca{nday,9}=id+nday;
end

