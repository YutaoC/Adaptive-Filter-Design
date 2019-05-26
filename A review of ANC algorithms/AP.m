%% Parameters initialization
N = 4000; % length of the sequence
taps = 5; % number of taps
epoch = 100; % number of epoch
mus = [0.005 0.01 0.05 0.1 0.5]; % learning rate
Pz = (0.5*(0:4)); % linear coefficients
gamma = 0.001; % regularization factor;
mse = zeros(length(mus),N); % error

%% AP algorithm with different mu
for i =1:length(mus)
   mu = mus(i);
   for j = 1:epoch
       input = randn(1, N); % input signal
       input = input / max(input);
       desired = conv(Pz,input); % input signal filtered by known filter Pz
       [w,y] = Affine_projection(input, desired, mu, 0.001, 4, taps); % APA
       e = desired(1:N) - y; % error
   end
   mse(i,:) = mse(i,:) + e.^2;
end
mse = mse / epoch; % average by the epoch

%% plot the result
figure
for i = 1:length(mus)
    plot(mse(i,:))
    hold on
end
set(gca, 'YScale', 'log');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
title('Convergence in AP algorithm');
hleg = legend({'0.005','0.01', '0.05', '0.1', '0.5'},'Location','best');
htitle = get(hleg,'Title');
set(htitle,'String','mu');
