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
A = ForwardModel.A;
B = ForwardModel.B;
C = ForwardModel.C;
u = data.u;
P0 = zeros(2,2);
x0 = zeros(2,1);
u0 = u(1,1);
Z = data.yNoise;
%% 2) Preallocation (reserving space) of matrices to speed up calculations

% MArray = zeros(2,2,length(u));
% xPrioriArray = zeros(2,length(u));
% xPosterioArray = zeros(2,length(u));
% pPosterioArray = zeros(2,2,length(u));
% pPrioriArray = zeros(2,2,length(u));

MArray = zeros(length(u),2,2);
xPrioriArray = zeros(length(u),2);
xPosterioArray = zeros(length(u),2);
pPosterioArray = zeros(length(u),2,2);
pPrioriArray = zeros(length(u),2,2);


%% 3) Initialize Covariance and State Estimates

% xPrioriArray(:,1) = A*x0+B*u0;
% pPrioriArray(:,:,1) = A*P0*A.'+Q;

xPrioriArray(1,:) = A*x0+B*u0;
pPriori = A*P0*A.'+Q;
pPrioriArray(1,:,:) = pPriori;

%% 4) Run the Kalman Filter

% for i = 1:(length(u)-1)
%     MArray(:,:,i) = pPrioriArray(:,:,i)*C.'*(C*pPrioriArray(:,:,i)*C.'+R).^(-1);
%     xPosterioArray(:,i) = xPrioriArray(:,i)+MArray(:,:,i)*(Z(:,i)-C*xPrioriArray(:,i));
%     pPosterioArray(:,:,i) = pPrioriArray(:,:,i)-MArray(:,:,i)*C*pPrioriArray(:,:,1);
%     
%     xPrioriArray(:,i+1) = A*xPosterioArray(:,i)+B*u(:,i);
%     pPrioriArray(:,:,i+1) = A*pPosterioArray(:,:,i)*A.'+Q;
% end
% 
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

% xPosterioArray = xPosterioArray.';
% xPrioriArray = xPrioriArray.';
% MArray = permute(MArray,[3 1 2]);
% pPosterioArray = permute(pPosterioArray,[3 1 2]);
