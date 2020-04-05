function [data,dataid1,dataid2,idprediksi,textout]=getdata(conn,conn1)
%% Get data from database 
%% Set preferences
prefs = setdbprefs('DataReturnFormat');
setdbprefs('DataReturnFormat','table')
%% Execute query and fetch results
curs = exec(conn,['SELECT * ' ...
    'FROM weather.rata_cuaca']);
curs = fetch(curs);
data = curs.Data;

curs1 = exec(conn,['SELECT id ' ...
    'FROM weather.prediksicuacas']);
curs1 = fetch(curs1);
dataid1 = curs1.Data;


%% Execute query and fetch results
curs2 = exec(conn1,['SELECT id, ' ...
    '	datetime ' ...
    'FROM u726548613_ynade.prediksicuacas']);
curs2 = fetch(curs2);
dataid2 = curs2.Data;


curs3 =  exec(conn1,['SELECT prediksicuaca_id ' ...
    'FROM u726548613_ynade.prediksiikans']);
curs3 = fetch(curs3);
idprediksi = curs3.Data;

textout='Pengambilan data dari webserver berhasil';