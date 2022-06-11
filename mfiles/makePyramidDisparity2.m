function pyr = makePyramidDisparity2(img,params)
%Makes the centre surround pyramid using a CS mask on each
%layer of the image pyramid
%
%inputs :
%img - input image
%params - model parameter structure
%
%outputs :
%pyr - image pyramid
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012

if (nargin ~= 2)
    error('Incorrect number of inputs for makePyramid');
end
if (nargout ~= 1)
    error('One output argument required for makePyramid');
end
prs=params.disGabor;
depth = prs.maxLevel;

pyr(1).data = img;
if depth>=2
    for l = 2:depth
        if strcmp(prs.downSample,'half')%downsample halfoctave
            %TU changed imresize way to reduce noise
            %         pyr(l).data = imresize(pyr(l-1).data,0.7071,'cubic');
            pyr(l).data = imresize(pyr(1).data,(1/sqrt(2))^(l-1),'cubic');
            
        elseif strcmp(prs.downSample,'full') %downsample full octave
            pyr(l).data = imresize(pyr(1).data,(1/2)^(l-1),'cubic');
        else
            error('Please specify if downsampling should be half or full octave');
        end
    end
end