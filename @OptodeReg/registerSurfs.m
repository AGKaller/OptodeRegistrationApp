function [dataVerts,TM] = registerSurfs(modlVerts,dataVerts,method,varargin)
%     modlVerts = app.referenceHead.vertices;
%     dataVerts = app.hsurfSelectedSurf.vertices;
modlVerts = modlVerts.';
dataVerts = dataVerts.';

validMeths = {'bergstroem','wilm','ml_pcregistericp'};
method = validatestring(method,validMeths,mfilename,'method',3);
switch method
    case 'bergstroem'
        [TR,TT] = icp_berg(modlVerts,dataVerts,varargin{:});
    case 'wilm'
        [TR,TT] = icp_wilm(modlVerts,dataVerts,varargin{:});
    case 'ml_pcregistericp'
        tform = pcregistericp(pointCloud(modlVerts.'), pointCloud(dataVerts.'),  ...
            varargin{:});
        TR = tform.Rotation;
        TT = tform.Translation.';
    otherwise, error('BUG');
end

TM = [[TR;zeros(1,3)], [TT;1]];
dataVerts = ApplyTM(TM,dataVerts.');
    
end
