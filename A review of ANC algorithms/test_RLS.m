%% different file names for different noises
fnames = ["PinkNoise.wav" "WhiteNoise.wav" "FlyingBillboard.wav" "DriveinSnow.wav"];

%% RLS on each noises
for i = 1:4
    filename = fnames(i); % file name
    [x, Fs] = audioread(filename); % read the noise
    N = length(x); % length of the signal
    taps = 5; % number of taps
    Pz = 0.5.^(0:4)'; % linear coefficients
    lambda  = 1; % forgetting factor
    laminv  = 1/lambda; % lambda inverse
    delta   = 0.005;  % use to initialize P matrix
    mse = zeros(1, N);
    e = zeros(1,N);
    y = zeros(1,N);
    x = x / max(x);
    d = conv(Pz,x); % input signal filtered by known filter Pz
    x = x(:);
    d = d(:);
    w = zeros(taps,1);
    P = eye(taps)/delta;
     % Start of RLS algorithm
    for m = taps:N
        xvec = x(m:-1:m-taps+1);
        y(m) = w'*xvec;
        e(m) = d(m)-y(m);
        Pi = P*xvec;
        k = (Pi)/(lambda+xvec'*Pi);
        P = (P - k*xvec'*P)*laminv;
        w = w + k*e(m);
    end
    % End
    subplot(2,2,i)
    plot(e)
    ymax = max(abs(e));
    title(filename);
    ylim([-ymax,ymax]) % scale the y axis
end