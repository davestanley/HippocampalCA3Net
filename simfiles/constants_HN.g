



//====================================================================
// simulation parameter
//====================================================================
//***** Integration time (at least for interneurons)*/
float	dt = 1e-5
setclock 0 {dt}

//*****Data collection time*/
float dt2 = 5e-4
setclock 1 {dt2}

float dt3 = 1e-4	// Clock used for extracellular field object
setclock 2 {dt3}

//float sim_time=0.2		// Total simulation runtime

// Injection currents (From Neymotin / Traub)
//float pyr_inject = 50.0e-12		// Value used in Neymotin paper
float pyr_inject = 200.0e-12		// Value used in Traub91.g
float bc_inject = 0.0			// From Neymotin 2011
float olm_inject = -25.0e-12	// From Neymotin 2011
float msg_inject = 1.885e-11	// From Hajos 2004

// Injection currents (From Hajos / Traub)
float pyr_inject = 200.0e-12		// From Traub 1991
float bc_inject = 1.7592904e-11	// From Hajos 2004
float olm_inject = 0.0			//  From Hajos 2004 
float msg_inject = 1.885e-11		// From Hajos 2004



//====================================================================
// Dataset paths
//====================================================================
str	gp, pp, sp
gp = "./dataset_temp/"
pp = "0_def/"
sp = "t0/"

gp = "./dataset_temp/"
pp = ""
sp = ""

gp = {{dataoutput_path} @ "/"}	// Davedit
pp = {{expname_path} @ "/"}	// Davedit
sp = {{circtime_path} @ "/"}	// Davedit



//============================================================
// network dimensions
//==========================================================

if (small_net)
	int pyr_nx = 2 // number of pyramidal cells along x-axis
	int pyr_ny = 1 // number of pyramidal cells along y-axis
	int olm_nx = 2 // number of feedback interneurons along x-axis
	int olm_ny = 1 // number of feedback interneurons along y-axis
	int bc_nx = 2 // number of feedforward interneurons along x-axis
	int bc_ny = 1 // number of feedforward interneurons along y-axis
	int msg_nx = 2 // number of feedforward interneurons along x-axis
	int msg_ny = 1 // number of feedforward interneurons along y-axis
	if (include_msg_aff_input)
		msg_nx = 25
		msg_ny = 1
	end
else
	int pyr_nx = 200 // number of pyramidal cells along x-axis
	int pyr_ny = 1 // number of pyramidal cells along y-axis
	int olm_nx = 25 // number of feedback interneurons along x-axis
	int olm_ny = 1 // number of feedback interneurons along y-axis
	int bc_nx = 25 // number of feedforward interneurons along x-axis
	int bc_ny = 1 // number of feedforward interneurons along y-axis
	int msg_nx = 25 // number of feedforward interneurons along x-axis
	int msg_ny = 1 // number of feedforward interneurons along y-axis
end

int n_of_pyr // number of pyramidal cells in array    
n_of_pyr = {pyr_nx}*{pyr_ny} 
float pyr_dx = 10e-6 // distance between pyramidal cells in x-dimension
float pyr_dy = 10e-6 // distance between pyramidal cells in y-dimension
float pyr_origin_x = 0 // x-coordinate for first element in network
float pyr_origin_y = 0 // y-coordinate for first element in network

int n_of_olm // number of feedback interneurons in array    
n_of_olm = {olm_nx}*{olm_ny} 
float olm_dx = 20e-6 // distance between olm interneurons in x-dimension
float olm_dy = 40e-6 // distance between olm interneurons in y-dimension
float olm_origin_x = 5e-6 // x-coordinate for first element in network
float olm_origin_y = 5e-6 // y-coordinate for first element in network
 
int n_of_bc // number of feedforward interneurons in array    
n_of_bc = {bc_nx}*{bc_ny} 
float bc_dx = 20e-6 // distance between bc interneurons in x-dimension
float bc_dy = 40e-6 // distance between bc interneurons in y-dimension
float bc_origin_x = 5e-6 // x-coordinate for first element in network
float bc_origin_y = 25e-6 // y-coordinate for first element in network

