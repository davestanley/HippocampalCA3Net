
//Output some connection stats
	//Count the number of AMPA, NMDA, and GABA channels input into the cell
str pyr_count = "/olm_arr/olm[]"
int numAMPA = {countelementlist {pyr_count}/#/AMPA#[TYPE=GENsynpores]/}
int numNMDA = {countelementlist {pyr_count}/#/NMDA#[TYPE=GENsynpores]/}
int numGABA_A = {countelementlist {pyr_count}/#/GABA_A#[TYPE=GENsynpores]/}
int numGABA_B = {countelementlist {pyr_count}/#/GABA_B#[TYPE=GENsynpores]/}
echo olm Markov synapses AMPA {numAMPA} NMDA {numNMDA} GABA_A {numGABA_A} GABA_B {numGABA_B}

str loop_chan
numAMPA = 0
foreach loop_chan ( {el {pyr_count}/#/AMPA/} )
	numAMPA = numAMPA + {getfield {loop_chan} nsynapses}
end

numNMDA = 0
foreach loop_chan ( {el {pyr_count}/#/NMDA/} )
	numNMDA = numNMDA + {getfield {loop_chan} nsynapses}
end

numGABA_A = 0
foreach loop_chan ( {el {pyr_count}/#/GABA_A/} )
	numGABA_A = numGABA_A + {getfield {loop_chan} nsynapses}
end

int numGABA_A_MS = 0
foreach loop_chan ( {el {pyr_count}/#/GABA_A_MS/} )
	numGABA_A_MS = numGABA_A_MS + {getfield {loop_chan} nsynapses}
end

foreach loop_chan ( {el /#/#/#/GABA_B/} )
	numGABA_B = numGABA_B + {getfield {loop_chan} nsynapses}
	//echo {loop_chan} {getfield {loop_chan} nsynapses}
end
echo olm standard synapses AMPA {numAMPA} NMDA {numNMDA} GABA_A {numGABA_A} GABA_B {numGABA_B} numGABA_A_MS {numGABA_A_MS}

str fb_count = "/bc_arr/bc[]"
int numAMPA = {countelementlist {fb_count}/#/AMPA#[TYPE=GENsynpores]/}
int numNMDA = {countelementlist {fb_count}/#/NMDA#[TYPE=GENsynpores]/}
int numGABA_A = {countelementlist {fb_count}/#/GABA_A#[TYPE=GENsynpores]/}
int numGABA_B = {countelementlist {fb_count}/#/GABA_B#[TYPE=GENsynpores]/}
echo bc Markov synapses AMPA {numAMPA} NMDA {numNMDA} GABA_A {numGABA_A} GABA_B {numGABA_B}

str loop_chan
numAMPA = 0
foreach loop_chan ( {el {fb_count}/#/AMPA/} )
	numAMPA = numAMPA + {getfield {loop_chan} nsynapses}
end

numNMDA = 0
foreach loop_chan ( {el {fb_count}/#/NMDA/} )
	numNMDA = numNMDA + {getfield {loop_chan} nsynapses}
end

numGABA_A = 0
foreach loop_chan ( {el {fb_count}/#/GABA_A/} )
	numGABA_A = numGABA_A + {getfield {loop_chan} nsynapses}
end

numGABA_A_MS = 0
foreach loop_chan ( {el {fb_count}/#/GABA_A_MS/} )
	numGABA_A_MS = numGABA_A_MS + {getfield {loop_chan} nsynapses}
end

int numGABA_B = 0
foreach loop_chan ( {el /#/#/#/GABA_B/} )
	numGABA_B = numGABA_B + {getfield {loop_chan} nsynapses}
	//echo {loop_chan} {getfield {loop_chan} nsynapses}
end
echo bc standard synapses AMPA {numAMPA} NMDA {numNMDA} GABA_A {numGABA_A} GABA_B {numGABA_B} numGABA_A_MS {numGABA_A_MS}


echo p_pyr2pyr_AMPA {p_pyr2pyr_AMPA} p_pyr2fb_AMPA {p_pyr2fb_AMPA} p_fb2pyr_GABA_A {p_fb2pyr_GABA_A}


