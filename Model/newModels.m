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
Ts_orig = 1e-8;
Ts_reduced = 1e-7;
time = tbl.TIME;
DATA = [tbl.GER tbl.AMP tbl.PIEZO];

% pro algum motivo tem tempos repetidos
[time1, indtime] = unique(time);
DATA1 = DATA(indtime,:);
nans  = any(isnan(DATA1)');
DATA2 = DATA1(~nans,:); % por algum motivo tinhamos NANs
time2 = time1(~nans);

[DATAr,timer] = resample(DATA2,time2,1/Ts_reduced,1,1);
[DATAr2,timer2] = resample(DATA1,time1,1/Ts_orig,1,1); % apenas corrige as amostras nao espacadas igualmente

% Original Data vs. Resample: 
% 1- vejam que o sinal nao possui uma curva bem definida (dar zoom na 
% horizontal - x), acredito que isto se deva a resolucao da medicao. seria 
% interessante comparar com os dados com amplitude maior da nova aquisicao
figure
plot(time2,DATA2(:,1),'k-',timer,DATAr(:,1),'b--')
figure
plot(time2,DATA2(:,3),'k-',timer,DATAr(:,3),'b--')

figure
periodogram(DATAr2(:,[1 3]),[],[],1/Ts_orig)
legend('u','y')
figure
periodogram(DATAr(:,[1 3]),[],[],1/Ts_reduced)
legend('u','y')
% algumas frequencias aparecem na saida devido (acredito) as 
% nao-linearidade

%% Filtrar o sinal para a banda de interesse
[B,A] = butter(5,[0.16 0.3]); % passband in normalized frequency
figure
freqz(B,A)
dataOut = filter(B,A,DATAr);
figure
periodogram(dataOut(:,[1 3]),[],[],1/Ts_reduced)
legend('u','y')

figure
plot(timer,dataOut(:,1),'k-',timer,DATAr(:,1),'b--')
figure
plot(timer,dataOut(:,3),'k-',timer,DATAr(:,3),'b--')

z = iddata(dataOut(:,3),dataOut(:,1),Ts_reduced);