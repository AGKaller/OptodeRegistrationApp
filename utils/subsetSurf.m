function surf = subsetSurf(surf,keep)
% 

vIdx = find(keep);
[lia,faces] = ismember(surf.faces,vIdx);
keepFaces = all(lia,2);

surf.faces = faces(keepFaces,:);

% surf.faces = vIdx(faces);
surf.vertices = surf.vertices(keep,:);
if isfield(surf,'color')
    surf.color = surf.color(keep,:);
end

end