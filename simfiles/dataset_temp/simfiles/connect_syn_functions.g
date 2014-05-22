

//////////////////////////////
// Convergent connections
//////////////////////////////


function make_connection (source, dest)
	//echo adding synapse addmsg {source} {dest} SPIKE
	addmsg {source} {dest} SPIKE
end

function conv_cell (source, dest, spikesource, syndest, conv, is_recurrent, allow_repeats, random_dest, dest_num, num_source)

	int i, j, r, t
	int N_syndest
	str selected_syndest

	// Set up convergence table
	create table /syntable
	call /syntable TABCREATE {{conv}-1} 0 1	// Creates a table with conv entries
	for (i=0; i<{conv}; i=i+1)
		setfield /syntable table->table[{i}] 0
	end
	
	j=0
	t=1
	while (j < conv)
		r = {rand 0 {num_source + 0.9 - 1}}		// Random number between 0 and "num_source - 1"
		// echo Proposed connection: source->{r} dest->{dest_num}
		
		if (is_recurrent)
			if (r == dest_num)
				t=0	//if is recurrent network, don't want neuron k to synapse onto itself
				// echo Self synapse! Skipping
			end
		end
		
		if ({!allow_repeats})
			for (i=0; i<{j}; i=i+1)
				if({getfield /syntable table->table[{i}]} == r)		// Check to see if the value is already taken
					t=0	// if it's already taken, don't add to list
					// echo Already taken! Skipping
				end
			end
		end
		
		if (t == 1)
			setfield /syntable table->table[{j}] {r}		// If all is well, add synapse to the list
    		j = j+1
    		// echo All's well, adding
	    end
	    t = 1

	end
	
	for (i=0;i<{conv};i=i+1)
		N_syndest = {getarg {arglist {syndest}} -count}


		if (random_dest)
			r = {rand 1 {N_syndest + 0.9}}		// Random number between 1 and "N_syndest"
			selected_syndest = {getarg {arglist {syndest}} -arg {r}}
			echo selected_syndest = {getarg {arglist {syndest}} -arg {r}}
			make_connection {source}[{getfield /syntable table->table[{i}]}]/{spikesource} {dest}[{dest_num}]/{selected_syndest}
		else
			for (j=1;j<={N_syndest};j=j+1)
				selected_syndest = {getarg {arglist {syndest}} -arg {j}}
				make_connection {source}[{getfield /syntable table->table[{i}]}]/{spikesource} {dest}[{dest_num}]/{selected_syndest}
			end
		end
	end

	delete /syntable
end




function conv_connect (source, dest, spikesource, syndest, conv, is_recurrent, allow_repeats, random_dest)

	// is_recurrent - if 1, network is recurrent (i.e. pyr2pyr) and therefore a synapse from neuron X -> neuron Y is only allowed if X≠Y
	// allow_repeats - if 1, neuron X can synapse to neuron Y more than once. Useful for smaller networks
	// random_dest - if 1, syndest is an argument list, likely containing multiple synapse locations on dendritic tree.
	//				when calculating convergences, a random destination synapse will be chosen.		
	//			   - if 0, then the source synapse will send SPIKE messages to all destination synapses in the syndest arglist
	//					--> this is useful for pairing AMPA and NMDA synapses

	int k, num_source, num_dest
	str name
	
	// Count number of source and dest compartments
	k=0
	foreach name ({el {source}[]}); k = k + 1; end
	num_source = {k}
	k=0
	foreach name ({el {dest}[]}); k = k + 1; end
	num_dest = {k}
	
	if (!allow_repeats)
		if (is_recurrent)
			if ({conv} > {num_source - 1})
				echo Warning: convergence is greater than number of available source cells.
				echo Allowing repeats for recurrent network.
				allow_repeats = 1
			end
		else
			if (conv > num_source)
				echo Warning: convergence is greater than number of available source cells.
				echo Allowing repeats.
				allow_repeats = 1
			end
		end
	end
	
	if (is_recurrent)
		if (num_source <= 1)
			echo Only one source element - cannot form recurrent network
			return
		end
	end
	
	
	// For each destination cell, add the number "conv" presynaptic connections
	for (k=0; k<num_dest; k=k+1)
		conv_cell {source} {dest} {spikesource} {syndest} {conv} {is_recurrent} {allow_repeats} {random_dest} {k} {num_source}
	end

