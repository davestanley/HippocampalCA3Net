



// ------------------------ Epileptogenesis tweaks ------------------------

	// NBNB MS GABA cells are disabled in the main script!

	// Scale amplitude of ACh modification based on # surviving ACh fibers
ACh_accom_amp = {{ACh_accom_amp}*{percent_ACh_intact}}
ACh_Esyn_amp = {{ACh_Esyn_amp}*{percent_ACh_intact}}
ACh_Isyn_amp = {{ACh_Isyn_amp}*{percent_ACh_intact}}
ACh_pyr_amp = {{ACh_pyr_amp}*{percent_ACh_intact}}
ACh_bc_amp = {{ACh_bc_amp}*{percent_ACh_intact}}
ACh_olm_amp = {{ACh_olm_amp}*{percent_ACh_intact}}

// ------------------------ End epilepsy tweaks ------------------------









// ------------------------ Circadian tweaks ------------------------

////////////////////// Entorhinal Cortex (CA3 inject) ////////////////////////
//EC input
pyr_inject = {{pyr_inject} * {EC_val}}           // depol. curr to pyr cell (A)




//////////////////////// SCN input on MS GABA cells ////////////////////////
// SCN input on Septal GABAergic cells
msg_inject = {{msg_inject} * {SCN_val}}             // injected current to MS GABA cells


//////////////////////// Melatonin input ////////////////////////
// Gmaxes for background synaptic activity
Gmax_pyr_soma_GABA_A = {{Gmax_pyr_soma_GABA_A}*{mel_val}}
Gmax_pyr_dend_GABA_A = {{Gmax_pyr_dend_GABA_A}*{mel_val}}
Gmax_bc_soma_GABA_A = {{Gmax_bc_soma_GABA_A}*{mel_val}}
Gmax_olm_soma_GABA_A = {{Gmax_olm_soma_GABA_A}*{mel_val}}

// Gmaxes for CA3 network
bc2pyr_GABA_A = {{bc2pyr_GABA_A}*{mel_val}}
bc2bc_GABA_A = {{bc2bc_GABA_A}*{mel_val}}
olm2pyr_GABA_A = {{olm2pyr_GABA_A}*{mel_val}}
msg2bc_GABA_A = {{msg2bc_GABA_A}*{mel_val}}
msg2olm_GABA_A = {{msg2olm_GABA_A}*{mel_val}}
msg2msg_GABA_A = {{msg2msg_GABA_A}*{mel_val}}
olm2bc_GABA_A = {{olm2bc_GABA_A}*{mel_val}}
olm2msg_GABA_A = {{olm2msg_GABA_A}*{mel_val}}


//////////////////////// Acetylcholine input ////////////////////////
float ACh_sinusoid = {{ACh_val}-1.0}/{ACh_amp}
float ACh_level = {{ACh_sinusoid} + 1.0}/2.0	// ACh level in hippo, varies from 0 to 1
float ACh_accom_scale = {1.0 - ACh_accom_amp*ACh_level}	// Suppress accommodation
float ACh_Esyn_scale = {1.0 - ACh_Esyn_amp*ACh_level}	// Suppress recurrent excitation
float ACh_Isyn_scale = {1.0 - ACh_Isyn_amp*ACh_level}	// Suppress inhibition
float ACh_pyr_inj = {pyr_inject}*{ACh_pyr_amp}*{ACh_level}	// Inject current to provide depolarization
float ACh_bc_inj = {bc_inject}*{ACh_bc_amp}*{ACh_level}
float ACh_olm_inj = {bc_inject}*{ACh_olm_amp}*{ACh_level}

// Increase current injection in response to ACh levels
pyr_inject = pyr_inject + ACh_pyr_inj
bc_inject = bc_inject + ACh_bc_inj
olm_inject = olm_inject + ACh_olm_inj
//msg_inject = 1.885e-11	--> No septal ACh


// Scale Gmaxes for background synaptic activity with ACh
Gmax_pyr_soma_AMPA = {{Gmax_pyr_soma_AMPA}*{ACh_Esyn_scale}}
Gmax_pyr_dend_AMPA = {{Gmax_pyr_dend_AMPA}*{ACh_Esyn_scale}}
Gmax_bc_soma_AMPA = {{Gmax_bc_soma_AMPA}*{ACh_Esyn_scale}}
Gmax_olm_soma_AMPA = {{Gmax_olm_soma_AMPA}*{ACh_Esyn_scale}}
Gmax_pyr_soma_GABA_A = {{Gmax_pyr_soma_GABA_A}*{ACh_Isyn_scale}}
Gmax_pyr_dend_GABA_A = {{Gmax_pyr_dend_GABA_A}*{ACh_Isyn_scale}}
Gmax_bc_soma_GABA_A = {{Gmax_bc_soma_GABA_A}*{ACh_Isyn_scale}}
Gmax_olm_soma_GABA_A = {{Gmax_olm_soma_GABA_A}*{ACh_Isyn_scale}}
//Gmax_pyr_dend_NMDA = {{Gmax_pyr_dend_NMDA}*{ACh_Isyn_scale}} --> No NMDA in this sim

// Scale Gmaxes for CA3 network with ACh
pyr2pyr_AMPA = {{pyr2pyr_AMPA}*{ACh_Esyn_scale}}
pyr2bc_AMPA = {{pyr2bc_AMPA}*{ACh_Esyn_scale}}
pyr2olm_AMPA = {{pyr2olm_AMPA}*{ACh_Esyn_scale}}
bc2pyr_GABA_A = {{bc2pyr_GABA_A}*{ACh_Isyn_scale}}
bc2bc_GABA_A = {{bc2bc_GABA_A}*{ACh_Isyn_scale}}
olm2pyr_GABA_A = {{olm2pyr_GABA_A}*{ACh_Isyn_scale}}
msg2bc_GABA_A = {{msg2bc_GABA_A}*{ACh_Isyn_scale}}
msg2olm_GABA_A = {{msg2olm_GABA_A}*{ACh_Isyn_scale}}
//msg2msg_GABA_A = {{msg2msg_GABA_A}*{ACh_Isyn_scale}}	--> No synaptic modification of cells in MSG
olm2bc_GABA_A = {{olm2bc_GABA_A}*{ACh_Isyn_scale}}
//olm2msg_GABA_A = {{olm2msg_GABA_A}*{ACh_Isyn_scale}}	--> No synaptic modification of cells in MSG



// Scale accommodation by modifying AHP channels
//see tweaks_cells.g


//////////////////////// Calcium input (Kole, Fuchs 2001) ////////////////////////
//see tweaks_cells.g


// ------------------------ End Circadian tweaks ------------------------







