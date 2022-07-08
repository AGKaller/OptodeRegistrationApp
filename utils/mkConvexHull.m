function [cvsurf,v1,v2,v3] = mkConvexHull(srf)
% input surf as structure with faces and vertices.
% output convex hull as stuct and vertices of faces in arrays v1, v2, v3.

cvsurf.faces = convhulln(srf.vertices);
cvsurf.vertices = srf.vertices(unique(cvsurf.faces),:);
cvsurf.faces = convhulln(cvsurf.vertices);
if nargout > 1
    v1 = cvsurf.vertices(cvsurf.faces(:,1),:);
    v2 = cvsurf.vertices(cvsurf.faces(:,2),:);
    v3 = cvsurf.vertices(cvsurf.faces(:,3),:);
end

end