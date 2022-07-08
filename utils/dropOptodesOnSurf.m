function [I, u, sI] = dropOptodesOnSurf(optPos,convHullVert,convHullFac)
% Version of dropOptodeOnSurf that takes multiple optPos (in 3rd dim!).
% Take care of consistent UNITS!
% all coordinates have to be row-vectors!
%
% See also: dropOptodeOnSurf.m

% get the normal vector of the plane tangential to the convex hull at the
% Optode position.
[planeNormal, nearVerts] = getOptodeTangentPlane(optPos,convHullVert,convHullFac);




u = planeNormal;
w = optPos - nearVerts(1,:,:);
D = dot(planeNormal,u);
N = -dot(planeNormal,w);


sI = N ./ D;
I = optPos + bsxfun(@times,sI,u);

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