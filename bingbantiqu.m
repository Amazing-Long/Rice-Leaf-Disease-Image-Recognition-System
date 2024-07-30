function [outputfile] = bingbantiqu(inputfile) 
    %% 读取原始图像路径
%    inputfile='2_9.jpg';
%    outputfile='2_1.jpg';
    %% 双边滤波和颜色分割
        orig_ima=imread(inputfile);
        %%统一大小
        orig_ima=imresize(orig_ima, [512 512]);
        quzao_ima=demo_quzao(orig_ima);
        fenge_ima=BasedColor(quzao_ima);
        outputfile=fenge_ima;
end

%% 基于颜色特征的病斑分割方法
function fenge_ima=BasedColor(ima)
% 读取原始图像数据
ima_orig=ima;
%ima_otsu=imread('.\segmentation_secondTestPicture\baiyeku_fenge\1_4.jpg');
%读取原始数据的R分量、G分量、B分量，以及图像的长宽数据
r=ima_orig(:,:,1);
g=ima_orig(:,:,2);
b=ima_orig(:,:,3);
row=size(ima_orig,1);
col=size(ima_orig,2);
Pred=zeros(size(ima_orig));
for i=1:row
    for j=1:col
        if(r(i,j)>g(i,j)&&r(i,j)>b(i,j))   %当病斑的R分量大于G分量和B分量数值时，表示为病斑区域，其余为黑色区域
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
ima_2=imdilate(ima_1,se);             %图像膨胀处理两次
%%将最大类间方差法和基于颜色的分割方法的处理结果进行对比
%subplot(1,3,1);imshow(ima);title('原始图像');
%subplot(1,3,2);imshow(ima_otsu);title('最大类间方差法处理');
%subplot(1,3,3);imshow(ima_2);title('基于颜色的分割方法');
fenge_ima=ima_2;
end

%% 双边滤波
function  quzao_ima=demo_quzao(str)
clc;

img = im2double(str);
N = 15;
sigma = [60 , 40];
retimg = bialteral(img , N , sigma );

%subplot(1,3,1);imshow(img);title('原来图像');
%subplot(1,3,2);imshow(retimg);title('增强图像');

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

%subplot(1,3,3);imshow(retinex_img);title('双边滤波结果');
quzao_ima=retinex_img;
end  %双边滤波主函数

function retimg = bialteral(img ,N ,sigma)
%% 转换颜色空间
   img = rgb2hsv(img);

%% 
sigma_d = sigma(1);
sigma_r = sigma(2);
[X,Y] = meshgrid(-N:N,-N:N);
D = exp(-(X.^2+Y.^2)/(2*sigma_d^2));
%% create waitbar
h = waitbar(0,'双边滤波……');
set(h,'Name','双边滤波');

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
end  %双边滤波调用函数bialteral

function retimg = bialteral2(img ,N ,sigma)
%% 
sigma_d = sigma(1);
sigma_r = sigma(2);
[X,Y] = meshgrid(-N:N,-N:N); 
D = exp(-(X.^2+Y.^2)/(2*sigma_d^2));

%% create waitbar
h = waitbar(0,'提取病斑……');
set(h,'Name','提取病斑');

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
end   %双边滤波调用函数bialteral2