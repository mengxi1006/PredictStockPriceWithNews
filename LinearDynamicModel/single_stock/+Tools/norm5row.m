function [U_id,U_v]=norm5row(u_id,u_v)
%% old normalization
% G = diag([1e-7 1 1 1e1]);
% X = x*G;
%% Id mean and std
u_m = mean(u_id);
u_std = std(u_id);
%% New normalization % u_id
% x_id

% p_div = 5;
U_id = normalize(u_id,1);
% G = diag([1/p_div 1 1 1/p_div]);
% X_id = X_id_r*G;

% X_check = (x_id-x_m)./x_std;
%% New normalization % u_v
U_v = (0*u_v-u_m)./u_std;
U_v = 0*u_v; %!!!!!
end