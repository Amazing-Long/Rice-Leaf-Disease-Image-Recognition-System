function [outputfile] = bingbantiqu(inputfile) 
    %% ��ȡԭʼͼ��·��
%    inputfile='2_9.jpg';
%    outputfile='2_1.jpg';
    %% ˫���˲�����ɫ�ָ�
        orig_ima=imread(inputfile);
        %%ͳһ��С
        orig_ima=imresize(orig_ima, [512 512]);
        quzao_ima=demo_quzao(orig_ima);
        fenge_ima=BasedColor(quzao_ima);
        outputfile=fenge_ima;
end

%% ������ɫ�����Ĳ��߷ָ��
function fenge_ima=BasedColor(ima)
% ��ȡԭʼͼ������
ima_orig=ima;
%ima_otsu=imread('.\segmentation_secondTestPicture\baiyeku_fenge\1_4.jpg');
%��ȡԭʼ���ݵ�R������G������B�������Լ�ͼ��ĳ�������
r=ima_orig(:,:,1);
g=ima_orig(:,:,2);
b=ima_orig(:,:,3);
row=size(ima_orig,1);
col=size(ima_orig,2);
Pred=zeros(size(ima_orig));
for i=1:row
    for j=1:col
        if(r(i,j)>g(i,j)&&r(i,j)>b(i,j))   %�����ߵ�R��������G������B������ֵʱ����ʾΪ������������Ϊ��ɫ����
            Pred(i,j)=1;
        end
        if Pred(i,j)~=1
            ima_orig(i,j,1)=0;
            ima_orig(i,j,2)=0;
            ima_orig(i,j,3)=0;            
        end
    end
end
se=[0,1,0;1,1,1;0,1,0];
ima_1=imdilate(ima_orig,se);
ima_2=imdilate(ima_1,se);             %ͼ�����ʹ�������
%%�������䷽��ͻ�����ɫ�ķָ���Ĵ��������жԱ�
%subplot(1,3,1);imshow(ima);title('ԭʼͼ��');
%subplot(1,3,2);imshow(ima_otsu);title('�����䷽�����');
%subplot(1,3,3);imshow(ima_2);title('������ɫ�ķָ��');
fenge_ima=ima_2;
end

%% ˫���˲�
function  quzao_ima=demo_quzao(str)
clc;

img = im2double(str);
N = 15;
sigma = [60 , 40];
retimg = bialteral(img , N , sigma );

%subplot(1,3,1);imshow(img);title('ԭ��ͼ��');
%subplot(1,3,2);imshow(retimg);title('��ǿͼ��');

%% s-l
img_copy = rgb2hsv(img);
img_copy3 = log(img_copy(:,:,3));
retimg_copy = rgb2hsv(retimg);
retimg_copy3 = log(retimg_copy(:,:,3));
r_img = img_copy3 - retimg_copy3;
r_img = exp(r_img);
N = 4;
sigma = [60,40];
retinex_img(:,:,3) = bialteral2(r_img,N,sigma);

dim = size(img);
for i = 1:dim(1)
     for j = 1:dim(2)        
         img_copy(i,j,3) = img_copy(i,j,3)^(1/3);         
     end
end
retinex_img(:,:,3) = retinex_img(:,:,3).*(img_copy(:,:,3));
 
retinex_img(:,:,1) = img_copy(:,:,1);
retinex_img(:,:,2) = img_copy(:,:,2);
retinex_img = hsv2rgb(retinex_img);

%% 
% dim = size(img);
% for i = 1:dim(1)
%      for j = 1:dim(2)
%          for c=1:3
%          img(i,j,c) = img(i,j,c)^(1/3);
%          end
%      end
%  end
%         retinex_img(:,:,1) = retinex_img(:,:,1).*(img(:,:,1));
%         retinex_img(:,:,2) = retinex_img(:,:,2).*(img(:,:,2));
%         retinex_img(:,:,3) = retinex_img(:,:,3).*(img(:,:,3));

%subplot(1,3,3);imshow(retinex_img);title('˫���˲����');
quzao_ima=retinex_img;
end  %˫���˲�������

function retimg = bialteral(img ,N ,sigma)
%% ת����ɫ�ռ�
   img = rgb2hsv(img);

%% 
sigma_d = sigma(1);
sigma_r = sigma(2);
[X,Y] = meshgrid(-N:N,-N:N);
D = exp(-(X.^2+Y.^2)/(2*sigma_d^2));
%% create waitbar
h = waitbar(0,'˫���˲�����');
set(h,'Name','˫���˲�');

%% 
dim = size(img);
B = zeros(dim);
for i = 1:dim(1)
    for j = 1:dim(2)
        iMin = max(i-N,1);
        iMax = min(i+N,dim(1));
        jMin = max(j-N,1);
        jMax = min(j+N,dim(2));
        L = img(iMin:iMax,jMin:jMax,3);
        
        d = L-img(i,j,3);
          
        R = exp(-(d.^2)/(2*sigma_r^2));
                
        F = R.*D((iMin:iMax)-i+N+1,(jMin:jMax)-j+N+1);
        for m = 1:iMax-iMin+1
            for n = 1:jMax-jMin+1
                if d(m,n) < 0
                    F(m,n) = 0;
                end
            end
        end
        norm_F = sum(F(:));
        B(i,j,3) = sum(sum(F.*L))/norm_F;

        retimg(i,j,1) = img(i,j,1);
        retimg(i,j,2) = img(i,j,2);
        retimg(i,j,3) = B(i,j,3);
    end
    waitbar(i/dim(1));
end
close(h);

%% 
img = hsv2rgb(img);
retimg = hsv2rgb(retimg);
end  %˫���˲����ú���bialteral

function retimg = bialteral2(img ,N ,sigma)
%% 
sigma_d = sigma(1);
sigma_r = sigma(2);
[X,Y] = meshgrid(-N:N,-N:N); 
D = exp(-(X.^2+Y.^2)/(2*sigma_d^2));

%% create waitbar
h = waitbar(0,'��ȡ���ߡ���');
set(h,'Name','��ȡ����');

%% rang filtering in v layer
dim = size(img);%dim=[height,length,3]
B = zeros(dim);%create an image B with the same size and dimension with the zero value.
for i = 1:dim(1)
    for j = 1:dim(2)
        iMin = max(i-N,1);
        iMax = min(i+N,dim(1));
        jMin = max(j-N,1);
        jMax = min(j+N,dim(2));
        L = img(iMin:iMax,jMin:jMax);%extract the local region
        
        d = L-img(i,j);%the dissimilarity between the surroud and center
        R = exp(-(d.^2)/(2*sigma_r^2));%range filter weights
                
        F = R.*D((iMin:iMax)-i+N+1,(jMin:jMax)-j+N+1);%its row is from iMin-i+N+1 to iMax-i+N+1,and so as line

        norm_F = sum(F(:));
        B(i,j) = sum(sum(F.*L))/norm_F;
        
        retimg(i,j) = B(i,j);
    end
    waitbar(i/dim(1));
end
close(h);%close the bar
end   %˫���˲����ú���bialteral2