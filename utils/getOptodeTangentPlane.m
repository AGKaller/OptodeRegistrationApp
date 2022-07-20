function [planeNormal, nearestVerts] = getOptodeTangentPlane(optPos,convHullVert,convHullFac,normalize,chckOutward)
% x y z in 3 colums! Returns the normal vector of the nearest plane.
% multiple optodes in rows.
% rev. 2021-08-09: implemented processing of multiple optPos

if size(convHullFac,2)==3
    incentFH = @(f,v)mean(cat(3,...
                              v(f(:,1),:), v(f(:,2),:), v(f(:,3),:)),...
                          3);
elseif size(convHullFac,2)==4
    incentFH = @(f,v)mean(cat(3,...
                              v(f(:,1),:), v(f(:,2),:), v(f(:,3),:), v(f(:,4),:)),...
                          3);
else
    error('Face matrix must have 3 or 4 columns!');
end

assert(size(optPos,2)==3,'optPos must be row vectors of x,y,z coordinates.');

if nargin<4 || isempty(normalize)
    normalize = true;
end

if nargin<5 || isempty(chckOutward)
    chckOutward = true;
end

optPos = permute(optPos,[3 2 1]);

nOpt = size(optPos,3);
incent = incentFH(convHullFac,convHullVert);

d = bsxfun(@minus,optPos,incent);

[~,ix] = min(sqrt(sum(d.^2,2)));
nearestVerts = convHullVert(convHullFac(ix,:),:);
nearestVerts = permute(reshape(nearestVerts,nOpt,3,3),[2,3,1]);
nearestVerts(:,:,any(isnan(optPos),2)) = NaN;
% error('REVISE!');
% % nächstgelegene vertices bilden nicht zwingend eine face!
% % nimm den nächstgelegenen Vertex und suche unter seinen nachbarn die nächsten 2!
% 
% [~,ix] = sort(sqrt(sum(d.^2,2)));
% nearestVerts = convHullVert(ix(1:3),:);
% idx = bsxfun(@plus,1:nOpt:nOpt*3,(0:nOpt-1).');
planeNormal = cross(nearestVerts(1,:,:)-nearestVerts(2,:,:), ...
                    nearestVerts(1,:,:)-nearestVerts(3,:,:), 2);
% planeNormal(1,:,any(isnan(optPos),2)) = NaN;


planeNormal = ipermute(planeNormal,[3 2 1]);
nearestVerts = ipermute(nearestVerts,[3 2 1]);

if normalize
    planeNormal = bsxfun(@rdivide, planeNormal, sqrt(sum(planeNormal.^2,2)));
end
if chckOutward
    surfCent = mean(convHullVert,1);
    nearestVert = mean(nearestVerts,3);
    nearVertDelta = bsxfun(@minus,nearestVert+planeNormal,surfCent);
    vertNormDelta = bsxfun(@minus,nearestVert            ,surfCent);
    iOutWard = sqrt(sum(vertNormDelta.^2, 2)) < ...
               sqrt(sum(nearVertDelta.^2, 2));
    planeNormal(~iOutWard,:) = -planeNormal(~iOutWard,:);
end
end