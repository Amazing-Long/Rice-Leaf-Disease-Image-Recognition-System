function [kernel_c1,kernel_f1]=init_kernel(layer_c1_num,layer_f1_num)
%% ¾í»ıºË³õÊ¼»¯
for n=1:layer_c1_num
    kernel_c1(:,:,n)=(2*rand(5,5)-ones(5,5))/12;
end
for n=1:layer_f1_num
    kernel_f1(:,:,n)=(2*rand(254,254)-ones(254,254));
end
end
