%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Implementation of LMS algorithm
% Determine the optimal delay
% Yutao Chen
% 03/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters initialization
N = 20000; % length of the sequence
taps = 21; % number of taps
epoch = 100; % number of epoch
noise_var = -20; % variance of the noise in dBW
mu = 0.001; % step size
x_n = sign(randn(epoch, N)); % input signal
% H1 = 0.25 + z^-1 + 0.25*z^-2 -> transfer function # 1
h1 = [0.25 1 0.25];
% H2 = 0.25 + z^-1 - 0.25*z^-2 -> transfer function # 2
h2 = [0.25 1 -0.25];
% H3 = -0.25 + z^-1 + 0.25*z^-2 -> transfer function # 3
h3 = [-0.25 1 0.25];

%% 5.22(a) - Determine the optimal delay
tau_test = [9 10 11 12 13];
y = zeros(1, N); % output of the equalizer
e = zeros(1, N); % error
mse = zeros(length(tau_test), N); % mean square error
for i = 1 : length(tau_test)  % for every tau to be tested
    input = [zeros(epoch, tau_test(i)) x_n]; % input signal with the delay(desiered sig.)
    for j = 1 : epoch
        u_tmp = conv(x_n(j,:), h3); % output of the channel # 1
        noise = wgn(1,length(u_tmp), -20); % white Gaussian noise with var = 0.01
        u_tmp = u_tmp + noise; % output signal with the noise
        u = [zeros(1,taps-tau_test(i)-1) u_tmp];
        w = randn(1,taps); % initialize the weights
        % Start of LMS
        for k = taps : N
            uvec = u(k:-1:k-taps+1);
            y(k) = uvec * transpose(w);  % pass the signal through the equalizer
            e(k) = input(j,k)-y(k); % the error
            w = w + mu * e(k) * uvec; % update the weight
        end 
        % End of LMS
        mse(i,:) = mse(i,:) + e.^2;  % store the mean square error
    end
end
mse = mse / epoch;  % average over the epoch

%% Draw the figure #2
x = 1:1:N; % points in the figure
figure,plot(x, mse(1,:),x, mse(2,:),x, mse(3,:), x, mse(4,:), x, mse(5,:));
set(gca, 'YScale', 'log')
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
title('Learning curve for different dalay');
legend({'tau = 9','tau = 10', 'tau = 11', 'tau = 12' , '£n = 13'},'Location','northeast')
%% Draw the figure #1
x = 1:1:N; % points in the figure
figure
sgtitle('Learning curve for different dalays (tau)');
subplot(3,2,1),plot(x, mse(1,:));
set(gca, 'YScale', 'log')  % scale of the y axis
title('tau = 9');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
subplot(3,2,2),plot(x, mse(2,:));
set(gca, 'YScale', 'log')  % scale of the y axis
title('tau = 10');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
subplot(3,2,3),plot(x, mse(3,:));
set(gca, 'YScale', 'log')  % scale of the y axis
title('tau = 11');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
subplot(3,2,4),plot(x, mse(4,:));
set(gca, 'YScale', 'log')  % scale of the y axis
title('tau = 12');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
subplot(3,2,5),plot(x, mse(5,:));
set(gca, 'YScale', 'log')  % scale of the y axis
title('tau = 13');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');

%% 5.22(b) - Learning curve for different trnasfer functions
h = [h1; h2; h3]; % different transfer functions
tau_opt = 12;  % optimal delay
y = zeros(1, N); % output of the equalizer
e = zeros(1, N); % error
mse = zeros(length(h), N); % mean square error
for i = 1 : length(h)  % for every transfer function
    input = [zeros(epoch, tau_opt) x_n]; % input signal with the delay(desiered sig.)
    for j = 1 : epoch
        u_tmp = conv(x_n(j,:), h(i,:)); % output of the channel
        noise = wgn(1,length(u_tmp), -20); % white Gaussian noise with var = 0.01
        u_tmp = u_tmp + noise; % output signal with the noise
        u = [zeros(1,taps-tau_opt-1) u_tmp];
        w = randn(1,taps); % initialize the weights
        % Start of LMS
        for k = taps : N
            uvec = u(k:-1:k-taps+1);
            y(k) = uvec * transpose(w);  % pass the signal through the equalizer
            e(k) = input(j,k)-y(k); % the error
            w = w + mu * e(k) * uvec; % uodate the weight
        end 
        % End of LMS
        mse(i,:) = mse(i,:) + e.^2;  % store the mean square error
    end
end
mse = mse / epoch;  % average by the epoch

%% Draw the figure # 1
x = 1:1:N; % points in the figure
figure,plot(x, mse(1,:),x, mse(2,:),x, mse(3,:));
set(gca, 'YScale', 'log')
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
title('Learning curve for different transfer function');
legend({'transfer func. #1','transfer func. #2', 'transfer func. #3'},'Location','northeast')
%% Draw the figure #2
x = 1:1:N; % points in the figure
figure
sgtitle('Learning curve for different transfer functions');
subplot(2,2,1),plot(x, mse(1,:));
set(gca, 'YScale', 'log')  % scale of the y axis
title('transfer function #1');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
subplot(2,2,2),plot(x, mse(2,:));
set(gca, 'YScale', 'log')  % scale of the y axis
title('transfer function #2');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
subplot(2,2,3),plot(x, mse(3,:));
set(gca, 'YScale', 'log')  % scale of the y axis
title('transfer function #3');
xlabel('Number of adaptation cyckes, n');
ylabel('Mean squared error');
