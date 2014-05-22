/* Main script for MS-GABAergic Neuron from Wang paper
 *  -adapted from tutorial3.g by Eric Zilli
 */

include kons_msgaba.g

// steady state and time functions for slow potassium channel:
function p_inf (v)
	float v

        return { 1.0/(1.0 + {exp {-(v + 0.034)/0.0065}}) }
end

function p_tau (v)
	float v

	return { .006 }
end

function q_inf (v)
	float v

        return { 1.0/(1.0 + {exp {(v + 0.065)/0.0066}}) }
end

function q_tau (v)
	float v

        return { .1*(1.0 + 1.0/(1.0 + ({exp {-(v + 0.050)/0.0068}}))) }
end

// alpha and beta functions for slow potassium channel:
function p_alpha(v)
	float v

	return { {p_inf {v}} / {p_tau {v}} }
end

function p_beta(v)
	float v
	
	return { (1.0 - {p_inf {v}}) / {p_tau {v}} }
end

function q_alpha(v)
	float v

	return { {q_inf {v}} / {q_tau {v}} }
end

function q_beta(v)
	float v

	return { (1.0 - {q_inf {v}}) / {q_tau {v}} }
end


// alpha and beta functions for potassium channel
function n_alpha (v)
	float v
	if(v==-.038)
		return { Phi * .1 }
	end

        return { Phi * (-10e3 * (v+.038)) / ({exp {-.1e3*(v+.038)}}-1) }
end

function n_beta (v)
	float v

        return { Phi * 125 * ({exp {-(v + 0.048)/0.080}}) }
end


// alpha and beta functions for sodium channel
function m_alpha (v)
	float v
	if(v==-.033)
		return 1 
	end
        return { (-.1e6 * (v+.033)) / ({exp {-.1e3*(v+.033)}}-1) }
end

function m_beta (v)
	float v

        return { 4e3 * ({exp {-(v + 0.058)/0.018}}) }
end


function h_alpha (v)
	float v

        return { Phi * 70 * ({exp {-(v + 0.051)/0.010}}) }
end

function h_beta (v)
	float v

        return { Phi * 1e3 / ({exp {-.1e3*(v+.021)}}+1) }
end

/********************************************************************
**  adapted from Scripts/neurokit/prototypes/newbulbchan.g
**	^Non-inactivating Muscarinic K current
**
**	Tabulated Slow K Channel
**
********************************************************************/
function make_KS_tab
        if (({exists KS_tab}))
                return
        end

        int i
        float x, dx, t, b

    create tabchannel KS_tab
    setfield KS_tab Ek {EK_MSGABA} Gbar {120.0*SOMA_A_MSGABA} Ik 0 Gk 0 Xpower 1  \
        Ypower 1 Zpower 0

        call KS_tab TABCREATE X 79 -0.15 0.075
        call KS_tab TABCREATE Y 79 -0.15 0.075
        x = -0.15
        dx = 0.225/79.0

	for (i = 0; i <= 79; i = i + 1)
                setfield KS_tab X_A->table[{i}] {p_alpha {x}}

                setfield KS_tab X_B->table[{i}] {{p_alpha {x}} + {p_beta {x}}}

                setfield KS_tab Y_A->table[{i}] {q_alpha {x}}

                setfield KS_tab Y_B->table[{i}] {{q_alpha {x}} + {q_beta {x}}}
                x = x + dx
	end	

        call KS_tab TABFILL X 3000 0
        call KS_tab TABFILL Y 3000 0
end


/********************************************************************
**  adapted from Scripts/neurokit/prototypes/newbulbchan.g
**	^Non-inactivating Muscarinic K current
**
**	Tabulated K Channel
**
********************************************************************/
function make_K_tab
        if (({exists K_tab}))
                return
        end

        int i
        float x, dx, t, b

    create tabchannel K_tab
    setfield K_tab Ek {EK_MSGABA} Gbar {80.0*SOMA_A_MSGABA} Ik 0 Gk 0 Xpower 4  \
        Ypower 0 Zpower 0

        call K_tab TABCREATE X 79 -0.15 0.075
        x = -0.15
        dx = 0.225/79.0

	for (i = 0; i <= 79; i = i + 1)
                setfield K_tab X_A->table[{i}] {n_alpha {x}}

                setfield K_tab X_B->table[{i}] {{n_alpha {x}} + {n_beta {x}}}
                x = x + dx
	end	

        call K_tab TABFILL X 3000 0
end


