
 
This folder contains code for generating quick plots of simulation output, and also for bulk extraction to Matlab .mat files.

analyse_script.m - Analyses output data produced by Genesis, and produces some basic plots. By default, it will load some sample data included with this package (stored in simfiles/dataset_sample). You can modify it directly load new Genesis output by adjusting the path_ld variable. 


~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The remainder of these commands are largely undocumented, and use at your own risk. I will update the documentation as necessary, or feel free to contact me if you require assistance using them (stanleyd@bu.edu). They work together to automatically extract Matlab .mat from the Genesis simulation output. These are designed to work together with the bash scripts for running parallel simulations. 

The commands should be run in the following order:

extract_script.sh - Bulk parallel extraction from Genesis output data. There is also an equivalent extract_script_octave.sh modified to work with Octave, incase licenses are an issue. Calls make_wrkspc.m

stitch_wrkspc.m - Stitches together multiple mat files from extract script into one single large mat file.

find_error_sims.m - Can also be useful for finding simulations that have failed

Additional utility files (located in matlab_libdave1, but useful)
clean_evol - Downsamples and removes pyramidal voltage traces from wrkspc file.
clean_wrkspc - After running stitch_wrkspc, this will strip large variables (such as voltage traces) out of the structures, to save space.
trim_wrkspc - As above, but will be less stringent, leaving behind a few example traces.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


