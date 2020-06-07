clear
clc
I=double(imread('baboon.tiff')); 
J=imread('DWatermarking.bmp');                     % 32*32
H=double(J);
tempImg=H;
%-----------------------------����ˮӡ--------------------------------------
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
f=CWI;  %����Ԥ����--------------------------------------------------------------
%����ˮӡͼ��f��һ��,�Ա��ڹ�������
m=max(max(f));
f=double(f)./double(m);
%����----------------------------------------------------------------------
attack=4;
switch attack
    case 0,
        attackf=f;
        att='δ����';
    case 1,    
%%1. JPEG ѹ��
 imwrite(f,'attackf.jpg','jpg','quality',90);
 attackf=imread('attackf.jpg');
 attackf=double(attackf)/300;
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
attackf=imnoise(f,'gaussian',0,0.1);
att='��Ӹ�˹����';
    case 9,
%%9. ��������
%attackf=noise(f,'sp',0.05);
attackf=imnoise(f,'salt & pepper',0.1);
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
%f(1:512,256:512)=0;
f(30:100,20:50)=0;
f(250:270,100:250)=0;
f(350:470,400:450)=0;
f(50:100,480:510)=0;
f(80:150,100:350)=0;
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
%��������-----------------------------------------------------------------
f=attackf.*double(m);
figure;
imshow(uint8(f));%title('�ܹ������ˮӡͼ��');%��ʾˮӡǶ��ͼ������Ч��
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
imshow(Y,[]);%title('ˮӡͼ��');
%imwrite(Y,'watermark.bmp','bmp');
NC=nc(Y,J)