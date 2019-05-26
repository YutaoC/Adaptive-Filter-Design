%% Parameters initialization
N = 20000; % length of the sequence
taps = 128; % number of taps
epoch = 100; % number of epoch
mus = [0.005 0.01 0.05 0.1]; % learning rate
Pz=(0.5*(0:127)).^2;  % filter coefficients

%% LMS algorithm with different mu
y = zeros(1, N); % output of the equalizer
e = zeros(1, N); % error
mse = zeros(length(mus), N); % mean square error
for i = 1 : length(mus)  % for every learning rate
    mu = mus(i);
    for j = 1 : epoch
        x_n = randn(1, N); % input signal
        x_n = x_n / max(x_n);
        d=conv(Pz,x_n); % input signal filtered by known filter Pz
        w = zeros(1,taps); % initialize the weights
        % Start of LMS
        for k = taps : N
            xvec = x_n(k:-1:k-taps+1);
            y(k) = xvec * transpose(w);  % pass the signal through the equalizer
            e(k) = d(k)-y(k); % the error
            w = w + mu * e(k) * xvec; % update the weight
        end 
        % End of LMS
        mse(i,:) = mse(i,:) + e.^2;  % store the mean square error
    end
end
mse = mse / epoch;  % average by the epoch

%% Plot the result
figure
for i = 1:length(mus)
    plot(mse(i,:))
    hold on
end
set(gca, 'YScale', 'log');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
title('Convergence in LMS algorithm');
hleg = legend({'0.005','0.01', '0.05', '0.1'},'Location','best');
htitle = get(hleg,'Title');
set(htitle,'String','mu');
