
function add_synapse (source, dest)

	copy {source} {dest}
	ce {dest}	
	str added_synapse = {getfield . name}
	
	ce ..
	addmsg . ./{added_synapse} VOLTAGE Vm
	addmsg ./{added_synapse} . CHANNEL Gk Ek

end

function add_synapse_NMDA (source, dest)

	copy {source} {dest}
	ce {dest}	
	str added_synapse = {getfield . name}
	
	ce ..
	
	addmsg . ./{added_synapse}/Mg_BLOCK VOLTAGE Vm
	addmsg ./{added_synapse} ./{added_synapse}/Mg_BLOCK CHANNEL Gk Ek
	addmsg ./{added_synapse}/Mg_BLOCK . CHANNEL Gk Ek
	// Even though the channel current isn't used, CHECK expects this message
	addmsg . ./{added_synapse} VOLTAGE Vm

end

function add_spk_gen (source, dest)
		copy {source} {dest}
		ce {dest}	
		str added_synapse = {getfield . name}
		
		ce ..
		addmsg . ./{added_synapse} INPUT Vm
end


create neutral /prot
move /prot_msgaba /prot/msg
move /prot_b /prot/bc
move /prot_olm /prot/olm
move /prot_pyr /prot/pyr



create neutral /library_HN
pushe /library_HN

make_AMPA
make_NMDA
make_GABA_A
make_GABA_A_OLM
make_GABA_A_MS

make_pyr_spikegen
make_spikegen

pope

// Set injection currents
setfield /prot/pyr/soma inject {pyr_inject}
setfield /prot/bc/soma inject {bc_inject}
setfield /prot/olm/soma inject {olm_inject}
setfield /prot/msg/soma inject {msg_inject}

// Add spike generators
add_spk_gen /library_HN/pyr_spikegen /prot/pyr/soma/pyr_spikegen
add_spk_gen /library_HN/spikegen /prot/bc/soma/spikegen
add_spk_gen /library_HN/spikegen /prot/olm/soma/spikegen
add_spk_gen /library_HN/spikegen /prot/msg/soma/spikegen


// Add background synapses
add_synapse /library_HN/AMPA /prot/pyr/soma/AMPA_bk
setfield /prot/pyr/soma/AMPA_bk frequency {freq_bkgnd_pyr} gmax {Gmax_pyr_soma_AMPA}
	
add_synapse /library_HN/AMPA /prot/pyr/apical_19/AMPA_bk
setfield /prot/pyr/apical_19/AMPA_bk frequency {freq_bkgnd_pyr} gmax {Gmax_pyr_dend_AMPA}

add_synapse /library_HN/AMPA /prot/bc/soma/AMPA_bk
setfield /prot/bc/soma/AMPA_bk frequency {freq_bkgnd} gmax {Gmax_bc_soma_AMPA}

add_synapse /library_HN/AMPA /prot/olm/soma/AMPA_bk
setfield /prot/olm/soma/AMPA_bk frequency {freq_bkgnd_olm} gmax {Gmax_olm_soma_AMPA}
	
add_synapse /library_HN/GABA_A /prot/pyr/soma/GABA_A_bk
setfield /prot/pyr/soma/GABA_A_bk frequency {freq_bkgnd_pyr} gmax {Gmax_pyr_soma_GABA_A}

add_synapse /library_HN/GABA_A /prot/pyr/apical_19/GABA_A_bk
setfield /prot/pyr/apical_19/GABA_A_bk frequency {freq_bkgnd_pyr} gmax {Gmax_pyr_dend_GABA_A}
	
add_synapse /library_HN/GABA_A /prot/bc/soma/GABA_A_bk
setfield /prot/bc/soma/GABA_A_bk frequency {freq_bkgnd} gmax {Gmax_bc_soma_GABA_A}
	
add_synapse /library_HN/GABA_A /prot/olm/soma/GABA_A_bk
setfield /prot/olm/soma/GABA_A_bk frequency {freq_bkgnd_olm} gmax {Gmax_olm_soma_GABA_A}

