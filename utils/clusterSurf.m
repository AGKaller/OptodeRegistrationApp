function [splitSurfs,nVerts] = clusterSurf(fragmentedSurf,clusterCutoff)
% Split patch into fragments based on vertex distance (using a clustering
% algorithm).
%
% INPUT
% - fragmentedSurf      Structure with fields 'faces' & 'vertices' defining
%                       the fragmented surface.
% - clusterCutoff       Vertex distance threshold at which the input
%                       surface is split. Defaults to 5.
%
% OUTPUT
% - splitSurfs          Structure vector defining the clusters of
%                       fragmentedSurf.
% - nVerts              Number of vertices of each cluster.
%
%
% Konrad Schumacher, 2022


if ~exist('clusterCutoff','var') || isempty(clusterCutoff)
    clusterCutoff = 5;
end

Z = linkage(fragmentedSurf.vertices,'single','euclidean');
T = cluster(Z,'cutoff',clusterCutoff,'criterion','distance');

for c = max(T):-1:1
    splitSurfs(c) = subsetSurf(fragmentedSurf,T==c);
end

if nargout>1
    nVerts = arrayfun(@(x)size(x.vertices,1),splitSurfs);
end

end