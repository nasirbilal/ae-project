% In this file all the constants of the project are defined and they should not
% be changed in any other part of the code. They can be accessed from any other
% function writing global and the name of the constants to use

global

% Wheels and encoders data
E_T = 2048;
B   = 0.35;
R_L = 0.1;
R_R = 0.1;

% Threshold for the outlier detection
LAMBDA_M = chi2inv(0.999, 2);

% Covariance matrices for the noise processes
Q = [1^2 0 0; 0 1^2 0; 0 0 1^2];        % Noise in the motion model
R = [0.1^2 0; 0 0.1^2];                 % Noise in the observations