int n_of_msg // number of feedforward interneurons in array    
n_of_msg = {msg_nx}*{msg_ny} 
float msg_dx = 20e-6 // distance between msg interneurons in x-dimension
float msg_dy = 40e-6 // distance between msg interneurons in y-dimension
float msg_origin_x = 5e-6 // x-coordinate for first element in network
float msg_origin_y = 50e-6 // y-coordinate for first element in network



//Biophysical constants for HN network
float E_AMPA = 0.0
float E_NMDA = 0.0
float E_GABA_A = -0.080

// Frequencies for background synaptic activity
float freq_bkgnd = 1000
float freq_bkgnd_pyr = 1000
float freq_bkgnd_olm = 1000
float freq_bkgnd_nmda = 10
float freq_bkgnd_nmda_pyr = 10

if (noise_off)
	float freq_bkgnd = 0
	float freq_bkgnd_pyr = 0
	float freq_bkgnd_olm = 0
	float freq_bkgnd_nmda = 0
	float freq_bkgnd_nmda_pyr = 0
end

// Gmaxes for background synaptic activity
float Gmax_pyr_soma_AMPA = 0.05e-9
float Gmax_pyr_dend_AMPA = 0.05e-9
float Gmax_bc_soma_AMPA = 0.02e-9
float Gmax_olm_soma_AMPA = 0.0625e-9
float Gmax_pyr_soma_GABA_A = 0.012e-9
float Gmax_pyr_dend_GABA_A = 0.012e-9
float Gmax_bc_soma_GABA_A = 0.2e-9
float Gmax_olm_soma_GABA_A = 0.2e-9
float Gmax_pyr_dend_NMDA = 6.5e-9

// Gmaxes for CA3 network
float pyr2pyr_AMPA = 0.02e-9
float pyr2bc_AMPA = 0.36e-9
float pyr2olm_AMPA = 0.36e-9
float bc2pyr_GABA_A = 0.72e-9
float bc2bc_GABA_A = 4.5e-9
float olm2pyr_GABA_A = 72e-9	
//float msg2bc_GABA_A = 1.6e-9	// From Neymotin 2011
//float msg2olm_GABA_A = 1.6e-9 // From Neymotin 2011
float msg2bc_GABA_A = 0.5e-9	// From Hajos 2004
float msg2olm_GABA_A = 0.5e-9 // From Hajos 2004
float msg2msg_GABA_A = 0.25e-9	// From Hajos 2004
float olm2bc_GABA_A = 0.88e-9	// From Hajos 2004
float olm2msg_GABA_A = 0.5e-9	// From Hajos 2004

float pyr2pyr_NMDA = 0.004e-9
float pyr2bc_NMDA = 1.38e-9
float pyr2olm_NMDA = 0.7e-9


// Synaptic time constants
float AMPA_tau1 = 0.05e-3
float AMPA_tau2 = 5.3e-3
float NMDA_tau1 = 15e-3
float NMDA_tau2 = 150e-3
float GABAA_tau1=0.07e-3	// Neymotin 2011
float GABAA_tau2=9.1e-3		// Neymotin 2011
float GABAA_OLM_tau1 = 0.2e-3	// Neymotin 2011
float GABAA_OLM_tau2 = 20e-3	// Neymotin 2011
float GABAA_MS_tau1 = 20e-3	// Neymotin 2011
float GABAA_MS_tau2 = 40e-3	// Neymotin 2011
float GABAA_MS_tau1 = 0.07e-3	// Davedit (follow same pattern as Hajos, using default GABA const here)
float GABAA_MS_tau2 = 9.1e-3	// Davedit (follow same pattern as Hajos, using default GABA const here)

float Q10_synapse = 1.0

