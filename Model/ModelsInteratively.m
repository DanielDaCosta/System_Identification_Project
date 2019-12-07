% Daniel Pereira da Costa
% Load input and output data from file: ResampledData.sid

clc;
clear;
close all;
%% CSV
fid=fopen('ARMAX_Results_article.csv','a+');
fprintf(fid, 'na,nb,nc,nk,R2_OSA1,R2_OSA2,R2_OSA3,R2_OSA10,R2_OSA20,R2_OSA50,R2_OSA100');
fclose(fid);

%% Estimate ARMAX Models Iteratively
opt = nlarxOptions;
opt.SearchOptions.MaxIterations = 10;

fid=fopen('ARMAX_Results_article.csv','a+');
fprintf(fid, '\n');

na = 1:10;
nb = 1:10;
nc = 1:10;
nk = 1;
ct = 1;
for i = 1:length(na)
    na_ = na(i);
    for  m = 1:length(nb)
    nb_ = nb(m);
        for j = 1:length(nc)
            nc_ = nc(k);
            for k = 1:1
                nk_ = nk(k); 
                models = armax(z_article,[na_ nb_ nc_ nk_]);
                  kstep = [1 2 3 10 20 50 100];
                  fprintf(fid, '%d;%d;%d;',na_,nb_,nk_);
                  nk_step = length(kstep);
                for l=1:nk_step
                    [y,fit,x0] = compare(z_article,models,kstep(l));
                    fprintf(fid,'%d;',fit);
                end
                fprintf(fid,'\n');
            end
        end
   
    end
end
%% 
fid=fopen('ARX_Results_article.csv','a+');
fprintf(fid, '\n');
models = arx(z_article,[10 1 1]);
                 kstep = [1 2 3 10 20 50 100];
                 fprintf(fid, '10;1;1;');
                 nk_step = length(kstep);
                for l=1:1
                    [y,fit,x0] = compare(z_article,models,Inf);
                    fprintf(fid,'%d;',fit);
                end
                fprintf(fid,'\n');
fclose(fid);
%% Estimate ARMAX - with the orders that had obtained the best results: Preprocessing Data
PreprocessType = 2; %  1 or 2 - Subtract offset or trend from time-domain signals contained in iddata objects

if PreprocessType == 0
    z_range_preProcess = z_range; % raw data
end
if PreprocessType == 1
    [z_range_preProcess,T] = detrend(z_range, 0); % Compute and subtract the means of input and output signals and stores
end
if PreprocessType == 2
    [z_range_preProcess,T] = detrend(z_range, 1); % Compute and subtract a best-fit straight line for both input and output signals
end
%% 

na_ = 4;
nb_ = 1;
nc_ = 10;
nk_ = 1;
models = armax(z_range_preProcess,[na_ nb_ nc_ nk_]);
kstep = [1 2 3 10 20 50 100];
nk_step = length(kstep);
for l=1:nk_step
    [y,fit,x0] = compare(z,models,kstep(l));
    fprintf('Preprocess Type %d - ARMAX na=%d/nb=%d/nc=%d/nk=%d Passos %d / fit %2.2f \n',PreprocessType,na_,nb_,nc_,nk_,kstep(l),fit)
end


%% Estimate Non - linear Model - NLARX - with the orders that had obtained the best results
na = 10;
nb = 10;

opt = nlarxOptions;
opt.Display = 'full';
opt.SearchOptions.MaxIterations = 10;
mdl2 = nlarx(z_range,[na nb 1], sigmoidnet('NumberOfUnits',20),opt);

% kstep = [1 2 3 10 20 50 100];
kstep = [1 2 3 10 20];
nk = length(kstep);
for i=1:nk
    [y,fit,x0] = compare(z_range,mdl2,kstep(i));
    fprintf('NARX Passos %d / fit %2.2f \n',kstep(i),fit)
end

%% Estimate Non - linear Model - NLARX - with the orders that had obtained the best results: Prepocessing Data

PreprocessType = 2; %  1 or 2 - Subtract offset or trend from time-domain signals contained in iddata objects

if PreprocessType == 0
    z_range_preProcess = z_range2; % raw data
end
if PreprocessType == 1
    [z_range_preProcess,T] = detrend(z_range2, 0); % Compute and subtract the means of input and output signals and stores
end
if PreprocessType == 2
    [z_range_preProcess,T] = detrend(z_range2, 1); % Compute and subtract a best-fit straight line for both input and output signals
end

na = 10;
nb = 10;

opt = nlarxOptions;
opt.Display = 'full';
opt.SearchOptions.MaxIterations = 10;
mdl2 = nlarx(z_range_preProcess,[na nb 1], sigmoidnet('NumberOfUnits',10),opt);

% kstep = [1 2 3 10 20 50 100];
kstep = [1 2 3 10 20];
nk = length(kstep);
for i=1:nk
    [y,fit,x0] = compare(z_range_preProcess,mdl2,kstep(i));
    fprintf('NARX Passos %d / fit %2.2f \n',kstep(i),fit)
end