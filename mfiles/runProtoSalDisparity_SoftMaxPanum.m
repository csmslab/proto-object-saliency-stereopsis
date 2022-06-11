function runProtoSalDisparity_SoftMaxPanum(filename1,filenameOut,panumPix)
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
%load and normalize image
load(filename1)
% load(filename2)
expMap=double(expMap);
[~,name,~]=fileparts(filenameOut);
params.name=name;

numDis=size(expMap,3);
zeroDis=uint16(numDis-1)/2;
panum1=zeroDis-panumPix;
panum2=zeroDis+panumPix;

img1=sum(expMap(:,:,1:panum1),3);
img2=sum(expMap(:,:,panum1+1:panum2),3);
img3=sum(expMap(:,:,panum2+1:end),3);

img{1}.type = 'DisSoftMax';
img{1}.subtype{1}.pyr = makePyramid(img1,params);
img{1}.subtype{1}.type = 'Near View';
img{1}.subtype{2}.pyr = makePyramid(img2,params);
img{1}.subtype{2}.type = 'Zero View';
img{1}.subtype{3}.pyr = makePyramid(img3,params);
img{1}.subtype{3}.type = 'Far View';

%generate border ownership structures
[b1Pyr b2Pyr]  = makeBorderOwnership2(img,params);        
%generate grouping pyramids
gPyr = makeGrouping(b1Pyr,b2Pyr,params);
%normalize grouping pyramids and combine into final saliency map
collapseLevel=8;
[h]= ittiNorm0(gPyr,collapseLevel,params);
 
imagesc(img1);colorbar;axis image
saveas(gcf,['Result_',name,'_img1.png'])
imagesc(img2);colorbar;axis image
saveas(gcf,['Result_',name,'_img2.png'])
imagesc(img3);colorbar;axis image
saveas(gcf,['Result_',name,'_img3.png'])
imagesc(h.data);colorbar;axis image
saveas(gcf,['Result_',name,'.png'])

save(['Result_',name,'.mat'],'h','-v7.3')

fprintf('\nDone\n')