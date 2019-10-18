% Daniel Pereira da Costa
% Load input and output data from file: ResampledData.sid

clc;
clear;
close all;
% %% Preprocess Data
% 
% PreprocessType = 0; %  1 or 2 - Subtract offset or trend from time-domain signals contained in iddata objects
% 
% if PreprocessType == 0
%     Resampled10k = ResampledGER_PIEZO10k; % raw data
% end
% if PreprocessType == 1
%     [Resampled10k,T] = detrend(ResampledGER_PIEZO10k, 0); % Compute and subtract the means of input and output signals and stores
% end
% if PreprocessType == 2
%     [Resampled10k,T] = detrend(ResampledGER_PIEZO10k, 1); % Compute and subtract a best-fit straight line for both input and output signals
% end

%% Estimate ARMAX Models Iteratively
na = 7:10;
nb = 1:10;
nc = 1:10;
nk = 1;
models = cell(1,18);
ct = 1;
for i = 1:length(na)
    na_ = na(i);
    for  m = 1:length(nb)
    nb_ = nb(m);
        for j = 1:length(nc)
            nc_ = nc(j);
            for k = 1:1
                nk_ = nk(k); 
                models = armax(z_range,[na_ nb_ nc_ nk_]);
                kstep = [1 2 3 10 20 50 100];
                nk_step = length(kstep);
                for l=1:nk_step
                    [y,fit,x0] = compare(z,models,kstep(l));
                    fprintf('ARMAX na=%d/nb=%d/nc=%d/nk=%d Passos %d / fit %2.2f \n',na_,nb_,nc_,nk_,kstep(l),fit)
                end
            end
        end
    end
end


%% Estimate Non - linear Model - NLARX

opt = nlarxOptions;
opt.Display = 'full';
opt.SearchOptions.MaxIterations = 10;
mdl2 = nlarx(z2,[nord nord 1],sigmoidnet('NumberOfUnits',7),opt);

kstep = [1 2 3 10 20 50 100];
nk = length(kstep);
for i=1:nk
    
    [y,fit,x0] = compare(z2,mdl2,kstep(i));
    fprintf('NNARX Passos %d / fit %2.2f \n',kstep(i),fit)
end

% %% Stack the estimated model
% Kstep = 3;
% models = stack(1,models{:});
% ResampledGER_PIEZO = detrend(ResampledGER_PIEZO, T);
% [y, fit] = compare(ResampledGER_PIEZO,models,Kstep);
% y_tot = retrend(y,T);
% 
% %% Evaluate Model
% result = zeros(length(fit),5);
% for i = 1:length(fit)
%     aux = fit(i);
%     Predcit_1StepAhead = [aux models(:,:,i,1).na models(:,:,i,1).nb models(:,:,i,1).nc models(:,:,i,1).nk];
%     result(i,:) = Predcit_1StepAhead;
% end
