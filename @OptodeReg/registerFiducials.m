function [registerdFids, TM] = registerFiducials(fiducials,referenceFids)
% Registers 3d point pairs; returns 1st input registered to 2nd input
% If inputs are structures, intersection of fieldnames are used as
% coordinates to perform registration. Otherwise inputs have to be Nx3
% matrices of coordinates.
%
% 2nd output is the transformation matrix
%
% Adapted from n2n_spat_match_npoints.m
% Konrad Schumacher, 7.2022

if isstruct(fiducials)
    assert(isstruct(referenceFids),'1st and 2nd input must be both either structs or matrices');
    fidNames = intersect(fieldnames(fiducials), ...
                         fieldnames(referenceFids)); %{'Nasion','RPA','LPA'};
    fids = nan(3,numel(fidNames));
    fidsRef = fids;
    for k = 1:numel(fidNames)
        fids(:,k) = fiducials.(fidNames{k});
        fidsRef(:,k) = referenceFids.(fidNames{k});
    end
    structFlag = true;
else
    fids = fiducials.';
    fidsRef = referenceFids.';
    structFlag = false;
end
 

[R,T] = PointRegister(fidsRef,fids);
[R]   = [R zeros(3,1); zeros(1,3) 1];
[T]   = [eye(3) T; zeros(1,3) 1];
[TM]  = inv(R)*inv(T);

fids = ApplyTM(TM,fids.');


if structFlag
    registerdFids = fiducials;
    for k = 1:numel(fidNames)
        registerdFids.(fidNames{k}) = fids(k,:);
    end
else
    registerdFids = fids;
end

end 



%==========================================================================
% SubFunctions
%==========================================================================

% PointRegister -----------------------------------------------------------
% Fit function based on: Fitzpatrick, West, Maurer (1998). Predicting
% Error in Rigid-body, Point-based Registration. IEEE Transactions on
% Medical Imaging.
%--------------------------------------------------------------------------

function [R,T] = PointRegister(X,Y)

[~, N] = size(X);

meanX = X*ones(N,1)/N;
meanY = Y*ones(N,1)/N;
Xc = X-meanX*ones(1,N);
Yc = Y-meanY*ones(1,N);
H = Xc*Yc';
[U,~,V] = svd(H);
R = V*diag([1,1,det(V*U)])*U';
T = meanY - R*meanX;

end
