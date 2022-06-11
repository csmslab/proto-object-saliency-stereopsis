function runSoftmax_Shift_ND_Ori4_SepLv(filename1,filename2,dPercent,LR,octave,aspect,shift)
%Runs the proto-object based saliency algorithm with disparity channel
%
%inputs:
%filename1 - filename of image Right
%filename2 - filename of image Left
%dVector - Disparity Vector : Disparity channel is tuned to these numbers.

%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy, 2012
%Modified by Elena Mancinelli, Johns Hopkins University, 2018


fprintf('Start Proto-Object & disparity Saliency')
%generate parameter structure
params = makeDefaultParamsDisparity;
params.disGabor.gamma = aspect;%3%0.5; %aspect ratio of gabor filter
params.disGabor.downSample=octave;
params.disGabor.LR = LR;
params.difH.LR = LR;
% params.disGabor.compSigma=sigma;
params.shift=shift;%Shift for Gaze3D
%load and normalize image
im1 = normalizeImage(im2double(imread(filename1)));
im2 = normalizeImage(im2double(imread(filename2)));
params.dPercent = dPercent;
sizeX=size(im1,2);
if strcmp(params.disGabor.downSample,'full')
    params.disGabor.maxLevel = floor(log2(sizeX/1));
else
    params.disGabor.maxLevel = floor(log2(sizeX/1.5)*sqrt(2));
end
[~,name,~]=fileparts(filename1);
params.name=name;

[in, R,G,B,Y] = makeColors(im1);
[in2,R2,G2,B2,Y2] = makeColors(im2);
%Generate color opponency channels
rg1 = R-G;by1 = B-Y;
gr1 = G-R;yb1 = Y-B;
rg2 = R2-G2;by2 = B2-Y2;
gr2 = G2-R2;yb2 = Y2-B2;
%Threshold opponency channels
rg1(rg1<0) = 0;gr1(gr1<0) = 0;
by1(by1<0) = 0;yb1(yb1<0) = 0;
rg2(rg2<0) = 0;gr2(gr2<0) = 0;
by2(by2<0) = 0;yb2(yb2<0) = 0;

pyr1 = makePyramidDisparity2(in,params);
pyr2 = makePyramidDisparity2(in2,params);
EPyr1 = edgeEvenPyramidDisGabor(pyr1,params);
[OPyr1,~] = edgeOddPyramidDisGabor(pyr1,params);
EPyr2 = edgeEvenPyramidDisGabor(pyr2,params);
[OPyr2,~] = edgeOddPyramidDisGabor(pyr2,params);
[resMap]=Softmax_Shift_ND_Ori4_SepLv(EPyr1,OPyr1,EPyr2,OPyr2,params);
expMap=single(zeros(size(resMap)));
expMap=expMap+resMap;

save([name,'_expMap.mat'],'expMap')


fprintf('\nDone\n')