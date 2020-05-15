% function as5_kf_run
%
% This is the main run MATLAB script for assignment 5: Kalman Filter
%
% Instructions
% Run and step though this file to answer the questions in the assignment.
% You will need to complete the following functions:
%
%   as5_kf_dynamics.m
%   as5_kf_delay_system.m
%   as5_kf_kalman.m
%   as5_kf_movement.m
%   as5_kf_compare_parameter.m
%
% All of these functions have predefined inputs and outputs - do not change
% these! If you do so, we (the lecturers and teaching assistants) are not
% able to check and grade them.
%
% Academic integrity
% Although collaboration between students is allowed and even encouraged,
% you have to write and hand in your own code.
%
% Written by : Alexander Kuck
% Date       : February 20 2017


%% initialization
clear all; clc; close all 

%% parameter setup
% set up all the parameters you will need to complete this exercise. 
% Global parameters, DO NOT CHANGE!

params=struct;                          % Parameter structure
models=struct;                          % Models structure
results=struct;                         % Results structure
data=struct;                            % Data structure

params.dt=0.01;                         % sample time (s)
params.tEnd = 4;                        % end of simulation time (s)
params.t = 0:params.dt:params.tEnd;     % time vector (-)
params.m=4;                             % Weight of the hand [kg]
params.beta=3.9;                        % Damping Constant [Ns/m]
params.Q=[0 0; 0 1.47e-07];             % Process noise covariance matrix
params.R = eye(2)*3.3e-4;               % Measurement noise covariance matrix
params.delay=0.1;                       % Delay for models [s]
params.gain=1.0;                        % Forward model offset
params.force = 1.5;                     % Force excerted on hand [N]


%% -- Question 1 (I), Implementing the Models -- 
% Implement the models for the true Hand, the true Hand with noise inputs and
% forward model

% Complete the function: as5_kf_dynamics.

[models.TrueHandIdeal, models.TrueHandNoisy, models.ForwardModel]=as5_kf_dynamics(params);

%% -- Question 2 (II), Generating a Movement -- 
% Generate an appropriate movement trajectory which accelerates and
% deccelerates the hand. The resulting movement should result in a
% steady state end point.

% Edit the file: as5_kf_movement.

data.u=as5_kf_movement(models,params);

data.w = randn(length(data.u),2)*sqrt(params.Q);          % Process noise
data.v = randn(length(data.u),2)*sqrt(params.R);          % Measurement noise

% Calculate the resulting movement trajectories
results.yForward=lsim(models.ForwardModel,data.u);
results.yHand=lsim(models.TrueHandNoisy,[data.u data.w zeros(length(data.u),2)]); 
results.yNoise=lsim(models.TrueHandNoisy,[data.u data.w data.v]);                     

% Plot resulting movement.
as5_kf_plot(results,params,data,'Movement')

%% -- Question 3 (III), Implementing and running the Kalman filter 
% Implement the basic version of the Kalman filter into the file:
% as5_kf_kalman_undelayed.m

results.yHand=lsim(models.TrueHandNoisy,[data.u data.w zeros(length(data.u),2)]);             % Calculate the real hand position by including only those noise sources that affect the real hand position and set other noise sources to zero 
results.yNoiseMean=lsim(models.TrueHandNoisy,[data.u data.w zeros(length(data.u),2)]);                 % True system has process and sensor noise
results.yNoise=lsim(models.TrueHandNoisy,[data.u data.w data.v]);                                    % True system has process and sensor noise

data.yNoise=results.yNoise;

% Run kalman filter
[results.MArray, results.xPrioriArray, results.xPosterioArray, results.pPosterioArray]  = as5_kf_kalman(models.ForwardModel,models.TrueHandNoisy,params,models,data);

% Plot kalman filter results.
as5_kf_plot(results,params,data,'Kalman')


%% -- Question 4 (IV), Investigate the Effect of Process and Measurement Noise
% Run the following section to investigate different levels of Q and R.


%% a) Investigating the Effects of varying Q
%
% Run this section to plot the Kalman filter output for various levels of Q. 
% Adjust the offsets if needed in the file: as5_kf_compare_parameter_levels.m

% Preallocate space for cell array outputs
results.xPrioriArray=cell(1,1);
results.MArray=cell(1,1);
results.xPosterioArray=cell(1,1);
results.pPosterioArray=cell(1,1);
results.yNoise=cell(1,1);
results.yNoiseMean=cell(1,1);
results.yHand=cell(1,1);

% Define what will be varied
results.varied='Q';
% Run comparison
results=as5_kf_compare_parameter_levels(models,params,data,results);

% Plot results.
as5_kf_plot(results,params,data,'Compare')

%% b) Investigating the Effects of varying R
%
% Run this section to plot the Kalman filter output for various levels of R. 
% Adjust the offsets if needed in the file: as5_kf_compare_parameter_levels.m

