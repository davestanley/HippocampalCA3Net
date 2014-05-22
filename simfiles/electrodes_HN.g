// genesis 2.2
// Kerstin Menne
// Luebeck, 24.10.2001

/*====================================
functions to create recording sites
====================================*/

// create single efield object
function place_recsite(recording_site_name, x, y, z, scale)
        str recording_site_name 
        float x, y, z // positions of recording_site
	float scale // scale factor for efield object
       
        create efield {recording_site_name}
        setfield ^ scale {scale} x {x} y {y} z {z}

        // call {recording_site_name} RECALC // calculate distances
	// input_for_electrodes does it now
end

// create one multisite-electrode
function electrode(electrode_name,recording_site,x,y,zmin,zmax,dz,scale)
	str electrode_name, recording_site 
 	float scale, x, y
	float zmin, zmax, dz // recording sites from zmin to zmax with distance
			     // dz (parallel to neurons)
        float i // help variables
        int count = 0

	if (!({exists {electrode_name}}))
         	create neutral {electrode_name}
        end
	// different recordings sites of electrode "electrode_name" 
	// are installed and 
	// named {electrode_name}{recording_site}[{count}]
	for (i=zmin; i<=zmax; i=i+dz)
        	place_recsite {electrode_name}{recording_site}[{count}] \
				{x} {y} {i} {scale} 
                count = count +1
        end
end


function dave_electrode(electrode_name,recsite_name)
	str electrode_name
	str recsite_name

	pushe {electrode_name}

	str loop_chan
	foreach loop_chan ({el /pyr_arr/pyr[]/#[TYPE=symcompartment]})
		addmsg {loop_chan} {electrode_name}{recsite_name}[] CURRENT Im 0.0
	end
	
	call {electrode_name}{recsite_name}[] RECALC // calculate
	//distances to
	//compartments that deliver input

	pope 	
		
end




electrode /e90  {e_recsite1} 43e-6 57e-6 \
		{e_z1_min} {e_z1_max} {e_dz1} {e_scale1}

dave_electrode /e90 {e_recsite1} // electrodes.g



