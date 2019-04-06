function [] = fun_exportColorTIF( data, path )
%FUN_EXPORTIMAGES Summary of this function goes here
%   Detailed explanation goes here

% scale the data (0-1) to accompany 8-bit resolution
data = double(data);
data = data/max(data(:))*(2^8-1);
data = uint8(data);

[height, width, cc, depth] = size(data); % cc: color channels. 3: rgb
tagstruct.Photometric = Tiff.Photometric.RGB;
tagstruct.ImageLength = height;
tagstruct.ImageWidth = width;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.SamplesPerPixel = cc;
data = reshape(data, height, width, cc, depth);
tagstruct.Compression = Tiff.Compression.None;
tagstruct.SampleFormat = Tiff.SampleFormat.UInt; % uint8
tagstruct.BitsPerSample = 8;
maxstripsize = 8*1024;
tagstruct.RowsPerStrip = ceil(maxstripsize/(width*(tagstruct.BitsPerSample/8)*size(data,3))); % http://www.awaresystems.be/imaging/tiff/tifftags/rowsperstrip.html

    
[pathstr, fname, fext] = fileparts(path);
if ~isempty(pathstr)
    if ~exist(pathstr, 'dir')
        mkdir(pathstr);
    end
    cd(pathstr);
end

tfile = Tiff([fname, fext], 'w');

for d = 1:depth
    tfile.setTag(tagstruct);
    tfile.write(data(:, :, :, d));
    if d ~= depth
       tfile.writeDirectory();
    end
end

tfile.close();
if exist('path_parent', 'var'), cd(path_parent); end



end

