%function T=Arnoldp(N);
% 计算Arnold变换的周期
N=32;
C=[1,1;8,9];
[x,y]=meshgrid(1:N);
P0=[x(:)';y(:)'];
P1=[x(:)';y(:)'];
for k=1:N^2/2+1;
    P1=rem(C*P1-1,N)+1;
    s=max(max(abs(P1-P0)));
    if s<1;
        T=k
        break;
    end
end