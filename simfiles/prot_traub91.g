




include traub91proto.g

if (!({exists /library}))
	create neutral /library
end

create neutral /library_traub91
pushe /library_traub91
//    make_cylind_symcompartment  /* makes "symcompartment" */
create symcompartment symcompartment
/* Assign some constants to override those used in traub91proto.g */
EREST_ACT = -0.06       // resting membrane potential (volts)
float ENA = 0.115 + EREST_ACT // 0.055  when EREST_ACT = -0.060
float EK = -0.015 + EREST_ACT // -0.075
float ECA = 0.140 + EREST_ACT // 0.080

make_Na
make_Ca
make_K_DR
make_K_AHP
make_K_C
make_K_A
make_Ca_conc

pope


move /library /library_temp
move /library_traub91 /library

//readcell CA3_traub91_reduced_Ca.p /prot_pyr
readcell CA3_traub91_orig.p /prot_pyr

move /library /library_traub91
move /library_temp /library

disable /library_traub91

