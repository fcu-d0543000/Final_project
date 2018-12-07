function [Y,Xf,Af] = myNeuralNetworkFunction(X,Xi,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Auto-generated by MATLAB, 05-Dec-2018 19:42:27.
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
x1_step1.xoffset = [0;0;0;90345.875;6.348233223;0;-8.908602715;-8.404230118;269.4362793;114712.6875;821617.5625;0];
x1_step1.gain = [0.0869565217391304;0.487398059370769;2.43762639961286;0.000334938245760938;0.0207275085253355;1.9999847421164;0.0910526205279148;0.104628625491563;0.0487540692827698;5.79527529713685e-08;5.90806231963713e-08;35.739045852892];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = 0;
x2_step1.gain = 1.99292511583877;
x2_step1.ymin = -1;

% Layer 1
b1 = [0.038538529575293245522;3.2746112443819654914;5.0928133476255759149;5.7191060495493637461;1.6999798874776761437];
IW1_1 = [-2.3496239128888931624 1.2887215104124871701 0.29569714265642860207 -0.12379857718928155563 0.15675453252745127908 0.34082017815148923923 -0.18549489242582609116 0.13715363576907496634 1.4978178552290566383 -0.38985683302214046986 -2.7657628470536823606 0.34145266460440115708;-3.7310351938719317211 2.3905717132959694027 0.38411925874329955199 -0.083211733871010343244 0.051739749179368174636 0.11020138976216997673 -0.29380765422536719855 0.073501042065233085365 1.9561382640848052894 -0.85268802609036420392 -4.2924736353419046253 0.61270965746776639982;0.97894121857326321656 0.38104351457360985389 0.25571084693580420355 -0.0057278722634684173937 0.034278136781751955553 0.012815969752692260922 0.015539700174975133382 0.00063843485779220988247 0.060218520222130728081 -0.0006649563903979114482 -0.011956620461646191161 -0.029905394294040994752;-2.272668527270830463 0.66814568554532882683 -1.4726060261775784088 0.9001486803955968119 -0.44429989328130153892 -0.29912636110634716058 -0.58519957237707764808 -0.99049089012821334155 -2.5497687607143912913 1.8604302518549538092 10.131738634301896695 1.1484952135367276771;1.0670119105535591508 0.96450899285878421985 0.56231698240255334476 0.0030693683417855684332 0.052991752082811455216 0.075840657928374327623 -0.026127190822012879429 -0.026693256489932312009 0.069768963063434427663 0.0028645735225120319382 0.1232941690843885052 -0.066699172267447245921];
IW1_2 = [-0.64223102619477867581;0.99085660538052378055;3.1021602091197544304;5.9129308932876538663;-0.83745573590438493472];

% Layer 2
b2 = -1.8794055007187722151;
LW2_1 = [0.2139011503923796409 -0.13214419073265795679 2.0383953793293678736 0.14217500793383394675 -0.92762621207306850124];

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