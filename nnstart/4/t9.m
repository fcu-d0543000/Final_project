function [Y,Xf,Af] = myNeuralNetworkFunction(X,Xi,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Auto-generated by MATLAB, 05-Dec-2018 19:35:59.
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
b1 = [4.2459749508478328295;4.3571275506308877468;-10.533538270435549578;-0.20917652863915586758;5.5283328085048868417];
IW1_1 = [0.4536982223231539324 -0.045659400828750938695 1.2506840874074727221 2.0445483861386399838 -0.07244905053208053336 0.11105316342241114413 0.066006151700474496868 0.030591668274878084516 0.034276030439126616012 -0.073673981493889914574 0.8296855707760026899 -0.064568946928469928004 -0.15391068495405332839;-1.034933223604560748 -0.131260026504041033 0.76573184427079654668 1.5349194647488126897 -0.20752585074019327949 0.16297967007193528421 0.13885889832590167514 -0.15998001098784228602 0.014488286619964818591 -0.073615860583894826563 1.2978115597599015896 -0.096207593188698245501 0.99925247471096811935;-2.8704656899762097666 0.049285106209709668434 -0.38676119680339154927 -0.16253316894619040944 0.21985023722599741913 -0.11482119633637544176 -0.12348209331957812895 0.3160320810529367308 0.17276304008958115466 -0.27242648405161590253 0.2586419354030879969 0.10401347995045406858 0.081917032709797291123;2.0818713474631715954 -0.013434449406475078639 0.42301684716672527387 0.15698443450410032307 -0.11745319325963533841 0.062658319112796970196 0.070951671076228003954 -0.22947773195611570474 -0.19319746528285566822 -0.17655938073985191772 0.27080526631110346525 -0.035762561791919313114 -0.094456503582838399757;-0.49979628279223664578 -0.0043781132502295093054 2.9425610795059538027 1.1242096052354468849 -0.080194092378017958755 -0.14012931705648795644 0.5026977839835069517 -1.5986034071835846238 -0.45125195373195881032 3.4332543530023826861 -4.3379686837893798312 -0.43324989204391095576 1.2182436901715727462];
IW1_2 = [-1.3531621721108972878;-1.7960464470558246131;-8.2101156852135375175;-1.7776796128963390231;-2.5728766288040922916];

% Layer 2
b2 = -0.36106638142621139131;
LW2_1 = [-1.1825230746514061586 0.66710926295902606142 -0.49156495742342498634 -0.48086381849202985972 -0.12530777061335815481];

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