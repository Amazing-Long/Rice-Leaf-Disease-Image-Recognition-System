% 提取22维颜色特征向量
function Hist = getHsvHist(Image)
[M,N,O] = size(Image);
if O~= 3
    error('必须为彩色图');
end
[h,s,v] = rgb2hsv(Image);
H = h; S = s; V = v;
h = h*360;

%将hsv空间非等间隔量化：
%  h量化成7级；
%  s量化成3级；
%  v量化成2级；
for i = 1:M
    for j = 1:N
        if h(i,j)<=22||h(i,j)>330
            H(i,j) = 0;
        end
        if h(i,j)<=45&&h(i,j)>22
            H(i,j) = 1;
        end
        if h(i,j)<=70&&h(i,j)>45
            H(i,j) = 2;
        end
        if h(i,j)<=155&&h(i,j)>70
            H(i,j) = 3;
        end
        if h(i,j)<=186&&h(i,j)>155
            H(i,j) = 4;
        end
        if h(i,j)<=278&&h(i,j)>186
            H(i,j) = 5;
        end
        if h(i,j)<=330&&h(i,j)>278
            H(i,j) = 6;
        end
    end
end
for i = 1:M
    for j = 1:N
        if s(i,j)<=0.2&&s(i,j)>=0
            S(i,j) = 0;
        end
        if s(i,j)<=0.65&&s(i,j)>0.2
            S(i,j) = 1;
        end
        if s(i,j)<=1&&s(i,j)>0.65
            S(i,j) = 2;
        end
       
    end
end
for i = 1:M
    for j = 1:N
        if v(i,j)<=0.2&&v(i,j)>=0
            V(i,j) = 0;
        end
        if v(i,j)<=1&&v(i,j)>0.2
            V(i,j) = 1;
        end
    end
end

%将三个颜色分量合成为一维特征向量：L = 3H+S+V； L取值范围[0,21]
l=zeros(M,N);
for  i = 1:M
    for j = 1:N
        l(i,j) = H(i,j)*3+S(i,j)+V(i,j);
    end
end

%计算特征向量Hist
Hist=zeros(1,22);
for i=0:21 
    Hist(i+1) = size(find(l==i),1);
end 
%特征向量归一化处理 
Hist=Hist./sum(Hist);
%plot(1),bar(Hist),title('HSV非均匀量化直方图')


