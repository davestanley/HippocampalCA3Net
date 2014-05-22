// genesis
include kons_olm.g

/*****This script creates a prototype for the oriens interenuron which projects
******to the LM moleculare region innervating pyramidal cells in the distal
******apical dendrites
******/

create neutral /prot_olm

//*****************************************************************************
//*****Somatic compartment
create	compartment 	/prot_olm/soma
setfield 		/prot_olm/soma \
	Cm		{CM_OLM * SOMA_A_OLM} \			// F
	Ra		{RA_OLM * SOMA_L_OLM /SOMA_XA_OLM}\ // ohm (felesleges)
	Em  		{EREST_ACT_OLM} \				// V
	Rm		{RM_OLM/SOMA_A_OLM} \  				// ohm
	inject		0.0 \
	initVm		-0.065

//*****************************************************************************
//*****Active sodium channel a la Wang & Buzsaki '96 with fast m gate
create	vdep_channel	/prot_olm/soma/Na_channel
setfield 	/prot_olm/soma/Na_channel \
	Ek 		55e-3 \					// V
	gbar		{ 350 * {SOMA_A_OLM} }			// S

//*****the m gate of the sodium channel
create table /prot_olm/soma/Na_channel/m_gate

ce /prot_olm/soma/Na_channel/m_gate

call . TABCREATE {VRES} {VMIN} {VMAX}
int i
float y
float alpham
float betam
float x
echo Tablazat feltoltese ...
 for (i = 0; i<= VRES; i = i + 1)
   x = (i * (VMAX - VMIN) / VRES) + VMIN
   alpham= -0.1e+6 * ( x  + 0.035) / ({ exp {-0.1e+3 * ( x + 0.035 )} } - 1)
   betam= 4e+3 * { exp { -1 * ( x + 0.060 ) / 0.018 } }
   y = alpham / ( alpham + betam )
   if (x == -0.035)
      y = 0.9970947
   end 
   setfield . table->table[{i}] {y}
 end
setfield . table->calc_mode 0

ce /

//*****the h gate of the sodium channel
create tabgate /prot_olm/soma/Na_channel/h_gate

/*****tobb dolog is megkavarja a nagysagrandeket es elojeleket: atteres mV->V;
******atteres ms->s; az exponencialis szamlaloban, vagy nevezoben van-e
******/

setupgate ^ alpha {Phi*70} 0 0 58e-3 20e-3 -size {VRES} -range {VMIN} {VMAX}
setupgate ^ beta {Phi*1e+3} 0 1 28e-3 -10e-3 -size {VRES} -range {VMIN} {VMAX}

//*****Connecting gates to the channel
ce /prot_olm/soma/Na_channel
addmsg m_gate . MULTGATE output 3
addmsg h_gate . MULTGATE m 1
ce /

//*****************************************************************************
//*****Active potassium channel (deleyed rectifier)

create vdep_channel /prot_olm/soma/K_channel
setfield ^  Ek -90e-3 gbar {90*{SOMA_A_OLM}}

create tabgate /prot_olm/soma/K_channel/nv_gate

setupgate ^ alpha {-0.01e+6*Phi*0.034} {-0.01e+6*Phi} -1 0.034 -10e-3 -size {VRES} -range {VMIN} {VMAX}
setupgate ^ beta {0.125e+3*Phi} 0 0 0.044 0.080 -size {VRES} -range {VMIN} {VMAX}


//*****Connecting gates to the channel
ce /prot_olm/soma/K_channel
addmsg nv_gate . MULTGATE m 4
ce /

//*****************************************************************************
//*****Active hyperpolarization-activated channel (for the I_h current)
create vdep_channel /prot_olm/soma/h_channel
setfield ^  Ek -40e-3 gbar {1.5*{SOMA_A_OLM}}

//*****H gate of the channel
create tabgate /prot_olm/soma/h_channel/H_gate
//create table /prot_olm/soma/h_channel/H_gate

