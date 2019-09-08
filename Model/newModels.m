%Daniel Pereira da Costa

%Building new models using Chirp signal;
%   tek002 - Chirp 900 a 1350 80MVpp. Sweep time: 100Ms

clc;
clear;
close all;

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = [22, 10000000];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["TIME", "GER", "AMP", "PIEZO"];
opts.VariableTypes = ["double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable("/Users/danieldacosta/Documents/TCC_Matlab/Model/270519/tek0002.csv", opts);

%% Resampling Signal to new Sampling Rate
Ts_old = 1e-8;
Ts_reduced = 1.35e-8;
TIME = tbl.TIME';
GER = tbl.GER'; 
AMP = tbl.AMP';
PIEZO = tbl.PIEZO';

TIME_resampled = resample(TIME,7407,10000); %p/q -> Ts_old/Ts_reduced
GER_resampled = resample(GER,7407,10000);
PIEZO_resampled = resample(PIEZO,7407,10000);
AMP_resampled = resample(AMP,7407,10000);

figure
plot(TIME_resampled,PIEZO_resampled);
hold on 
plot(TIME,PIEZO);
legend('Ts_{old}','Ts_{reduced}');