// Destination compartments
str pyr2pyr_compt = "basal_5"
str olm2pyr_compt = "apical_18"


// Connectivity convergences
int pyr2pyr_conv = 25
int pyr2bc_conv = 100
int pyr2olm_conv = 10
int bc2pyr_conv = 50
int bc2bc_conv = 60
int olm2pyr_conv = 20
//int msg2bc_conv = 1		//Neymotin 2011
//int msg2olm_conv = 1	//Neymotin 2011
int msg2bc_conv = 10	//Hajos 2004
int msg2olm_conv = 10	//Hajos 2004

int msg2msg_conv = 10	//Hajos 2004
int olm2bc_conv = 5	//Hajos 2004
int olm2msg_conv = 2	//Hajos 2004

//Traub connectivities
int pyr2pyr_conv = 10
int pyr2bc_conv = 20
int pyr2olm_conv = 10
int bc2pyr_conv = 15
int bc2bc_conv = 25
int olm2pyr_conv = 10
//int msg2bc_conv = 1		//Neymotin 2011
//int msg2olm_conv = 1	//Neymotin 2011
int msg2bc_conv = 5		//Hajos 2004
int msg2olm_conv = 5	//Hajos 2004

int msg2msg_conv = 10	//Hajos 2004
int olm2bc_conv = 5	//Hajos 2004
int olm2msg_conv = 2	//Hajos 2004

if (test_synapses)
	pyr2bc_conv = 1
	pyr2pyr_conv = 1
	pyr2pyr_conv = 1
	pyr2bc_conv = 1
	pyr2olm_conv = 1
	bc2pyr_conv = 1
	bc2bc_conv = 1
	olm2pyr_conv = 1
	msg2bc_conv = 1	
	msg2olm_conv = 1
	msg2msg_conv = 1
end

//==============================================================
// spike generator and randomspike parameters
//==============================================================


float int_refract_HN = 0.001 // sec; refractory-period
float pyr_refract_HN = 0.001 // sec; allows discrimination of single action 

float AFF_min_amp = 1 // parameters for randomspike
float AFF_max_amp = 1 // all spikes have unit amplitude
float AFF_rate = 40 // 50 spikes per second; Reinouds suggestion
float AFF_abs_refract = 0.001 // 0.005 consecutive events cannot occur in an 
			      // interval shorter than abs_refract



//=================================================================
// randomization of variables
//=================================================================
float rand_Vinit=-0.010
float rand_VEm=-0.002
//rand_inj=


 
//=================================================================
// elektrode information
//=================================================================

str e_recsite1 = "/rec_site"

float e_z1_min = -55e-6 // -50e-6; -60e-6; -130e-6 level of lowest recording site for one electrode
float e_z1_max = 96e-6 // 200e-6; 160e-6; 150; 151e-6; 221e-6 since 150 was not used correctly level of highest recording site
float e_dz1 = 12.5e-6 // distance between recording sites of electrode

float e_scale1 = -15 // -50; -10; -15; -30 scale factor used in efield-object
int n_of_e90 = { {{e_z1_max} - {e_z1_min}} / {e_dz1} + 1}


//=================================================================
// conduction velocities and percentage of randomization for delay
//=================================================================

float cond_vel_pyr_ax = 0.5 // m*s^-1; pyramidal cell axons are myelinated
float cond_vel_int_ax = 0.1  // unmyelinated


//float pyr_refract_HN = 0.1 // sec; allows discrimination of single action 

float pyr2pyr_NMDA = 0.008e-9
float pyr2bc_NMDA = 0.0034e-9		//davedit 
float pyr2olm_NMDA = 0.0034e-9		//davedit

