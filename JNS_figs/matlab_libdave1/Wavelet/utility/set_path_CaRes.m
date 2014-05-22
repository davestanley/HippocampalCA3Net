


% path (path, 'C:\Documents and Settings\Dave\Desktop\MATLAB\Wavelet');
% path (path, 'C:\Documents and Settings\Dave\Desktop\MATLAB\Wavelet\utility');

% path (path, 'F:\2007-7_Documents\Skule\Thesis_Neural\MATLAB\Wavelet');
% path (path, 'F:\2007-7_Documents\Skule\Thesis_Neural\MATLAB\Wavelet\utility');


% path (path, '/media/KINGSTON/2007-7_Documents/Skule/Thesis_Neural/MATLAB/Wavelet/utility')
% path (path, '/media/KINGSTON/2007-7_Documents/Skule/Thesis_Neural/MATLAB/Wavelet')

cd ..


path (path, pwd)

cd Demitre_beta-est
path (path, pwd)
cd ..

cd NRE_Wavelet_Packet               % Neural rhythm extractor
path (path,pwd)
cd ..

cd utility_Genesis               % Neural rhythm extractor
path (path,pwd)
cd ..

cd utility_quickautomations               % Neural rhythm extractor
path (path,pwd)
cd ..

cd utility_downloads
path (path,pwd)
cd ..

cd struct_CaRes
path (path,pwd)
cd ..

cd utility_structarrays
path (path,pwd)
cd ..

cd utility_testcode
path (path,pwd)
cd ..

cd utility
path (path, pwd)



currpath_wavelet = pwd;

cd ../../Wavelet_largefiles/utility;

set_path_largefiles


cd (currpath_wavelet);
clear currpath_wavelet


