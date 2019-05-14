%% 16.9 a
N = 500; % number of bits to be sent
symbol_r = round(rand(1,N))*2-1; % generate the bitstream
symbol_i = round(rand(1,N))*2-1; % generate the bitstream
symbol = symbol_r + 1i * symbol_i;
L=20; % smoothing length L+1
ChL=2;  % length of the channel= ChL+1
EqD=round((L+ChL)/2);  %  channel equalization delay
Ch=randn(1,ChL+1)+1i*randn(1,ChL+1);
Ch=Ch/norm(Ch);% normalize
x=filter(Ch,1,symbol); %channel distortion

%estimation using CMA
K=N-L;   % Discard initial samples for avoiding 0's and negative
X=zeros(L+1,K);  %each vector
for i=1:K
    X(:,i)=x(i+L:-1:i).';
end
e_r=zeros(1,K);  % to store the error signal
e_i=zeros(1,K);  % to store the error signal
c_r=zeros(L+1,1); c_r(EqD)=1;    % initial condition
c_i=zeros(L+1,1); c_i(EqD)=1;    % initial condition
e = e_r + 1i*e_i;
c = c_r + 1i*c_i;
R2=2;                  % constant modulous of QPSK symbols
mu=0.001;      % step size
for i=1:K
   e(i)=(c'*X(:,i))*(R2-abs((c'*X(:,i)))^2);
   c=c+mu*(conj(e(i))*X(:,i));
   c(EqD)=1+1i;
%    y = c'*X(:,i);
%    e_r(i)=real(y)*(R2-(real(y))^2-(imag(y))^2);
%    e_i(i)=imag(y)*(R2-(real(y))^2-(imag(y))^2);
%    c_r=c_r+mu*(e_r(i)*real(X(:,i))-e_i(i)*imag(X(:,i)));
%    c_i=c_i+mu*(e_r(i)*imag(X(:,i))-e_i(i)*real(X(:,i)));
%    c_r(EqD)=1;
%    c_i(EqD)=1;
%    c = c_r + 1i*c_i;
end   
   
sym_r=real(c'*X);   % symbol estimation
sym_i=imag(c'*X);   % symbol estimation
figure;
scatter(sym_r,real(e));
title('real part')
xlabel('y(n)')
ylabel('e(n)')
figure;
scatter(sym_i,imag(e));
title('imaginary part')
xlabel('y(n)')
ylabel('e(n)')

%% 16.9 b
N = 500; % number of bits to be sent
symbol_r = round(rand(1,N))*2-1; % generate the bitstream
symbol_i = round(rand(1,N))*2-1; % generate the bitstream
symbol = symbol_r + 1i * symbol_i;
L=20; % smoothing length L+1
ChL=2;  % length of the channel= ChL+1
EqD=round((L+ChL)/2);  %  channel equalization delay
Ch=randn(1,ChL+1)+1i*randn(1,ChL+1);
Ch=Ch/norm(Ch);% normalize
x=filter(Ch,1,symbol); %channel distortion

%estimation using CMA
K=N-L;   %% Discard initial samples for avoiding 0's and negative
X=zeros(L+1,K);  %each vector
for i=1:K
    X(:,i)=x(i+L:-1:i).';
end
e_r=zeros(1,K);  % to store the error signal
e_i=zeros(1,K);  % to store the error signal
e = e_r + 1i*e_i;
c_r=zeros(L+1,1); c_r(EqD)=1;    % initial condition
c_i=zeros(L+1,1); c_i(EqD)=1;    % initial condition
c = c_r + 1i*c_i;
R2=1;                  % constant modulous of QPSK symbols
mu=0.001;      % step size
for i=1:K
   e(i)=(c'*X(:,i))*(R2-abs((c'*X(:,i)))^2);
   e_r = sign(real(e(i)));
   e_i = sign(imag(e(i)));
   e(i) = e_r + 1i*e_i;
   c=c+mu*(conj(e(i))*X(:,i));
   c(EqD)=1+1i;
%    y = c'*X(:,i);
%    e_r(i)=sign(real(y)*(R2-(real(y))^2-(imag(y))^2));
%    e_i(i)=sign(imag(y)*(R2-(real(y))^2-(imag(y))^2));
%    c_r=c_r+mu*(e_r(i)*real(X(:,i))-e_i(i)*imag(X(:,i)));
%    c_i=c_i+mu*(e_r(i)*imag(X(:,i))-e_i(i)*real(X(:,i)));
%    c_r(EqD)=1;
%    c_i(EqD)=1;
%    c = c_r + 1i*c_i;
end   
   
sym_r=real(c'*X);   % symbol estimation
sym_i=imag(c'*X);   % symbol estimation
figure;
scatter(sym_r,real(e));
hold on;
line([-1 -1], ylim);
line([0 0], ylim);
line([1 1], ylim);
title('real part')
xlabel('y(n)')
ylabel('e(n)')
figure;
scatter(sym_i,imag(e));
hold on;
line([-1 -1], ylim);
line([0 0], ylim);
line([1 1], ylim);
title('imaginary part')
xlabel('y(n)')
ylabel('e(n)')