/********************************************************************
**  adapted from Scripts/neurokit/prototypes/newbulbchan.g
**	^Non-inactivating Muscarinic K current
**
**	Tabulated Na Channel
**
********************************************************************/
function make_Na_t
        if (({exists Na_t}))
                return
        end

	create vdep_channel Na_t
	setfield ^ Ek {ENA_MSGABA} gbar {500.0 * SOMA_A_MSGABA}

	ce Na_t

	create table Na_minf
	call ^  TABCREATE 79 -0.15 0.075

	create tabgate Na_h
	call ^ TABCREATE alpha 79 -0.15 0.075
	call ^ TABCREATE beta 79 -0.15 0.075	

        int i
        float x, dx, t, b
        x = -0.15
        dx = 0.225/79.0

	for (i = 0; i <= 79; i = i + 1)
		setfield Na_minf table->table[{i}] \
			{ {m_alpha {x}} / ({m_alpha {x}} + {m_beta {x}}) }
		setfield Na_h alpha->table[{i}] {h_alpha {x}}
		setfield Na_h beta->table[{i}] {h_beta {x}}

                x = x + dx
	end	

	call Na_minf TABFILL 3000 0
	setfield Na_minf table->calc_mode 0
	call Na_h TABFILL alpha 3000 0
	setfield Na_h alpha->calc_mode 0
	call Na_h TABFILL beta 3000 0
	setfield Na_h beta->calc_mode 0

	addmsg Na_minf . MULTGATE output 3
	addmsg Na_h . MULTGATE m 1

	ce ..
end

//===============================
//      Function Definitions
//===============================

function makecompartment(path, length, dia, Erest)
    str path
    float length, dia, Erest
    float area = length*PI*dia
    float xarea = PI*dia*dia/4

    create      compartment     {path}
    setfield    {path}              \
		Em      { Erest }   \           // volts
		Rm 	{ RM_MSGABA / SOMA_A_MSGABA} \		// Ohms
		Cm 	{ CM_MSGABA * SOMA_A_MSGABA} \		// Farads
		Ra      { RA_MSGABA*length/xarea } 	// Ohms
end

function step_tmax
    step {tmax} -time
end

function set_inject(dialog)
    str dialog
    setfield /prot_msgaba/soma inject {getfield {dialog} value}
end

//===============================
//         Main Script
//===============================

create neutral /prot_msgaba
// create the soma compartment "/prot_msgaba/soma"
makecompartment /prot_msgaba/soma {SOMA_L_MSGABA} {SOMA_D_MSGABA} {ELEAK_MSGABA}
setfield /prot_msgaba/soma initVm {EREST_ACT_MSGABA} // initialize Vm to rest potential

// provide current injection to the soma
setfield /prot_msgaba/soma inject  1.885e-11	// injection current

// Create three channels, "/prot_msgaba/soma/Na_hh", "/prot_msgaba/soma/K_hh"
//	and  "/prot_msgaba/soma/KS_tab"
pushe /prot_msgaba/soma
make_KS_tab
make_K_tab
make_Na_t
pope

/*
// spikegen and spikehistory stuff
create spikegen /prot_msgaba/soma/spike
setfield /prot_msgaba/soma/spike thresh 0 abs_refract .005 output_amp 1
addmsg /prot_msgaba/soma /prot_msgaba/soma/spike INPUT Vm

create spikehistory s_history
setfield s_history ident_toggle 0 filename "spikes"\
	initialize 0 leave_open 1 flush 1
addmsg /prot_msgaba/soma/spike s_history SPIKESAVE
*/

// The soma needs to know the value of the channel conductance
// and equilibrium potential in order to calculate the current
// through the channel.  The channel calculates its conductance
// using the current value of the soma membrane potential.

addmsg /prot_msgaba/soma/K_tab /prot_msgaba/soma CHANNEL Gk Ek
addmsg /prot_msgaba/soma /prot_msgaba/soma/K_tab VOLTAGE Vm

addmsg /prot_msgaba/soma/Na_t /prot_msgaba/soma CHANNEL Gk Ek
addmsg /prot_msgaba/soma /prot_msgaba/soma/Na_t VOLTAGE Vm

addmsg /prot_msgaba/soma/KS_tab /prot_msgaba/soma CHANNEL Gk Ek
addmsg /prot_msgaba/soma /prot_msgaba/soma/KS_tab VOLTAGE Vm

addmsg /prot_msgaba/soma /prot_msgaba/soma/Na_t/Na_minf INPUT Vm
addmsg /prot_msgaba/soma /prot_msgaba/soma/Na_t/Na_h VOLTAGE Vm

/*
pushe
ce /output/msgdata/voltage/volts/
setfield . ysquish 0
pope
*/

//check
reset

