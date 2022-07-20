function [I, u, sI] = dropOptodesOnSurf(optPos,convHullVert,convHullFac)
% Version of dropOptodeOnSurf that takes multiple optPos (in 1st dim!).
% Take care of consistent UNITS!
% all coordinates have to be row-vectors!
%
% See also: dropOptodeOnSurf.m

% get the normal vector of the plane tangential to the convex hull at the
% Optode position.
[planeNormal, nearVerts] = getOptodeTangentPlane2(optPos,convHullVert,convHullFac,false,false);


% planeNormal = permute(planeNormal,[3 2 1]);
% nearVerts = permute(nearVerts,[3 2 1]);
% optPos = permute(optPos,[3 2 1]);

u = planeNormal;
w = optPos - nearVerts(:,:,1);
D = dot(planeNormal,u,2);
N = -dot(planeNormal,w,2);


sI = N ./ D;
I = optPos + bsxfun(@times,sI,u);

% I = ipermute(I,[3 2 1]);
% u = ipermute(u,[3 2 1]);
% sI = ipermute(sI,[3 2 1]);

% dot/inner product of distance photon positions-Optiode position and the
% plane normal gives the signed distances between plane and photon pos.
% distance = (planeNormal-optPos)*planeNormal.';
% 
% % trajectory of the crossing photon path:
% crossTraj = planeNormal+optPos;
% 
% % coordinates of crossing point
% % taken from https://www.mathworks.com/matlabcentral/fileexchange/17751-straight-line-and-plane-intersection?w.mathworks.com
% photPos1 = optPos;
% % w = photPos1 - optPos;
% D = dot(planeNormal, planeNormal);
% N = -distance; % -dot(planeNormal, w);
% % compute the intersection parameter
% sI = N/D;
% % crossing point
% I = photPos1 + sI.*crossTraj;
% 
end