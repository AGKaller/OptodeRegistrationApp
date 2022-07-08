function shape = load_wavefront_obj(objfilename,imagefilename,prgrsCB)

% This function has been adopted from fieldtrip
% (fileio/ft_read_headshape.m) by Konrad Schumacher.
%
% Copyright (C) 2008-2019 Robert Oostenveld
%
% This file is part of FieldTrip, see http://www.fieldtriptoolbox.org
% for the documentation and details.
%
%    FieldTrip is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FieldTrip is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FieldTrip. If not, see <http://www.gnu.org/licenses/>.
%

setProgrs =  nargin > 2 && ~isempty(prgrsCB);

if ~exist(objfilename,'file')
    error('load_wavefront_obj:objfileNotFound','Obj-file ''%s'' not found!',objfilename);
end
if nargin < 2 || isempty(imagefilename)
    pth = fileparts(objfilename);
    mdlfiles = dir(pth);
    mdlfiles = mdlfiles(~[mdlfiles.isdir]);
    isImg = ~cellfun(@isempty, ...
        regexp({mdlfiles.name},'\.(jpe?g|png|tiff?|bmp|gif)$','once'));
    if any(isImg)
        k = find(isImg,1,'first');
        imagefilename = fullfile(pth,mdlfiles(k).name);
    else, imagefilename = '';
    end
end

if ~exist(imagefilename,'file')
    error('load_wavefront_obj:imgfileNotFound','Image file ''%s'' not found!',imagefilename);
end

if setProgrs, args = {prgrsCB, [0 .2]};
else, args = {};
end
[pos, tri, texture, textureIdx] = read_obj_new(objfilename, args{:});

% check if the texture is defined per vertex, in which case the texture can be refined below
if size(texture, 1)==size(pos, 1)
    texture_per_vert = true;
else
    texture_per_vert = false;
end

% remove the triangles with 0's first
allzeros = sum(tri==0,2)==3;
tri(allzeros, :)        = [];
textureIdx(allzeros, :) = [];

% check whether all vertices belong to a triangle. If not, then prune the vertices and keep the faces consistent.
utriIdx = unique(tri(:));
remove  = setdiff((1:size(pos, 1))', utriIdx);
if ~isempty(remove)
    [pos, tri] = remove_vertices(pos, tri, remove);
    if texture_per_vert
        % also remove the removed vertices from the texture
        texture(remove, :) = [];
    end
end


if texture_per_vert
    % Refines the mesh and textures to increase resolution of the colormapping
    if setProgrs, args = {prgrsCB, [.2 .9]};
    else, args = {};
    end
    [pos, tri, texture] = refine(pos, tri, 'banks', texture, args{:});

    picture = imread(imagefilename);
    nc = size(pos, 1);
    color   = zeros(nc, 3);
    prgrs = linspace(.9,1,nc);
    for i = 1:nc
        color(i,1:3) = picture(floor((1-texture(i,2))*length(picture)),1+floor(texture(i,1)*length(picture)),1:3);
        if setProgrs && rem(i,10000)==0, prgrsCB(prgrs(i)); end
    end
else
    % do the texture to color mapping in a different way, without additional refinement
    picture      = flip(imread(imagefilename),1);
    [sy, sx, sz] = size(picture);
    picture      = reshape(picture, sy*sx, sz);

    % make image 3D if grayscale
    if sz == 1
        picture = repmat(picture, 1, 3);
    end
    [~, ix]  = unique(tri);
    textureIdx = textureIdx(ix);

    % get the indices into the image
    x     = abs(round(texture(:,1)*(sx-1)))+1;
    y     = abs(round(texture(:,2)*(sy-1)))+1;
    xy    = sub2ind([sy sx], y, x);
    sel   = xy(textureIdx);
    color = double(picture(sel,:))/255;
    if setProgrs, prgrsCB(1); end
end

% If color is specified as 0-255 rather than 0-1 correct by dividing by 255
if range(color(:)) > 1
    color = color./255;
end


shape.vertices   = bsxfun(@minus, pos, mean(pos,1)); % centering vertices
shape.faces      = tri;
shape.color      = color;

end