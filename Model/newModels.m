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
tbl = readtable("/Users/danieldacosta/Documents/TCC_Matlab/Model/270519/tek0002.csv", opts);

%% Resampling Signal to new Sampling Rate
Ts_old = 1e-8;
Ts_reduced = 3e-8;
TIME = tbl.TIME';
GER = tbl.GER'; 
AMP = tbl.AMP';
PIEZO = tbl.PIEZO';

%% Choosing the sampling period
TIME_trunc = TIME(1:(end-1));
PIEZO_trunc = PIEZO(1:(end-1));
GER_trunc = GER(1:(end-1));
AMP_trunc = AMP(1:(end-1));

%% Plotting
pq = fix(Ts_old/Ts_reduced *10000);
TIME_resampled = resample(TIME_trunc,pq,10000); %p/q -> Ts_old/Ts_reduced
GER_resampled = resample(GER_trunc,pq,10000);
PIEZO_resampled = resample(PIEZO_trunc,pq,10000);
AMP_resampled = resample(AMP_trunc,pq,10000);

figure
% subplot(2,1,1)
plot(TIME_resampled,GER_resampled);
    legend('Ts_{reduced}');

% subplot(2,1,2)
% pspectrum(GER_resampled)
% legend('Spectrum_{reduced}');

figure
% subplot(2,1,1)
plot(TIME_resampled,PIEZO_resampled);
legend('Ts_{reduced}');

% subplot(2,1,2)
% pspectrum(PIEZO_trunc)
% legend('Spectrum_{all}'); 
