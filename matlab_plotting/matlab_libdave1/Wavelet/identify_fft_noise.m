function noise_bands = identify_fft_noise (f, fft, start_freq, window_hertz, spike_threshold_multiplier)

start_freq; % Only search for noise at frequencies above this one
window_hertz; % window size measured in measured in hertz
spike_threshold_multiplier; % Consider it a spike if it is this many times larger than the average surrounding power

%Convert this to the indicies of f
df = f(2) - f(1);
window = round(window_hertz / df);

%Change FFT coefficients to power spectrum
powerSpec = (abs(fft).^2);

noise_bands = [];
start_loc = find (f >= start_freq, 1, 'first'); % Identify location of starting frequency
for i = start_loc:window:(length(f)-window)
    meanpower = mean(abs(powerSpec(i:(i+window-1))));  %Approxixmate power of power spectrum for this particular window
    noise_bands = [noise_bands (find(powerSpec(i:(i+window-1)) > (spike_threshold_multiplier*meanpower)) + (i-1))];   %Find if there are any spikes where the power is many times greater than the background noise
    
end

noise_bands = noise_bands * df;

end



