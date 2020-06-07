clear
clc
I=double(imread('baboon.tiff')); 
J=imread('DWatermarking.bmp');                     % 32*32
H=double(J);
tempImg=H;
%-----------------------------置乱水印--------------------------------------
for n=1:5
    for u=1:32
        for v=1:32
            temp=tempImg(u,v);
            ax=mod((u-1)+(v-1),32)+1;
            ay=mod(8*(u-1)+9*(v-1),32)+1;
            outImg(ax,ay)=temp;
        end
    end
    tempImg=outImg;
end
G=uint8(outImg);
G=double(G);
figure;
imshow(G); 
[LL1,HL1,LH1,HH1]=dwt2(I,'haar');
[LL2,HL2,LH2,HH2]=dwt2(LL1,'haar');
[LL3,HL3,LH3,HH3]=dwt2(HH2,'haar');
[LL4,HL4,LH4,HH4]=dwt2(LH3,'haar');
k=0.2;
M=HH4+k*G;
W1=idwt2(LL4,HL4,LH4,M,'haar');
W2=idwt2(LL3,HL3,W1,HH3,'haar');
W3=idwt2(LL2,HL2,LH2,W2,'haar');
W4=idwt2(W3,HL1,LH1,HH1,'haar');
CWI=uint8(W4);
figure;
imshow(CWI,[]);
%------------------------------jiemi---------------------------------------
f=CWI;  %攻击预处理--------------------------------------------------------------
%将含水印图像f归一化,以便于攻击处理。
m=max(max(f));
f=double(f)./double(m);
%攻击----------------------------------------------------------------------
attack=4;
switch attack
    case 0,
        attackf=f;
        att='未攻击';
    case 1,    
%%1. JPEG 压缩
 imwrite(f,'attackf.jpg','jpg','quality',90);
 attackf=imread('attackf.jpg');
 attackf=double(attackf)/300;
 att='JPEG压缩';
    case 2,
% %2. 高斯低通滤波
%attackf=imnoise(f,'gaussian');
h=fspecial('gaussian',5,0.1);
attackf=filter2(h,f);                  %%%%%%%%%%%%%%%%%%%%%%%%%%
att='高斯低通滤波';
    case 3,
%%3. 直方图均衡化
attackf=histeq(f);
att='直方图均衡化';
    case 4,
%%4. 图像增亮
attackf=imadjust(f,[],[0.3,1]);
att='图像增亮';
    case 5,
%%5. 图像变暗
attackf=imadjust(f,[],[0,0.85]);
att='图像变暗';
    case 6,
%%6. 增加对比度
attackf=imadjust(f,[0.2,0.8],[]);
att='增加对比度';
    case 7,
%%7. 降低对比度
attackf=imadjust(f,[],[0.2,0.9]);
att='降低对比度';
    case 8,
%%8. 添加高斯噪声
attackf=imnoise(f,'gaussian',0,0.1);
att='添加高斯噪声';
    case 9,
%%9. 椒盐噪声
%attackf=noise(f,'sp',0.05);
attackf=imnoise(f,'salt & pepper',0.1);
att='椒盐噪声';
    case 10,
%%10. 添加乘积性噪声
attackf=imnoise(f,'speckle',0.03);
att='添加乘积性噪声';
    case 11,
%%%11.中值滤波
attackf=medfilt2(f,[3 3]);
att='中值滤波';
    case 12,
%%%12.剪切
%f(1:256,256:512)=0;
%f(1:512,256:512)=0;
f(30:100,20:50)=0;
f(250:270,100:250)=0;
f(350:470,400:450)=0;
f(50:100,480:510)=0;
f(80:150,100:350)=0;
attackf=f;
att='剪切';
    case 13,
%%%13.旋转
attackf=imrotate(f,10,'bilinear','crop');
att='旋转';
    case 14,
%%%13.放大
attackf=imresize(f,2,'nearest');
%k=k*2;
att='放大';
    case 15,
%%%13.缩小
attackf=imresize(f,0.5,'nearest');
%k=k/2;
att='缩小';
end;
%攻击后处理-----------------------------------------------------------------
%攻击后处理-----------------------------------------------------------------
f=attackf.*double(m);
figure;
imshow(uint8(f));%title('受攻击后的水印图像');%显示水印嵌入图攻击后效果
%imwrite(uint8(f),'f.tif','tif');
f=double(f);
[ll1,hl1,lh1,hh1]=dwt2(f,'haar');
[ll2,hl2,lh2,hh2]=dwt2(ll1,'haar');
[ll3,hl3,lh3,hh3]=dwt2(hh2,'haar');
[ll4,hl4,lh4,hh4]=dwt2(lh3,'haar');
k=0.1524;
mm=(hh4-HH4)/k;
Y=double(mm);
for n=1:27
    for u=1:32
        for v=1:32
            temp1=Y(u,v);
            bx=mod((u-1)+(v-1),32)+1;
            by=mod(8*(u-1)+9*(v-1),32)+1;
            outImg1(bx,by)=temp1;
        end
    end
    Y=outImg1;
end

Y=uint8(Y);
imwrite(Y,'watermark.bmp','bmp');
figure;
imshow(Y,[]);%title('水印图像');
%imwrite(Y,'watermark.bmp','bmp');
NC=nc(Y,J)