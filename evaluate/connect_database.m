function [conn,textout]=connect()
%Koneksi Localhost
% %% Automate Importing Data by Generating Code Using the Database Explorer App
% 
%% Set preferences
prefs = setdbprefs('DataReturnFormat');
setdbprefs('DataReturnFormat','table')

%% Make connection to database 1 
conn = database('weather','root','');
conn.Message


%% Make connection to database 2
conn1 = database('u726548613_ynade','u726548613_yjata','');
conn1.Message

conn={conn conn1};
textout='Koneksi berhasil';
