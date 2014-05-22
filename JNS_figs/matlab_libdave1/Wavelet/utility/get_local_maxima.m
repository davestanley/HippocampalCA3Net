

function max_index = get_local_maxima (x, ploton)

    if nargin < 2
        ploton = 0;
    end

    v_plot = x;

    v_prime = diff(v_plot);
    v_doubpr = diff(v_prime);

    v_prime_shift = v_prime (1:end-1) .* v_prime(2:end);
    t_zeros_index = (find (v_prime_shift < 0));        
    t_maxima_index = t_zeros_index( find (v_doubpr(t_zeros_index) < 0) );
    t_maxima_index = t_maxima_index (2:end-1) + 1;

    t_plot = 1:length(v_plot);

    if (ploton); figure; hold on;
        plot(t_plot,v_plot); 
        plot (t_plot(t_maxima_index),v_plot(t_maxima_index),'ro');
    end