% Preallocate space for cell array outputs
results.xPrioriArray=cell(1,1);
results.MArray=cell(1,1);
results.xPosterioArray=cell(1,1);
results.pPosterioArray=cell(1,1);
results.yNoise=cell(1,1);
results.yNoiseMean=cell(1,1);
results.yHand=cell(1,1);

% Define what will be varied
results.varied='R';
% Run comparison
results=as5_kf_compare_parameter_levels(models,params,data,results);

% Plot results.
as5_kf_plot(results,params,data,'Compare')

%% -- Question 5 (V), Investigate the Effect of an Incorrect Forward Model
%
% Run this section to plot the Kalman filter output for various levels of
% forward model offsets. Adjust the offsets if needed in the file: 
% as5_kf_compare_parameter_levels.m

% Preallocate space for cell array outputs
results.xPrioriArray=cell(1,1);
results.MArray=cell(1,1);
results.xPosterioArray=cell(1,1);
results.pPosterioArray=cell(1,1);
results.yNoise=cell(1,1);
results.yNoiseMean=cell(1,1);
results.yHand=cell(1,1);

% Define what will be varied
results.varied='x Forw.Model';
% Run comparison
results=as5_kf_compare_parameter_levels(models,params,data,results);
% Plot results
as5_kf_plot(results,params,data,'Compare')

%% -- Question 6, (VI) Implementing delays into the models
%
% In real life, the above systems are unrealistic. Since the real system usually
% includes traveling time through neural pathways, we will therefore investigate
% the effect of time delays on our state estimate.
% Implement a delay into the models: TrueHandIdeal, TrueHandNoisy and
% ForwardModel. 
% Finish the function: as5_kf_delay_system to construct the
% delayed system matrices based on the non- delayed models.
% Then, run this section to check your results and plot the delayed model
% output.

% Delay True Hand Noisy
NoiseModelDelayed_Matrices=as5_kf_delay_system(models.TrueHandNoisy,params); % Get delayed model matrices
models.TrueHandNoisyDelayed = ss(NoiseModelDelayed_Matrices.a,NoiseModelDelayed_Matrices.b,NoiseModelDelayed_Matrices.c,NoiseModelDelayed_Matrices.d,models.TrueHandNoisy.Ts); % Define discrete ss model

% Delay True Hand
TrueHandModelDelayed_Matrices=as5_kf_delay_system(models.TrueHandIdeal,params);
models.TrueHandIdealDelayed = ss(TrueHandModelDelayed_Matrices.a,TrueHandModelDelayed_Matrices.b,TrueHandModelDelayed_Matrices.c,TrueHandModelDelayed_Matrices.d,models.TrueHandIdeal.Ts);

% Delay Forward Model
ForwardModelDelayed_Matrices=as5_kf_delay_system(models.ForwardModel,params);
models.ForwardModelDelayed = ss(ForwardModelDelayed_Matrices.a,ForwardModelDelayed_Matrices.b,ForwardModelDelayed_Matrices.c,ForwardModelDelayed_Matrices.d,models.ForwardModel.Ts);

% Compute output for Forward Model Delayed (includes NO noise)
results.yForwardDelayed=lsim(models.ForwardModelDelayed,data.u); 
% Compute output for True Hand Model Delayed (includes process noise)
results.yHandDelayed=lsim(models.TrueHandNoisyDelayed,[data.u data.w zeros(length(data.u),2)]); 
% Compute output for Noisy True Hand Model Delayed (includes process and measurement noise)
results.yNoiseDelayed=lsim(models.TrueHandNoisyDelayed,[data.u data.w data.v]);   
% Compute output for True Hand Model UN-Delayed (includes process noise)
results.yHand=lsim(models.TrueHandNoisy,[data.u data.w zeros(length(data.u),2)]); 

% Plot the resulting movement.
as5_kf_plot(results,params,data,'MovementDelayed')

%% -- Question 6, Running the Kalman Filter including delays
% Run this section to execute the Kalman filter for models with time
% delays. 
% If you receive errors, check the matrix sizes in as5_kf_kalman.m.
% The matrix size has to be dynamic to incorporate systems of various
% sizes.

results.yHand=lsim(models.TrueHandNoisy,[data.u data.w zeros(length(data.u),2)]);                           % Calculate the real hand position by including only those noise sources that affect the real hand position and set other noise sources to zero 
results.yNoiseMean=lsim(models.TrueHandNoisyDelayed,[data.u data.w zeros(length(data.u),2)]);               % True system has process and sensor noise
results.yNoise=lsim(models.TrueHandNoisyDelayed,[data.u data.w data.v]);                                    % True system has process and sensor noise

data.yNoise=results.yNoise;

[results.MArray, results.xPrioriArray, results.xPosterioArray, results.pPosterioArray] = as5_kf_kalman(models.ForwardModelDelayed,models.TrueHandNoisyDelayed,params,models,data);
as5_kf_plot(results,params,data,'Kalman')


