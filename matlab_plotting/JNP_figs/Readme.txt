


So far I’ve gotten the first figs0-2 working. fig3 is not working correctly. I’ve gotten it to plot, but I think I might be using either the wrong dataset, or the wrong arrangement of parameter labels.

It is likely something in this section that needs to be fixed:
sim = sim4;
    loop1ROI=[6]; loop1range = [1:7];     % Range of interest for outer loop; Total number of iterations of outer loop
    loop2ROI=[2:5]; loop2range = 1:7;   % Range of interest for inner loop; Total number of iterations of inner loop
    experiment_ROI = [0]; experiment_range = 0:0; % Experiment number of interest within loops; Total number of experiments within nested loops
    if plot_2D_sens
        loop1ROI = loop1range([1:7]); loop2ROI = loop2range([1:7]);   % If doing sensitivity analysis, need to use whole grid.
            % Note, for this simulation, sim{36:38} have bad values (sim
            % terminated on error)
    end
    loop1vals = [-0.05 -0.075 -0.085 -0.10 -0.12 -0.14 -0.18];  % We absolute value these later ...just incase
    loop2vals = [0.0 0.15 0.3 0.45 0.65 0.80 1.0]*50;                   % We absolute value these later ...just incase