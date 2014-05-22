#!/bin/bash

currpath=`pwd`

## ****************************************** Set Script parameters ******************************************

pi=3.1415926535


EC_amp=0.166	## Estimated by looking at rat data STDEV osciallations, Rat 9, Ch 11
EC_amp=0.06		## Exaggeration...
EC_period=24
EC_phase=12		## Estimated by looking at rat data STDEV osciallations, Rat 9, Ch 11

## SCN input drives MS GABA cells
## Input to MS GABA cells peaks during the day
SCN_amp=0.04		# SCN peaks at middle of day; this peak is inhibitory -- therefore use neg amplitude
SCN_period=24
SCN_phase=0


## Mel peaks during the middle of the night and inhibits
## GABA_A currents. Therefore, GABA_A currents should be inhibited
## during the middle of the night, and potentiated during the day.
mel_amp=0.25	## Mel peaks at night, so GABA_A should peak during the day.
mel_period=24
mel_phase=12

## Assume ACh comes from the medial septum. Medial septum cells are inhibited by the 
## SCN during the day and peaks firing at night, so we assume ACh arrives at night.
## ACh causes a depolarization by inhibiting K_M.
ACh_amp=1.0	# ACh influx from septum peaks at night; K_M is min at night (negative)
ACh_period=24
ACh_phase=0

## Kole, Fuchs et al (2001) have shown that calcium currents peaks at the onset of night; this
## is thought to be regulated by corticosterone.
Ca_amp=0.25		## Ca current densities should peak at night
Ca_period=24
Ca_phase=0

small_net=0
no_synapses=0
include_NMDA=0
plot_on=0
bc_gammanet=0
percent_msg_intact=1.0
percent_ACh_intact=${percent_msg_intact}


ACh_accom_amp=0.25
ACh_Esyn_amp=0.25
ACh_Isyn_amp=0.25
ACh_pyr_amp=0.25
ACh_bc_amp=0.25
ACh_olm_amp=0.25

bc2pyr_GABA_A0=9.2e-9 		# Reduced to prevent excessive inhibition of pyr, which interrupts bursting
pyr2pyr_AMPA0=2.6e-9		# Tuned to EPSP value based on Traub - Fast Oscillations (1999). EPSP of 1.0mV @ -65mV

#pyr_inject0=0.0e-12
#Gmax_pyr_bkgnd0=0.8e-9		# Neymotin original

pyr_inject0=200.0e-12
Gmax_pyr_bkgnd0=0.05e-9		# Neymotin original
bc_inject0=0.00e-11		# From Hajos 2004
olm_inject0=-1.0e-11	# From Neymotin 2010 
msg_inject0=2.1e-11	# From Hajos 2004

# For noise adjust
pyr_inject0=500.0e-12
#bc_inject0=0.0e-11		# From Hajos 2004
#olm_inject0=0.0e-11	# From Neymotin 2010 
#msg_inject0=1.885e-11	# From Hajos 2004
Gmax_pyr_bkgnd0=1.0e-9		# Neymotin original


## ****************************************** End set Script parameters ******************************************




## ****************************************** Define Script functions ******************************************

	# Take in a single bash variable and write that variable to 
	# our Neuron hoc parameter file
function wp()
{
	echo $1 = ${!1} >> ${PARAM_FILENAME}	#Use BASH indirection
	#echo $1 = ${!1}
}

	# Same as above, but special treatment for string variables
function wp_str()
{
	echo strdef $1 >> ${PARAM_FILENAME}
	echo $1 = \"${!1}\" >> ${PARAM_FILENAME}
	#echo $1 = \"${!1}\"
}

	# Genesis variable types
function wp_int()
{
	echo int $1 = ${!1} >> ${PARAM_FILENAME}	#Use BASH indirection
}

function wp_float()
{
	echo float $1 = ${!1} >> ${PARAM_FILENAME}	#Use BASH indirection
}

function wp_strgen()
{
	echo str $1 = \"${!1}\" >> ${PARAM_FILENAME}
}

function wp_text()
{
	echo ${!1} >> ${PARAM_FILENAME}
	#echo ${!1}
}


