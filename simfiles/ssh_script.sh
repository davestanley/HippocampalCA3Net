#!/bin/bash
currpath=`pwd`

## ****************************************** Overview ***************************************************


########### Quick start ###############
#This is the bash script used for launching the Genesis code. It assumes Genesis executable is in your
#current path, and will call Genesis by the command "genesis."
#
#The function of this script is to run one or several Genesis simulations for the purpose of condcuting
#parameter sweeps. The main parameter that is swept over is the "time of day" parameter, upon which certain
#neural parameters are dependent.
#
#To run the script, type
#
#./ssh_script.sh N
#
#where N is a number from 0 - 5 controlling which parameter sweep is used. The possibilities are
#listed below. Note that Modes 3-5 assume parallel execution is set up.
#
# Mode 0 run small network under default settings. Use local machine.
# Mode 1 - Run full network locally.
# Mode 2 Run small network at multiple circadian time points. Plotting is disabled
# Mode 3 - Healthy vs Injured (tests the effects of removing the septum)
#		 Used in Figure 7A-D of paper
#		 Note that I sweep through several parameters here. I end up only using EC_amp0 = 0.25
# Mode 4 - Sensitivity analysis; vary melatonin and septal inputs
#		 Used in Figure 7E of paper
# Mode 5 - Singles; apply only 1 circadian input at a time.
#		 Used in Figure A3 (Appendix) of paper
#		 (This code is taken from S05f_singles_huge)
#
############# How the script works ########
#This script works by setting up basic parameters and then calling a function called runexp (see
#ssh_script_funcs.sh). This function will automatically generate a bunch of Genesis scripts named sag_paramsI.g,
#where i is an integer. These scripts correspond to different "times of day." It will then execute these scripts
#(in serial or parallel, depending on run_mode; see below). runexp also accepts an argument. This argument tells 
#the script how many times of day you would like to simulate. These values are hard coded into runexp (see
#ssh_script_funcs.sh).
#
#Additional parameter sweeps can be conducted over synaptic channel strengths, etc (see Modes 3 and 4 below).
#
############# Simulation output ########
#Output is generated and stored in a directory (specified by the variable dataoutput_path). It is organized
#by the time of day of each simulation and includes both membrane voltage (spike traces, sptr*.dat) and spike
#times (raster plots, raster*.dat).
#
############# Note: Parallel execution ########
#This script has two ways to run code and this is controlled by the "run_mode" variable. When run_mode=1, all
#parameter sweeps will run in serail within your current terminal, one after the other. For other values of
#run_mode, the bash script will distribute simulations via ssh commands to a machine with multiple nodes. This
#will likely require some customizaiton to get working, but you can see examples of how this works by looking
#at the run_genesis() function in ssh_script_funcs.sh. In particular, run_mode=5 is useful for submitting to
#a cluster that uses qsub, while run_mode=4 can distribute to different nodes based on their names.

## ****************************************** Load parameters and functions **********************************

source ssh_script_params.sh
source ssh_script_funcs.sh


## ****************************************** Start Script ***************************************************

	## Neuron Setup
SIMPATH1="/Applications/NEURON-7.1/nrn/share/nrn/"
SIMNAME1="lib/hoc/nrngui.hoc"
SIMPATH2="./"
SIMNAME2="50knet_dav.hoc"
MODFILE_HOME="mod/umac/special"
MODFILE_REMOTE="mod_MB/umac/special"
EXECPATH="./"

	## Genesis Setup
GEN_EXEC="genesis"
GEN_SIMNAME="main_script.g"

	## Files
PARAM_FILENAME_ROOT="sag_params"
MATLAB_FILELIST="fnamelist"
MATLAB_CIRCLIST="circnamelist"
MATLAB_VARLIST="varnamelist"
	## Simflags
run_mode=1
NOSAVE=0
dataoutput_path="./S05f_randseed_huge"
expname_suffix='_def'
expname_raw="do"
sim_mode=$1


	## Turn off graphics if running remotely via SSH
if ([ $run_mode = 3 ]||[ $run_mode = 4 ]); then graphics_on=0; fi


								## Mode 0 run small network under default settings. Use local machine.
