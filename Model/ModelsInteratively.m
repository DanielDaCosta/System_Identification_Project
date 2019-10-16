% Daniel Pereira da Costa
% Load input and output data from file: Predictions.sid

clc;
clear;
close all;
%% Preprocess Data

PreprocessType = 0; %  1 or 2 - Subtract offset or trend from time-domain signals contained in iddata objects

if PreprocessType == 0
    Resampled10k = ResampledGER_PIEZO10k; % raw data
end
if PreprocessType == 1
    [Resampled10k,T] = detrend(ResampledGER_PIEZO10k, 0); % Compute and subtract the means of input and output signals and stores
end
if PreprocessType == 2
    [Resampled10k,T] = detrend(ResampledGER_PIEZO10k, 1); % Compute and subtract a best-fit straight line for both input and output signals
end

%% Estimate ARMAX Models Iteratively
na = 2:4;
nc = 2:7;
nk = 0;
models = cell(1,18);
ct = 1;
for i = 1:3
    na_ = na(i);
    nb_ = na_;
    for j = 1:6
        nc_ = nc(j);
        for k = 1:1
            nk_ = nk(k); 
            models{ct} = armax(Resampled10k,[na_ nb_ nc_ nk_]);
            ct = ct+1;
        end
    end
end

%% Stack the estimated model
Kstep = 3;
models = stack(1,models{:});
ResampledGER_PIEZO = detrend(ResampledGER_PIEZO, T);
[y, fit] = compare(ResampledGER_PIEZO,models,Kstep);
y_tot = retrend(y,T);

%% Evaluate Model
result = zeros(length(fit),5);
for i = 1:length(fit)
    aux = fit(i);
    Predcit_1StepAhead = [aux models(:,:,i,1).na models(:,:,i,1).nb models(:,:,i,1).nc models(:,:,i,1).nk];
    result(i,:) = Predcit_1StepAhead;
end
