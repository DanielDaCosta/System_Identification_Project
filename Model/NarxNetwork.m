% Daniel Pereira da Costa
% Load input and output data from file: ResampledData.sid

clc;
clear;
close all;

%% PreprocessType = 2; %  1 or 2 - Subtract offset or trend from time-domain signals contained in iddata objects

na = 10;
nb = 10;

opt = nlarxOptions;
opt.Display = 'full';
opt.SearchOptions.MaxIterations = 10;
% Neutal Network Configuration 

%% FeedForward
net = feedforwardnet(5);

net_estimator = neuralnet(net);
mdl2 = nlarx(z_article,[na nb 1], net_estimator,opt);

kstep = [1 2 3 10 20 50 100];
%% CascadeForwardnet
net = cascadeforwardnet(5);

net_estimator = neuralnet(net);
mdl2 = nlarx(z_range,[na nb 1], net_estimator,opt);

kstep = [1 2 3 10];

%%
N_layer1 = 5;
N_layer2 = 4;
net = cascadeforwardnet(N_layer1);

net_estimator = neuralnet(net);

fid=fopen('NARX_CF_Results_article.csv','a+');

fprintf(fid, '\nna,nb,Neuron1,R2_OSA1,R2_OSA2,R2_OSA3,R2_OSA10,R2_OSA20,R2_OSA50,R2_OSA100,Free_Run\n');
fprintf('\n');
nk = length(kstep);
for na_ = 10:10
    for nb_ = 10:10
        mdl2 = nlarx(z_article,[na_ nb_ 1], net_estimator,opt);
         kstep = [1 2 3 10 20 50 100];
         nk = length(kstep);
         fprintf(fid,'%d; %d; %d;',na_,nb_,N_layer1);
        for i=1:nk
            [y,fit,x0] = compare(z_article,mdl2,kstep(nk));
            fprintf(fid,'%d,',fit);
        end
        fprintf(fid,'\n');
    end
end
fclose(fid); 