if [ $sim_mode = 0 ]; then		
	
	NOSAVE=1;
	run_mode=1 ## Run full sim locally
	sim_time=1.0	# 1 seconds simtime
	plot_on=1
	small_net=1		# Run a small network with only a few neurons
	include_NMDA=0	# NMDA synapses were not used in this version
	bc_gammanet=0	# This was used for tuning purposes only
	percent_msg_intact=1.0	# Adjust this parameter to simulate septal injury
	percent_ACh_intact=1.0	# Ach synapses were not used in this version
	no_synapses=0			# Synapse-less version of model. Useful for parameter tuning.
	setup_batch
	
	export numexps=0


		# Setting up default circadian input magnitudes
	EC_amp0=0.25; SCN_amp0=0.20; mel_amp0=0.10; Ca_amp0=0.20
	ACh_accom_amp0=0.20; ACh_Esyn_amp0=0.20; ACh_pyr_amp0=0.20;
	ACh_Isyn_amp0=${ACh_Esyn_amp0}; ACh_bc_amp0=${ACh_pyr_amp0}; ACh_olm_amp0=${ACh_pyr_amp0}
	
		# Set up parameters for the simulation
	percent_msg_intact=1.0
	EC_amp=${EC_amp0}; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="test_smallnet_6am"; runexp 1
								# This batch of simulations will be named "test_smallnet_6am"
								# runexp N function controls generation of circadian simulations
								# N tells the number of times of day to simulate (see runexp function
								# for possibilities).



fi

								# Mode 1 - Run full network locally.
if [ $sim_mode = 1 ]; then		
	
	NOSAVE=1;
	run_mode=1 ## Run full sim locally
	sim_time=1.0	# 1 seconds simtime
	plot_on=1
	small_net=0		# Run whole network
	include_NMDA=0	# NMDA synapses were not used in this version
	bc_gammanet=0	# This was used for tuning purposes only
	percent_msg_intact=1.0	# Adjust this parameter to simulate septal injury
	percent_ACh_intact=1.0	# Ach synapses were not used in this version
	no_synapses=0			# Synapse-less version of model. Useful for parameter tuning.
	setup_batch
	
	export numexps=0


		# Setting up default circadian input magnitudes
	EC_amp0=0.25; SCN_amp0=0.20; mel_amp0=0.10; Ca_amp0=0.20
	ACh_accom_amp0=0.20; ACh_Esyn_amp0=0.20; ACh_pyr_amp0=0.20;
	ACh_Isyn_amp0=${ACh_Esyn_amp0}; ACh_bc_amp0=${ACh_pyr_amp0}; ACh_olm_amp0=${ACh_pyr_amp0}
	
		# Set up parameters for the simulation
	percent_msg_intact=1.0
	EC_amp=${EC_amp0}; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="test_fullnet_6am"; runexp 1


	
fi

								# Mode 2 Run small network at multiple
if [ $sim_mode = 2 ]; then		#  circadian time points. Plotting is disabled
	
	NOSAVE=1;
	run_mode=1 ## Run full sim locally
	sim_time=1.0	# 1 seconds simtime
	plot_on=0
	small_net=1		# Run whole network
	include_NMDA=0	# NMDA synapses were not used in this version
	bc_gammanet=0	# This was used for tuning purposes only
	percent_msg_intact=1.0	# Adjust this parameter to simulate septal injury
	percent_ACh_intact=1.0	# Ach synapses were not used in this version
	no_synapses=0			# Synapse-less version of model. Useful for parameter tuning.
	setup_batch
	
	export numexps=0


		# Setting up default circadian input magnitudes
	EC_amp0=0.25; SCN_amp0=0.20; mel_amp0=0.10; Ca_amp0=0.20
	ACh_accom_amp0=0.20; ACh_Esyn_amp0=0.20; ACh_pyr_amp0=0.20;
	ACh_Isyn_amp0=${ACh_Esyn_amp0}; ACh_bc_amp0=${ACh_pyr_amp0}; ACh_olm_amp0=${ACh_pyr_amp0}
	
		# Set up parameters for the simulation
	percent_msg_intact=1.0
	EC_amp=${EC_amp0}; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="test_fullnet_6am"; runexp 4


	
fi



