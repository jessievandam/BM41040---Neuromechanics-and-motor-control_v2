function F=as5_kf_movement(models,params)
% Function which generates a movement and returns the appropriate output F.
% 
% Inputs
%  param            : structure containing all the required parameters
%  models           : structure containing all the required models
%
% Output
%  F                : Force needed to accelerate the hand for 1 second and
%                     subsequently stop it. This should be a COLUMN vector  of
%                     the same length as t (dimensions: [length(t) x 1]),
%                     with each row being a new time step.
%                     Make sure the above dimensions are correct, or else
%                     you will get errors!
%
% Written by : Alexander Kuck
% Date       : February 20 2017

%% 1) Generate force vector

%% 2) Simulate real hand position with hand pulling back.

%% 3) Find the moment at which the hand velocity reaches zero and put F to 0 to avoid hand pulling back

%% 4) plot F