function [ocoords] = ApplyTM(TM,icoords)

ocoords = (TM*[icoords ones(size(icoords,1),1)]')';
ocoords(:,end) = [];

end
