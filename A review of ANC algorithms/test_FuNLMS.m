%% different file names for different noises
fnames = ["PinkNoise.wav" "WhiteNoise.wav" "FlyingBillboard.wav" "DriveinSnow.wav"];
 
%% NLMS on each noises
for i = 1:4
    filename = fnames(i); % file name
    [x, Fs] = audioread(filename); % read the noise
    x = x';
    N = length(x); % length of the signal
    taps = 128; % number of taps
    Pz=(0.5*(0:127)).^2; % filter coefficients

    y = zeros(1, N);
    e = zeros(1, N);
    mu = 0.05; % learning rate
    x = x / max(x);
    d=conv(Pz,x); % input signal filtered by known filter Pz
    w = zeros(1,taps); % weight vector
    % Start of NLMS algorithm
    for k = taps : N
        xvec = x(k:-1:k-taps+1);
        y(k) = xvec * transpose(w);
        e(k) = d(k)-y(k);
        mu_new = mu/(1+(xvec*xvec'));
        w = w + mu_new * e(k) * xvec;
    end 
    % End
    subplot(2,2,i)
    plot(e)
    ymax = max(abs(e));
    title(filename);
    ylim([-ymax,ymax]) % scale the y axis
end
