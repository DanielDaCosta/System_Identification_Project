%% Testing "choosing sampling frequency Luis Aguirre" method

clc;
clear;
close all;

fmin = 900*10^3; %Min Frequency (Hz) 
fmax = 950*10^3; %Max Frequency (Hz)
T = 0.1; %period length (s)
A = 5;

fSample = 10^(floor(log10(fmax)) + 1); %Sample Frequency (Hz)
Ts = 1/fSample; %Sample Period
timeVector = 0:Ts:10*T-Ts; %time axis
Ndata1 = round(T/Ts); %Ndata1 must be : 65k at maximum. 

if fmin>fmax
    disp('Min Frequency must be bigger than Max Frequency');
    return
end

%% Chirpy - Swept Sine

chirpsignal = chirp(timeVector, fmin, timeVector(end), fmax);
figure
plot(timeVector, chirpsignal);
xlabel('Time (s)');
ylabel('u(t)');

figure
pspectrum(chirpsignal);
legend('x');

%% Choosing the sampling period

%% Linear Autocorrelation
[r, lags] = autocorr(chirpsignal,'NumLags',length(timeVector)-2);
TF = islocalmin(r);
index_min_linear = find(TF,1,'first');
r_min_linear = r(index_min_linear);
tau_min = lags(index_min_linear);

figure
plot(lags,r)
hold on
plot(tau_min, r_min_linear)
legend('r','r_{min}')

%% Non Linear Autocorrelation
chirpsignal2 = chirpsignal.^2;
[r2, lags2] = autocorr(chirpsignal2,'NumLags',length(timeVector)-2);
TF2 = islocalmin(r2);
index_min_nonlinear = find(TF2,1,'first');
r_min_linear2 = r(index_min_nonlinear);
tau_min2 = lags2(index_min_nonlinear);


figure
plot(lags2,r2)
hold on
plot(tau_min2, r_min_linear2)
legend('r2','r2_{min}')

%The smallest lag;
tau_m = min(abs(tau_min), abs(tau_min2));
if tau_m > 20
    delta = tau_m/20; %decimation factor. tau*_m shoud be between [10,20] or [5,25]
elseif tau_m < 10
    delta = 10/tau_m;
end
    

Ts_reduced = Ts*delta;