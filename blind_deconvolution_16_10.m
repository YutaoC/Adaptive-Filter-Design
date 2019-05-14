% 16.10 b
N = 500;
alpha = 2;
symbol = round(rand(1,N))*2-1;
L=20;
ChL=2;
EqD=round((L+ChL)/2);
Ch=randn(1,ChL+1);
Ch=Ch/norm(Ch);
x=filter(Ch,1,symbol);

K=N-L;
X=zeros(L+1,K);
for i=1:K
    X(:,i)=x(i+L:-1:i).';
end
e=zeros(1,K);
c=zeros(L+1,1); 
c(EqD)=1;
v = zeros(1,K);
R2=1;
mu=0.001;
for i=1:K
   e(i)=(c'*X(:,i))*(R2-(abs(c'*X(:,i)))^2);
   v(i) = e(i) + alpha * (2*rand(1)-1);
   c=c+mu*X(:,i)*alpha*sign(v(i));
   c(EqD)=1;
end   
   
sym=c'*X;
figure;
scatter(sym,e);
xlabel('y(n)');
ylabel('e(n)');