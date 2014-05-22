
// PID function including both original and new clamping styles
// Optional save to file -- set filename to "nosave" to avoid saving

function PID_thresh (location, settle, duration, value, reset_trick, graphics_on, fastclamp, file_name)

float dt = { getclock 0 }
str curr_chan
str local
float original_Em


foreach local ({el {location}})
	
	create PID {local}/pid
	setfield {local}/pid cmd {value} gain {1*{getfield {local} Cm}/{dt}}  tau_d {{dt}/40}  tau_i {{dt}*1e2} saturation 1e-4
	if (fastclamp)
		setfield {local}/pid cmd {value} gain 0.25e-6  tau_d {{dt}/4}  tau_i {{dt}} saturation 1e-4
	end
	addmsg {local} {local}/pid SNS Vm
	addmsg {local}/pid {local} INJECT output



	create compartment {local}/integral
	setfield {local}/integral Vm 0 Em 0 Cm 1 Rm {{duration}*1000}	// Make sure decay constant is 10 times duration (very low)
	addmsg {local}/pid {local}/integral INJECT output		// This will integrate the total output
end


// // Plotting
//create xform /formpid
//create xgraph /formpid/graph
//addmsg {local}/pid /formpid/graph PLOT output *value *blue
//addmsg {local}/integral /formpid/graph PLOT Vm *integral *red
//xshow /formpid


// Write to file
if ( file_name != "nosave" )
	create asc_file {file_name}
	setfield ^  flush 0 leave_open 1 append 0 notime 0 float_format %0.10g filename {dataoutput_path}{file_name}
	useclock ^ 1
	addmsg {local}/pid {file_name} SAVE output
end

//Plotting		// Adds a line to the exisitng "graphs1/Ik" plotting forum
if (graphics_on == 1)
	str dest_plot = "/graphs1"
	addmsg {local}/pid {{dest_plot} @ "/Ik"} PLOT output *PID *red
end



if ( reset_trick )			// Generally good not to use this, since
					// it produces an unexplainable kink in the
					// output.... (probably a bug)
	setfield /#/#/#[TYPE=compartment] Em {value}
	reset
	reset	// Get channels into correct equilibrium state
	setfield /#/#/#[TYPE=compartment] Em -0.060 Vm {value}

	//From looking at the Im plot, it appears that this
	//kink is caused by some abrupt change in the axial
	//current, possibly caused by a discontinuity in a
	//dendrite upstream of the soma (integrator problem)

else
	reset
	reset
end



step {round { {settle}/{dt} }}
foreach local ({el {location}})
	setfield {local}/integral Vm 0
end
step {round { {duration}/{dt} }}


foreach local ({el {location}})
	echo setfield {local} inject {{getfield {local}/integral Vm} / {duration}}
	echo Current PID value: {getfield {local}/pid output}

	setfield {local} inject {{getfield {local}/integral Vm} / {duration}}
//	setfield /fb_array/fb[1]/soma inject {{getfield {local}/integral Vm} / {duration}}
	//setfield {local} inject {getfield {local}/pid output}
//	if (!ploton)
		delete {local}/pid
		delete {local}/integral
//	end
end


//reset
//reset

end