// Tune EPSPs and IPSPs to literature values!
float pyr2pyr_AMPA = 2.6e-9			//Tuned to EPSP value based on Traub - Fast Oscillations (1999). EPSP of 1.0mV @ -65mV
float pyr2bc_AMPA = 0.05e-9			//Tuned to EPSP value based on Traub - Fast Oscillations (1999); Taxidis 2011. EPSP of ~1.5mV @ -65mV
float pyr2olm_AMPA = 0.05e-9		//Tuned to EPSP value based on Traub - Fast Oscillations (1999); Taxidis 2011. EPSP of ~1.4mV @ -65mV
float bc2pyr_GABA_A = 9.2e-9		//Tuned to IPSP value based on Traub - Fast Oscillations (1999). IPSP of ~1.2mV @ -62mV
float olm2pyr_GABA_A = 8.3e-9		//Tuned to IPSP value based on Traub - Fast Oscillations (1999). IPSP of ~1.0mV @ -62mV
float bc2bc_GABA_A = 0.125e-9		//From Hajos et al, 2004; This approximates that used by Taxidis et al (2011). (~0.6mV IPSP)


//
//// Alter afferent input ratio adjustment
////float Gmax_pyr_soma_AMPA = 0.8e-9	//Davedit
////float Gmax_pyr_dend_AMPA = 0.8e-9	//Davedit
//float Gmax_bc_soma_AMPA = 0.00278e-9
//float Gmax_olm_soma_AMPA = 0.00868e-9
//float Gmax_pyr_soma_GABA_A = 0.153e-9
//float Gmax_pyr_dend_GABA_A = 0.153e-9
//float Gmax_bc_soma_GABA_A = 0.00556e-9
//float Gmax_olm_soma_GABA_A = 0.00556e-9
//float Gmax_pyr_dend_NMDA = 6.5e-9

// Adjust afferent input to produce Vm fluctuations at -65mV of approximately 1.5mV standard deviation
float Gmax_olm_soma_AMPA = 0.03e-9
float Gmax_olm_soma_GABA_A = 0.01e-9
float Gmax_bc_soma_AMPA = 0.03e-9
float Gmax_bc_soma_GABA_A = 0.01e-9
float Gmax_pyr_soma_GABA_A = 2.5e-9
float Gmax_pyr_dend_GABA_A = 2.5e-9


// Gmaxes for background synaptic activity

//float Gmax_pyr_soma_AMPA = 0.05e-9
//float Gmax_pyr_dend_AMPA = 0.05e-9
//float Gmax_pyr_soma_GABA_A = 0.012e-9
//float Gmax_pyr_dend_GABA_A = 0.012e-9


// Adjust input currents for new afferent input
//float pyr_inject = 320.0e-12		// From Traub 1991
//float bc_inject = 0.8592904e-11	// From Hajos 2004
//float olm_inject = -0.20e-11			//  From Hajos 2004 
//float msg_inject = 1.885e-11		// From Hajos 2004
//float msg_inject = 2.00e-11		// From Hajos 2004	// Increased to compensate for olm->msg connectivity
//float bc_inject = 1.3592904e-11	// Increase this again to get back gamma rhythms

float pyr_inject = {pyr_inject0}		// From Traub 1991
float bc_inject = 3.8592904e-11	// From Hajos 2004
float olm_inject = 1.0592904e-11			//  From Hajos 2004 
float msg_inject = 1.885e-11		// From Hajos 2004

float bc_inject = 1.1592904e-11	// From Hajos 2004
float olm_inject = -0.25e-11			//  From Neymotin 2010 
float msg_inject = 1.885e-11		// From Hajos 2004
float bc_inject = 0.40e-11	// From Hajos 2004

float bc_inject = {bc_inject0}	// From Hajos 2004
float olm_inject = {olm_inject0}			//  From Neymotin 2010 
float msg_inject = {msg_inject0}		// From Hajos 2004


//
////Tuning Adjustments
//int pyr2pyr_conv = 25
//int pyr2bc_conv = 100
////int pyr2olm_conv = 10
//float bc2pyr_GABA_A = 4.6e-9		//Tuned to IPSP value based on Traub - Fast Oscillations (1999). IPSP of ~1.2mV @ -62mV
////float pyr2pyr_AMPA = 5.2e-9			//Tuned to EPSP value based on Traub - Fast Oscillations (1999). EPSP of 1.0mV @ -65mV
//float Gmax_pyr_soma_AMPA = 0.05e-9	//Neymotin original
//float Gmax_pyr_dend_AMPA = 0.05e-9
//

