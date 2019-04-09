%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Implementation of QR-RLS algorithm
% on a Adaptive MVDR Beamforming problem
% Yutao Chen
% 03/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% General parameters setting
M = 5; % # of sensors
N = 105; % # of snapshots
TSNR = 10; % target signalto noise ratio
ISNR = 40; % interference signal to noise ratio
phi_interf = asin(0); % angle of arrival for interference
phi_target = [asin(-0.15) asin(-0.1) asin(-0.05)]; % angle of arrival for target
lambda = 1; % exponential weighting vector
input = zeros(N,M,3); % elemental signal

%% Signal Generate
% noise
noise_mean = 0; % mean value of the noise
noise_var = 1;  % variance of the noise

% target signal
th_target = zeros(1,3);
steer_vec = zeros(M,3);
amp_target = 10 ^ (TSNR/20);  % amplitude of target signal
for i = 1:3  % for every different arrival angle of target sig.
    th_target(i) = pi * sin(phi_target(i));  % electrical angle
    steer_vec(:,i) = exp(-1i*(0:(M-1))'*th_target(i));  % steer vector
end

% interference signal
th_interf = pi * sin(phi_interf); % interference electrical angle 
amp_interf = 10 ^ (ISNR/20); % amplitude of the interference

% elemental signal
for n = 1:3 % for every different arrival angle of target sig.
    for i = 1 : N
        Phi = 2*pi*rand(1); % phase difference (0,2pi)
        noise = wgn(1,M,0,'complex');  % generate white gaussian noise
        input(i,:,n) = amp_target*exp(1i*(1:M)*th_target(n)) + ...
                       amp_interf*exp(1i*((1:M)*th_interf+Phi)) + ...
                       noise; 
    end
end

% % One when the interference and target is correlated
% for n = 1:3 % for every different arrival angle of target sig.
%     Phi = 2*pi*rand(1); % phase difference (random but fixed)
%     for i = 1 : N
%         noise = wgn(1,M,0,'complex');  % generate white gaussian noise
%         input(i,:,n) = amp_target*exp(1i*(1:M)*th_target(n)) + ...
%                        amp_interf*exp(1i*((1:M)*th_interf+Phi)) + ...
%                        noise; 
%     end
% end

%% QR-RLS algorithm
% parameter initialization
w_opt = zeros(N,M,3);  % optimal weight
w_H = zeros(1, M);  % temp weight
zero_vec = zeros(1, M);
desire_sig = zeros(1, N); % the desire sig for this problem is 0

for iter = 1:3
    Phi_root = zeros(M, M);
    a_H = zeros(1, M);
    % initialize the phi_root matrix
    for n = 1:M
        u = input(n,:,iter).'; 
        pre_array = [[lambda*Phi_root u]; [lambda*a_H desire_sig(n)]; [zero_vec 1]];
        post_array = triu(qr(pre_array'))';
        % update the Phi matrix
        Phi_root = post_array(1:M, 1:M);
        % fill with zeros
        w_opt(n,:,iter) = w_H;
    end
    % compute the auxiliary vector
    a_H = (Phi_root \ steer_vec(:,iter))';
    % start
    for n = (M+1):N
        u = input(n, :,iter).';
        pre_array = [[lambda*Phi_root u]; [lambda*a_H desire_sig(n)]; [zero_vec 1]];
        post_array = triu(qr(pre_array'))';
        % update the Phi matrix and auxiliary vector
        Phi_root = post_array(1:M, 1:M);
        a_H = post_array(M+1, 1:M);
        % compute the temp. optimal weight 
        w_H = (Phi_root' \ a_H')';
        w_H = w_H / (a_H * a_H');
        % store all the temp. weight
        w_opt(n,:,iter) = w_H;
    end
end

%% plot 
opt_weight = conj(w_opt(N,:,:));  % conjucate of the optimal weights
sin_phi = -1:0.025:1; % sin_phi where phi is the actual angle of incidence
theta = pi * sin_phi;  % electrical angle
S = ones(81,5);  % sample signals
for i = 1:M-1
   S(:,i+1) = exp(-1i * i * theta); % arrival signal for different theta
end

figure
sgtitle('Result on the spatial response of the systolic MVDR beamformer');

subplot(1,3,1)
plot(sin_phi,20*log10(abs(opt_weight(:,:,1)*S')),'K');
yline(0,'--r');
xline(-0.15,'--r');
xlabel('sin \phi');
ylabel('Amplitude response, dB');

subplot(1,3,2)
plot(sin_phi,20*log10(abs(opt_weight(:,:,2)*S')),'K');
yline(0,'--r');
xline(-0.1,'--r');
xlabel('sin \phi') ;
ylabel('Amplitude response, dB');

subplot(1,3,3)
plot(sin_phi,20*log10(abs(opt_weight(:,:,3)*S')),'K');
yline(0,'--r');
xline(-0.05,'--r');
xlabel('sin \phi');
ylabel('Amplitude response, dB');
