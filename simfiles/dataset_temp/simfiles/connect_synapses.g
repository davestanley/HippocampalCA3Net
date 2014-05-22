// genesis 2.2
// Kerstin Menne
// Luebeck, 02.10.2001
// establish synatpic connections 

//==================================================================
// connections
//==================================================================

// recurrent excitation from pyramidal cells to pyramidal cells
// AMPA channels

int allow_repeats = 0
int random_dest = 0


if (!no_synapses)
	randseed 12345
//	randseed
	if (!test_synapses)
		
		if (include_NMDA)																			// 0 -> is not recurrent
																									// 1 -> is recurrent
			str temp_syndestlist = {{pyr2pyr_compt} @ "/AMPA " @ {pyr2pyr_compt} @ "/NMDA"}			
			conv_connect /pyr_arr/pyr /pyr_arr/pyr soma/pyr_spikegen {temp_syndestlist} {pyr2pyr_conv} 1 {allow_repeats} {random_dest}
			conv_connect /pyr_arr/pyr /bc_arr/bc soma/pyr_spikegen "soma/AMPA soma/NMDA" {pyr2bc_conv} 0 {allow_repeats} {random_dest}
			conv_connect /pyr_arr/pyr /olm_arr/olm soma/pyr_spikegen "soma/AMPA soma/NMDA" {pyr2olm_conv} 0 {allow_repeats} {random_dest}
		else
			str temp_syndestlist = {{pyr2pyr_compt} @ "/AMPA"}			
			conv_connect /pyr_arr/pyr /pyr_arr/pyr soma/pyr_spikegen {temp_syndestlist} {pyr2pyr_conv} 1 {allow_repeats} {random_dest}
			conv_connect /pyr_arr/pyr /bc_arr/bc soma/pyr_spikegen "soma/AMPA" {pyr2bc_conv} 0 {allow_repeats} {random_dest}
			conv_connect /pyr_arr/pyr /olm_arr/olm soma/pyr_spikegen "soma/AMPA" {pyr2olm_conv} 0 {allow_repeats} {random_dest}		
		end
		
		conv_connect /bc_arr/bc /pyr_arr/pyr soma/spikegen "soma/GABA_A" {bc2pyr_conv} 0 {allow_repeats} {random_dest}
		conv_connect /bc_arr/bc /bc_arr/bc soma/spikegen "soma/GABA_A" {bc2bc_conv} 1 {allow_repeats} {random_dest}
		conv_connect /olm_arr/olm /pyr_arr/pyr soma/spikegen {{olm2pyr_compt} @ "/GABA_A_OLM"} {olm2pyr_conv} 0 {allow_repeats} {random_dest}		
		
		
		// Use convergence for MSG
		conv_connect /msg_arr/msg /bc_arr/bc soma/spikegen "soma/GABA_A_MS" {msg2bc_conv} 0 {allow_repeats} {random_dest}
		conv_connect /msg_arr/msg /olm_arr/olm soma/spikegen "soma/GABA_A_MS" {msg2olm_conv} 0 {allow_repeats} {random_dest}
		// Use divergence for MSG	--> Don't need to use divergence b/c we are disabling cells anyways
//		div_connect /msg_arr/msg /bc_arr/bc soma/spikegen "soma/GABA_A_MS" {msg2bc_div} 0 {allow_repeats} {random_dest}
//		div_connect /msg_arr/msg /olm_arr/olm soma/spikegen "soma/GABA_A_MS" {msg2olm_div} 0 {allow_repeats} {random_dest}
		
		conv_connect /msg_arr/msg /msg_arr/msg soma/spikegen "soma/GABA_A" {msg2msg_conv} 1 {allow_repeats} {random_dest}
		
		if (enable_olm2bc_synapse)
			conv_connect /olm_arr/olm /bc_arr/bc soma/spikegen {"soma/GABA_A_OLM"} {olm2bc_conv} 0 {allow_repeats} {random_dest}
		end
		conv_connect /olm_arr/olm /msg_arr/msg soma/spikegen {"soma/GABA_A_OLM"} {olm2msg_conv} 0 {allow_repeats} {random_dest}
	else
		str temp_syndestlist = {{pyr2pyr_compt} @ "/AMPA"}			// 1 -> is recurrent
