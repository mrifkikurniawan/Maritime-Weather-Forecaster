function [hasilprediksi2,textout]=prediksi(dataset,jst,it2fis,bestpop,jumlahprediksi,wh,dataset1)
day=jumlahprediksi;   %Jumlah hari ke depan yang diprediksi
nvar=7;  %Jumlah variabel yang diprediksi

for nn=1:12
    if nn==8
        continue
    elseif nn==9
        dataset2{1,nn-1}=dataset1{1,nn+1};
    elseif nn==10 || nn==11 || nn==12
        dataset2{1,nn}=0;
    else
    dataset2{1,nn}=dataset1{1,nn+1};
    end
end
    
    
   for nday=1:day
    disp(['Prediksi hari ke ' num2str(nday)]) 
    
    [kds,lds]=size(dataset);

%% Inisialisasi variabel input 

    t=dataset{kds,2};         %T(t)
    t24=dataset{kds-1,2};     %Suhu rata-rata(t-24)
    tmin=dataset{kds,3};      %Suhu minimum(t)
    tmax=dataset{kds,4};      %Suhu maksimum(t)
    rh=dataset{kds,5};        %Kelembaban(t)
    rh24=dataset{kds-1,5};    %Kelembaban(t-24)
    rh48=dataset{kds-2,5};    %Kelembaban(t-48)
    ch=dataset{kds,6};        %Curah hujan(t)
    ws=dataset{kds,7};        %Kecepatan angin(t)
    ws24=dataset{kds-1,7};    %Kecepatan angin(t-24)
    ws48=dataset{kds-2,7};    %Kecepatan angin(t-48)
    ws72=dataset{kds-3,7};    %Kecepatan angin(t-72)
    ws96=dataset{kds-4,7};    %Kecepatan angin(t-96)
    wd=dataset{kds,8};        %Arah angin(t)
    wd24=dataset{kds-1,8};    %Arah angin(t-24)
    wd48=dataset{kds-2,8};    %Arah angin(t-48)
    wd72=dataset{kds-3,8};    %Arah angin(t-72)
    wd96=dataset{kds-4,8};    %Arah angin(t-96)
    p=dataset{kds,9};         %Tekanan(t)
    waveh=dataset{kds,10};        %Ketinggian gelombang(t)
    spl=dataset{kds,11};      %Suhu permukaan laut(t)
    sal=dataset{kds,12};        %Salinitas(t)
    dsuhu=abs(spl-t);
    
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
    
    if nday==1
    %% Prediktor Ikan   
    hasilprediksi=prediksiikan(spl,sal,ch,nday);   %Prediksi ikan 1 hari ke depan
    
    %% Prediktor Waveheight
    modelwh=wh;
    hasilprediksi=prediksiwh(ws,p,dsuhu,modelwh,hasilprediksi);          %Prediksi ketinggian gelommbang
    end
    
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
           prediksijst(nday).keluaran(kds,v)=keluaranjst;
           
           %% Processing IT2FIS
           keluaranit2fis=evalt2(it2fis(v).input,it2fis(v).model);
           keluaranit2fis=round(keluaranit2fis,1);
           prediksiit2fis(nday).keluaran(kds,v)=keluaranit2fis;
                                 
           %% Proses Prediktor Hybrid
           output=[keluaranjst keluaranit2fis]*bestpop(v).bobot;
           output=round(output,1);
           if v==7
               if output<0
                   output=output+360;
               elseif output>360
                   output=output-360;
               end
           end
           dataset{kds+1,v+1}=output;
           hasilprediksi(nday,v)=output;    
           
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
   end
   dataset2=cell2mat(dataset2);
 
   for k=1:8
       if k==1
          hasilprediksi2(k,:)=dataset2;
       else
       hasilprediksi2(k,:)=hasilprediksi(k-1,:);
       end
   end
   
   textout='Mesin prediktor berhasil berjalan';