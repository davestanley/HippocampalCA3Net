//genesis

/*****This script controls the output of the simulations
******
******Functions implemented followed by parameters:
******1, spike_rec_setup $SIM_TIME $OUTPUT_TYPE $NEURON_TYPE $SPIKE_TRAIN_NO
******2, spike_rec_save
******/

str recs=""				//string of names of tables containing
					//recordings

//*****Table for the spiketrains
create neutral /spktrns

//*****Raster diagram and/or spike train recording tool************************

function spike_rec_setup(time,sr,type,no)
float	time				//simulation time
int	no				//number of spike trains recorded
str	type				//type of neuron: olm
int	sr				//swich of output types: 1, raster;
					//2, spike tr; 3 raster + spike tr
str	cellp				//path to the neurons
str	compp				//path to the compartments
int	i,total
int	table_no = 0			//total number of allocated data tables
int res

str type_alias

ce /spktrns

//*****Here, elementpaths to specific neuron types can be set
if (type=="olm")
  type_alias="olm"
  cellp="/olm_arr/olm"
  compp="soma"
  total={n_of_olm}
  
elif (type=="bc")
  type_alias="b"
  cellp="/bc_arr/bc"
  compp="soma"
  total={n_of_bc}
  
elif (type=="msg")
  type_alias="msg"
  cellp="/msg_arr/msg"
  compp="soma"
  total={n_of_msg}
  
elif (type=="pyr")
  type_alias="psoma"
  cellp="/pyr_arr/pyr"
  compp="soma"
  total={n_of_pyr}
  
elif (type=="e90")
  type_alias="efield_arr"
  cellp="/e90"
  compp="rec_site"
  total={n_of_e90}
else
  echo "Misspecified NEURON_TYPE. Select from options int_olm, int_b or int_msg"
  return
end

//*****Tables for rasters
if (sr != 2)
  if (type=="bc")
    res=80
  else
    res=40
  end
  for (i = 0; i< {total}; i = i + 1)
    create table /spktrns/raster_{type_alias}{i+1}
    setfield ^ step_mode 4 stepsize -0.01
    call ^ TABCREATE {time * res} 0 {time * res}
    addmsg {cellp}[{i}]/{compp} ^ INPUT Vm
    recs = {strcat {recs} " "}
    recs = {strcat {recs} raster_{type_alias}{i+1}}
    if ({getarg {arglist {recs}} -count} > 990)
    	echo Overflow of "recs" variable imminent; end
  end
end

//*****Tables for spike trains
if (sr != 1)
  i=0
  while(i<{no})
    if (!{exists /spktrns/sptr_{type_alias}{i+1}})
    
      // davedit ------------------------ For saving electrode data ------------------------
      if (type=="e90")
	      create table /spktrns/sptr_{type_alias}{i+1}
	      setfield ^ step_mode 3 
	      useclock ^ 2
	      call ^ TABCREATE {{time}/{dt3}} 0 {time}
	      addmsg {cellp}/{compp}[{i}] /spktrns/sptr_{type_alias}{i+1} INPUT field
	      recs = {strcat {recs} " "}
	      recs = {strcat {recs} sptr_{type_alias}{i+1}}
		    if ({getarg {arglist {recs}} -count} > 990)
		    	echo Overflow of "recs" variable imminent; end
	      i=i+1
      else
      
	// end davedit ------------------------ For saving electrode data ------------------------
    
	      create table /spktrns/sptr_{type_alias}{i+1}
	      setfield ^ step_mode 3 
	      useclock ^ 1
	      call ^ TABCREATE {{time}/{dt2}} 0 {time}
	      addmsg {cellp}[{i}]/{compp} /spktrns/sptr_{type_alias}{i+1} INPUT Vm
	      recs = {strcat {recs} " "}
	      recs = {strcat {recs} sptr_{type_alias}{i+1}}
		    if ({getarg {arglist {recs}} -count} > 990)
		    	echo Overflow of "recs" variable imminent; end
	      
	      i=i+1
      end
      
    end
  end
end

ce /

end

//*****An argumentless function for writing data on disk***********************

function spike_rec_save
//str sp
int i
str tabname

//mkdir {gp}{pp}{sp}

for (i = 1; i <= {getarg {arglist {recs}} -count}; i = i + 1)
  tabname = {getarg {arglist {recs}} -arg {i}}
  tab2file {gp}{pp}{sp}/{tabname}.dat \
	/spktrns/{tabname} \
	table
  //delete /spktrns/{tabname}
end
recs = ""					//clearing record of records
if ({exists /output/extable[1]})
  tab2file {gp}{pp}{sp}/electrode.dat /output/extable[1] table
end
end
