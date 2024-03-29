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




A = ForwardModel.A;
B = ForwardModel.B;
C = ForwardModel.C;
N = size(A,1);
U = size(B,2);
O = size(C,1);
NN = size(C,2);
Q = [params.Q zeros(O,NN-2);
    zeros(NN-2,NN)];
R = params.R;
u = data.u;
P0 = zeros(N,N);
x0 = zeros(N,1);
u0 = u(1,:);
Z = data.yNoise;
%% 2) Preallocation (reserving space) of matrices to speed up calculations

% MArray = zeros(2,2,length(u));
% xPrioriArray = zeros(2,length(u));
% xPosterioArray = zeros(2,length(u));
% pPosterioArray = zeros(2,2,length(u));
% pPrioriArray = zeros(2,2,length(u));

MArray = zeros(length(u),N,O);
xPrioriArray = zeros(length(u),N);
xPosterioArray = zeros(length(u),N);
pPosterioArray = zeros(length(u),N,N);
pPrioriArray = zeros(length(u),N,N);


%% 3) Initialize Covariance and State Estimates

xPrioriArray(1,:) = A*x0+B*u0;
pPriori = A*P0*A.'+Q;
pPrioriArray(1,:,:) = pPriori;

%% 4) Run the Kalman Filter


for i = 1:(length(u)-1)
    M = pPriori*C.'/(C*pPriori*C.'+R);
    MArray(i,:,:) = M;
    xPosterioArray(i,:) = xPrioriArray(i,:)+(M*(Z(i,:).'-C*xPrioriArray(i,:).')).';
    pPosterio = pPriori-M*C*pPriori;
    pPosterioArray(i,:,:) = pPosterio;
    
    xPrioriArray(i+1,:) = (A*xPosterioArray(i,:).').'+B.'*u(i,:);
    pPriori = A*pPosterio*A.'+Q;
    pPrioriArray(i+1,:,:) = pPriori;
end

