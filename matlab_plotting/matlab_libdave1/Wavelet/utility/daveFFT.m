function [f X] = daveFFT (t_input, x_input, scale_freq)


% Scale freq is not used - see daveFFT_scale
if nargin < 3
    scale_freq = 1;
end

tstep = t_input(2)-t_input(1);
min_t = min(t_input);
max_t = max(t_input);

t = min_t:tstep:max_t;
t = (0:length(t_input)-1)*tstep + min_t;
N = length(t);
dt = tstep;
df = 1/(N*dt);
%t = (0:N-1)*dt;
f = df * (0:N-1);

% x = interp1(t_input,x_input,t);
x = x_input;
X = 2*pi*fft (x)/N; % This 2*pi scaling produces the correct amplitudes for CTFT
                    % Dividing by N removes the "delta" functions
X=X';

end