float bc2pyr_GABA_A = {bc2pyr_GABA_A0}		//Tuned to IPSP value based on Traub - Fast Oscillations (1999). IPSP of ~1.2mV @ -62mV
float pyr2pyr_AMPA = {pyr2pyr_AMPA0}			//Tuned to EPSP value based on Traub - Fast Oscillations (1999). EPSP of 1.0mV @ -65mV
float Gmax_pyr_soma_AMPA = {Gmax_pyr_bkgnd0}	//Neymotin original
float Gmax_pyr_dend_AMPA = {Gmax_pyr_bkgnd0}


if (enable_olm2bc_synapse)
 	bc_inject = bc_inject + 0.5e-11	// From Hajos 2004
 	// Should be around this: bc_inject = 1.5592904e-11	// From Hajos 2004
end

if (bc_gammanet)
	bc2pyr_conv = 10
	bc_inject = 1.0592904e-11
//	bc_inject = 1.3592904e-11	// Increase this again to get back gamma rhythms
	bc2bc_conv = 20
//	Gmax_pyr_soma_GABA_A = 0.0e-9
//	Gmax_pyr_dend_GABA_A = 0.0e-9
	pyr_inject = 220.0e-12		// From Traub 1991
	// pyr2bc_conv = 100 		// Set to 100 to reduce bursting, get sporadic behaviour
end

//Disable connections
//float pyr2pyr_AMPA = 0.0
//float pyr2bc_AMPA = 0.0
//float pyr2olm_AMPA = 0.0
//float bc2pyr_GABA_A = 0.0
//float bc2bc_GABA_A = 0.025e-9
//float olm2pyr_GABA_A = 0.0
//float msg2bc_GABA_A = 0.0	// From Hajos 2004
//float msg2olm_GABA_A = 0.0 // From Hajos 2004
//float msg2msg_GABA_A = 0.0	// From Hajos 2004
//float pyr2pyr_NMDA = 0.0
//float pyr2bc_NMDA = 0.0
//float pyr2olm_NMDA = 0.0




if (test_synapses)
	float bc_inject = 0.22904e-11
	float olm_inject = 0.0
end



//int msg2bc_conv = 20	//Davedit -- increased septal influence (maybe not necessary)
//int msg2olm_conv = 20	//Davedit -- increased septal influence (maybe not necessary)




































int msg2bc_div = msg2bc_conv * n_of_bc / n_of_msg
int msg2olm_div = msg2olm_conv * n_of_olm / n_of_msg




//============================================================
// network dimensions
//==========================================================

int AFF_nx = 4 // number of randomspike elements along x-axis
int AFF_ny = 4 // number of randomspike elements along y-axis
int n_of_AFF // number of randomspike elements in array    
n_of_AFF = {AFF_nx}*{AFF_ny} 
float AFF_dx = 15e-6 // distance between randomspike elements in x-dimension
float AFF_dy = 15e-6 // distance between randomspike elements in y-dimension
float AFF_origin_x_1 = 0 // x-coordinate for first element in network
float AFF_origin_y_1 = 0 // y-coordinate for first element in network

float AFF_origin_x_2 = 0 // x-coordinate for first element in network
float AFF_origin_y_2 = 60e-6 // y-coordinate for first element in network


//===================================================================
// x1,y1,z1, x2,y2,z2 for destination mask of volumeconnect
//==================================================================

float AFF2ca3_x1 = -1 // meter
float AFF2ca3_y1 = -1 // employment of this huge number ensures, that 
float AFF2ca3_z1 = -1 // connections are made from each element in the
float AFF2ca3_x2 = 1  // source region to each element in the destination
float AFF2ca3_y2 = 1  // region; AFFerents can have contacts to 
float AFF2ca3_z2 = 1  // ca3amidal cells everywhere in the network

