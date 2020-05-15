function results=as5_kf_compare_parameter_levels(models,params,data,results)
% Function which investigates the effect of different noise levels.
% 
% Inputs
%  params            : structure containing all parameters
%  models            : structure containing all models
%  data              : structure containing all data (u,w,v...)
%  results           : structure containing all results
%
% Output
%  results          : structure containing all results
%
%  Each field of the 'results' structure is a cell array. Do not change the
%  way this is saved, otherwise it will stop working.
%
% Written by : Alexander Kuck
% Date       : February 20 2017


%% You may change the values in the vectors 'levels' if you want to, but it is not
%% necessarily needed.

params_var=params;
switch results.varied
        case'Q'             % When altering Q
            levels=0.5:0.5:3;
        case'R'             % When altering R
            levels=0.5:.5:3;
        case 'x Forw.Model' % When altering the Forward Model gain
            levels=0.5:0.5:3;
end

%% You do not need to change anything here

% Only change if you are interested and know what you are doing!
% otherwise just leave it as it is!

for i = 1:length(levels)
    switch results.varied
        case'Q'
            params_var.Q=levels(i)*params.Q;
            
            data.w = randn(length(data.u),2)*sqrt(params_var.Q);          % Process noise
            data.v = randn(length(data.u),2)*sqrt(params_var.R);          % Measurement noise
            
            results.yNoise{i}=lsim(models.TrueHandNoisy,[data.u data.w data.v]);                          % True system has process and sensor noise
            results.yNoiseMean{i}=lsim(models.TrueHandNoisy,[data.u data.w zeros(length(data.u),2)]);     % True system has process and sensor noise
            results.yHand{i}=lsim(models.TrueHandNoisy,[data.u data.w zeros(length(data.u),2)]);          % Calculate the real hand position by including only those noise sources that affect the real hand position and set other noise sources to zero 
            
            [results.MArray{i}, results.xPrioriArray{i}, results.xPosterioArray{i}, results.pPosterioArray{i}] = as5_kf_kalman(models.ForwardModel,models.TrueHandNoisy,params_var,models,data);
        case'R'
            params_var.R=levels(i)*params.R;
            
            data.w = randn(length(data.u),2)*sqrt(params_var.Q);          % Process noise
            data.v = randn(length(data.u),2)*sqrt(params_var.R);          % Measurement noise
            
            results.yNoise{i}=lsim(models.TrueHandNoisy,[data.u data.w data.v]);                          % True system has process and sensor noise
            results.yNoiseMean{i}=lsim(models.TrueHandNoisy,[data.u data.w zeros(length(data.u),2)]);     % True system has process and sensor noise
            results.yHand{i}=lsim(models.TrueHandNoisy,[data.u data.w zeros(length(data.u),2)]);          % Calculate the real hand position by including only those noise sources that affect the real hand position and set other noise sources to zero 
            
            [results.MArray{i}, results.xPrioriArray{i}, results.xPosterioArray{i}, results.pPosterioArray{i}] = as5_kf_kalman(models.ForwardModel,models.TrueHandNoisy,params_var,models,data);
        case 'x Forw.Model'

            ForwardModel_Offset=models.ForwardModel;
            ForwardModel_Offset.b=models.ForwardModel.b*levels(i);            
            
            data.w = randn(length(data.u),2)*sqrt(params_var.Q);          % Process noise
            data.v = randn(length(data.u),2)*sqrt(params_var.R);          % Measurement noise
            
            results.yNoise{i}=lsim(models.TrueHandNoisy,[data.u data.w data.v]);                          % True system has process and sensor noise
            results.yNoiseMean{i}=lsim(models.TrueHandNoisy,[data.u data.w zeros(length(data.u),2)]);     % True system has process and sensor noise
            results.yHand{i}=lsim(models.TrueHandNoisy,[data.u data.w zeros(length(data.u),2)]);          % Calculate the real hand position by including only those noise sources that affect the real hand position and set other noise sources to zero 
            
            [results.MArray{i}, results.xPrioriArray{i}, results.xPosterioArray{i}, results.pPosterioArray{i}] = as5_kf_kalman(ForwardModel_Offset,models.TrueHandNoisy,params_var,models,data);
    end
end
results.levels=levels;
