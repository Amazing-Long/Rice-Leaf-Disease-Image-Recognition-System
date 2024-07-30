function CNNFeature = getCNNFeature(Image)
layer_c1_num=20;
layer_s1_num=20;
layer_f1_num=100;
layer_output_num=16;
%Ȩֵ��������
yita=0.01;
%bias��ʼ��
bias_c1=(2*rand(1,20)-ones(1,20))/sqrt(20);
bias_f1=(2*rand(1,100)-ones(1,100))/sqrt(20);
%����˳�ʼ��
[kernel_c1,kernel_f1]=init_kernel(layer_c1_num,layer_f1_num);
%pooling�˳�ʼ��
pooling_a=ones(2,2)/4;
%ȫ���Ӳ��Ȩֵ
weight_f1=(2*rand(20,100)-ones(20,100))/sqrt(20);
weight_output=(2*rand(100,16)-ones(100,16))/sqrt(100);
% disp('�����ʼ�����......');
%% ��ʼ����ѵ��
% disp('��ʼ��ȡCNN����......');
        %��ȡ����
        train_data=Image;
        train_data=rgb2gray(train_data);
        train_data=double(train_data);
        % ȥ��ֵ
%       train_data=wipe_off_average(train_data);
        %ǰ�򴫵�,��������1
        for k=1:layer_c1_num
            state_c1(:,:,k)=convolution(train_data,kernel_c1(:,:,k));
            %���뼤������
            state_c1(:,:,k)=tanh(state_c1(:,:,k)+bias_c1(1,k));
            %����pooling1
            state_s1(:,:,k)=pooling(state_c1(:,:,k),pooling_a);
        end
        %����f1��
        [state_f1_pre,state_f1_temp]=convolution_f1(state_s1,kernel_f1,weight_f1);
        %���뼤������
        for nn=1:layer_f1_num
            state_f1(1,nn)=tanh(state_f1_pre(:,:,nn)+bias_f1(1,nn));
        end
        %����softmax��
        for nn=1:layer_output_num
            output(1,nn)=exp(state_f1*weight_output(:,nn))/sum(exp(state_f1*weight_output));
        end
        CNNFeature=output;