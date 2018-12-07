function [Y,Xf,Af] = myNeuralNetworkFunction(X,Xi,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 07-Dec-2018 19:02:27.
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
x1_step1.xoffset = [0;0;0;90345.875;6.348233223;0;-8.908602715;-8.404230118;269.4362793;821617.5625;646523;0];
x1_step1.gain = [0.666666666666667;0.487398059370769;2.43762639961286;0.000334938245760938;0.0207275085253355;1.9999847421164;0.0910526205279148;0.104628625491563;0.0487540692827698;5.90806231963713e-08;5.3944012642103e-08;35.739045852892];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = 0;
x2_step1.gain = 1.99292511583877;
x2_step1.ymin = -1;

% Layer 1
b1 = [0.26253602030021889;-4.3655663645288625;-4.2175992277794334;-0.21889744874757686;0.49549632982332276];
IW1_1 = [0.027140303111294273 0.46359582225607782 -0.32842040434955461 0.061175901292307718 0.12527345173503715 0.08786278753788089 -0.033119950150688443 0.066316664353124818 0.69769363789560956 -2.784259431664827 -0.055273817303910462 0.95672670741971355;0.015440591136006251 0.022896804024456784 -0.38664016255566452 0.061738983473802064 0.040344001871576489 0.0041374844631983021 -0.066245572847011894 0.0047413432928581209 0.43393126801799153 -1.4141594772870303 -0.063205302482777573 0.47303242792428257;0.031189386286615731 0.18670920428486196 -0.35678675494381501 0.0731868617103201 0.036005363602042567 0.0295528566920671 -0.069668204280694937 0.0063097349751140477 0.5346264690798036 -1.6294357260514598 -0.070764411676968592 0.576967957293128;0.021786241179062735 0.57420265756837874 -0.30502701363882706 0.046274764231623869 0.14840448625177122 0.12678296342181383 -0.03488815404171388 0.08236064206982141 0.82755252402069734 -3.1403101919112895 -0.082503152948622011 1.032013986637528;0.012036059830528517 0.26291892697820168 0.17982959788031852 -0.0041413687518751519 -0.018928989744189384 0.0316362197112263 -0.0036661064663153884 -0.0111990986778046 0.017742996917990458 0.21388991302111526 -0.0082953175585438379 -0.059309659800062448];
IW1_2 = [0.88734096842990628;-4.3914721110850907;-4.3620389714622059;0.49525889345470653;-0.3699979353770656];

% Layer 2
b2 = 0.1921289901766052;
LW2_1 = [-2.609719623749283 -3.1556610069966937 2.9869685358115898 2.1977703375843336 -2.2777643719811329];

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