//		conv_connect /pyr_arr/pyr /pyr_arr/pyr soma/pyr_spikegen {temp_syndestlist} {pyr2pyr_conv} 1 {allow_repeats} {random_dest}
//		conv_connect /pyr_arr/pyr /bc_arr/bc soma/pyr_spikegen "soma/AMPA" {pyr2bc_conv} 0 {allow_repeats} {random_dest}
//		conv_connect /pyr_arr/pyr /olm_arr/olm soma/pyr_spikegen "soma/AMPA" {pyr2olm_conv} 0 {allow_repeats} {random_dest}
//		conv_connect /bc_arr/bc /pyr_arr/pyr soma/spikegen "soma/GABA_A" {bc2pyr_conv} 0 {allow_repeats} {random_dest}
//		conv_connect /olm_arr/olm /pyr_arr/pyr soma/spikegen {{olm2pyr_compt} @ "/GABA_A_OLM"} {olm2pyr_conv} 0 {allow_repeats} {random_dest}
		conv_connect /bc_arr/bc /bc_arr/bc soma/spikegen "soma/GABA_A" {bc2bc_conv} 1 {allow_repeats} {random_dest}
		deletemsg /bc_arr/bc/soma/spikegen 0 -outgoing
	end

elif (test_bkgnd_syn & include_msg_aff_input)
	conv_connect /msg_arr/msg /bc_arr/bc soma/spikegen "soma/GABA_A_MS" {msg2bc_conv} 0 {allow_repeats} {random_dest}
	conv_connect /msg_arr/msg /olm_arr/olm soma/spikegen "soma/GABA_A_MS" {msg2olm_conv} 0 {allow_repeats} {random_dest}
	conv_connect /msg_arr/msg /msg_arr/msg soma/spikegen "soma/GABA_A" {msg2msg_conv} 1 {allow_repeats} {random_dest}
end

//====================================================
// delays
//====================================================



//volumedelay /bc_arr/bc[]/soma/spikegen -radial {cond_vel_int_ax}
//volumedelay /olm_arr/olm[]/soma/spikegen -radial {cond_vel_int_ax}
//volumedelay /msg_arr/msg[]/soma/spikegen -radial {cond_vel_int_ax}
//volumedelay /pyr_arr/pyr[]/soma/pyr_spikegen -radial {cond_vel_pyr_ax}


//volumedelay /bc_arr/bc[]/soma/spikegen -fixed 2e-3
//volumedelay /olm_arr/olm[]/soma/spikegen -fixed 2e-3
//volumedelay /msg_arr/msg[]/soma/spikegen -fixed 2e-3
//volumedelay /pyr_arr/pyr[]/soma/pyr_spikegen -fixed 2e-3


//
//// delay for excitation from pyramidal cells
//volumedelay {pyr_array_name}{pyr_cell_name}[]/ax/pyr_spikegen \
//		-radial {cond_vel_pyr_ax} \
//	        -uniform {rand_delay_pyr_ax}
//
//// delay for inhibition from fb interneurons
//volumedelay {fb_array_name}{fb_cell_name}[]/ax/spikegen \
//		-radial {cond_vel_fb_ax} \
//	        -uniform {rand_delay_fb_ax}
//
//
//// delay for inhibition from ff interneurons
//volumedelay {ff_array_name}{ff_cell_name}[]/ax/spikegen \
//		-radial {cond_vel_ff_ax} \
//	        -uniform {rand_delay_ff_ax}


//===============================================
// synaptic weights
//===============================================
//
//volumeweight /pyr_arr/pyr[]/soma/pyr_spikegen \
//	-fixed 1.0 \
//	-uniform 0.30
//
//
//
//// for synapses with pyramidal cells on presynaptic site
//volumeweight {pyr_array_name}{pyr_cell_name}[]/ax/pyr_spikegen \
//	-fixed {from_pyr_weight} \
//	-uniform {rand_from_pyr_weight}
//
//// for synapses with fb interneurons on presynaptic site
//volumeweight {fb_array_name}{fb_cell_name}[]/ax/spikegen \
//	-fixed {from_fb_weight} \
//	-uniform {rand_from_fb_weight}
//
//
//// for synapses with ff interneurons on presynaptic site
//volumeweight {ff_array_name}{ff_cell_name}[]/ax/spikegen \
//	-fixed {from_ff_weight} \
//	-uniform {rand_from_ff_weight} 
//