if [ $sim_mode = 3 ]; then		# Mode 3 - Healthy vs Injured (tests the effects of removing the septum)
								# Used in Figure 7A-D of paper
								# Note that I sweep through several parameters here. I end up only using EC_amp0 = 0.25

	NOSAVE=0;
	run_mode=4 ## Run full sim locally
	sim_time=10.0
	plot_on=0
	small_net=0
	include_NMDA=0
	bc_gammanet=0
	percent_msg_intact=1.0
	percent_ACh_intact=1.0
	no_synapses=0
	setup_batch
	
	export numexps=0


		# Setting up default circadian input magnitudes
	EC_amp0=0.25; SCN_amp0=0.20; mel_amp0=0.10; Ca_amp0=0.20
	ACh_accom_amp0=0.20; ACh_Esyn_amp0=0.20; ACh_pyr_amp0=0.20;
	ACh_Isyn_amp0=${ACh_Esyn_amp0}; ACh_bc_amp0=${ACh_pyr_amp0}; ACh_olm_amp0=${ACh_pyr_amp0}

	
		# Running simulations
	# Sens
	for EC_amp0 in 0.23 0.25
	do
		for SCN_amp0 in 0.25
		do
		# Healthy
		percent_msg_intact=1.0
		EC_amp=${EC_amp0}; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
		ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
		ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
		expname_raw=""$numexps"_"; expname_suffix="healthy_all3"; runexp 16

		done
	done

	
	for EC_amp0 in 0.25
	do
		for SCN_amp0 in 0.10
		do
		# Latent
		percent_msg_intact=0.0
		EC_amp=${EC_amp0}; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
		ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
		ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
		expname_raw=""$numexps"_"; expname_suffix="latent_all3"; runexp 16

		done
	done


	
fi



if [ $sim_mode = 4 ]; then		# Mode 4 - Sensitivity analysis; vary melatonin and septal inputs
								# Used in Figure 7E of paper

	NOSAVE=0;
	run_mode=6 ## Run full sim locally
	sim_time=5.0
	plot_on=0
	small_net=0
	include_NMDA=0
	bc_gammanet=0
	percent_msg_intact=1.0
	percent_ACh_intact=1.0
	no_synapses=0
	setup_batch
	
	export numexps=0


		# Setting up default circadian input magnitudes
	EC_amp0=0.25; SCN_amp0=0.25; mel_amp0=0.10; Ca_amp0=0.20
	ACh_accom_amp0=0.20; ACh_Esyn_amp0=0.20; ACh_pyr_amp0=0.20;
	ACh_Isyn_amp0=${ACh_Esyn_amp0}; ACh_bc_amp0=${ACh_pyr_amp0}; ACh_olm_amp0=${ACh_pyr_amp0}

	
		# Running simulations
	# Sens
	for mel_amp0 in 0.05 0.075 0.085 0.10 0.12 0.14 0.18
	do
		for percent_msg_intact in 0.0 0.15 0.3 0.45 0.65 0.80 1.0
		do
		# Healthy
		EC_amp=${EC_amp0}; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
		ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
		ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
		expname_raw=""$numexps"_"; expname_suffix="healthy_all3"; runexp 9
		done
	done

	
fi




if [ $sim_mode = 5 ]; then		# Mode 5 - Singles; apply only 1 circadian input at a time.
								# Used in Figure A3 (Appendix) of paper
								# This code is taken from S05f_singles_huge

	NOSAVE=0;
	run_mode=4 ## Run full sim locally
	sim_time=10.0
	plot_on=0
	small_net=0
	include_NMDA=0
	bc_gammanet=0
	percent_msg_intact=1.0
	percent_ACh_intact=1.0
	no_synapses=0
	setup_batch
	
	export numexps=0


		# Setting up default circadian input magnitudes
	EC_amp0=0.25; SCN_amp0=0.25; mel_amp0=0.10; Ca_amp0=0.20
	ACh_accom_amp0=0.20; ACh_Esyn_amp0=0.20; ACh_pyr_amp0=0.20;
	ACh_Isyn_amp0=${ACh_Esyn_amp0}; ACh_bc_amp0=${ACh_pyr_amp0}; ACh_olm_amp0=${ACh_pyr_amp0}

	
		# Running simulations
		# Healthy
		percent_msg_intact=1.0
		EC_amp=${EC_amp0}; SCN_amp=0.0; mel_amp=0.0; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
		ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
		ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
		expname_raw=""$numexps"_"; expname_suffix="Pyrinj"; runexp 16
		
		EC_amp=0.0; SCN_amp=${SCN_amp0}; mel_amp=0.0; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
		ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
		ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
		expname_raw=""$numexps"_"; expname_suffix="SCN"; runexp 16
		
		EC_amp=0.0; SCN_amp=0.0; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
		ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
		ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
		expname_raw=""$numexps"_"; expname_suffix="mel"; runexp 16
		
#		percent_msg_intact=0.0
#		EC_amp=${EC_amp0}; SCN_amp=0.0; mel_amp=0.0; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
#		ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
#		ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
#		expname_raw=""$numexps"_"; expname_suffix="latent_Pyrinj"; runexp 16
#		
#		EC_amp=0.0; SCN_amp=0.0; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
#		ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
#		ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
#		expname_raw=""$numexps"_"; expname_suffix="latent_mel"; runexp 16
		
		

	
fi


