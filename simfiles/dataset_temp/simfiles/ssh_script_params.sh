

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