end














//////////////////////////////
// Divergent connections
//////////////////////////////



function make_connection_div (dest, source)
	//echo adding divergent synapse addmsg {source} {dest} SPIKE
	addmsg {source} {dest} SPIKE
end

function div_cell (dest, source, syndest, spikesource, div, is_recurrent, allow_repeats, random_source, source_num, num_dest)

	int i, j, r, t
	int N_spikesource
	str selected_spikesource

	// Set up divergence table
	create table /syntable
	call /syntable TABCREATE {{div}-1} 0 1	// Creates a table with div entries
	for (i=0; i<{div}; i=i+1)
		setfield /syntable table->table[{i}] 0
	end
	
	j=0
	t=1
	while (j < div)
		r = {rand 0 {num_dest + 0.9 - 1}}		// Random number between 0 and "num_dest - 1"
		// echo Proposed connection: dest->{r} source->{source_num}
		
		if (is_recurrent)
			if (r == source_num)
				t=0	//if is recurrent network, don't want neuron k to synapse onto itself
				// echo Self synapse! Skipping
			end
		end
		
		if ({!allow_repeats})
			for (i=0; i<{j}; i=i+1)
				if({getfield /syntable table->table[{i}]} == r)		// Check to see if the value is already taken
					t=0	// if it's already taken, don't add to list
					// echo Already taken! Skipping
				end
			end
		end
		
		if (t == 1)
			setfield /syntable table->table[{j}] {r}		// If all is well, add synapse to the list
    		j = j+1
    		// echo All's well, adding
	    end
	    t = 1

	end
	
	for (i=0;i<{div};i=i+1)
		N_spikesource = {getarg {arglist {spikesource}} -count}


		if (random_source)
			r = {rand 1 {N_spikesource + 0.9}}		// Random number between 1 and "N_spikesource"
			selected_spikesource = {getarg {arglist {spikesource}} -arg {r}}
			echo selected_spikesource = {getarg {arglist {spikesource}} -arg {r}}
			make_connection_div {dest}[{getfield /syntable table->table[{i}]}]/{syndest} {source}[{source_num}]/{selected_spikesource}
		else
			for (j=1;j<={N_spikesource};j=j+1)
				selected_spikesource = {getarg {arglist {spikesource}} -arg {j}}
				make_connection_div {dest}[{getfield /syntable table->table[{i}]}]/{syndest} {source}[{source_num}]/{selected_spikesource}
			end
		end
	end

	delete /syntable
end



function div_connect (source, dest, spikesource, syndest, div, is_recurrent, allow_repeats, random_source)
	// is_recurrent - if 1, network is recurrent (i.e. pyr2pyr) and therefore a synapse from neuron X -> neuron Y is only allowed if X≠Y
	// allow_repeats - if 1, neuron X can synapse to neuron Y more than once. Useful for smaller networks
	// random_source - if 1, spikesource is an argument list, likely containing multiple synapse locations on dendritic tree.
	//				when calculating divergences, a random sourceination synapse will be chosen.		
	//			   - if 0, then the dest synapse will send SPIKE messages to all sourceination synapses in the spikesource arglist
	//					--> this is useful for pairing AMPA and NMDA synapses

	int k, num_dest, num_source
	str name
	
	// Count number of dest and source compartments
	k=0
	foreach name ({el {dest}[]}); k = k + 1; end
	num_dest = {k}
	k=0
	foreach name ({el {source}[]}); k = k + 1; end
	num_source = {k}
	
	if (!allow_repeats)
		if (is_recurrent)
			if ({div} > {num_dest - 1})
				echo Warning: divergence is greater than number of available dest cells.
				echo Allowing repeats for recurrent network.
				allow_repeats = 1
			end
		else
			if (div > num_dest)
				echo Warning: divergence is greater than number of available dest cells.
				echo Allowing repeats.
				allow_repeats = 1
			end
		end
	end
	
	if (is_recurrent)
		if (num_dest <= 1)
			echo Only one dest element - cannot form recurrent network
			return
		end
	end
	
	
	// For each source cell, add the number "div" postsynaptic connections
	for (k=0; k<num_source; k=k+1)
		div_cell {dest} {source} {syndest} {spikesource} {div} {is_recurrent} {allow_repeats} {random_source} {k} {num_dest}
	end

end

