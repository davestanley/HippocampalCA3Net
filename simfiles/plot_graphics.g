


//str loop_chan
//create neutral /temp
//foreach loop_chan ( {el /pyr_array/pyr[] })
//	//echo {loop_chan}
//	create neutral /temp{strsub {loop_chan} /pyr_array/ /}
//	move {loop_chan}/soma /temp{strsub {loop_chan} /pyr_array/ /}/
//end


function plot_graphics (plot_path, graph_name)

//str plot_path = "/pyr_array/pyr[]"
//str graph_name = "/waveform"

float yoffset_val = 0.010
yoffset_val = 0.000
int max_num_plots = 50

if (test_synapses)
	yoffset_val = 0.0
end

int gui3d = 0
if (gui3d)
	create xform {graph_name}cells [430,10,400,400]
	    create xdraw {graph_name}cells/draw [0,0,100%,100%]
	    setfield {graph_name}cells/draw xmin -0.5e-4 xmax 1e-4 ymin -0.5e-4 ymax 2e-4 \
	        zmin -0.5e-4 zmax 1e-4 \
	        transform z
	    xshow {graph_name}cells
	    echo creating xcell
	    create xcell {graph_name}cells/draw/cell
	
	//	Plot all compartments
	    setfield {graph_name}cells/draw/cell colmin -0.1 colmax 0.1 \
	        path {plot_path}/##[TYPE=compartment] field Vm \
	        script "echo <w> <v>"
	
	
	//	Plot all compartments subthreshold
	//    setfield {graph_name}cells/draw/cell colmin -0.070 colmax -0.060 \
	//        path {plot_path}/##[TYPE=compartment] field Vm \
	//        script "echo <w> <v>"
	//
	//	Plot only somas
	//    setfield {graph_name}cells/draw/cell colmin -0.1 colmax 0.1 \
	//        path {plot_path}/soma field Vm \
	//        script "echo <w> <v>"
end


int plot_all = 1
create xform {graph_name}wave [20, 10, 400, 400]
	xshow {graph_name}wave
	create xlabel {graph_name}wave/label [10,0,98%,25] -label "voltage"
	create xgraph {graph_name}wave/Vm [0, 0, 100%, 100%] -title "membrane potential"
	setfield {graph_name}wave/Vm XUnits "t (sec)" YUnits "voltage (V)"
	setfield {graph_name}wave/Vm xmax 0.03 ymin -0.150 ymax 0.040
	setfield {graph_name}wave/Vm xoffset 0 yoffset {yoffset_val}
	useclock {graph_name}wave/Vm 2
	
	
	
	str loop_chan
	int col = 15
	int num_plots = 0
	foreach loop_chan ({el {plot_path}/soma})
		if (plot_all)
			addmsg {loop_chan} {graph_name}wave/Vm PLOT Vm *{strsub {loop_chan} /pyr_array/ /} *{col}
//			addmsg {loop_chan} {graph_name}wave/Vm PLOT Vm *{loop_chan} *{col}
//			echo {loop_chan}
		end
		
		col = col + 7
		if (col > 63)
			col = col - 60
		end
		
		num_plots = num_plots + 1
		if (num_plots > max_num_plots)
			return
		end
	end

	if (plot_all==0)
		addmsg /pyr_array/pyr[0]/soma {graph_name}wave/Vm  PLOT Vm *Vm *blue
		addmsg /pyr_array/pyr[10]/soma {graph_name}wave/Vm  PLOT Vm *Vm *green
		//addmsg /pyr_array/pyr[20]/soma {graph_name}wave/Vm  PLOT Vm *Vm *red
		addmsg /pyr_array/pyr[30]/soma {graph_name}wave/Vm  PLOT Vm *Vm *orange
		//addmsg /pyr_array/pyr[40]/soma {graph_name}wave/Vm  PLOT Vm *Vm *cyan
		addmsg /pyr_array/pyr[50]/soma {graph_name}wave/Vm  PLOT Vm *Vm *magenta
	end
	
//	setfield {graph_name}wave/Vm xoffset 0 yoffset 0.050
//	addmsg /e90/rec_site[9] {graph_name}wave/Vm PLOT field *ECF *blue
	
	
//	create xgraph {graph_name}wave/Ik [10:Vm.right,0,49%,100%]
//	setfield {graph_name}wave/Ik XUnits "t (sec)" YUnits "current (S)"
//	setfield {graph_name}wave/Ik xmax 0.03 ymin -1e-7 ymax 9e-7
//	useclock {graph_name}wave/Ik 1
//
//	addmsg /pyr_array/pyr[0]/soma/ChR2_m {graph_name}wave/Ik PLOT Gk *pyr[0]Gk *blue
////	addmsg /pyr_array/pyr[1]/soma/ChR2 {graph_name}wave/Ik PLOT Gk *pyr[1]Gk *red


end

