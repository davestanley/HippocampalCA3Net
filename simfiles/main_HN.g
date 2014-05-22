


// Menne stuff
include network41.g // network functions and randomizations



// Hajos stuff!
int no_synapses = 0

// Make basket, olm, and msg cells from Hajos paper
include constants_HN.g
include prot_msgaba.g
include prot_b.g
include prot_olm.g
include prot_traub91.g
include output_dav.g
include electrodes_HN.g

include synapse_objects.g	// Create library of synaptic objects
include create_arrays_HN.g	// Add synaptic channels, create cell arrays

// Add synapses!
include connect_syn_functions.g	// Supporting functions
include connect_synapses.g

if (n_of_pyr > 1); spike_rec_setup {sim_time} 3 "pyr" {n_of_pyr}; end
if (n_of_olm > 1); spike_rec_setup {sim_time} 3 "olm" {n_of_olm}; end
if (n_of_bc > 1); spike_rec_setup {sim_time} 3 "bc" {n_of_bc}; end
if (n_of_msg > 1); spike_rec_setup {sim_time} 3 "msg" {n_of_msg}; end
if (n_of_e90 > 1); spike_rec_setup {sim_time} 2 "e90" {n_of_e90}; end


check  // only issues warnings that compartments taken over by hsolve would
         // not get issued for simulation
reset


//str loop_chan
//foreach loop_chan ( {el /pyr/#/AMPA,/pyr/#/NMDA,/pyr/#/GABA_A,/pyr/#/GABA_B} )
//	disable {loop_chan}
//end


//include connection_stats.g
include plot_graphics.g

//plot_graphics "/pyr_array/pyr[]" "/form"
//plot_graphics "/fb_array/fb[]" "/form2"
//plot_graphics "/ff_array/ff[]" "/form3"
//addmsg /prot/pyr/soma /form2wave/Vm  PLOT Vm *PYR *blue
//addmsg /prot/b/soma /form2wave/Vm  PLOT Vm *BC *red
//addmsg /prot/olm/soma /form2wave/Vm  PLOT Vm *OLM *green
//addmsg /prot/msgaba/soma /form2wave/Vm  PLOT Vm *MSG *yellow

plot_graphics "/pyr_arr/pyr[]" "/form4"
plot_graphics "/bc_arr/bc[]" "/form5"
plot_graphics "/olm_arr/olm[]" "/form6"
plot_graphics "/msg_arr/msg[]" "/form7"


include write_everything_totals
//plot_graphs "/prot/pyr/soma" "/graphs1" "deleteme1" 1 1
//plot_graphs "/prot/bc/soma" "/graphs2" "deleteme2" 1 1
//plot_graphs "/prot/olm/soma" "/graphs3" "deleteme3" 1 1
//plot_graphs "/prot/msg/soma" "/graphs4" "deleteme4" 1 1
//plot_graphs "/prot/pyr/apical_19" "/graphs5" "deleteme5" 1 1

//plot_graphs "/pyr_arr/pyr/soma" "/graphs1" "deleteme1" 1 1
//plot_graphs "/bc_arr/bc/soma" "/graphs2" "deleteme2" 1 1
//plot_graphs "/olm_arr/olm/soma" "/graphs3" "deleteme3" 1 1
//plot_graphs "/msg_arr/msg/soma" "/graphs4" "deleteme4" 1 1
//plot_graphs "/pyr_arr/pyr/apical_19" "/graphs5" "deleteme5" 1 1

reset
reset


step {sim_time} -t
spike_rec_save





