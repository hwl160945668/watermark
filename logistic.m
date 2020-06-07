function [x y]=logistic(x0,y0,N);
%x0=0.2;
%y0=0.2;
%N=256;
x(1)=x0;
y(1)=y0;
mu1=3.1457;
mu2=2.7842;
gama1=0.19;
gama2=0.14;
for i=1:N-1
    x(i+1)=mu1*x(i)*(1-x(i))+gama1*y(i);
    %x(i+1)=mu1*x(i)*(1-x(i));
   y(i+1)=mu2*y(i)*(1-y(i))+gama2*(x(i)^2+x(i)*y(i));
    %y(i+1)=mu2*y(i)*(1-y(i));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%
%clc;
%clear;
%x0=0.65;
%y0=0.88;
%x(1)=x0;
%y(1)=y0;
%b=1:0.001:2;
%for j=1:length(b)
%gama=b(j);
%N=10000;
%for i=1:N
%    x(i+1)=gama*(3*y(i)+1)*x(i)*(1-x(i));
%    y(i+1)=gama*(3*x(i+1)+1)*y(i)*(1-y(i));
%end
%end

%%%%%%%%%%%%%%%%%%%%%%


