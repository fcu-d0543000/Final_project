function [Y,Xf,Af] = myNeuralNetworkFunction(X,Xi,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 05-Dec-2018 21:42:23.
%
% [Y,Xf,Af] = myNeuralNetworkFunction(X,Xi,~) takes these arguments:
%
%   X = 2xTS cell, 2 inputs over TS timesteps
%   Each X{1,ts} = 12xQ matrix, input #1 at timestep ts.
%   Each X{2,ts} = 1xQ matrix, input #2 at timestep ts.
%
%   Xi = 2x1 cell 2, initial 1 input delay states.
%   Each Xi{1,ts} = 12xQ matrix, initial states for input #1.
%   Each Xi{2,ts} = 1xQ matrix, initial states for input #2.
%
%   Ai = 2x0 cell 2, initial 1 layer delay states.
%   Each Ai{1,ts} = 5xQ matrix, initial states for layer #1.
%   Each Ai{2,ts} = 1xQ matrix, initial states for layer #2.
%
% and returns:
%   Y = 1xTS cell of 2 outputs over TS timesteps.
%   Each Y{1,ts} = 1xQ matrix, output #1 at timestep ts.
%
%   Xf = 2x1 cell 2, final 1 input delay states.
%   Each Xf{1,ts} = 12xQ matrix, final states for input #1.
%   Each Xf{2,ts} = 1xQ matrix, final states for input #2.
%
%   Af = 2x0 cell 2, final 0 layer delay states.
%   Each Af{1ts} = 5xQ matrix, final states for layer #1.
%   Each Af{2ts} = 1xQ matrix, final states for layer #2.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [0;0;90345.875;6.348233223;0;-8.908602715;-8.404230118;269.4362793;114712.6875;821617.5625;646523;0];
x1_step1.gain = [0.487398059370769;2.43762639961286;0.000334938245760938;0.0207275085253355;1.9999847421164;0.0910526205279148;0.104628625491563;0.0487540692827698;5.79527529713685e-08;5.90806231963713e-08;5.3944012642103e-08;35.739045852892];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = 0;
x2_step1.gain = 1.99292511583877;
x2_step1.ymin = -1;

% Layer 1
b1 = [-11.022187716514049;16.894397313955555;5.7756736726569251;-1.6590096507766927;10.623140946416305];
IW1_1 = [-3.49939565898489 -3.28806773510785 0.08824741189391351 -0.35210601641772415 -0.09676299745622885 0.086308009361096075 0.018751145025186908 -0.53059208005469272 -5.5789879318731828 -4.450140491134766 6.5073399144119666 -0.69749009251555194;2.2263114820911194 0.48711496729698672 -0.037854816926872967 -0.12408364364128834 0.17951315891135999 -0.25504451841787495 -0.15493880047424058 0.79783301870948664 -1.0902805864582401 -1.2356949742646599 0.73259797060237253 0.04243362979692878;0.83336065278033677 0.19608966335981551 -0.038995022132333947 0.25632394326633334 -0.13298016101011528 -0.45150797123828601 -0.21856123927437751 -0.76271167934191975 8.2224081128343371 7.6048981063191361 -8.8252245384351511 -0.063664191124592776;-1.4495949746632621 -0.33666466626676772 0.0027084836954565372 0.048830442242165435 -0.12375947225785025 0.17396218733995666 0.10715550666169694 -0.55584974217504413 0.71992406671217002 0.81703876873711789 -0.49559371090390814 -0.037402741850543847;3.5330735291264581 3.2196342378937244 -0.083482180251852445 0.34017910192241829 0.10738256966199132 -0.11839770583504128 -0.035757161140020435 0.60457314875521884 5.2020988211463068 4.0449935990273493 -6.1178129184754315 0.66716774160191883];
IW1_2 = [0.91395516595080806;13.578465130580224;-1.4676516362173775;1.0232592560596541;-0.93461389228882463];

% Layer 2
b2 = -0.18574650604285389;
LW2_1 = [7.3501472007509498 0.41950993165912853 -0.27221869000608928 0.89825439070465951 7.2398197765228174];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 1.99292511583877;
y1_step1.xoffset = 0;

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
    X = {X};
end
if (nargin < 2), error('Initial input states Xi argument needed.'); end

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
    Q = size(X{1},2); % samples/series
elseif ~isempty(Xi)
    Q = size(Xi{1},2);
else
    Q = 0;
end

% Input 1 Delay States
Xd1 = cell(1,2);
for ts=1:1
    Xd1{ts} = mapminmax_apply(Xi{1,ts},x1_step1);
end

% Input 2 Delay States
Xd2 = cell(1,2);
for ts=1:1
    Xd2{ts} = mapminmax_apply(Xi{2,ts},x2_step1);
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS
    
    % Rotating delay state position
    xdts = mod(ts+0,2)+1;
    
    % Input 1
    Xd1{xdts} = mapminmax_apply(X{1,ts},x1_step1);
    
    % Input 2
    Xd2{xdts} = mapminmax_apply(X{2,ts},x2_step1);
    
    % Layer 1
    tapdelay1 = cat(1,Xd1{mod(xdts-1-1,2)+1});
    tapdelay2 = cat(1,Xd2{mod(xdts-1-1,2)+1});
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*tapdelay1 + IW1_2*tapdelay2);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
end

% Final Delay States
finalxts = TS+(1: 1);
xits = finalxts(finalxts<=1);
xts = finalxts(finalxts>1)-1;
Xf = [Xi(:,xits) X(:,xts)];
Af = cell(2,0);

% Format Output Arguments
if ~isCellX
    Y = cell2mat(Y);
end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
x = bsxfun(@minus,y,settings.ymin);
x = bsxfun(@rdivide,x,settings.gain);
x = bsxfun(@plus,x,settings.xoffset);
end