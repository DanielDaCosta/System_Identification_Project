%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: /Users/danieldacosta/Documents/TCC_Matlab/190801/tek0016.csv
%
% Auto-generated by MATLAB on 04-Sep-2019 19:17:52
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
tbl = readtable("/Users/danieldacosta/Documents/TCC_Matlab/190801/tek0016.csv", opts);

%% Convert to output type
Ts = 4e-10;
TIME = tbl.TIME';
GER = tbl.GER';
AMP = tbl.AMP';
PIEZO = tbl.PIEZO';
timevector = unique(TIME); %values are too close. Chosing only differents values.
PIEZO_trunc = PIEZO(1:length(timevector));

%% Clear temporary variables
clear opts tbl

%% Choosing the sampling period

%Linear Autocorrelation
[r, lags] = autocorr(PIEZO_trunc);
[r_min_linear, index_min_linear] = min(r);
tau_min = lags(index_min_linear);
figure
% stem(lags(index_min_linear-1e4:index_min_linear+1e4),r(index_min_linear-1e4:index_min_linear+1e4))
stem(lags,r)
hold on
stem(tau_min, r_min_linear, 'linewidth',8)
legend('r','r_{min}')

%Non Linear Autocorrelation
PIEZO2_trunc = PIEZO_trunc.^2;
[r2, lags2] = xcov(PIEZO2_trunc);
[r2_min_linear, index2_min_linear] = min(r2);
tau2_min = lags2(index2_min_linear);
figure
stem(lags2,r2)
hold on
stem(tau2_min, r2_min_linear, 'linewidth',8)
legend('r','r_{min}')

%The smallest lag;
tau_m = min(abs(tau_min), abs(tau2_min));
delta = tau_m/25; %decimation factor. tau*_m shoud be between [10,20] or [5,25]

Ts_reduced = Ts*delta;