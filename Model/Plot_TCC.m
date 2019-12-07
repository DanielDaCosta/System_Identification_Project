%Daniel Pereira da Costa

%Building new models using Chirp signal from June;
%   tek002 - Chirp 900 a 1350 80MVpp. Sweep time: 100Ms

clc;
clear;
close all;

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = [22, 10000022];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["TIME", "GER", "AMP", "PIEZO"];
opts.VariableTypes = ["double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable("/Users/danieldacosta/Documents/TCC_Matlab/Model/190919/tek0008.csv", opts);

%% Resampling Signal to new Sampling Rate
Ts_orig = 2e-9;
time = tbl.TIME;
DATA = [tbl.GER tbl.AMP tbl.PIEZO];

% pro algum motivo tem tempos repetidos
[time1, indtime] = unique(time);
DATA1 = DATA(indtime,:);
nans  = any(isnan(DATA1)');
DATA2 = DATA1(~nans,:); % por algum motivo tinhamos NANs
time2 = time1(~nans);

[DATAr2,timer2] = resample(DATA1,time1,1/Ts_orig,1,1); % apenas corrige as amostras nao espacadas igualmente

figure
plot(time2,DATA2(:,1))
xlabel('time(s)')
ylabel('Voltage(V)')