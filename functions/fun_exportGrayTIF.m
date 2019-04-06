function [] = fun_exportGrayTIF( data, path )
%FUN_EXPORTIMAGES Summary of this function goes here
%   Detailed explanation goes here


% normalize the data to accompany 8-bit resolution
data = double(data);
data = mat2gray(data, [min(data(:)) max(data(:))])*(2^8-1);
data = uint8(data);

[height, width, depth] = size(data);
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.ImageLength = height;
tagstruct.ImageWidth = width;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.SamplesPerPixel = 1;
data = reshape(data, height, width, 1, depth);
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

