%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Implementation of RLS algorithm
% Yutao Chen
% 03/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters initialization
N = 400; % length of the sequence
taps = 21; % number of taps
epoch = 100; % number of epoch
noise_var = -20; % variance of the noise in dBW
tau_opt = 12;  % optimal delay
delta = 0.005; % regularization parameter
lambda = 0.99; % forgetting factor
x_n = sign(randn(epoch, N)); % input signal
% H1 = 0.25 + z^-1 + 0.25*z^-2 -> transfer function # 1
h1 = [0.25 1 0.25];
% H2 = 0.25 + z^-1 - 0.25*z^-2 -> transfer function # 2
h2 = [0.25 1 -0.25];
% H3 = -0.25 + z^-1 + 0.25*z^-2 -> transfer function # 3
h3 = [-0.25 1 0.25];

%% 9.11 - Learning curve for different trnasfer functions using RLS algorithm
h = [h1; h2; h3]; % different transfer functions
alpha = zeros(1, N); % error
[row, col] = size(h); % size of the transfer function matrix
mse = zeros(row, N); % mean square error
for i = 1 : row  % for every transfer function
    input = [zeros(epoch, tau_opt) x_n]; % input signal with the delay(desiered sig.)
    for j = 1 : epoch
        u_tmp = conv(x_n(j,:), h(i,:)); % output of the channel
        noise = wgn(1,length(u_tmp), -20); % white Gaussian noise with var = 0.01
        u_tmp = u_tmp + noise; % output signal with the noise
        u = [zeros(1,taps-tau_opt-1) u_tmp];
        P = eye(taps) / delta; % initialize the P matrix
        w = randn(1,taps); % initialize the weights
        % Start of RLS
        for m = taps : N
            uvec = u(m:-1:m-taps+1);
            temp = uvec * P;  % tempoerary result that will be used multiple times later
            k = transpose(temp) / (lambda + temp * transpose(uvec));  % k matrix
            alpha(m) = input(j,m) - w * transpose(uvec);  % priori estimation error
            w = w + transpose(k) * alpha(m); % update the weight
            p = lambda^(-1) * P - lambda^(-1) * k * temp; % update the P matrix
        end 
        % End of RLS
        mse(i,:) = mse(i,:) + alpha.^2;  % store the mean square error
    end
end
mse = mse / epoch;  % average by the epoch

%% Draw the figure # 1 (together)
x = 1:1:N; % points in the figure
figure,plot(x, mse(1,:),x, mse(2,:),x, mse(3,:));
set(gca, 'YScale', 'log')
xlabel('Number of adaptation cyckes, n');
ylabel('priori estimation error');
title('Learning curve for different transfer functions');
legend({'transfer func. #1','transfer func. #2', 'transfer func. #3'},'Location','northeast')

%% Draw the figure # 2 (separate)
x = 1:1:N; % points in the figure
figure
sgtitle('Learning curve for different transfer functions');
subplot(1,3,1),plot(x, mse(1,:));
set(gca, 'YScale', 'log')  % scale of the y axis
title('transfer function #1');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
subplot(1,3,2),plot(x, mse(2,:));
set(gca, 'YScale', 'log')  % scale of the y axis
title('transfer function #2');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
subplot(1,3,3),plot(x, mse(3,:));
set(gca, 'YScale', 'log')  % scale of the y axis
title('transfer function #3');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
