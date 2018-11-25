function [X_id,X_v]=norm4row(x_id,x_v)
%% old normalization
% G = diag([1e-7 1 1 1e1]);
% X = x*G;
%% Id mean and std
x_m = mean(x_id);
x_std = std(x_id);
%% New normalization % x_id
% x_id

p_div = 5;
X_id_r = normalize(x_id,1);
G = diag([1/p_div 1 1 1/p_div]);
X_id = X_id_r*G;

% X_check = (x_id-x_m)./x_std;
%% New normalization % x_v
X_v_r = (x_v-x_m)./x_std;
X_v = X_v_r*G;
end