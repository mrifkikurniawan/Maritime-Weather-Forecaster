function [dataset2,id,textout]=inputarrange(data,dataid)
dataset2{1}=datetime('tomorrow');
id(1)=1;
[mdb,ndb]=size(data);

% Menentukan variabel berdasarkan database
for ndata=1:mdb
dataset{ndata,1}=datetime(data{ndata,13},'InputFormat','yyyy-MM-dd HH:mm:ss');
dataset{ndata,2}=str2double(data{ndata,2});     %Suhu
dataset{ndata,3}=str2double(data{ndata,3});     %Suhu minimum
dataset{ndata,4}=str2double(data{ndata,4});     %Suhu maksimum
dataset{ndata,5}=str2double(data{ndata,5});     %Kelembaban
dataset{ndata,6}=str2double(data{ndata,10});    %Curah hujan
dataset{ndata,7}=str2double(data{ndata,7});     %kec angin
dataset{ndata,8}=str2double(data{ndata,9});     %arah angin
dataset{ndata,9}=str2double(data{ndata,6});     %tekanan
dataset{ndata,10}=str2double(data{ndata,8});    %ket gelombang
dataset{ndata,11}=str2double(data{ndata,11});   %salinitas
dataset{ndata,12}=str2double(data{ndata,12});   %suhu air
end

datedb=dataset(:,1);
date=transpose(datetime('now')-days(0:4));

nrata=1;
nrata1=1;
nrata2=1;
nrata3=1;
nrata4=1;

for a=1:5
    nrowdata(a)=0;
end

for ndata=1:mdb
    if (day(datedb{ndata})==day(date(1))) && (month(datedb{ndata})==month(date(1))) && (year(datedb{ndata})==year(date(1)))
        rata2(5).data(nrata,:)=dataset(ndata,:);
        nrata=nrata+1;
        nrowdata(5)=1;
    elseif (day(datedb{ndata})==day(date(2))) && (month(datedb{ndata})==month(date(2))) && (year(datedb{ndata})==year(date(2)))
            rata2(4).data(nrata1,:)=dataset(ndata,:);
            nrata1=nrata1+1;
            nrowdata(4)=1;
    elseif (day(datedb{ndata})==day(date(3))) && (month(datedb{ndata})==month(date(3))) && (year(datedb{ndata})==year(date(3)))
            rata2(3).data(nrata2,:)=dataset(ndata,:);
            nrata2=nrata2+1;
            nrowdata(3)=1;
    elseif (day(datedb{ndata})==day(date(4))) && (month(datedb{ndata})==month(date(4))) && (year(datedb{ndata})==year(date(4)))
            rata2(2).data(nrata3,:)=dataset(ndata,:);
            nrata3=nrata3+1;
            nrowdata(2)=1;
    elseif (day(datedb{ndata})==day(date(5))) && (month(datedb{ndata})==month(date(5))) && (year(datedb{ndata})==year(date(5)))
            rata2(1).data(nrata4,:)=dataset(ndata,:);
            nrata4=nrata4+1;
            nrowdata(1)=1;
    end
end

b=4;
for a=1:5
    if nrowdata(a)==0
        if a==1
           textout='Data pada h-4 tidak tersedia';
        elseif a==2
           textout='Data pada h-3 tidak tersedia';
        elseif a==3
           textout='Data pada h-2 tidak tersedia';
        elseif a==4
           textout='Data pada h-1 tidak tersedia';
        elseif a==5
           textout='Data pada hari ini tidak tersedia';
        end
        return
    end
end
    
%% Penataan data (menghilangkan id)    
for nday=1:5
    [m,n]=size(rata2(nday).data);
    for nvar=2:12
        for ndata=1:m
        rata2_1(nday).data(ndata,nvar-1)=rata2(nday).data{ndata,nvar};
        end
    end
end

%% Merata-ratakan data yang didapat sesuai tanggal
for nday=1:5
    for nvar=1:11
        data_rata2{nday,nvar+1}=mean(rata2_1(nday).data(:,nvar));
    end
end

dataset2=data_rata2;
for nday=1:5
    dataset2{nday,1}=date(6-nday);
end    

[mdb1,ndb1]=size(dataid);
id=table2array(dataid(mdb1,1));
textout=[];



