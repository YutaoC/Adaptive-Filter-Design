%% 16.8 a
N = 500; % number of bits to be sent
symbol = round(rand(1,N))*2-1; % generate the bitstream
L=20; % smoothing length L+1
ChL=1;  % length of the channel= ChL+1
EqD=round((L+ChL)/2);  %  channel equalization delay
Ch=[0.6 0.4 0.7]; %complex channel
Ch=Ch/norm(Ch);% normalize
x=filter(Ch,1,symbol); %channel distortion

%estimation using CMA
K=N-L;   %% Discard initial samples for avoiding 0's and negative
X=zeros(L+1,K);  %each vector
for i=1:K
    X(:,i)=x(i+L:-1:i).';
end
e=zeros(1,K);  % to store the error signal
c=zeros(L+1,1); 
c(EqD)=1;    % initial condition
R2=1;                  % constant modulous of QPSK symbols
mu=0.001;      % step size
for i=1:K
   e(i)=(c'*X(:,i))*(R2-abs(c'*X(:,i))^2);                  % initial error
   c=c+mu*X(:,i)*e(i);     % update equalizer co-efficients
   c(EqD)=1;
end   
   
sym=c'*X;   % symbol estimation
figure;
scatter(sym,e);
xlabel('y(n)');
ylabel('e(n)');

%% 16.8 b
N = 500; % number of bits to be sent
symbol = round(rand(1,N))*2-1; % generate the bitstream
L=20; % smoothing length L+1
ChL=1;  % length of the channel= ChL+1
EqD=round((L+ChL)/2);  %  channel equalization delay
Ch=rand(1,10); %complex channel
Ch=Ch/norm(Ch);% normalize
x=filter(Ch,1,symbol); %channel distortion

%estimation using CMA
K=N-L;   %% Discard initial samples for avoiding 0's and negative
X=zeros(L+1,K);  %each vector
for i=1:K
    X(:,i)=x(i+L:-1:i).';
end
e=zeros(1,K);  % to store the error signal
c=zeros(L+1,1); c(EqD)=1;    % initial condition
R2=1;                  % constant modulous of QPSK symbols
mu=0.001;      % step size
for i=1:K
   e(i)=sign((c'*X(:,i))*(R2-abs(c'*X(:,i))^2));                  % initial error
   c=c+mu*e(i)*X(:,i);     % update equalizer co-efficients
   c(EqD)=1;
end   
   
sym=c'*X;   % symbol estimation
figure;
scatter(sym,e);
hold on;
line([-1 -1], ylim);
line([0 0], ylim);
line([1 1], ylim);
xlabel('y(n)');
ylabel('e(n)');
