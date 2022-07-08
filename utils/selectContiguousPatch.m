function selVertsOut = selectContiguousPatch(faces,selVertsIn,clickedVert)
%

selVertsInIdx = find(selVertsIn);
selVertsOut = false(size(selVertsIn));
addVerts_ = clickedVert;
addVerts = NaN;

while ~isequal(addVerts,addVerts_)
    addVerts = addVerts_;
    selVertsOut(addVerts) = true;
    connectedFace = any(ismember(faces,addVerts),2);
    connectedVerts = faces(connectedFace,:);
    addVerts_ = intersect(selVertsInIdx,connectedVerts);
end

end