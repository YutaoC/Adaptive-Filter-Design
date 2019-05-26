%% different file names for different noises
fnames = ["PinkNoise.wav" "WhiteNoise.wav" "FlyingBillboard.wav" "DriveinSnow.wav"];

%% APA on each noises
for i=1:4
    filename = fnames(i); % file name
    [x, Fs] = audioread(filename); % read the noise
    N = length(x); % length of the signal
    taps = 5; % number of taps
    Pz = (0.5*(0:4)); % linear coefficients
    gamma = 0.001; % regularization factor;
    x = x' / max(x);
    desired = conv(Pz,x); % input signal filtered by known filter Pz
    [w,y] = Affine_projection(x, desired, 0.05, 0.001, 4, taps); % APA
    e = desired(1:N) - y;
    
    subplot(2,2,i)
    plot(e)
    ymax = max(abs(e));
    title(filename);
    ylim([-ymax,ymax]) % scale the y axis
end