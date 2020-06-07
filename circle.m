function [P1 P2]=circle(x,y,N)
P1=zeros(N,N);
P2=zeros(N,N);
P1(1,:)=y;
P2(1,:)=x;
nabda1=2;
nabda2=3;
for i=2:N
    P1(i,1)=nabda1*P1(i-1,N);
    P1(i,2:N)=P1(i-1,1:N-1);
    P2(i,1)=nabda2*P2(i-1,N);
    P2(i,2:N)=P2(i-1,1:N-1);
end
    