ce /prot_olm/soma/h_channel/H_gate

call . TABCREATE alpha {VRES} {VMIN} {VMAX}
call . TABCREATE beta {VRES} {VMIN} {VMAX}
float alpha, beta
for (i = 0; i <= VRES; i = i + 1)
   x = (i * (VMAX - VMIN) / VRES) + VMIN
   alpha = 1 / (1 + { exp {(x + 80e-3) / 10e-3 }}) / (200e-3/({ exp {(x + 70e-3) /20e-3}} + { exp {-(x + 70e-3) / 20e-3}})+0.005)
   beta = (1 - 1 / (1 + { exp {(x + 80e-3) / 10e-3 }})) / (200e-3/({ exp {(x + 70e-3) /20e-3}} + { exp {-(x + 70e-3) / 20e-3}})+0.005)
   setfield . alpha->table[{i}] {alpha}
   setfield . beta->table[{i}] {beta}
end

ce /prot_olm/soma/h_channel
addmsg H_gate . MULTGATE m 1
ce /

//*****************************************************************************
//*****Calcium channel

create vdep_channel /prot_olm/soma/Ca_channel
setfield ^ Ek 120e-3 gbar {10 * {SOMA_A_OLM}}

//*****The m gate of the channel
create table /prot_olm/soma/Ca_channel/m_gate

ce /prot_olm/soma/Ca_channel/m_gate

call . TABCREATE {VRES} {VMIN} {VMAX}
for (i = 0; i<= VRES; i = i + 1)
   x = (i * (VMAX - VMIN) / VRES) + VMIN
   y = 1/(1 + { exp {-(x + 20e-3) / 9e-3}})
   setfield . table->table[{i}] {y}
end
setfield . table->calc_mode 0

ce /prot_olm/soma/Ca_channel
addmsg m_gate . MULTGATE output 2
ce /

//*****************************************************************************
//*****Hyperpolarization activated Calcium-dependent potassium current

//*****Calcium concentration
create Ca_concen 	/prot_olm/soma/Calcium_c
setfield ^		tau 0.08 B 200000 Ca_base 0

create vdep_channel	/prot_olm/soma/K_C_channel
setfield ^ 		Ek -90e-3 gbar {100 * {SOMA_A_OLM}}
create table 		/prot_olm/soma/K_C_channel/psg

ce ^

call . TABCREATE 3200 0 32e-7
for (i = 0; i <= 3200; i = i + 1)
   x = (i * (32e-7 - 0) / 3200) + 0
   y = x / (x + 30e-6)
   setfield . table->table[{i}] {y}
end
setfield . table->calc_mode 0

ce /prot_olm/soma/K_C_channel
addmsg psg . MULTGATE output 1
ce /

//*****************************************************************************
//Copying constituents to a prototype cell

ce /prot_olm/soma

addmsg . 		K_channel/nv_gate 	VOLTAGE	Vm
addmsg K_channel	. 			CHANNEL Gk Ek
addmsg . 		K_channel 		VOLTAGE Vm

addmsg . 		Na_channel/m_gate	INPUT	Vm
addmsg . 		Na_channel/h_gate	VOLTAGE Vm
addmsg Na_channel	.			CHANNEL	Gk Ek
addmsg . 		Na_channel		VOLTAGE	Vm

addmsg .		h_channel/H_gate	VOLTAGE	Vm
addmsg h_channel 	. 			CHANNEL Gk Ek
addmsg . 		h_channel 		VOLTAGE Vm

addmsg . 		Ca_channel/m_gate	INPUT	Vm
addmsg Ca_channel	.			CHANNEL	Gk Ek
addmsg .		Ca_channel		VOLTAGE Vm

addmsg Ca_channel 	Calcium_c		I_Ca	Ik
addmsg Calcium_c 	K_C_channel/psg		INPUT	Ca
addmsg K_C_channel 	. 			CHANNEL	Gk Ek
addmsg . 		K_C_channel 		VOLTAGE	Vm

ce /
