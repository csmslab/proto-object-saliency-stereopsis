function params =  makeDefaultParamsDisparity
%Sets the default parameters for the grouping saliency map
%
%inputs: none
%
%Outputs:
%params - parameter structure for grouping saliency map
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012
%Modified by Elena Mancinelli, Johns Hopkins University, 2018
%Modified by Takeshi Uejima, Johns Hopkins University, 2019-2020

%pyramid levels over which to compute
minLevel = 1;%leave as 1
maxLevel =10; %How many times do you want to downsample the pyramid

%Set downsampling mode
downSample = 'half'; %downsample by 'half' or 'full' octave. better performance at half

params.channels = ['ICOD']; %feature channels on which to operate
                           %I - intensity
                           %C - color opponency
                           %O - orientation
                           %D - disparity

params.maxLevel = maxLevel;


%ENTER EDGE MAP ORIENTATIONS (DEG) FOR 1ST QUADRANT ONLY INTO ORI
%   - computations are done on ori and ori + 90 degrees
ori = [0 45];
oris = deg2rad([ori (ori+90)] );

%Enter zero crossing radius of Center surround and x where the std of the outer gauss = x*(std inner gauss)
[sigma1,sigma2] = calcSigma(2,3);

%Center-Surround parameters
params.csPrs.inner = sigma1;
params.csPrs.outer =sigma2;
params.csPrs.depth = maxLevel;
params.csPrs.downSample = downSample;

%get radius of zero crossing in center surround mask
msk = makeCentreSurround(params.csPrs.inner,params.csPrs.outer);
temp = msk(round(size(msk,1)/2),:);
temp(temp>0)= 1;
temp(temp<0)= -1;
zc = temp(round(size(msk,2)/2):end-1)-temp(round(size(msk,1)/2)+1:end);
R0 = find(abs(zc)==2);
fprintf('\nCenter Surround Radius is %d pixels. \n',R0);

%gabor filter parameters for orientation channel
params.gaborPrs.lamba = 8; %wavelenth
params.gaborPrs.sigma = 0.4*params.gaborPrs.lamba; %std of gaussian
params.gaborPrs.gamma = 0.8;%aspect ratio

%even orientation cell parameters
params.evenCellPrs.minLevel = minLevel;
params.evenCellPrs.maxLevel = maxLevel;
params.evenCellPrs.oris = oris;
params.evenCellPrs.numOri = length(oris);
params.evenCellPrs.lambda = 4; %gabor filter wavlength
params.evenCellPrs.sigma = 0.56*params.evenCellPrs.lambda; %std of gaussian in gabor filter
params.evenCellPrs.gamma = 0.5; %aspect ratio of gabor filter

%odd orientation cell parameters
params.oddCellPrs.minLevel = minLevel;
params.oddCellPrs.maxLevel = maxLevel;
params.oddCellPrs.oris = oris;
params.oddCellPrs.numOri = length(oris);
params.oddCellPrs.lambda = 4;
params.oddCellPrs.sigma = 0.56*params.oddCellPrs.lambda;
params.oddCellPrs.gamma =  0.5;

%border pyramid paramers
params.bPrs.minLevel = minLevel;
params.bPrs.maxLevel = maxLevel;
params.bPrs.numOri = length(oris);
params.bPrs.alpha = 1;
params.bPrs.oris = oris;
params.bPrs.CSw = 1; %inhibition between CS pyramids

%von Mises distribution paramers
params.vmPrs.minLevel = minLevel;
params.vmPrs.maxLevel = maxLevel;
params.vmPrs.oris = oris;
params.vmPrs.numOri = length(oris);
params.vmPrs.R0 =R0;

%Grouping Cell inhibition parameters
params.giPrs.w_sameChannel = 1;% Inhibitory weight for same channel inhibition

%Disparity Gabor parameters
params.disGabor.minLevel = 1;
params.disGabor.maxLevel = 12;
params.disGabor.oris = oris;
params.disGabor.numOri = length(oris);
params.disGabor.lambda = 4; %gabor filter wavlength
params.disGabor.sigma = 0.56*params.evenCellPrs.lambda; %std of gaussian in gabor filter
params.disGabor.gamma = 3;%0.5; %aspect ratio of gabor filter
params.disGabor.downSample = 'full';
params.disGabor.bins = [1,1,1];
params.disGabor.algo = 'WTA';
params.disGabor.blockSize = 10;
%Disparity normalization Paramters
params.disNorm.Inhi=5;
params.disNorm.CoEx=2.0;
params.disNorm.CoIn=2.0;
params.disNorm.ExSig=1.0;
params.disNorm.InSig=0.9;
params.disNorm.numIter=2;
%Disparity Differentiation Paramters
params.difH.blockSize=7;
%Disparity 3D Center-Surround Z axis sigma
[sigmaZ1,sigmaZ2] = calcSigma(5,3);
params.disCS.inner = sigmaZ1;
params.disCS.outer = sigmaZ2;

params.save=0;

