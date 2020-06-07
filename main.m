   clear
clc
%I=double(imread('baboon.tiff'));  % 512*512
%I=double(imread('lena.tiff'));
I=double(imread('man.tiff'));
%figure;
%imhist(uint8(I));
figure;
imshow(uint8(I));title ('ԭͼ��');
J=imread('DWatermarking.bmp');                    % 32*32
H=double(J);
tempImg=H;
%-----------------------------����ˮӡ--------------------------------------
for n=1:6
    for u=1:32
        for v=1:32
            temp=tempImg(u,v);
            ax=mod((u-1)+(v-1),32)+1;
            ay=mod((u-1)+2*(v-1),32)+1;
            outImg(ax,ay)=temp;
        end
    end
    tempImg=outImg;
end
ws2=500;
key1=0.3; key2=0.4;
r1(1)=key1; r2(1)=key2;
u=3.93;
for i=1:ws2-1
    r1(i+1)=u*r1(i)*(1-r1(i));
end
r11=r1(150:181);
for i=1:ws2-1
    r2(i+1)=u*r2(i)*(1-r2(i));
end
r22=r2(250:281);
[sr1,ind1]=sort(r11); [sr2,ind2]=sort(r22); 
na1(ind1,:,:)=outImg;
na2(:,ind2,:)=na1;
G=uint8(na2);
G=double(G);
figure;
imshow(G);
%----------------------------����ԭͼ��-------------------------------------
[LL,HL,LH,HH]=dwt2(I,'haar');
[LL1,HL1,LH1,HH1]=dwt2(LL,'haar');
[LL2,HL2,LH2,HH2]=dwt2(HH1,'haar');
[LL3,HL3,LH3,HH3]=dwt2(LH2,'haar');
HC=dct2(HH3);
[U,S,V]=svd(HC);
[U1,S1,V1]=svd(G);
af=0.15;            %----------qianruqiangdu
S2=S+af*S1;
HC1=U*S2*V';
HC2=idct2(HC1);
WW1=idwt2(LL3,HL3,LH3,HC2,'haar');
WW2=idwt2(LL2,HL2,WW1,HH2,'haar');
WW3=idwt2(LL1,HL1,LH1,WW2,'haar');
WW4=idwt2(WW3,HL,LH,HH,'haar');
CWI11=uint8(WW4);
figure;
imhist(uint8(CWI11));
figure;
imshow(CWI11);
title('ˮӡͼ��');
imwrite(CWI11,'2shuiyin.tif','tif');
%-----------------------------��ȡˮӡ--------------------------------------
watermark_image0=imread('2shuiyin.tif');
watermark_image=double(watermark_image0);
f=watermark_image;
m=max(max(f));
f=double(f)./double(m);
%����----------------------------------------------------------------------
attack=0;
switch attack
    case 0,
        attackf=f;
        att='δ����';
    case 1,    
%%1. JPEG ѹ��
 imwrite(f,'attackf.jpg','jpg','quality',30);
 attackf=imread('attackf.jpg');
 attackf=double(attackf)./double(m);
 att='JPEGѹ��';
    case 2,
% %2. ��˹��ͨ�˲�
%attackf=imnoise(f,'gaussian');
h=fspecial('gaussian',5,0.1);
attackf=filter2(h,f);                  %%%%%%%%%%%%%%%%%%%%%%%%%%
att='��˹��ͨ�˲�';
    case 3,
%%3. ֱ��ͼ���⻯
attackf=histeq(f);
att='ֱ��ͼ���⻯';
    case 4,
%%4. ͼ������
attackf=imadjust(f,[],[0.3,1]);
att='ͼ������';
    case 5,
%%5. ͼ��䰵
attackf=imadjust(f,[],[0,0.85]);
att='ͼ��䰵';
    case 6,
%%6. ���ӶԱȶ�
attackf=imadjust(f,[0.2,0.8],[]);
att='���ӶԱȶ�';
    case 7,
%%7. ���ͶԱȶ�
attackf=imadjust(f,[],[0.2,0.9]);
att='���ͶԱȶ�';
    case 8,
%%8. ��Ӹ�˹����
attackf=imnoise(f,'gaussian',0,0.5);
att='��Ӹ�˹����';
    case 9,
%%9. ��������
%attackf=noise(f,'sp',0.05);
attackf=imnoise(f,'salt & pepper',0.5);
att='��������';
    case 10,
%%10. ��ӳ˻�������
attackf=imnoise(f,'speckle',0.03);
att='��ӳ˻�������';
    case 11,
%%%11.��ֵ�˲�
attackf=medfilt2(f,[3 3]);
att='��ֵ�˲�';
    case 12,
%%%12.����
%f(1:256,256:512)=0;
f(1:512,256:512)=0;
%f(30:100,20:50)=0;
%f(250:270,100:250)=0;
%f(350:470,400:450)=0;
%f(50:100,480:510)=0;
%f(80:150,100:350)=0;
attackf=f;
att='����';
    case 13,
%%%13.��ת
attackf=imrotate(f,10,'bilinear','crop');
att='��ת';
    case 14,
%%%13.�Ŵ�
attackf=imresize(f,2,'nearest');
%k=k*2;
att='�Ŵ�';
    case 15,
%%%13.��С
attackf=imresize(f,0.5,'nearest');
%k=k/2;
att='��С';
end;
%��������-----------------------------------------------------------------
f=attackf.*double(m);
figure;
imshow(uint8(f));title('�ܹ������ˮӡͼ��');%��ʾˮӡǶ��ͼ������Ч��
imwrite(uint8(f),'2f.tif','tif');
f=double(f);
[ll,hl,lh,hh]=dwt2(f,'haar');
[ll1,hl1,lh1,hh1]=dwt2(ll,'haar');
[ll2,hl2,lh2,hh2]=dwt2(hh1,'haar');
[ll3,hl3,lh3,hh3]=dwt2(lh2,'haar');
hc=dct2(hh3);
[U3,S3,V3]=svd(hc);
S4=(S3-S)/af;
Y=U1*S4*V1';
ma1=Y(:,ind2,:);
Y=ma1(ind1,:,:);
for n=1:18
    for u=1:32
        for v=1:32
            temp1=Y(u,v);
            bx=mod((u-1)+(v-1),32)+1;
            by=mod((u-1)+2*(v-1),32)+1;
            outImg1(bx,by)=temp1;
        end
    end
    Y=outImg1;
end
Y=uint8(Y);
figure;
imshow(Y,[]);title('��ȡ��ˮӡ');
imwrite(Y,'2watermark.bmp','bmp');
NC=nc(Y,J)








