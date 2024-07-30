function CNNFeature = getCNNFeature(Image)
layer_c1_num=20;
layer_s1_num=20;
layer_f1_num=100;
layer_output_num=16;
%权值调整步进
yita=0.01;
%bias初始化
bias_c1=(2*rand(1,20)-ones(1,20))/sqrt(20);
bias_f1=(2*rand(1,100)-ones(1,100))/sqrt(20);
%卷积核初始化
[kernel_c1,kernel_f1]=init_kernel(layer_c1_num,layer_f1_num);
%pooling核初始化
pooling_a=ones(2,2)/4;
%全连接层的权值
weight_f1=(2*rand(20,100)-ones(20,100))/sqrt(20);
weight_output=(2*rand(100,16)-ones(100,16))/sqrt(100);
% disp('网络初始化完成......');
%% 开始网络训练
% disp('开始抽取CNN特征......');
        %读取样本
        train_data=Image;
        train_data=rgb2gray(train_data);
        train_data=double(train_data);
        % 去均值
%       train_data=wipe_off_average(train_data);
        %前向传递,进入卷积层1
        for k=1:layer_c1_num
            state_c1(:,:,k)=convolution(train_data,kernel_c1(:,:,k));
            %进入激励函数
            state_c1(:,:,k)=tanh(state_c1(:,:,k)+bias_c1(1,k));
            %进入pooling1
            state_s1(:,:,k)=pooling(state_c1(:,:,k),pooling_a);
        end
        %进入f1层
        [state_f1_pre,state_f1_temp]=convolution_f1(state_s1,kernel_f1,weight_f1);
        %进入激励函数
        for nn=1:layer_f1_num
            state_f1(1,nn)=tanh(state_f1_pre(:,:,nn)+bias_f1(1,nn));
        end
        %进入softmax层
        for nn=1:layer_output_num
            output(1,nn)=exp(state_f1*weight_output(:,nn))/sum(exp(state_f1*weight_output));
        end
        CNNFeature=output;