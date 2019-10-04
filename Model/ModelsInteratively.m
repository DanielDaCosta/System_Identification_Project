% Daniel Pereira da Costa
% Load input and output data from file: Predictions.sid

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
[y, fit] = compare(ResampledGER_PIEZO,models,Kstep);

%% Evaluate Model
result = zeros(length(fit),5);
for i = 1:length(fit)
    aux = fit(i);
    Predcit_3StepAhead = [aux models{i}.na models{i}.nb models{i}.nc models{i}.nk];
    result(i,:) = Predcit_3StepAhead;
end