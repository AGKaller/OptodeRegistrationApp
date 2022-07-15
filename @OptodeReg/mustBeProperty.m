function mustBeProperty(p,cn)

k = ismember(p,properties(cn));
if ~all(k)
    eidType = sprintf('%s:InvalidPropertyValue',cn);
    notProp = strjoin(p(~k),', ');
    msgType = sprintf('%s is not a class property!',notProp);
    throwAsCaller(MException(eidType,msgType));
end

end