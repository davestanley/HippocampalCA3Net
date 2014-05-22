



path(path, pwd);

cd struct_evol
path(path,pwd);
cd ..

cd make_wrkspc
path(path,pwd);
cd ..

cd spk_analysis
path(path,pwd);
cd ..



%Add Thesis wavelet stuff to path
currpath_evol_mod = pwd;
cd ../Wavelet/utility
set_path_CaRes
cd (currpath_evol_mod)
clear currpath_evol_mod

