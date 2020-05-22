function [Md]=as5_kf_delay_system(M,params)
% Delay arbitrary state space system by discrete delay line 
% Changes the observation matrix, such that only delayed states are
% observable. Changes A, B, C and D accordingly.
%
% Inputs:
%   - M:        State Space Model to be delayed.
%
%   - params:   Containing params.delay and params.dt
%   
%
% Outputs:
%   - Md:       Structure containing the new matrices to generate a the delayed model.
%               These are Md.a, Md.b, Md.c and Md.d for the extended versions
%               of the A, B, C and D matrices.
%               Matlab is case sensitive! Use exactly the same naming!
%
% -------------------------------------------------
% Taken from Joern Diedrichsen j.diedrichsen@bangor.ac.uk
% changed by Alexander Kuck a.kuck@utwente.nl

d = params.delay/params.dt;
N = size(M.A,1);
U = size(M.B,2);
O = size(M.C,1);

Md.a = [M.A zeros(N,N*(d-1)) zeros(N,N);
    eye(N) zeros(N,N*(d-1)) zeros(N,N);
    zeros(N*(d-1),N) eye(N*(d-1),N*(d-1)) zeros(N*(d-1),N)];
Md.b = [M.B;
        zeros(N*d,U)];
Md.c = [zeros(O,N*d) M.C];
Md.d = M.D;

