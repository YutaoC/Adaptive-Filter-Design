%% Parameters initialization
N = 10000; % length of the sequence
taps = 128; % number of taps
epoch = 100; % number of epoch
mus = [0.005 0.01 0.05 0.1]; % learning rate
Pz=0.5*(0:127); % linear coefficients
Sz = Pz/2; % secondary path filter
eall = zeros(length(mus),N); % error signal envelope

%% FuLMS algorithm with different mu
for i = 1 : length(mus)
    mu = mus(i);
    for j = 1 : epoch
        x = randn(N, 1); % input signal
        x = x / max(x);
        d=conv(Pz,x); % input signal filtered by known filter Pz
        yp=conv(Sz,x); % input signal filtered by known filter Sz
        Szh=zeros(taps,1); % Sz hat to be estimated
        e = zeros(N,1); % error signal
        % Start to estimate Sz
        for n=taps:N
            ypvec=x(n:-1:n-taps+1);
            e(n)=yp(n)-Szh'*ypvec;
            Szh=Szh+mu*ypvec*(e(n));
        end
        % End
        Szh = abs(ifft(1./abs(fft(Szh))));
        mse = zeros(N,1);
        y = zeros(N,1);
        
        xp = conv(Szh,x); % input signal filtered by known filter Szh
        yp = conv(Szh,y); % input signal filtered by known filter Szh
        ypvec_prev = zeros(taps,1); % previous signal
        yvec_prev = zeros(taps,1); % previous signal
        
        Az=zeros(taps,1);
        Bz=zeros(taps,1);
        
        x=x(:);
        d=d(:);
        % Start of FuLMS
        for k = taps : N
            yvec = y(n:-1:n-taps+1);
            ypvec=yp(n:-1:n-taps+1);
            xvec = x(k:-1:k-taps+1)+.8*ypvec; % input with leakage from y
            xpvec = xp(k:-1:k-taps+1)+.8*ypvec; % input with leakage from y
            y(n) = Az'*xvec + Bz'*yvec_prev;
            e(k) = d(k)-y(n);
            Az=Az+mu*xpvec*(e(n));
            Bz=Bz+mu*ypvec_prev*(e(n));
            ypvec_prev = ypvec;
            yvec_prev = yvec;
        end
        % End
        e = e(:);
        mse = mse(:) + e;
    end
    mse = mse / epoch;  % average by the epoch
    [eall(i,:),q]=(envelope(abs(mse),500,'peaks')); % calculate the envelope
end

%% Plot the result
figure
for i = 1:length(mus)
    plot(abs(eall(i,:)))
    hold on
end
set(gca, 'YScale', 'log');
xlabel('Number of adaptation cyckes, n');
ylabel('Error');
title('Convergence in FuLMS algorithm');
hleg = legend({'0.005','0.01', '0.05', '0.1'},'Location','best');
htitle = get(hleg,'Title');
set(htitle,'String','mu');
