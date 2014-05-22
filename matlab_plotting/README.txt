


This folder contains MATLAB code for analysis of model output.

extract_data - Contains the file analyse_script.m, which generates some quick Matlab plots based on simulation output. Also contains batch code to extract all simulation output from Genesis and package into Matlab files. These files will be in the format of those in “output_paperdata”. Note that this code is complex and not well documented at the moment. Please contact the author for additional information.

ouptut_paperdata - Matlab files containing simulation data, extracted using the code in extract_data.

JNP_figs - Operates on .mat files extracted from the simulation (stored in output_paperdata) to generate paper figures.

matlab_libdave1 - Library of custom Matlab functions used by these scripts.