

//====================================================================
//Randomize various aspects of network
//====================================================================


randseed 12345
//randseed

// Randomize initial voltage
str curr_chan
float curr_variable
float r


// Randomize Vinit
foreach curr_chan ({el /pyr_arr/#[]/soma,/bc_arr/#[]/soma,/olm_arr/#[]/soma,/msg_arr/#[]/soma})
	curr_variable = {getfield {curr_chan} initVm}
	r = {rand {curr_variable-rand_Vinit} {curr_variable+rand_Vinit}}
	if (!test_synapses); setfield {curr_chan}/../# initVm {r}; end
end


// Randomize Em
foreach curr_chan ({el /pyr_arr/#[]/soma,/bc_arr/#[]/soma,/olm_arr/#[]/soma,/msg_arr/#[]/soma})
	curr_variable = {getfield {curr_chan} Em}
	r = {rand {curr_variable-rand_VEm} {curr_variable+rand_VEm}}
//	if (!test_synapses); setfield {curr_chan}/../# Em {r}; end
	
end


// Randomize injection current









//{el /pyr_arr/#/#[TYPE=symcompartment],/bc_arr/#/#[TYPE=compartment],/olm_arr/#/#[TYPE=compartment],/msg_arr/#/#[TYPE=compartment]}
//setfield {currchan} initVm {gaussian {curr_variable} {curr_variable*{1+rand_Vinit}}}
	
//	Test code to view new initVms
//foreach curr_chan ({el /pyr_arr/#[]/#,/bc_arr/#[]/soma,/olm_arr/#[]/soma,/msg_arr/#[]/soma})
//	echo showfield {curr_chan} initVm {getfield {curr_chan} initVm }
//end
//
//foreach curr_chan ({el /pyr_arr/#[]/#,/bc_arr/#[]/soma,/olm_arr/#[]/soma,/msg_arr/#[]/soma})
//	echo showfield {curr_chan} Em {getfield {curr_chan} Em }
//end





