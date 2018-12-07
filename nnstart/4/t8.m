function [Y,Xf,Af] = myNeuralNetworkFunction(X,Xi,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Auto-generated by MATLAB, 05-Dec-2018 19:34:37.
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
x1_step1.xoffset = [0;0;0;0;90345.875;6.348233223;0;-8.908602715;-8.404230118;269.4362793;821617.5625;646523;0];
x1_step1.gain = [0.0869565217391304;0.666666666666667;0.487398059370769;2.43762639961286;0.000334938245760938;0.0207275085253355;1.9999847421164;0.0910526205279148;0.104628625491563;0.0487540692827698;5.90806231963713e-08;5.3944012642103e-08;35.739045852892];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = 0;
x2_step1.gain = 1.99292511583877;
x2_step1.ymin = -1;

% Layer 1
b1 = [-6.8452956793026498161;-1.9281633874560109021;1.6405641305971294663;3.8412728474707802384;3.6577974191138240556];
IW1_1 = [-2.5391668969470773121 0.062602327393983928094 -0.28334827103084775368 -0.33158299786013972765 0.59414861499067150863 -0.012089721466956918766 -0.1067668469571533274 0.73771488914249816471 0.38310143201034357885 0.0016362695463312849908 -0.27939428618870204568 -0.39589833625996018185 -0.017321608364308269806;-1.5755742922271671613 -0.09729411115181818559 -1.5944514360622985549 0.0089869835633512619444 -0.24787336737303686252 0.1450544082140582669 0.22579445725016883406 0.23155702124482574478 0.41153143765122895958 1.1084783562238551546 -2.3588493127996121856 -0.57218833025172144424 0.73269865988622628894;1.9547389036471745083 0.006732925254263641239 0.28775423340364009173 1.0721595935997501048 -0.019720789779136289194 0.10699796969199021346 0.039434747357075451701 0.1089542439009549557 0.058719656988822838128 0.11491233418603193084 -0.29319008203354940401 -0.23589938933479334682 0.030028232173240253927;2.8531347715837154233 -0.069319077963780145746 0.10442804349356651916 0.33478397591650316256 -0.66894406044645793319 0.064993315069628687652 0.073942208515078863829 -0.74249670925007127398 -0.3921140717795599806 0.13163923127416887748 -0.021415678598104739838 0.37403272518329677698 0.064534782062369316913;2.7806612484228629967 -0.0079543077269310299982 0.0084646506460503492808 1.1443017675941822286 -0.18857134200400402224 0.21756656141874899935 -0.043143101478096794466 0.13817629024230818069 0.055189454210186859873 0.2890231282520618894 -0.73841031844293170128 -0.2460760373394223488 0.071942312852595655115];
IW1_2 = [-4.1840946834651422392;1.6527843681722207414;-0.86128132445779825854;0.95526414894602618144;0.54482344586948350251];

% Layer 2
b2 = -0.74482762869514762549;
LW2_1 = [-1.7193643117949410914 0.2376727360423398494 -0.93640745940794201108 -1.7116713390625064584 0.90076456076981337162];

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