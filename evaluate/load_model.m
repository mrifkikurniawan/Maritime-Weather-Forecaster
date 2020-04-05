% Tahap ini merupakan tahap di mana semua model prediktor dan parameternya
% di unggah dan di load

% run('C:\Users\Kaka\Documents\MATLAB\Add-Ons\Collections\type-2-fuzzy-logic-systems-matlab-toolbox-master\fuzzyt2.m');


%% Load Model
% Load Data Max Min (untuk normalisasi JST)
load('maxTrata2.mat');
load('maxTmin.mat');
load('maxTmax.mat');
load('maxRH.mat');
load('maxCH.mat');
load('maxWS.mat');
load('maxWD.mat');

load('minTrata2.mat');
load('minTmin.mat');
load('minTmax.mat');
load('minRH.mat');
load('minCH.mat');
load('minWS.mat');
load('minWD.mat');
disp('Load data berhasil')

jst(1).datamax=datamaksT;
jst(1).datamin=dataminT;
jst(2).datamax=datamaksTmin;
jst(2).datamin=dataminTmin;
jst(3).datamax=datamaksTmax;
jst(3).datamin=dataminTmax;
jst(4).datamax=datamaksRH;
jst(4).datamin=dataminRH;
jst(5).datamax=datamaksCH;
jst(5).datamin=dataminCH;
jst(6).datamax=datamaksWS;
jst(6).datamin=dataminWS;
jst(7).datamax=datamaksWD;
jst(7).datamin=dataminWD;

disp('Load data max dan data min berhasil');
%% Load model JST
load('Trata2.mat');
jst(1).net=bestnetTrata2.net{1,1};
load('Tmin.mat');
jst(2).net=bestnetTmin.net{1,1};
load('Tmax.mat');
jst(3).net=bestnetTmax.net{1,1};
load('RH.mat');
jst(4).net=bestnetRH.net{1,1};
load('CH.mat');
jst(5).net=bestnetCH.net{1,1};
load('WS.mat');
jst(6).net=bestnetWS.net{1,1};
load('WD.mat');
jst(7).net=bestnetWD.net{1,1};

disp('Load model JST berhasil');
%% LOAD MODEL IT2FIS
it2fis(1).model=readt2fis('it2fisT.t2fis');
it2fis(2).model=readt2fis('it2fisTmin.t2fis');
it2fis(3).model=readt2fis('it2fisTmax.t2fis');
it2fis(4).model=readt2fis('it2fisRH.t2fis');
it2fis(5).model=readt2fis('it2fisCH.t2fis');
it2fis(6).model=readt2fis('it2fisWS.t2fis');
it2fis(7).model=readt2fis('it2fisWD.t2fis');

disp('Load model IT2FIS berhasil');
%% LOAD MODEL HYBRID
load('bestDE.mat');

disp('Load model Hybrid berhasil');
disp('...Semua model berhasil diload...');
