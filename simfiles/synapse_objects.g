

int synapse_normalize_weights = 0	//davedit


function make_AMPA
	
	if (({exists AMPA}))
		return
	end
        
	create synchan2 AMPA    	
    	setfield AMPA Ek {E_AMPA} tau2 {{AMPA_tau2}  / Q10_synapse} \
                              tau1 {{AMPA_tau1}   / Q10_synapse} \
                              gmax 0.0 \
                              frequency 0 \
			      normalize_weights {synapse_normalize_weights}
end


function make_NMDA
	
	if (({exists NMDA}))
		return
	end
	
	float CMg = 1.0
	float eta = 0.28
	float gamma = 62
	
	// From Mg_block help file
	//float CMg = 2                       // [Mg] in mM
    //float eta = 0.33                    // per mM
    //float gamma = 60                    // per Volt

        
	create synchan2 NMDA    	
    	setfield NMDA Ek {E_NMDA} tau2 {{NMDA_tau2}  / Q10_synapse} \
                              tau1 {{NMDA_tau1}   / Q10_synapse} \
                              gmax 0.0 \
                              frequency 0 \
			      normalize_weights {synapse_normalize_weights}
			      

        if (! {exists NMDA/Mg_BLOCK})
                create Mg_block NMDA/Mg_BLOCK
        end

        setfield NMDA/Mg_BLOCK CMg {CMg}  \
            KMg_A {1.0/eta} \
            KMg_B {1.0/gamma}

		if(!{exists NMDA sendmsg1})
		    addfield NMDA sendmsg1
	        end
		setfield NMDA sendmsg1 ". ./Mg_BLOCK CHANNEL Gk Ek"

end


function make_GABA_A

	if (({exists GABA_A}))
		return
	end
        
	create synchan2 GABA_A    	
    	setfield GABA_A Ek {E_GABA_A} tau2 {{GABAA_tau2}  / Q10_synapse} \
                              tau1 {{GABAA_tau1}   / Q10_synapse} \
                              gmax 0.0 \
                              frequency 0 \
			      normalize_weights {synapse_normalize_weights}
end


function make_GABA_A_OLM

	if (({exists GABA_A_OLM}))
		return
	end
        
	create synchan2 GABA_A_OLM    	
    	setfield GABA_A_OLM Ek {E_GABA_A} tau2 {{GABAA_OLM_tau2}  / Q10_synapse} \
                              tau1 {{GABAA_OLM_tau1}   / Q10_synapse} \
                              gmax 0.0 \
                              frequency 0 \
			      normalize_weights {synapse_normalize_weights}
end


function make_GABA_A_MS

	if (({exists GABA_A_MS}))
		return
	end
        
	create synchan2 GABA_A_MS    	
    	setfield GABA_A_MS Ek {E_GABA_A} tau2 {{GABAA_MS_tau2}  / Q10_synapse} \
                              tau1 {{GABAA_MS_tau1}   / Q10_synapse} \
                              gmax 0.0 \
                              frequency 0 \
			      normalize_weights {synapse_normalize_weights}
end


function make_pyr_spikegen
	if (({exists pyr_spikegen}))
                return
        end
	create spikegen pyr_spikegen
	setfield ^ thresh -0.03 abs_refract {pyr_refract_HN} output_amp 1
		// thresh taken from CA3_chan041.p
end

function make_spikegen
	if (({exists spikegen}))
                return
        end
	create spikegen spikegen
	setfield ^ thresh 0 abs_refract {int_refract_HN} output_amp 1
end





