% Daniel Pereira da Costa
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
U=zeros(1e6 ,1);            % initizalize the spectrum
U((ExcitationLines))=exp(j*2*pi*rand(length(ExcitationLines),1));

aux=2*real(ifft(U));
u=aux/std(aux); 
U2=fft(u)/sqrt(Ndata1);       % spectrum of the actual generate multisine% 
% Plot the results
u_trunc = u(1:65835);
figure
plot(u_trunc)
hold on
plot(u)

% plot(timeVector2,u2,'k')
legend('u_{trunc}','u2')
xlabel('Time (s)')

figure(2)
ut_trunc = timetable(u_trunc,'SamplingRate',fSample);
ut = timetable(u,'SamplingRate', fSample);
pspectrum(ut_trunc)
hold on
pspectrum(ut)
legend('ut_{trunc}', 'ut')

figure(3)
histogram(u_trunc,50);
hold on;
histogram(u,50, 'FaceColor', 'red')
legend('u_{trunc}','u')
%% Chirpy - Swept Sine

chirpsignal = chirp(timeVector, fmin, timeVector(end), fmax);
figure
plot(timeVector, chirpsignal);
xlabel('Time (s)');
ylabel('u(t)');

figure
% xt = timetable(x,'SamplingRate', fSample);
pspectrum(chirpsignal);
legend('x');


%% Square Sweep
amplitude = 1 ;
chirpsignal2 = chirp(timeVector, fmin, timeVector(end), fmax)*amplitude;
squarechirpsignal = sign(chirpsignal2)*amplitude;
% Plot the timeseries
plot(timeVector,squarechirpsignal,'r-');
