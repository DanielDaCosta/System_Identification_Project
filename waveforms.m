%Daniel Pereira da Costa
clc;
clear;
close all;

%input parameters, common to all waveforms
fmin = 900*10^3; %Min Frequency (Hz) 
fmax = 1350*10^3; %Max Frequency (Hz)
T = 0.1; %period length (s)
A = 5;

fSample = 10^(floor(log10(fmax)) + 1); %Sample Frequency (Hz)
TSample = 1/fSample; %Sample Period
timeVector = 0:TSample:T-TSample; %time axis
Ndata1 = round(T/TSample); %Ndata1 must be : 65k at maximum. 

if fmin>fmax
    disp('Min Frequency must be bigger than Max Frequency');
    return
end

%% Generate de Multisine
ExcitationLines=1+floor((fmin/fSample)*Ndata1:(fmax/fSample)*Ndata1);
% ExcitationLines=1+floor([fmin*100:fmax*100]); 
U=zeros(Ndata1 ,1);            % choose random phases
U((ExcitationLines))=exp(j*2*pi*rand(length(ExcitationLines),1));

u2=2*real(ifft(U));
u2=u2/std(u2);  %A foi omitido para a realização do primeiro teste. 
U2=fft(u2)/sqrt(Ndata1);       % spectrum of the actual generate multisine% 
% % % % plot the results
figure
plot(timeVector,u2,'k')
xlabel('Time (s)')
%% Chirpy - Swept Sine
phaseInit = -90;
method = 'linear';
timeVector = 0:1/10e3:T-TSample;
x = chirp(timeVector, fmin, timeVector(end), fmax, method, phaseInit);
figure
plot(timeVector, x);
xlabel('Time (s)');
ylabel('u(t)');

%% Square Sweep
timeVector = 0:1/10e3:T-TSample; % time samples in seconds
amplitude = 1 ;
chirpsignal = chirp(timeVector, fmin, timeVector(end), fmax)*amplitude;
squarechirpsignal = sign(chirpsignal)*amplitude;
% Plot the timeseries
plot(timeVector,squarechirpsignal,'r-');
