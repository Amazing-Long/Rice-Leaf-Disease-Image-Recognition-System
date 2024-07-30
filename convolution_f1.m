function [state_f1,state_f1_temp]=convolution_f1(state_s1,kernel_f1,weight_f1)
%% 完成卷积层2操作
layer_f1_num=size(weight_f1,2);
layer_s1_num=size(weight_f1,1);
%%
for n=1:layer_f1_num
    count=0;
    for m=1:layer_s1_num
        temp=state_s1(:,:,m)*weight_f1(m,n);
        count=count+temp;
    end
    state_f1_temp(:,:,n)=count;
    state_f1(:,:,n)=convolution(state_f1_temp(:,:,n),kernel_f1(:,:,n));
end
end