function write_all_params()
{
	echo '//Bash generated parameter file' > ${PARAM_FILENAME}
#	wp_int scriptmode
#	wp_float scale_difshell_binding_tau
#	wp_strgen script_chan 
	

	wp_int small_net
	wp_int no_synapses
	wp_int plot_on
	wp_int include_NMDA
	wp_int bc_gammanet
	wp_float percent_msg_intact
	wp_float percent_ACh_intact
	
	wp_float pi
	wp_float EC_val 
	wp_float SCN_val 
	wp_float mel_val
	wp_float ACh_val
	wp_float Ca_val
	
	wp_float EC_amp
	wp_float SCN_amp
	wp_float mel_amp
	wp_float ACh_amp
	wp_float Ca_amp
	
	wp_float ACh_accom_amp
	wp_float ACh_Esyn_amp
	wp_float ACh_Isyn_amp
	wp_float ACh_pyr_amp
	wp_float ACh_bc_amp
	wp_float ACh_olm_amp
	
	wp_float pyr_inject0
	wp_float bc_inject0
	wp_float olm_inject0
	wp_float msg_inject0
	
	wp_float bc2pyr_GABA_A0
	wp_float pyr2pyr_AMPA0
	wp_float Gmax_pyr_bkgnd0


	

#	# Defined below
	wp_strgen dataoutput_path #String
	wp_strgen expname_path #String
	wp_strgen circtime_path #String
	wp_float sim_time
	
	wp_int tindex
	strvar="include "${GEN_SIMNAME}
	wp_text strvar

}

