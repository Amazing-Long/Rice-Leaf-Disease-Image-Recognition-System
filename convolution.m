function [state]=convolution(data,kernel)
%实现卷积层操作
[data_row,data_col]=size(data);
[kernel_row,kernel_col]=size(kernel);
for m=1:data_col-kernel_col+1
    for n=1:data_row-kernel_row+1
        state(m,n)=sum(sum(data(m:m+kernel_row-1,n:n+kernel_col-1).*kernel));
    end
end
end
