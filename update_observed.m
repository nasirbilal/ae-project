% function observed = update_observed(observed, observer, Rrobo, z)
% Performs the update step for a robot. This robot has played the role of
% observed in the measurement. The update step is any that is not the first
% one.
%
% Inputs:
%           observed(t):    robot structure
%           observer(t):    robot structure
%           Rrobo      :    3x3, covariance of the measurement noise 
%                           (between robots)
%           z(t)       :    3x1, measurement
%
% Outputs:
%           observed(t):    robot structure
%
function observed = update_observed(observed, observer, Rrobo, z)

% Compute H_tilde

J = [
      0 -1;
      1  0
    ];

p_observed = [ observed.mu_bar(1) observed.mu_bar(2) ]';
p_observer = [ observer.mu_bar(1) observer.mu_bar(2) ]';

H_tilde = [ 
            eye(2)          J*(p_observed - p_observer);
            zeros(1, 2)     1
          ];

% Compute R_tilde

C = [
      cos( observer.mu_bar(3) ) -sin( observer.mu_bar(3) );
      sin( observer.mu_bar(3) )  cos( observer.mu_bar(3) )
    ];

Gamma = [
          C             zeros(2, 1);
          zeros(1, 2)   1
        ];

R_tilde = Gamma*Rrobo*Gamma';

% Compute S_tilde using H_tilde and R_tilde
S_tilde = H_tilde*observer.sigma_bar*H_tilde' - ...
          observed.cross_bar*H_tilde' - ...
          H_tilde*observer.cross_bar + observed.sigma_bar + R_tilde;

S_tinv  = S_tilde\eye(3);

% Compute the Kalman gain
K = ( observed.sigma_bar - observed.cross_bar*H_tilde' )*S_tinv;

% Update the mean of the belief
% % observed.mu = observed.mu_bar + ...
% %               K*( Gamma*z - (observed.mu_bar - observer.mu_bar) );

% Update the uncertainty in the belief
% % observed.sigma = observed.sigma_bar - ...
% %                  ( observed.sigma_bar - observed.cross_bar*H_tilde' )* ...
% %                  S_tinv* ...
% %                  ( observed.sigma_bar - H_tilde*observer.cross_bar );

% Update the cross correlation term

% This is first computed with the expression for the observer and later
% transposed. A new variable cross_observer is introduced because this 
% function does not update anything for the observer, it just processes its
% information

cross_observer = observer.cross_bar - ...
                 ( observer.cross_bar - observer.sigma_bar*H_tilde' )* ...
                 S_tinv* ...
                 ( observed.sigma_bar - H_tilde*observer.cross_bar );

observed.cross = cross_observer';

observed.last_update = true;

end
