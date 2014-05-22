



function scalechannel (script_chan, scaleval)

	float currGbar
	str curr_chan
	foreach curr_chan (  {el {script_chan}[TYPE=tabchannel]} )
		currGbar = {getfield {curr_chan} Gbar}
		//echo Scaling tabchannel {curr_chan} to {{currGbar}*{scaleval}}
		setfield {curr_chan} Gbar {{currGbar}*{scaleval}}
	end
	foreach curr_chan (  {el {script_chan}[TYPE=vdep_channel]} )
		currGbar = {getfield {curr_chan} gbar}
		//echo Scaling vdep_channel {curr_chan} to {{currGbar}*{scaleval}}
		setfield {curr_chan} gbar {{currGbar}*{scaleval}}
	end
end


function scalepool (script_chan, scaleval)

	float currB
	str curr_chan
	foreach curr_chan (  {el {script_chan}[TYPE=Ca_concen]} )
		currB = {getfield {curr_chan} B}
		echo Scaling Ca_concen pool {curr_chan} to {{currB}*{scaleval}}
		setfield {curr_chan} B {{currB}*{scaleval}}
	end
end



// ------------------------ Circadian tweaks ------------------------



//////////////////////// SCN input on MS GABA cells ////////////////////////
// SCN input on Septal GABAergic cells
//See tweaks_constants.g


//////////////////////// Melatonin input ////////////////////////
//See tweaks_constants.g


//////////////////////// Acetylcholine input ////////////////////////
// Scale accommodation by modifying AHP channels
scalechannel /prot_pyr/#/K_AHP {ACh_accom_scale}

//////////////////////// Calcium input (Kole, Fuchs 2001) ////////////////////////
scalechannel /prot_pyr/#/Ca {Ca_val}
scalepool /prot_pyr/#/Ca_conc {1.0/{Ca_val}} 	// Counter-scale Ca pool to prevent motification of sAHP
//showfield pyr[]/#/Ca_conc B

// ------------------------ End Circadian tweaks ------------------------







