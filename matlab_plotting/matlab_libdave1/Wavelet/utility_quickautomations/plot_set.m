

if (synfirst)

eval (['hold on; s = ' prefix 'acsf; plot (downsample(s.datatimes,ds), downsample(s.datafilt - mean(s.datafilt)+0*m,ds),''b'');'])
eval (['hold on; s = ' prefix 'syn; plot (downsample(s.datatimes,ds), downsample(s.datafilt - mean(s.datafilt)+1*m,ds),''r'');'])
eval (['hold on; s = ' prefix 'syngap; plot (downsample(s.datatimes,ds), downsample(s.datafilt - mean(s.datafilt)+2*m,ds),''g'');'])
eval (['hold on; s = ' prefix 'washout; plot (downsample(s.datatimes,ds), downsample(s.datafilt - mean(s.datafilt)+3*m,ds),''m'');'])
eval (['title (''' prefix ''');'])
eval ('legend (''acsf, syn, syngap, washout,fb5s noAMPA, fb0s base m40m40'');')

else
    
    eval (['hold on; s = ' prefix 'acsf; plot (downsample(s.datatimes,ds), downsample(s.datafilt - mean(s.datafilt)+0*m,ds),''b'');'])
    eval (['hold on; s = ' prefix 'gap; plot (downsample(s.datatimes,ds), downsample(s.datafilt - mean(s.datafilt)+1*m,ds),''r'');'])
    eval (['hold on; s = ' prefix 'gapsyn; plot (downsample(s.datatimes,ds), downsample(s.datafilt - mean(s.datafilt)+2*m,ds),''g'');'])
    eval (['hold on; s = ' prefix 'washout; plot (downsample(s.datatimes,ds), downsample(s.datafilt - mean(s.datafilt)+3*m,ds),''m'');'])
    eval (['title (''' prefix ''');'])
    eval ('legend (''acsf, gap, gapsyn, washout,fb5s noAMPA, fb0s base m40m40'');')
    
end


eval (['hold on; s = fb5s_stoch_noAMPA; plot (downsample(s.datatimes,ds), downsample(s.datafilt - mean(s.datafilt)-1*m,ds),''k'');'])
eval (['hold on; s = fb0s_base_m40m40; plot (downsample(s.datatimes,ds), downsample(s.datafilt - mean(s.datafilt)-2*m,ds),''k'');'])



