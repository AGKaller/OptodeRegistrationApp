function [vertex, faces, texture, textureIdx] = read_obj_new(filename,prgrsCB,prgrsMinMax)

% Faster .obj reader for headshape information acquired using a structure
% sensor

% from http://boffinblogger.blogspot.com/2015/05/faster-obj-file-reading-in-matlab.html
% modified output structure and added scan for texture and textureIdx to handle vt
% Modifications by Robert Oostenveld and Robert Seymour
% Modifications by Konrad Schumacher

setProgrs =  nargin > 1 && ~isempty(prgrsCB);
if ~setProgrs || nargin < 3 || isempty(prgrsMinMax)
    prgrsMinMax = [0 1];
end
validateattributes(prgrsMinMax,'numeric',{'vector','numel',2,'increasing'},mfilename,'prgrsRange',3);
prgrsRange = diff(prgrsMinMax);

fid = fopen(filename);
if fid<0
  error(['Cannot open ' filename '.']);
end
[str, count] = fread(fid, [1,inf], 'uint8=>char');
% fprintf('Reading %d characters from %s\n', count, filename);
fclose(fid);

% tic;
vertex_lines = regexp(str,'v [^\n]*\n', 'match');
n = length(vertex_lines);
vertex = zeros(n, 3);
prgrs = (1:n)/n * prgrsRange/3 + prgrsMinMax(1);
prgrs = max(min(prgrs,1),0);
for i = 1:n
  v = sscanf(vertex_lines{i}, 'v %f %f %f');
  vertex(i, :) = v';
  if setProgrs && rem(i,3000)==0, prgrsCB(prgrs(i)); end
end

texture_lines = regexp(str,'vt [^\n]*\n', 'match');
n = length(texture_lines);
texture = zeros(n, 2);
prgrs = (1:n)/n * prgrsRange/3 + prgrsMinMax(1) + prgrsRange*1/3;
prgrs = max(min(prgrs,1),0);
for i = 1:n
  vt = sscanf(texture_lines{i}, 'vt %f %f');
  texture(i, :) = vt';
  if setProgrs && rem(i,3000)==0, prgrsCB(prgrs(i)); end
end

face_lines = regexp(str,'f [^\n]*\n', 'match');
n = length(face_lines);
faces = zeros(n, 3);
textureIdx = zeros(n, 3);
prgrs = (1:n)/n * prgrsRange/3 + prgrsMinMax(1) + prgrsRange*2/3;
prgrs = max(min(prgrs,1),0);
for i = 1:n
  %     f = sscanf(face_lines{i}, 'f %d//%d %d//%d %d//%d');
  %     if (length(f) == 6) % face
  %         faces(i, 1) = f(1);
  %         faces(i, 2) = f(3);
  %         faces(i, 3) = f(5);
  %         continue
  %     end
  %     f = sscanf(face_lines{i}, 'f %d %d %d');
  %     if (length(f) == 3) % face
  %         faces(i, :) = f';
  %         continue
  %     end
  f = sscanf(face_lines{i}, 'f %d/%d %d/%d %d/%d');
  if (length(f) == 6) % face
    faces(i, 1) = f(1);
    faces(i, 2) = f(3);
    faces(i, 3) = f(5);
    textureIdx(i,1) = f(2);
    textureIdx(i,2) = f(4);
    textureIdx(i,3) = f(6);
    continue
  end
  f = sscanf(face_lines{i}, 'f %d/%d/%d %d/%d/%d %d/%d/%d');
  if (length(f) == 9) % face
    faces(i, 1) = f(1);
    faces(i, 2) = f(4);
    faces(i, 3) = f(7);
    textureIdx(i,1) = f(2);
    textureIdx(i,2) = f(5);
    textureIdx(i,3) = f(8);
    continue
  end
  if setProgrs && rem(i,3000)==0, prgrsCB(prgrs(i)); end
end
% fprintf('.obj file took %f seconds to load\n',toc)
return