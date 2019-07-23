function [jst,it2fis,wh,de,textout]=model()

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

%% LOAD MODEL IT2FIS
it2fis(1).model=readt2fis('it2fisT.t2fis');
it2fis(2).model=readt2fis('it2fisTmin.t2fis');
it2fis(3).model=readt2fis('it2fisTmax.t2fis');
it2fis(4).model=readt2fis('it2fisRH.t2fis');
it2fis(5).model=readt2fis('it2fisCH.t2fis');
it2fis(6).model=readt2fis('it2fisWS.t2fis');
it2fis(7).model=readt2fis('it2fisWD.t2fis');


%% LOAD MODEL JST WH
load('netwh1.mat');
wh(1).net=net;
load('netwh2.mat');
wh(2).net=net;
load('netwh3.mat');
wh(3).net=net;
load('netwh4.mat');
wh(4).net=net;
load('netwh5.mat');
wh(5).net=net;
load('netwh6.mat');
wh(6).net=net;
load('netwh7.mat');
wh(7).net=net;

%% LOAD MODEL HYBRID
load('bestDE.mat');
de=bestpop;

textout='Semua model berhasil diload';

