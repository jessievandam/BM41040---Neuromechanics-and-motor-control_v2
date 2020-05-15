function [TrueHandIdeal, TrueHandNoisy, ForwardModel]=as5_kf_dynamics(params)
% Function which generates the discrete state space models for:
%
%         - True Hand
%         - True Hand with added Noise
%         - Forward Model of Hand
% 
% Inputs:
%  params:          structure containing all the required parameters
%
%
% Outputs:
%
% The function outputs are not variables or numbers but "matlab state space model obejcts"!
% These are:
%
%  TrueHandIdeal:    Discrete State Space Model of the Ideal Hand (without noise)
%  TrueHandNoisy:    Discrete State Space Model with both Noise Sources (w and v) added to the Ideal Model of the Hand 
%  ForwardModel:    Discrete State Space Model of Forward Model
% 
%
% Hint:
%
% Example of creating matrices: 
%       A=[1 4 2; 4 5 6];
%
% Example on how to generate a continuous model:
%
% model_name=ss(A,B,C,D,'inputname','input1','outputname',{'output1' 'output2'});
%
% Example on how to discretize a model:
%
%  model_name_discrete=c2d(model_name,dt);
%
% Written by : Alexander Kuck
% Date       : February 20 2017

%% 1) Create a state-space model of the true Hand dynamics

%% 2) Transform the continuous model into a discrete model.

%% 3) Create the forward model of the hand

%% 4) Noisy model
% Add one additional input to your original model representing the process
% noise and two inputs for the measurement noise.
% This comes down to extending the B and D matrix appropriately.


