

// ############# Like write_everything.g, except
// ############# display the total current from all
// ############# compartments, rather than just the
// ############# present compartment
// ## Dave Stanley Feb 10 2010


int scriptmode=7
int plot_HPo_channel=0
int show_calcium = 0

	//Called by plot_graphs
	//Writes Vm to graph and to file
function write_Vm (source, dest_plot, dest_save, graphics_on)
str diffampname = {{source} @ "/../soma/diffamp" @ {countelementlist {source}/../soma/#[TYPE=diffamp]}} // Create name & number for diffamp
str dest_info = {"." @ {dest_save} @ "_info"}

	openfile {dest_info} w

	create diffamp {diffampname}
	setfield {diffampname} plus 0 minus 0 gain 1000 saturation inf		// Convert V to mV

	if (scriptmode == 7)
//		addmsg {source}/../soma {diffampname} PLUS Vm
		addmsg {source} {diffampname} PLUS Vm
	else
		addmsg {source} {diffampname} PLUS Vm
	end
	if (graphics_on); addmsg {diffampname} {{dest_plot} @ "/Vm"} PLOT output *Vm  *blue; end
	addmsg {diffampname} {dest_save} SAVE output

end



function write_everything (source, dest_plot, dest_save, pfield, graphics_on, sum_currents)
	str curr_chan
	int col = 15
	str dest_info = {"." @ {dest_save} @ "_info"}
	
	
	
	openfile {dest_info} w
	
	xcolorscale hot
	
	
	
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Enter calculator (sum) mode #########################################
	if (sum_currents == 1)
		str curr_chan_name
		str calc_path
		foreach curr_chan ({el {source}/../#/#[TYPE=GENvgpores]} {el {source}/../#/#[TYPE=GENVhalf]} {el {source}/../#/#[TYPE=GENtabchan]} \
						{el {source}/../#/#[TYPE=tabchannel]} {el {source}/../#/#[TYPE=vdep_channel]} {el {source}/../#/#[TYPE=GENsynpores]})
			
			curr_chan_name = {getfield {curr_chan} name}
			calc_path = {{curr_chan} @ "/../.."}
		//	echo {calc_path}
			
		
			if ({curr_chan_name} == "K_AHPs_m")
				curr_chan_name = "K_AHP_m"
			end
			if ({curr_chan_name} == "K_Cs_m")
				curr_chan_name = "K_C_m"
			end
			if ({curr_chan_name} == "K_AHPs")
				curr_chan_name = "K_AHP"
			end
			if ({curr_chan_name} == "K_Cs")
				curr_chan_name = "K_C"
			end
			if ({curr_chan_name} == "NaA")
				curr_chan_name = "Na"
			end
			if ({curr_chan_name} == "K_DRA")
				curr_chan_name = "K_DR"
			end
			
			if ( !({exists {calc_path}/sum_{curr_chan_name}}) )
				create calculator {calc_path}/sum_{curr_chan_name}
				setfield {calc_path}/sum_{curr_chan_name} resetclock 0
				addfield {calc_path}/sum_{curr_chan_name} channel_name
				setfield {calc_path}/sum_{curr_chan_name} channel_name {curr_chan_name}
			end
		
			addmsg {curr_chan} {calc_path}/sum_{curr_chan_name} SUM {pfield}k
			
		end
		
				// Adds messages from "pooled" channel and Ca_concen objects
		foreach curr_chan ({el {source}/../#/#[TYPE=calculator],{source}/../#/volweighted_Ca#[TYPE=diffamp]})
			curr_chan_name = {getfield {curr_chan} name}
			calc_path = {{curr_chan} @ "/../.."}
		//	echo {calc_path}
			
			if ( !({exists {calc_path}/sum_{curr_chan_name}}) )
				create calculator {calc_path}/sum_{curr_chan_name}
				setfield {calc_path}/sum_{curr_chan_name} resetclock 0
				addfield {calc_path}/sum_{curr_chan_name} channel_name
				setfield {calc_path}/sum_{curr_chan_name} channel_name {curr_chan_name}
			end
			addmsg {curr_chan} {calc_path}/sum_{curr_chan_name} SUM output
		end

		// Look after High Open Probability stuff for SK2 channels - get average
		if ( plot_HPo_channel )
			create neutral {source}/../HPo_stuff
			foreach curr_chan ({el {source}/../sum_HPo#[TYPE=calculator]})
				move {curr_chan} {source}/../HPo_stuff
			end		

			float total_Gk = 0
			foreach curr_chan ({el /pyr_array/pyr/#/allpools/#/HPo#})
				if ( {getfield {curr_chan} name} == "HPo_SK2" )
					total_Gk = {getfield {curr_chan} Gbar} + total_Gk
				elif ( {getfield {curr_chan} name} == "HPo_SK2_m" )
					total_Gk = {getfield {curr_chan} Nt}*{10.0*{onepS}} + total_Gk
				end
			end
			
			if ( !({exists {source}/../HPo_norm}) )
				create diffamp {source}/../HPo_norm
				setfield ^ gain {1.0/total_Gk} saturation 999
				addfield ^ channel_name
				setfield ^ channel_name {getfield {source}/../HPo_stuff/sum_HPo_allpools channel_name}
				addmsg {source}/../HPo_stuff/sum_HPo_allpools {source}/../HPo_norm PLUS output
			end
		end

		//	%%%%% Add calculator object messages 
		foreach curr_chan ({el {source}/../#[TYPE=calculator],{source}/../#[TYPE=diffamp]})
			//echo  calculator currentchannel {curr_chan}
			if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT output *sum_{getfield {curr_chan} channel_name} *{col}; end
			addmsg {curr_chan} {dest_save} SAVE output
			writefile {dest_info} {curr_chan}
			col = col + 7
			if (col > 63)
			        col = col - 60
			end
		end
		
	// ############################# End calculator mode %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	elif (sum_currents == 0)	
	/// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Regular Mode %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
		foreach curr_chan ({el {source}/#[TYPE=GENvgpores]} {el {source}/#[TYPE=GENVhalf]} {el {source}/#[TYPE=GENsynpores]} {el {source}/#[TYPE=GENtabchan]})
			if ( {getfield {curr_chan} originalchannel} == "GABA_B" )
				if ( {getfield {curr_chan} mode} == "regular" )
					if (graphics_on) 
						addmsg {curr_chan}/G_protein {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}
						addmsg {curr_chan}/K_pore {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}
						//addmsg {curr_chan}/G_protein {{dest_plot} @ "/Ik"} PLOT Gconcs *{getfield {curr_chan} name}  *{col}
					end
		
		
					//addmsg {curr_chan}/G_protein {dest_save} SAVE {pfield}k
					addmsg {curr_chan}/K_pore {dest_save} SAVE {pfield}k
				else
					if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}; end
					addmsg {curr_chan} {dest_save} SAVE {pfield}k
				end
			else
				if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}; end
				addmsg {curr_chan} {dest_save} SAVE {pfield}k
			end
			writefile {dest_info} {curr_chan}
			col = col + 7
			if (col > 63)
			        col = col - 60
			end
		end
	
		
		
		foreach curr_chan ({el {source}/#[TYPE=tabchannel]} {el {source}/#[TYPE=vdep_channel]})
			if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name} *{col}; end
			addmsg {curr_chan} {dest_save} SAVE {pfield}k
			writefile {dest_info} {curr_chan}
			col = col + 7
			if (col > 63)
			        col = col - 60
			end
		end
		
		foreach curr_chan ({el {source}/#[TYPE=calculator],{source}/Ca#[TYPE=diffamp]})
			if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT output *{getfield {curr_chan} name} *{col}; end
			addmsg {curr_chan} {dest_save} SAVE output
			writefile {dest_info} {curr_chan}
			col = col + 7
			if (col > 63)
			        col = col - 60
			end
		end
		
	// ############################# End regular mode %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	elif (sum_currents == -1)
	// ############################# Single pool mode %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
		foreach curr_chan ({el {source}/#[TYPE=GENvgpores]} {el {source}/#[TYPE=GENVhalf]} {el {source}/#[TYPE=GENsynpores]} {el {source}/#[TYPE=GENtabchan]})
			if ( {getfield {curr_chan} originalchannel} == "GABA_B" )
				if ( {getfield {curr_chan} mode} == "regular" )
					if (graphics_on) 
						addmsg {curr_chan}/G_protein {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}
						addmsg {curr_chan}/K_pore {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}
						//addmsg {curr_chan}/G_protein {{dest_plot} @ "/Ik"} PLOT Gconcs *{getfield {curr_chan} name}  *{col}
					end
		
		
					//addmsg {curr_chan}/G_protein {dest_save} SAVE {pfield}k
					addmsg {curr_chan}/K_pore {dest_save} SAVE {pfield}k
				else
					if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}; end
					addmsg {curr_chan} {dest_save} SAVE {pfield}k
				end
			else
				if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}; end
				addmsg {curr_chan} {dest_save} SAVE {pfield}k
			end
			writefile {dest_info} {curr_chan}
			col = col + 7
			if (col > 63)
			        col = col - 60
			end
		end
	
		
		
		foreach curr_chan ({el {source}/#[TYPE=tabchannel]} {el {source}/#[TYPE=vdep_channel]})
			if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name} *{col}; end
			addmsg {curr_chan} {dest_save} SAVE {pfield}k
			writefile {dest_info} {curr_chan}
			col = col + 7
			if (col > 63)
			        col = col - 60
			end
		end
		
		
		// Add single pool currents
		foreach curr_chan ({el {source}/allpools/Capool_1/#[TYPE=GENvgpores]} {el {source}/allpools/Capool_1/#[TYPE=GENVhalf]} {el {source}/allpools/Capool_1/#[TYPE=GENsynpores]} {el {source}/allpools/Capool_1/#[TYPE=GENtabchan]})
			if ( {getfield {curr_chan} originalchannel} == "GABA_B" )
				if ( {getfield {curr_chan} mode} == "regular" )
					if (graphics_on) 
						addmsg {curr_chan}/G_protein {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}
						addmsg {curr_chan}/K_pore {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}
						//addmsg {curr_chan}/G_protein {{dest_plot} @ "/Ik"} PLOT Gconcs *{getfield {curr_chan} name}  *{col}
					end
		
		
					//addmsg {curr_chan}/G_protein {dest_save} SAVE {pfield}k
					addmsg {curr_chan}/K_pore {dest_save} SAVE {pfield}k
				else
					if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}; end
					addmsg {curr_chan} {dest_save} SAVE {pfield}k
				end
			else
				if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}; end
				addmsg {curr_chan} {dest_save} SAVE {pfield}k
			end
			writefile {dest_info} {curr_chan}
			col = col + 7
			if (col > 63)
			        col = col - 60
			end
		end
		
		foreach curr_chan ({el {source}/allpools/Capool_1/#[TYPE=tabchannel]} {el {source}/allpools/Capool_1/#[TYPE=vdep_channel]})
			if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name} *{col}; end
			addmsg {curr_chan} {dest_save} SAVE {pfield}k
			writefile {dest_info} {curr_chan}
			col = col + 7
			if (col > 63)
			        col = col - 60
			end
		end
		
		foreach curr_chan ({el {source}/allpools/Capool_1/#[TYPE=Ca_concen]})
			if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT Ca *{getfield {curr_chan} name} *{col}; end
			addmsg {curr_chan} {dest_save} SAVE Ca
			writefile {dest_info} {curr_chan}
			col = col + 7
			if (col > 63)
			        col = col - 60
			end
		end
		
		foreach curr_chan ({el {source}/allpools/Capool_1/#[TYPE=difshell]})
			if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT C *{getfield {curr_chan} name} *{col}; end
			addmsg {curr_chan} {dest_save} SAVE C
			writefile {dest_info} {curr_chan}
			col = col + 7
			if (col > 63)
			        col = col - 60
			end
		end
		
	// ############################# End single pool mode %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	end
	
	
	
	create diffamp {source}/sum_synapses
	setfield ^ gain 1 saturation Inf minus 0
	int num_channels = 0
	foreach curr_chan ({el {source}/#[TYPE=GENsynpores]})
		num_channels = num_channels + 1
		addmsg {curr_chan} {source}/sum_synapses PLUS {pfield}k
	end
	if (num_channels > 0)
	//	if (graphics_on); addmsg {source}/sum_synapses {{dest_plot} @ "/Ik"} PLOT output *{"sum" @ {getfield {curr_chan} name}}  *{col}; end
		//addmsg {source}/sum_synapses {dest_save} SAVE output
		//writefile {dest_info} "tot_synaptic_activity"
		col = col + 7
		if (col > 63)
			col = col - 60
		end
	end
	
	
	
	foreach curr_chan ({el {source}/#[TYPE=GENgap]})
		echo addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}
		if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name}  *{col}; end
		addmsg {curr_chan} {dest_save} SAVE {pfield}k
		writefile {dest_info} {curr_chan}
	
		//create xform /form			//display voltage comparison
		//create xgraph /form/graph
		//xshow /form
		//addmsg {curr_chan} /form/graph PLOT Vk *Vk *blue
		//addmsg {curr_chan} /form/graph PLOT Vk2 *Vk2 *red
		col = col + 7
		if (col > 63)
		        col = col - 60
		end
	end
	
	
	
	
	
	foreach curr_chan ( {el {source}/#[TYPE=synchan2]} )
		if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name} *{col}; end
		addmsg {curr_chan} {dest_save} SAVE {pfield}k
		writefile {dest_info} {curr_chan}
		col = col + 7
		if (col > 63)
		        col = col - 60
		end
	end
	
	// For NaCa Pump
	foreach curr_chan ({el {source}/#[TYPE=tabcurrent]})
		if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT {pfield}k *{getfield {curr_chan} name} *{col}; end
		addmsg {curr_chan} {dest_save} SAVE {pfield}k
		writefile {dest_info} {curr_chan}
		col = col + 7
		if (col > 63)
		        col = col - 60
		end
	end
	
	if (show_calcium)
		foreach curr_chan ({el {source}/#[TYPE=Ca_concen]})
			if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT Ca *{getfield {curr_chan} name} *{col}; end
			addmsg {curr_chan} {dest_save} SAVE C
			writefile {dest_info} {curr_chan}
			col = col + 7
			if (col > 63)
			        col = col - 60
			end
		end
	end
	
	
	foreach curr_chan ({el {source}/#[TYPE=difshell]})
		if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT C *{getfield {curr_chan} name} *{col}; end
		addmsg {curr_chan} {dest_save} SAVE C
		writefile {dest_info} {curr_chan}
		col = col + 7
		if (col > 63)
		        col = col - 60
		end
	end
	
	
	foreach curr_chan ({el {source}/../soma/#[TYPE=PID]})
		if (graphics_on); addmsg {curr_chan} {{dest_plot} @ "/Ik"} PLOT output *PID *{col}; end
		addmsg {curr_chan} {dest_save} SAVE output
		writefile {dest_info} {curr_chan}
		col = col + 7
		if (col > 63)
		        col = col - 60
		end
	end
	
	
	
	// Include soma current
	//addmsg {source}/../soma {{dest_plot} @ "/Ik"} PLOT Im *{getfield {source}/../soma name} *{col}
	//addmsg {source}/../soma {dest_save} SAVE Im
	//writefile {dest_info} "soma current"
	
	
	
	
	closefile {dest_info}

end


function plot_graphs (src_path, graph_name, file_name, graphics_on, sum_currents)

	if (graphics_on)
		create xform {graph_name} [10,10,900,350] -notitle
		create xlabel {graph_name}/label [10,0,98%,25] -label {src_path}
		create xgraph {graph_name}/Vm [10,10:label.bottom,50%,90%] -title \
		    "membrane potential"
		setfield {graph_name}/Vm XUnits "t (sec)" YUnits "voltage (V)"
		setfield {graph_name}/Vm xmax 0.03 ymin -150 ymax 40
		useclock {graph_name}/Vm 1
		create xgraph {graph_name}/Ik [10:Vm.right,10:label.bottom,49%,90%]  \
		    -title "channel current"
		setfield {graph_name}/Ik XUnits "t (sec)" YUnits "current (S)"
		setfield {graph_name}/Ik xmax 0.03 ymin -1e-7 ymax 9e-7
		useclock {graph_name}/Ik 1
		xshow {graph_name}
	end
	
		create asc_file {file_name}
		setfield ^  flush 0 leave_open 1 append 0 notime 0 float_format %0.12g
		useclock ^ 1


	write_Vm {src_path} {graph_name} {file_name} {graphics_on}
	write_everything {src_path} {graph_name} {file_name} I {graphics_on} {sum_currents}

end


