function [Y,Xf,Af] = myNeuralNetworkFunction(X,Xi,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 05-Dec-2018 21:28:31.
%
% [Y,Xf,Af] = myNeuralNetworkFunction(X,Xi,~) takes these arguments:
%
%   X = 2xTS cell, 2 inputs over TS timesteps
%   Each X{1,ts} = 13xQ matrix, input #1 at timestep ts.
%   Each X{2,ts} = 1xQ matrix, input #2 at timestep ts.
%
%   Xi = 2x1 cell 2, initial 1 input delay states.
%   Each Xi{1,ts} = 13xQ matrix, initial states for input #1.
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
%   Each Xf{1,ts} = 13xQ matrix, final states for input #1.
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
x1_step1.xoffset = [0;0;0;90345.875;6.348233223;0;-8.908602715;-8.404230118;269.4362793;114712.6875;821617.5625;646523;0];
x1_step1.gain = [0.666666666666667;0.487398059370769;2.43762639961286;0.000334938245760938;0.0207275085253355;1.9999847421164;0.0910526205279148;0.104628625491563;0.0487540692827698;5.79527529713685e-08;5.90806231963713e-08;5.3944012642103e-08;35.739045852892];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = 0;
x2_step1.gain = 1.99292511583877;
x2_step1.ymin = -1;

% Layer 1
b1 = [7.668686206598732;0.81169803254576978;9.2111613096133702;5.2363160198647245;-6.1328548620781183];
IW1_1 = [0.025438940492311421 -0.00081193067168637491 -0.76062979306942657 0.07313679572515297 0.68992073773899931 -0.12372383426569809 1.1395086263345158 0.71646032014470895 3.137304000958014 -2.7240636281980612 -5.878198229038734 1.9549949324799805 1.1744147525759829;-0.011205885402457197 0.070322750678952467 0.829265887480229 -0.12305782048667849 -0.79519680670988058 0.012105039393573921 -1.0285937649676058 -0.70332056496681805 -4.0498855069410151 3.3001555844423049 7.4808711711120361 -2.2249365742519966 -1.3917893159050108;-0.31703775579127302 -0.30229473098484994 4.0932300036302136 -0.3485881066567128 -0.013059170195477688 0.9299449618909067 0.73096164242307837 0.58895167485004962 -0.80113261420969972 5.0512557823088686 4.6162082695777711 -6.1884112076170705 -1.4595211037496825;-0.057652751847853324 1.1227323681399399 0.80263406404438586 -0.070463457792535267 0.1641799253691282 -0.013409551754137321 -0.038328218280675751 -0.038061025652504382 -0.37697464224414595 5.7086188781697853 5.121170774859598 -6.2066238172785599 -0.62227358846503522;-0.079242027045603097 -3.655319865201085 -1.9014671362566855 -0.0038793975878384937 -0.0082547539327300287 -0.10369912846152857 -0.097648699541863671 -0.060149445762573271 -0.40832412633126208 0.51616347738896617 0.67901049184322559 -0.40653551678108596 -0.047021117342187169];
IW1_2 = [5.0646240541268117;4.184966709872497;7.6207338611219537;-0.74189262954973212;1.2366739131510367];

% Layer 2
b2 = 0.28520163805547655;
LW2_1 = [0.35095747991244697 0.3813403138225559 0.041492198671546521 -0.70321514185146439 0.54608644738781087];

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