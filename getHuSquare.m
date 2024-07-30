% ��ȡ7ά��״��������
function result = getHuSquare( oriImg )
[a,b,~] = size(oriImg);
 
 
% ͼ��ҶȻ�
 
grayImg = rgb2gray(oriImg);
 
 
% canny��Ե�����ȡ��Ե,������Ե�Ҷ�ͼ��
edgeImg = edge( grayImg, 'canny' );
zerosIndex =  edgeImg==0 ;
grayImg(zerosIndex)=0;
 
% ͼ���ֵ��
bwImg = zeros( a,b );
level = graythresh(grayImg);
thresh = level*255;
onesIndex =  grayImg>=thresh ;
bwImg(onesIndex) = 1;
 
 
%% ����ͼ������
 
m00 = sum( sum(bwImg) );  % ��׾�
m01 = 0;                  % һ�׾صĳ�ֵ
m10 = 0;                  % һ�׾صĳ�ֵ
for i = 1:a
    for j = 1:b
        m01 = bwImg(i,j)*j + m01;
        m10 = bwImg(i,j)*i + m10;
    end
end
I = m10/m00;
J = m01/m00;
 
% ����ͼ�����ľ�
u11 = 0;
u20 = 0; u02 = 0;
u30 = 0; u03 = 0;
u12 = 0; u21 = 0;
for i = 1:a
    for j = 1:b
        u11 = bwImg(i, j)*(i-I)*(j-J) + u11;
        u20 = bwImg(i, j)*(i-I)^2 + u20;
        u02 = bwImg(i, j)*(j-J)^2 + u02;
        u30 = bwImg(i, j)*(i-I)^3 + u30;
        u03 = bwImg(i, j)*(j-J)^3 + u03;
        u21 = bwImg(i, j)*(i-I)^2*(j-J) + u21;
        u12 = bwImg(i, j)*(i-I)*(j-J)^2 + u12;
    end
end
u20 = u20/(m00^2);
u02 = u02/(m00^2);
u11 = u11/(m00^2);
u30 = u30/(m00^(5/2));
u03 = u03/(m00^(5/2));
u12 = u12/(m00^(5/2));
u21 = u21/(m00^(5/2));
 
% 7��Hu�����
result(1) = u20 + u02;
result(2) = (u20-u02)^2 + 4*u11^2;
result(3) = (u30-3*u12)^2 + (3*u21-u03)^2;
result(4) = (u30+u12)^2 + (u21+u03)^2;
result(5) = (u30-3*u12)*(u30+u12)*( (u30+u12)^2-3*(u21+u03)^2 ) + ...
       (3*u21-u03)*(u21+u03)*( 3*(u30+u12)^2-(u21+u03)^2 );
result(6) = (u20-u02)*( (u30+u12)^2-(u21+u03)^2 ) + 4*u11*(u30+u12)*(u21+u03);
result(7) = (3*u21-u03)*(u21+u03)*( (u30+u12)^2-3*(u21+u03)^2 ) - ...
       (u30-3*u12)*(u21+u03)*( 3*(u30+u12)^2-(u21+u03)^2 );
 
% �������ٺ���ɫ�������ٲ�࣬�ʲ����й�һ������
end


