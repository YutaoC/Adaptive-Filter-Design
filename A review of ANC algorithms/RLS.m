%% Parameters initialization
N = 500; % length of the sequence
taps = 5; % number of taps
epoch = 100; % number of epoch
Pz = 0.5.^(0:4)'; %linear coefficients
lambda  = 1; % forgetting factor
laminv  = 1/lambda; % lambda inverse
delta   = 0.005; % use to initialize P matrix

%% RLS algorithm
mse = zeros(1, N);
e = zeros(1,N); % error signal
for j = 1 : epoch
    x = randn(N, 1); % input signal
    d = conv(Pz,x); % input signal filtered by known filter Pz
    x = x(:);
    d = d(:);
    w = zeros(taps,1); % weight vector
    P = eye(taps)/delta; % initialize the P matrix
    % Start of RLS algorithm
    for m = taps:N
        xvec = x(m:-1:m-taps+1);
        e(m) = d(m)-w'*xvec;
        Pi = P*xvec;
        k = (Pi)/(lambda+xvec'*Pi);
        P = (P - k*xvec'*P)*laminv;
        w = w + k*e(m);
    end
    % End
    mse = mse + e.^2;
end
mse = mse / epoch; % average by the epoch

%% plot the result
figure
plot(mse)
set(gca, 'YScale', 'log');
xlabel('Number of adaptation cycles, n');
ylabel('Mean squared error');
title('Convergence in RLS algorithm');
