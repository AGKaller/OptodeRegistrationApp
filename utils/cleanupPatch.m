function [verts,faces,colors] = cleanupPatch(verts,faces,colors)
% vf = cleanupPatch(vf)
% input & output is a structure with fields 'vertices' & 'faces'
% Alternatively use faces & vertices as separate variables:
% [verts,faces] = cleanupPatch(verts,faces)

tol = 1e-10;
structFlag = false;
% handle input
if ~exist('face','var') && isstruct(verts) && all(isfield(verts,{'faces','vertices'}))
    verts_ = verts; % preserve other fields
    faces = verts_.faces;
    verts = verts_.vertices;
    if isfield(verts_,'color')
        colors = verts_.color;
    else, colors = [];
    end
    structFlag = true;
elseif nargin<3
    colors = [];
end

[~, vui, vi] = unique(round(verts./tol),'rows');
verts = verts(vui,:);
if ~isempty(colors)
    colors = colors(vui,:);
end

faces = vi(faces);

% remove duplicate faces
% faces = unique(sort(faces,2),'rows');
[~,ia] = unique(sort(faces,2),'rows');
faces = faces(ia,:);
% % remove faces that contain a vertex multiple times
% faces = faces(all(diff(faces,1,2)>0,2),:);

if structFlag
    verts_.vertices = verts;
    verts_.faces = faces;
    if ~isempty(colors)
        verts_.color = colors;
    end
    verts = verts_;
%     verts = struct('faces',faces,'vertices',verts);
end

end