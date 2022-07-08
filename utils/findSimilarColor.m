function k = findSimilarColor(colors,value,simiThresh)
%

method = 'euclidean';

switch method
    case 'euclidean'
        delta = bsxfun(@minus,colors,value);
        dist = sqrt(sum(delta.^2,2));
        k = dist < simiThresh.*sqrt(3);

    otherwise, error('Method not implemented!');
end

end