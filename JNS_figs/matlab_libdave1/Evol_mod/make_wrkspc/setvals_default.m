set_values = 0;
sim_num=0;
sim_num=sim_num+1;
cell_range=4;
time_range = (1:length(sim{sim_num}.time));

plot_on=0;
plot_traces = 0;
plot_inputs = 0;
plot_spws = 0;
plot_raster = 0;
    timerange_raster = 2;
plot_auto = 0;

plot_stats = 0;
    plot_error = 0;
    plot_efield = 0;
    plot_SPWs_stats = 0;
        dat_fieldname_sing_SPW='column.SPW_stats.width';
        dat_fieldname_sing_SPW='column.SPW_stats.SPW_rate';
        dat_fieldname_sing_SPW='column.SPW_stats.amp_prenorm';
    if plot_efield; cell_range = 1:11; end
    if plot_SPWs_stats; cell_range = 4; end


if plot_traces
   cell_range=[4];
   time_range=time_range;
   calc_auto = 0;
   plot_inputs = 0;
   recalc_SPWs = 0;
   plot_rawtraces = 0;
   plot_spw_rates = 0;
   %%%%%% TO DO: Fix KAPPA - It gives non-intuitive values for pyr
    %%% Are initial values biasing? Should I be chopping off some of the
    %%% initial data points?
    %%% Might also need to adjust bin size used by KAPPA.
end