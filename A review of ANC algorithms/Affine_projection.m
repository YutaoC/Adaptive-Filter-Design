%% AP algorithm
function [w,y] = Affine_projection( u,d,m,e,p,N )
% make sure the shape
s=size(u); if s(1)>s(2), u=u.'; end
s=size(d); if s(1)>s(2), d=d.'; end
w=zeros(N,1); % weight vector
uLen = length(u); % input length
y = zeros(1,uLen); % output signal
Ui = zeros(p,N); 
for i=1:uLen
    Ui(2:p,:) = Ui(1:p-1,:);
    Ui(1,:) = [ u(i:-1:max(i-N+1,1)),zeros(1,N-i) ];
    di = transpose([ d(i:-1:max(i-p+1,1)),zeros(1,p-i) ]);
    Yi = Ui*w;
    y(i) = Yi(1);
    w = w + m*Ui'*inv(e*eye(p)+Ui*Ui')*(di-Yi);
end
