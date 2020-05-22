function [MArray, xPrioriArray, xPosterioArray, pPosterioArray] = as5_kf_kalman(ForwardModel,NoiseModel,params,models,data)
%% Function containing the Kalman Filter Equations
%
% Inputs:
%  ForwardModel:        Model of the internal forward model
%  NoiseModel:          Model of the true Hand with noise added
%  param:               Structure containing all the required parameters
%  models:              Structure containing all the required models
%  data:                Structure containing important data (inputs u,w and v)

% Outputs:
%  MArray:              [nSample x 2 x 2] - (Type Double) Matrix of kalman gains varying in time (4 kalman relevant gains changing over time)
%  xPrioriArray:        [nSample x 2] - (Type Double) Matrix of kalman a-priori state estimates (2 relevant estimates changing over time)
%  xPosterioArray:      [nSample x 2] - (Type Double) Matrix of kalman state estimates varying in time for each test (2 relevant estimates changing over time)
%  pPosterioArray:      [nSample x 2 x 2] - (Type Double) Matrix of estimated error covariance matrix in time (4 relevant estimates changing over time)
%
%                       Output variable values have to be stored in the
%                       corresponding array while iterating through time.
%                       e.g. MArray(k,2,2)=M(1:2,1:2);
%                       etc... etc....
%
%                       With:
%                           nSample=length(u)
%                       and
%                           k=1:nSample
%
% Written by : Alexander Kuck
% Date       : February 20 2017


%% 1) Define Matrices needed for Kalman Filter

Q = params.Q;
R = params.R;


%% 2) Preallocation (reserving space) of matrices to speed up calculations

%% 3) Initialize Covariance and State Estimates

%% 4) Run the Kalman Filter

