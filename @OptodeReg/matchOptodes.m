function [idModl,unmtchTmpl,unmtchModl] = matchOptodes(xyzTmpl, xyzModl, idTmpl, matchCost)
% Assign optode IDs based on euclidean distance.
%
% [idModl,unmtchTmpl,unmtchModl] = matchOptodes(xyzTmpl, xyzModl, idTmpl, matchCost)
%
%
%

if nargin<4 || isempty(matchCost)
    matchCost = 15;
end

% distance matrix
delta = bsxfun(@minus,permute(xyzTmpl,[1 3 2]),permute(xyzModl,[3 1 2]));
dists = sqrt(sum(delta.^2,3));

% matchpairs() reconstructed positions to model positions
[optodeAssignment,unmtchTmpl,unmtchModl] = matchpairs(dists,matchCost);

idModl = repmat({''},size(dists,2),1);
idModl(optodeAssignment(:,2)) = idTmpl(optodeAssignment(:,1));

end