if (include_NMDA)
	add_synapse_NMDA /library_HN/NMDA /prot/pyr/apical_19/NMDA_bk
	setfield /prot/pyr/apical_19/NMDA_bk frequency {freq_bkgnd_nmda_pyr} gmax {Gmax_pyr_dend_NMDA}
end


// Add main synapses
add_synapse /library_HN/AMPA /prot/pyr/{pyr2pyr_compt}/AMPA
setfield /prot/pyr/{pyr2pyr_compt}/AMPA gmax {pyr2pyr_AMPA}

add_synapse /library_HN/AMPA /prot/bc/soma/AMPA
setfield /prot/bc/soma/AMPA gmax {pyr2bc_AMPA}

add_synapse /library_HN/AMPA /prot/olm/soma/AMPA
setfield /prot/olm/soma/AMPA gmax {pyr2olm_AMPA}

add_synapse /library_HN/GABA_A /prot/pyr/soma/GABA_A
setfield /prot/pyr/soma/GABA_A gmax {bc2pyr_GABA_A}

add_synapse /library_HN/GABA_A /prot/bc/soma/GABA_A
setfield /prot/bc/soma/GABA_A gmax {bc2bc_GABA_A}

add_synapse /library_HN/GABA_A_OLM /prot/pyr/{olm2pyr_compt}/GABA_A_OLM
setfield /prot/pyr/{olm2pyr_compt}/GABA_A_OLM gmax {olm2pyr_GABA_A}

add_synapse /library_HN/GABA_A_OLM /prot/bc/soma/GABA_A_OLM
setfield /prot/bc/soma/GABA_A_OLM gmax {olm2bc_GABA_A}

add_synapse /library_HN/GABA_A_OLM /prot/msg/soma/GABA_A_OLM
setfield /prot/msg/soma/GABA_A_OLM gmax {olm2msg_GABA_A}

add_synapse /library_HN/GABA_A_MS /prot/bc/soma/GABA_A_MS
setfield /prot/bc/soma/GABA_A_MS gmax {msg2bc_GABA_A}

add_synapse /library_HN/GABA_A_MS /prot/olm/soma/GABA_A_MS
setfield /prot/olm/soma/GABA_A_MS gmax {msg2olm_GABA_A}

if (include_NMDA)
	add_synapse_NMDA /library_HN/NMDA /prot/pyr/{pyr2pyr_compt}/NMDA
	setfield /prot/pyr/{pyr2pyr_compt}/NMDA gmax {pyr2pyr_NMDA}
	
	add_synapse_NMDA /library_HN/NMDA /prot/bc/soma/NMDA
	setfield /prot/bc/soma/NMDA gmax {pyr2bc_NMDA}
	
	add_synapse_NMDA /library_HN/NMDA /prot/olm/soma/NMDA
	setfield /prot/olm/soma/NMDA gmax {pyr2olm_NMDA}
end

add_synapse /library_HN/GABA_A /prot/msg/soma/GABA_A
setfield /prot/msg/soma/GABA_A gmax {msg2msg_GABA_A}


// Cell arrays
create_array /pyr_arr /prot/pyr {pyr_nx} {pyr_ny} {pyr_dx} \
		 {pyr_dy} {pyr_origin_x} {pyr_origin_y}
create_array /olm_arr /prot/olm {olm_nx} {olm_ny} {olm_dx} {olm_dy} \
		 {olm_origin_x} {olm_origin_y}
create_array /bc_arr /prot/bc {bc_nx} {bc_ny} {bc_dx} {bc_dy} \
		 {bc_origin_x} {bc_origin_y}
create_array /msg_arr /prot/msg {msg_nx} {msg_ny} {msg_dx} {msg_dy} \
		 {msg_origin_x} {msg_origin_y}


// Disable prototypes
disable /prot

// Disable HN library now that synapses have been copied
disable /library_HN



