function [resMap]=Softmax_Shift_ND_Ori4_SepLv(EPyr1,OPyr1,EPyr2,OPyr2,params)
%Calculate patch-wise similarity between two Gabor filtered
% pyramids

dPercent=params.dPercent;
prs=params.disGabor;
% numOri=prs.numOri;
maxLv=prs.maxLevel;
[sizeY,sizeX]=size(EPyr1(1).orientation(1).data);
shift=params.shift;%Shift for Gaze3D
maxDis=ceil(sizeX*dPercent);
dVector=-maxDis:maxDis;
dVector=dVector-shift;%Shift for Gaze3D
% halfLv=floor(maxLv/2);
% LVs=[maxLv,1];
% numIter=size(LVs,1);
% resMap=cell(1,numIter);%zeros(sizeY,sizeX);
% occMap=cell(1,numIter);%true(sizeY,sizeX);
% constantLow=0;

resMap=single(zeros(sizeY,sizeX,length(dVector)));


% difMap2=zeros(sizeY,sizeX,length(dVector));

for ori=1:4%numOri
    for lv=1:maxLv
        disCh=0;
        difMap1=zeros(sizeY,sizeX,length(dVector));
        for dis=dVector
            disCh=disCh+1;
            Even2 = zeros(sizeY,sizeX+abs(dis));
            Odd2 = zeros(sizeY,sizeX+abs(dis));
            Even1 = zeros(sizeY,sizeX+abs(dis));
            Odd1 = zeros(sizeY,sizeX+abs(dis));
            if dis>=0
                X1Start=1+abs(dis);
                X1End=sizeX+abs(dis);
                X2Start=1;
                X2End=sizeX;
            else
                X1Start=1;
                X1End=sizeX;
                X2Start=1+abs(dis);
                X2End=sizeX+abs(dis);
            end
            Even1(:,X1Start:X1End)=EPyr1(lv).orientation(ori).data;
            Odd1(:,X1Start:X1End)=OPyr1(lv).orientation(ori).data;
            Even2(:,X2Start:X2End)=EPyr2(lv).orientation(ori).data;
            Odd2(:,X2Start:X2End)=OPyr2(lv).orientation(ori).data;
            
            S12=(Even1+Even2).^2;
            S34=(Odd1+Odd2).^2;
            %                 MonoC1=Even1.^2+Odd1.^2;
            %                 MonoC2=Even2.^2+Odd2.^2;
            BiC=(S12+S34);%./(MonoC1+MonoC2+eps);
            
            difMap1(:,:,disCh) = difMap1(:,:,disCh) + BiC(:,X1Start:X1End);
%             difMap2(:,:,disCh) = difMap2(:,:,disCh) + BiC(:,X2Start:X2End);
        end
        denMap=zeros(sizeY,sizeX);
        for ii=1:length(dVector)
            denMap=denMap+exp(difMap1(:,:,ii));
        end
        expTmpMap=zeros(sizeY,sizeX,length(dVector));
        for ii=1:length(dVector)
            expTmpMap(:,:,ii)=exp(difMap1(:,:,ii))./denMap;
        end
        resMap = resMap + single(expTmpMap);
    end
end
% difMap1=difMap1/(2*maxLv);
% difMap2=difMap2/(2*maxLv);
