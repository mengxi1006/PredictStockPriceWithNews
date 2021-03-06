%% Clear
clear all
%% Parameters
Xdim = 4;
Ts = 1; %time domain
dimIdent = 40; %Identification dimension
t_back = 7; %ARM time back
tp_back =7;
%% Load data
load('ANF-daily-table.mat')

%% Input from table
x_raw = table2array(ANFdaily);

%% Normalization
X_raw=Tools.norm4row(x_raw);

%% Identification(taining) data set
X =X_raw(1:dimIdent,1:end);

%% Validation data set
X_v =X_raw(dimIdent+1:end,1:end);

%% Create iddata
data = iddata(X,[],Ts);

%% Identify the system
%ARM
na = t_back*ones(Xdim);
na(2,:) = tp_back*ones(1,Xdim);
na(3,:) = tp_back*ones(1,Xdim);
nb =[];
nk = [];

% opt = arxOptions;
% sys = arx(data,[na nb nk])
opt.InitialCondition = 'estimate';
sys = arx(data,[na nb nk],opt)


%% compare(X,sys)
compare(X,sys);

%% ssmodel comparison
% [y,fit,x0]=compare(X,sys);
% ssmodel=idss(sys);
% opt_sim = simOptions('InitialCondition',x0);
% figure
% sim(ssmodel,data,opt_sim)