%% Clear
clear all
%% Parameters
Xdim = 4;
Ts = 1; %time domain
dimIdent = 45; %Identification dimension
t_back = 7; %ARM time back
tp_back =7;
%% Load data
load('ANF-60daily-table.mat')

%% Input from table
x_raw = table2array(ANFdaily);


%% Identification(taining) data set
x_id =x_raw(1:dimIdent,1:end);

%% Validation data set
x_v =x_raw(dimIdent+1:end,1:end);

%% Normalization according to zscore of x_id
[X_id,X_v]=Tools.norm4row(x_id,x_v);


%% Create iddata
data_id = iddata(X_id,[],Ts);
data_v = iddata(X_v,[],Ts);
%% Identify the system
%ARM
na = t_back*ones(Xdim);
na(2,:) = tp_back*ones(1,Xdim);
na(3,:) = tp_back*ones(1,Xdim);
nb =[];
nk = [];

% sys = arx(data,[na nb nk])

opt = arxOptions;
opt.InitialCondition = 'estimate';
arxsys = arx(data_id,[na nb nk],opt)


%% compare(X,sys)
% compare(X_id,arxsys);

%% ssmodel comparison
% [y,fit,x0]=compare(X,sys);
% ssmodel=idss(sys);
% opt_sim = simOptions('InitialCondition',x0);
% figure
% sim(ssmodel,data,opt_sim)

%% Validation (w/o kalman openloop for future 20 days)
ssmodel=idss(arxsys);
[y_hat,fit,x0]=compare(X_id,arxsys);
x0_v_array = flipud(y_hat(dimIdent-tp_back+1:end,:)); %flipud!!!!

% x0_v_array = flipud(X_id(dimIdent-tp_back+1:end,:)); %flipud!!!!

x0_v = reshape(x0_v_array',[],1);

% figure
opt_com_id = compareOptions('InitialCondition',x0);%%%%%%Identification!!!!!!%%%%%
% compare(X_id,ssmodel,opt_com_id);
% % 
% % opt_sim_v = simOptions('InitialCondition',x0_v);
% % sim(ssmodel,data_v,opt_sim_v);
% % 
% figure
% opt_com = compareOptions('InitialCondition',x0_v);
% compare(X_v,ssmodel,opt_com);

%%
figure
compare([X_id;X_v(1:10,:)],ssmodel,opt_com_id);