function setup_batch()
{
	if [ $NOSAVE = 1 ]; then		# If we're not worried about saving data,
		dataoutput_path="./dataset_temp04b_sept"	# dump to currentdir
		if [ -d $dataoutput_path ]; then
			echo Temporary data path already exists. Purging…
			rm -rf $dataoutput_path
			mkdir $dataoutput_path
		else
			mkdir $dataoutput_path
		fi
	else
		if [ -d $dataoutput_path ]; then		# Check if save directory already exists
			echo Output directory \"${dataoutput_path}\" already exists. Exiting…
			exit 0
		fi
		mkdir $dataoutput_path
		cp ./ssh_script.sh ${dataoutput_path}
	fi
	
	mkdir ${dataoutput_path}/simfiles
	echo Copying simulation files
	cp ./*.p ${dataoutput_path}/simfiles/
	cp ./*.g ${dataoutput_path}/simfiles/
	cp ./*.sh ${dataoutput_path}/simfiles/
	cp ./*.m ${dataoutput_path}/simfiles/
	
	echo '% List of pathnames' > ${dataoutput_path}/${MATLAB_FILELIST}file.m
	echo '% List of variable names' > ${dataoutput_path}/${MATLAB_VARLIST}file.m
	
	export numprocs=1
}

function getcirc
{
	circ_amp=$1; circ_period=$2; circ_phase=$3; t=$4
	echo "{1 + "${circ_amp}"* {cos {2*{pi}/"${circ_period}"*{"${t}"-"${circ_phase}"}}} }"
}


function run_neuron()
{
	fullname_spike=${dataoutput_path}${filename_spike}${filename_suffix}		# Generate filename for raster
	echo fnamearr_spike\{${numprocs}\} = "'"${fullname_spike}"'"';' >> ${dataoutput_path}${MATLAB_FILELIST}.m		# Save filename to Matlab
	
	fullname_count=${dataoutput_path}${filename_counts}${filename_suffix}
	echo fnamearr_count\{${numprocs}\} = "'"${fullname_count}"'"';' >> ${dataoutput_path}${MATLAB_FILELIST}.m
	
	fullname_smooth=${dataoutput_path}${filename_smooth}${filename_suffix}
	echo fnamearr_smooth\{${numprocs}\} = "'"${fullname_smooth}"'"';' >> ${dataoutput_path}${MATLAB_FILELIST}.m

	write_all_params

	if [ $run_mode = 1 ]; then
		echo Opening new command window
		cmd_prefix="xterm -e"
		$cmd_prefix ${EXECPATH}${MODPATH} ${SIMPATH1}${SIMNAME1} ${SIMPATH2}${SIMNAME2} - &
	else
		echo Loading in current command window
		cmd_prefix = ""
		$cmd_prefix ${EXECPATH}${MODPATH} ${SIMPATH1}${SIMNAME1} ${SIMPATH2}${SIMNAME2} -
	fi
	
	numprocs=$(($numprocs+1))
	
#	echo 'echo filenamearr"{"'$[$numprocs + 1]'"}" = '"'"'{datafilename}fb1'"'"' >> matlab_script.m' >> main_script.g

}



function run_genesis()
{
	EC_val=`getcirc $EC_amp $EC_period $EC_phase $t`
	SCN_val=`getcirc $SCN_amp $SCN_period $SCN_phase $t`
	mel_val=`getcirc $mel_amp $mel_period $mel_phase $t`
	ACh_val=`getcirc $ACh_amp $ACh_period $ACh_phase $t`
	Ca_val=`getcirc $Ca_amp $Ca_period $Ca_phase $t`
	
	write_all_params


	if [ $run_mode = 1 ]; then
		echo Loading in current command window
		cmd_prefix=""
		$cmd_prefix ${GEN_EXEC} ${PARAM_FILENAME}
	elif [ $run_mode = 2 ]; then
		echo Opening new command window
		cmd_prefix="xterm -e"
		$cmd_prefix ${GEN_EXEC} ${PARAM_FILENAME} &
	elif [ $run_mode = 3 ]; then
		echo Running in SSH on Appliedchaos
		cmd_prefix=""
		ssh appliedchaos.asu.edu "export PATH=$PATH; export TERM=$TERM; cd $currpath; $cmd_prefix ${GEN_EXEC} ${PARAM_FILENAME} > sag_stdout${numprocs}.out" &
	elif [ $run_mode = 4 ]; then
		cmd_prefix=""
		
#		echo SENDING to Dominique2; export SERVER="dominique2.asu.edu"
		
		if (( $(( $numprocs % 4 )) == 0)); then
			echo SENDING to Dominique1; export SERVER="dominique1.asu.edu"
		elif (( $(( $numprocs % 4 )) == 1)); then
			echo SENDING to Dominique2; export SERVER="dominique2.asu.edu"
		elif (( $(( $numprocs % 4 )) == 2)); then
			echo SENDING to Dominique3; export SERVER="dominique3.asu.edu"
		elif (( $(( $numprocs % 4 )) == 3)); then
			echo SENDING to Dominique4; export SERVER="dominique4.asu.edu"
		fi

		
		ssh $SERVER "export PATH=$PATH; export TERM=$TERM; cd $currpath; $cmd_prefix ${GEN_EXEC} ${PARAM_FILENAME} > sag_stdout${numprocs}.out" &
	elif [ $run_mode = 5 ]; then
		echo QSub to saguaro.
		cmd_prefix=""
		qsub <<< "cd ${currpath}; $cmd_prefix ${GEN_EXEC} ${PARAM_FILENAME} > sag_stdout${numprocs}.out"	# Submits command to start GENESIS while running corresponding script.
		

	elif [ $run_mode = 6 ]; then
		cmd_prefix=""
		
#		echo SENDING to Dominique2; export SERVER="dominique2.asu.edu"
		
		if (( $(( $numprocs % 4 )) == 0)); then
			echo SENDING to Hera1; export SERVER="heracles1.ahc.ufl.edu"
		elif (( $(( $numprocs % 4 )) == 1)); then
			echo SENDING to Hera2; export SERVER="heracles2.ahc.ufl.edu"
		elif (( $(( $numprocs % 4 )) == 2)); then
			echo SENDING to Hera3; export SERVER="heracles3.ahc.ufl.edu"
		elif (( $(( $numprocs % 4 )) == 3)); then
			echo SENDING to Hera4; export SERVER="heracles4.ahc.ufl.edu"
		fi
				
		ssh $SERVER "export PATH=$PATH; export TERM=$TERM; cd $currpath; $cmd_prefix ${GEN_EXEC} ${PARAM_FILENAME} > sag_stdout${numprocs}.out" &
		
	fi
	
	
	numprocs=$(($numprocs+1))

}

function runcirc()
{
	export tindex=$(( ${tindex}+1 ))	
	echo ${MATLAB_CIRCLIST}\{${tindex}\} = "'"${expname_path}/${circtime_path}"'"';' >> ${dataoutput_path}/${expname_path}/${MATLAB_CIRCLIST}file.m		# Save circadian file info to Matlab
	if [ -d ${dataoutput_path}/${expname_path}/${circtime_path} ]; then		# Check if save directory already exists
		echo Output directory \"${dataoutput_path}/${expname_path}/${circtime_path}\" already exists. Exiting…
		exit 0
	fi
	mkdir ${dataoutput_path}/${expname_path}/${circtime_path}
	PARAM_FILENAME=${PARAM_FILENAME_ROOT}${numprocs}".g"
	run_genesis;
	if [ $NOSAVE = 0 ]; then		# If we're going to save the data, give a delay
		sleep 1
	fi
}


function runexp()
{
	num_time_intervals=$1
	
	export numexps=$(( ${numexps}+1 ))	
	expname_path=${expname_raw}${expname_suffix}		# Generate pathname for rasterplot
	echo ${MATLAB_FILELIST}\{${numexps}\} = "'"${expname_path}"'"';' >> ${dataoutput_path}/${MATLAB_FILELIST}file.m		# Save pathname to Matlab
	echo ${MATLAB_VARLIST}\{${numexps}\} = "'"${expname_suffix}"'"';' >> ${dataoutput_path}/${MATLAB_VARLIST}file.m		# Save variable name to Matlab
	if [ -d ${dataoutput_path}/${expname_path} ]; then		# Check if save directory already exists
		echo Output directory \"${dataoutput_path}/${expname_path}\" already exists. Exiting…
		exit 0
	fi
	mkdir ${dataoutput_path}/${expname_path}
	
	export tindex=0	
	
	if [ $num_time_intervals = 1 ]; then
		t=6; circtime_path='t0'; runcirc
	fi
	
	if [ $num_time_intervals = 2 ]; then
		t=5; circtime_path='t5'; runcirc
		t=7; circtime_path='t7'; runcirc
	fi
	
	if [ $num_time_intervals = 4 ]; then
		t=0; circtime_path='t0'; runcirc
		t=6; circtime_path='t6'; runcirc
		t=12; circtime_path='t12'; runcirc
		t=18; circtime_path='t18'; runcirc
	fi
	
	if [ $num_time_intervals = 5 ]; then
		t=0; circtime_path='t0'; runcirc
		t=2; circtime_path='t2'; runcirc
		t=6; circtime_path='t6'; runcirc
		t=10; circtime_path='t10'; runcirc
		t=12; circtime_path='t12'; runcirc
	fi
	
	if [ $num_time_intervals = 7 ]; then
		t=0; circtime_path='t0'; runcirc
		t=2; circtime_path='t2'; runcirc
		t=6; circtime_path='t6'; runcirc
		t=10; circtime_path='t10'; runcirc
		t=11; circtime_path='t11'; runcirc
		t=12; circtime_path='t12'; runcirc
		t=13; circtime_path='t13'; runcirc
	fi
	
	if [ $num_time_intervals = 9 ]; then
		t=0; circtime_path='t0'; runcirc
		t=3; circtime_path='t3'; runcirc
		t=6; circtime_path='t6'; runcirc
		t=9; circtime_path='t9'; runcirc
		t=12; circtime_path='t12'; runcirc
		t=14; circtime_path='t14'; runcirc
		t=17; circtime_path='t17'; runcirc
		t=20; circtime_path='t20'; runcirc
		t=23; circtime_path='t23'; runcirc
	fi
	
	if [ $num_time_intervals = 10 ]; then
		t=0; circtime_path='t0'; runcirc
		t=2; circtime_path='t2'; runcirc
		t=3; circtime_path='t3'; runcirc
		t=4; circtime_path='t4'; runcirc
		t=6; circtime_path='t6'; runcirc
		t=8; circtime_path='t8'; runcirc
		t=9; circtime_path='t9'; runcirc
		t=10; circtime_path='t10'; runcirc
		t=12; circtime_path='t12'; runcirc
		t=13; circtime_path='t13'; runcirc
	fi
	
	if [ $num_time_intervals = 12 ]; then
		t=0; circtime_path='t0'; runcirc
		t=1; circtime_path='t1'; runcirc
		t=2; circtime_path='t2'; runcirc
		t=3; circtime_path='t3'; runcirc
		t=4; circtime_path='t4'; runcirc
		t=5; circtime_path='t5'; runcirc
		t=6; circtime_path='t6'; runcirc
		t=7; circtime_path='t7'; runcirc
		t=8; circtime_path='t8'; runcirc
		t=9; circtime_path='t9'; runcirc
		t=10; circtime_path='t10'; runcirc
		t=11; circtime_path='t11'; runcirc
	fi
	
	if [ $num_time_intervals = 16 ]; then
		t=0; circtime_path='t0'; runcirc
		t=1; circtime_path='t1'; runcirc
		t=2; circtime_path='t2'; runcirc
		t=4; circtime_path='t4'; runcirc
		t=6; circtime_path='t6'; runcirc
		t=8; circtime_path='t8'; runcirc
		t=10; circtime_path='t10'; runcirc
		t=12; circtime_path='t12'; runcirc
		t=13; circtime_path='t13'; runcirc
		t=14; circtime_path='t14'; runcirc
		t=15; circtime_path='t15'; runcirc
		t=17; circtime_path='t17'; runcirc
		t=18; circtime_path='t18'; runcirc
		t=19; circtime_path='t19'; runcirc
		t=21; circtime_path='t21'; runcirc
		t=23; circtime_path='t23'; runcirc
	fi
}


## ****************************************** Start Script ***************************************************

	## Neuron Setup
SIMPATH1="/Applications/NEURON-7.1/nrn/share/nrn/"
SIMNAME1="lib/hoc/nrngui.hoc"
SIMPATH2="./"
SIMNAME2="50knet_dav.hoc"
MODFILE_HOME="mod/umac/special"
MODFILE_REMOTE="mod_MB/umac/special"
EXECPATH="./"
if [ $1 = 0 ]; then MODPATH=$MODFILE_HOME
else MODPATH=$MODFILE_REMOTE
fi


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


	## Turn off graphics if running remotely via SSH
if ([ $run_mode = 3 ]||[ $run_mode = 4 ]); then graphics_on=0; fi

	## Debug
if [ $2 = 0 ]; then		# Run under default settings

	NOSAVE=1;
	run_mode=1 ## Run full sim locally
	sim_time=1.0
	plot_on=1
	small_net=0
	include_NMDA=0
	bc_gammanet=0
	percent_msg_intact=0.5
	percent_ACh_intact=0.0
	no_synapses=0
	setup_batch
	
	export numexps=0
	
	# Setting up default circadian input magnitudes
	EC_amp0=0.0; SCN_amp0=0.40; mel_amp0=0.25; Ca_amp0=0.25
	ACh_accom_amp0=0.25; ACh_Esyn_amp0=0.25; ACh_pyr_amp0=0.25;
	ACh_Isyn_amp0=${ACh_Esyn_amp0}; ACh_bc_amp0=${ACh_pyr_amp0}; ACh_olm_amp0=${ACh_pyr_amp0}

#	EC_amp=${EC_amp0}; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=${Ca_amp0}; ACh_Esyn_amp=${ACh_Esyn_amp0};
#	ACh_accom_amp=${ACh_accom_amp0}; ACh_pyr_amp=${ACh_pyr_amp0};
#	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
#	expname_raw=""$numexps"_"; expname_suffix="def"; runexp 1
	
	EC_amp=0.0; SCN_amp=0.0; mel_amp=0.0; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="def"; runexp 1

fi

if [ $2 = 1 ]; then		# Run under default settings

	NOSAVE=0;
	run_mode=4 ## Run full sim locally
	sim_time=20.0
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
	EC_amp0=0.0; SCN_amp0=0.20; mel_amp0=0.20; Ca_amp0=0.20
	ACh_accom_amp0=0.20; ACh_Esyn_amp0=0.20; ACh_pyr_amp0=0.20;
	ACh_Isyn_amp0=${ACh_Esyn_amp0}; ACh_bc_amp0=${ACh_pyr_amp0}; ACh_olm_amp0=${ACh_pyr_amp0}



	
		# Running simulations
	# Individual
	percent_msg_intact=1.0
	EC_amp=0.0; SCN_amp=${SCN_amp0}; mel_amp=0.0; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="SCN"; runexp 9
	
	EC_amp=0.0; SCN_amp=0.0; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="mel"; runexp 9
	
	EC_amp=0.0; SCN_amp=0.0; mel_amp=0.0; Ca_amp=${Ca_amp0}; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="Ca"; runexp 9
	
#	EC_amp=0.0; SCN_amp=0.0; mel_amp=0.0; Ca_amp=0.0; ACh_Esyn_amp=${ACh_Esyn_amp0}; 
#	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
#	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
#	expname_raw=""$numexps"_"; expname_suffix="ACh_syn"; runexp 9
#	
#	EC_amp=0.0; SCN_amp=0.0; mel_amp=0.0; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
#	ACh_accom_amp=${ACh_accom_amp0}; ACh_pyr_amp=0.0;
#	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
#	expname_raw=""$numexps"_"; expname_suffix="ACh_accom"; runexp 9
#	
#	EC_amp=0.0; SCN_amp=0.0; mel_amp=0.0; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
#	ACh_accom_amp=0.0; ACh_pyr_amp=${ACh_pyr_amp0};
#	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
#	expname_raw=""$numexps"_"; expname_suffix="ACh_inj"; runexp 9
	
	# Combined
	EC_amp=0.0; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="SCN_mel_healthy"; runexp 9
	
	percent_msg_intact=0.0
	# Combined - (but really individual)
	EC_amp=0.0; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="mel_latent"; runexp 9
	# Individual
	EC_amp=0.0; SCN_amp=0.0; mel_amp=0.0; Ca_amp=${Ca_amp0}; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="Ca"; runexp 9
	
fi



if [ $2 = 2 ]; then		# Run under default settings

	NOSAVE=0;
	run_mode=4 ## Run full sim locally
	sim_time=4.0
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
	EC_amp0=0.15; SCN_amp0=0.20; mel_amp0=0.15; Ca_amp0=0.20
	ACh_accom_amp0=0.20; ACh_Esyn_amp0=0.20; ACh_pyr_amp0=0.20;
	ACh_Isyn_amp0=${ACh_Esyn_amp0}; ACh_bc_amp0=${ACh_pyr_amp0}; ACh_olm_amp0=${ACh_pyr_amp0}

	
		# Running simulations
	# Individual	
	percent_msg_intact=1.0
#	EC_amp=${EC_amp0}; SCN_amp=0.0; mel_amp=0.0; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
#	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
#	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
#	expname_raw=""$numexps"_"; expname_suffix="EC_healthy"; runexp 9
#	
#	EC_amp=0.0; SCN_amp=${SCN_amp0}; mel_amp=0.0; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
#	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
#	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
#	expname_raw=""$numexps"_"; expname_suffix="SCN"; runexp 9
	
	# Healthy	
	percent_msg_intact=1.0
	EC_amp=${EC_amp0}; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="all3"; runexp 12
	
	EC_amp=0.0; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="SCN_mel"; runexp 12
	
	EC_amp=${EC_amp0}; SCN_amp=0.0; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="EC_mel"; runexp 12


	# Latent
	percent_msg_intact=0.0
	EC_amp=${EC_amp0}; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
	expname_raw=""$numexps"_"; expname_suffix="latent_all3"; runexp 12
	
#	EC_amp=0.0; SCN_amp=${SCN_amp0}; mel_amp=${mel_amp0}; Ca_amp=0.0; ACh_Esyn_amp=0.0; 
#	ACh_accom_amp=0.0; ACh_pyr_amp=0.0;
#	ACh_Isyn_amp=${ACh_Esyn_amp}; ACh_bc_amp=${ACh_pyr_amp}; ACh_olm_amp=${ACh_pyr_amp}
#	expname_raw=""$numexps"_"; expname_suffix="latent_mel"; runexp 9

	
fi




if [ $2 = 3 ]; then		# Mode 3 - Healthy vs Injured (tests the effects of removing the septum)
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



if [ $2 = 4 ]; then		# Mode 4 - Sensitivity analysis; vary melatonin and septal inputs
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




if [ $2 = 5 ]; then		# Mode 5 - Singles; apply only 1 circadian input at a time.
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