float AFF2bc_x1 = -1 // meter
float AFF2bc_y1 = -1 // AFFerents can have contacts to bc interneurons
float AFF2bc_z1 = -1 // everywhere in the network
float AFF2bc_x2 = 1  // 
float AFF2bc_y2 = 1  //   
float AFF2bc_z2 = 1  // 

float ca32ca3_x1 = -1 // meter
float ca32ca3_y1 = -1 // employment of this huge number ensures, that 
float ca32ca3_z1 = -1 // connections are made from each element in the
float ca32ca3_x2 = 1  // source region to each element in the destination
float ca32ca3_y2 = 1  // region; ca3amidal cells can have contacts to other
float ca32ca3_z2 = 1  // ca3amidal cell everywhere in the network

float ca32olm_x1 = -1  // ca3amidal cells contact olm interneurons everywhere
float ca32olm_y1 = -1  // in the network
float ca32olm_z1 = -1
float ca32olm_x2 = 1
float ca32olm_y2 = 1
float ca32olm_z2 = 1

float olm2ca3_x1 = 0   // interneurons are only allowed to contact ca3amidal
float olm2ca3_y1 = 0   // cells within a distance of 500microns from the
float olm2ca3_z1 = 0   // respective interneuron; since relative positions 
float olm2ca3_x2 = 1000e-6 // and elipsoidal sourcemask are used, 0,0,0 gives 
float olm2ca3_y2 = 1000e-6 // the position of the interneuron(center of ellipse)
float olm2ca3_z2 = 1000e-6 // x2,y2,z2 specify lengthes of the axis

float bc2ca3_x1 = 0
float bc2ca3_y1 = 0
float bc2ca3_z1 = 0
float bc2ca3_x2 = 1000e-6
float bc2ca3_y2 = 1000e-6
float bc2ca3_z2 = 1000e-6


//=================================================================
// conduction velocities and percentage of randomization for delay
//=================================================================

float cond_vel_ca3_ax = 0.5 // m*s^-1; ca3amidal cell axons are supposed to be
		            // myelinated
float cond_vel_olm_ax = 0.2  // unmyelinated
float cond_vel_bc_ax = 0.2  // unmyelinated
float cond_vel_AFF_ax = 0.2  // mossy fibers are unmyelinated (Shepherd)

float rand_delay_ca3_ax = 0.15 // calculated delay +/- upto 15% (connections.g)
float rand_delay_olm_ax = 0.15
float rand_delay_bc_ax = 0.15
float rand_delay_AFF_ax = 0.15


//================================================
// synaptic weights used in volumeweight-function
//===============================================

float from_AFF_weight = 1 // gmax defined by values in cell descriptor files
// AMPA 100.0 in cell descriptor file of bc-interneurons
float from_ca3_weight = 1 // ca3amidal cell on presynaptic site
// AMPA 1.0 in cell descriptor file of olm-interneurons
float from_olm_weight = 1  // olm interneuron on presynaptic site
float from_bc_weight = 1  // bc interneuron on presynaptic site

float rand_from_AFF_weight = 0.15 // calculated weight +/- up to 15%
float rand_from_ca3_weight = 0.15
float rand_from_olm_weight = 0.15
float rand_from_bc_weight = 0.15

float injcurr = 0 	      // default injection
float bc_hold_cur = -0.03e-9 // Traub II: -0.045 nA current suppreses spontaneo				    //	us firing
float olm_hold_cur = -0.03e-9 // holding currents not employed
float ca3_hold_cur = -0.07e-9

//====================================================================
// hines solver
//====================================================================

int chanmode = 1 // 3

/* chanmodes 0 and 3 allow outgoing messages to non-hsolved elements.
   chanmode 3 is fastest.
*/



