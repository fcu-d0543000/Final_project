function [Y,Xf,Af] = myNeuralNetworkFunction(X,Xi,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Auto-generated by MATLAB, 05-Dec-2018 19:37:01.
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
b1 = [-3.7712050754397554719;10.10816934026300018;1.2724903778457394843;2.2983407611876129906;0.56914183464741208152];
IW1_1 = [-3.4125131181922432333 0.03426199567410899427 -0.20254139017938688205 -0.4364790107070568026 0.069216514278191809684 -0.027910396133009746089 0.10918504722367940174 -0.10642407347009547047 0.0051179437973481933452 0.28502589803672367941 -0.40371071426407667548 -0.14150285433334466867 0.24519728630899723099;-1.7651518903772251967 -0.072520858613801392201 3.9773936796273909877 4.5345941491104406751 -0.078793005173533534058 0.21700410933404395974 -0.055218472049159673942 0.25411553021074861913 0.33853799272057155667 0.50645260128815550171 -1.3197984134659692668 -0.2226133189935480261 1.1390999609891778732;2.889213024380950845 0.030560679313191636136 0.6405971475043883423 0.75531839031898395653 0.0066434525739596170246 0.097597672710489080661 0.090714338915796555174 0.073591231730958328594 -0.032364561321249332715 -0.017148355030474460303 -0.043547082993159326458 -0.08003880456987269576 -0.35076826939688160456;-0.61842161653927618659 0.1906363984627774677 2.1455101975238632939 0.020685104773865741618 0.62710743630924292713 0.70054112265051882158 -0.39671483012424813008 0.81045905548626517856 0.33641726521659004456 1.206990026749108047 -4.2586839385071835196 -0.99480781626847980537 0.25617170948292750099;-3.0052230085007431981 0.0065105948047256521904 -0.34610014327017668556 0.30936566172039897671 -0.0065511374312349560101 0.14214138564427106215 0.40980909804401499663 0.44593120929433677224 0.32367727575971105836 0.79429405393444696415 -0.7779896910663639531 -0.083536600614797437703 -0.08499270556852059344];
IW1_2 = [-1.8819972956053834245;-2.9418560442700503188;-0.63141384981778136964;-2.7115806025706281623;1.9261430581741982859];

% Layer 2
b2 = -0.95726547147702789609;
LW2_1 = [-0.85653116218593872144 -0.22279123035833475752 -0.66175567017264325109 0.17935649562698338655 0.20303242125713513722];

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