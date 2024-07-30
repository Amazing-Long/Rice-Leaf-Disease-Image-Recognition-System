clc;
clear all;
close all;
tic
fprintf('-----�ѿ�ʼ��ȴ�-----\n\n');

%%ʹ��ȫ��10ά
% ѵ������
% train_baiyeku=xlsread('.\��new��CCA�ں���������(��׼������)\baiyekuTrain.xlsx',1,'C2:L2001');
% train_daowenbing=xlsread('.\��new��CCA�ں���������(��׼������)\daowenbingTrain.xlsx',1,'C2:L2001');
% train_humaban=xlsread('.\��new��CCA�ں���������(��׼������)\humabanTrain.xlsx',1,'C2:L2001');

% % ��������
% test_baiyeku=xlsread('.\��new��CCA�ں���������(��׼������)\baiyekuTest.xlsx',1,'C2:L501');
% test_baiyeku_label=xlsread('.\��new��CCA�ں���������(��׼������)\baiyekuTest.xlsx',1,'B2:B501');
% test_daowenbing=xlsread('.\��new��CCA�ں���������(��׼������)\daowenbingTest.xlsx',1,'C2:L501');
% test_daowenbing_label=xlsread('.\��new��CCA�ں���������(��׼������)\daowenbingTest.xlsx',1,'B2:B501');
% test_humaban=xlsread('.\��new��CCA�ں���������(��׼������)\humabanTest.xlsx',1,'C2:L501');
% test_humaban_label=xlsread('.\��new��CCA�ں���������(��׼������)\humabanTest.xlsx',1,'B2:B501');
% 
% %ʹ��6ά
% %ѵ������
% train_baiyeku=xlsread('.\��new��CCA�ں���������(��׼������)\baiyekuTrain.xlsx',1,'C2:H2001');
% train_daowenbing=xlsread('.\��new��CCA�ں���������(��׼������)\daowenbingTrain.xlsx',1,'C2:H2001');
% train_humaban=xlsread('.\��new��CCA�ں���������(��׼������)\humabanTrain.xlsx',1,'C2:H2001');
% 
% % ��������
% test_baiyeku=xlsread('.\��new��CCA�ں���������(��׼������)\baiyekuTest.xlsx',1,'C2:H501');
% test_baiyeku_label=xlsread('.\��new��CCA�ں���������(��׼������)\baiyekuTest.xlsx',1,'B2:B501');
% test_daowenbing=xlsread('.\��new��CCA�ں���������(��׼������)\daowenbingTest.xlsx',1,'C2:H501');
% test_daowenbing_label=xlsread('.\��new��CCA�ں���������(��׼������)\daowenbingTest.xlsx',1,'B2:B501');
% test_humaban=xlsread('.\��new��CCA�ں���������(��׼������)\humabanTest.xlsx',1,'C2:H501');
% test_humaban_label=xlsread('.\��new��CCA�ں���������(��׼������)\humabanTest.xlsx',1,'B2:B501');

% %ʹ��ֱ���ں�
%ѵ������
train_baiyeku=xlsread('4CCA�ں�����(ԭʼ����).xlsx',1,'C1:D2000');
train_daowenbing=xlsread('4CCA�ں�����(ԭʼ����).xlsx',1,'C2501:D4500');
train_humaban=xlsread('4CCA�ں�����(ԭʼ����).xlsx',1,'C5001:D7000');

% ��������
test_baiyeku=xlsread('4CCA�ں�����(ԭʼ����).xlsx',1,'C2001:D2500');
test_baiyeku_label=xlsread('4CCA�ں�����(ԭʼ����).xlsx',1,'B2001:B2500');
test_daowenbing=xlsread('4CCA�ں�����(ԭʼ����).xlsx',1,'C4501:D5000');
test_daowenbing_label=xlsread('4CCA�ں�����(ԭʼ����).xlsx',1,'B4501:B5000');
test_humaban=xlsread('4CCA�ں�����(ԭʼ����).xlsx',1,'C7001:D7500');
test_humaban_label=xlsread('4CCA�ں�����(ԭʼ����).xlsx',1,'B7001:B7500');

%ʹ��ԭʼͼƬֱ���ں�
%ѵ������
% train_baiyeku=xlsread('newOriginalFeature.xlsx',1,'C1:AT11');
% train_daowenbing=xlsread('newOriginalFeature.xlsx',1,'C12:AT21');
% train_humaban=xlsread('newOriginalFeature.xlsx',1,'C22:AT30');
% 
% % ��������
% test_baiyeku=xlsread('newOriginalFeature.xlsx',1,'C1:AT11');
% test_baiyeku_label=xlsread('newOriginalFeature.xlsx',1,'B1:B11');
% test_daowenbing=xlsread('newOriginalFeature.xlsx',1,'C12:AT21');
% test_daowenbing_label=xlsread('newOriginalFeature.xlsx',1,'B12:B21');
% test_humaban=xlsread('newOriginalFeature.xlsx',1,'C22:AT30');
% test_humaban_label=xlsread('newOriginalFeature.xlsx',1,'B22:B30');

% �������ݻ���
test_features=[test_baiyeku;test_daowenbing;test_humaban];
% ����������ʵ��ǩ����
test_labels = [test_baiyeku_label;test_daowenbing_label;test_humaban_label];
                  

%%
% ѵ�����ݷ�Ϊ3��
% ���i�� ������ ѡ�����i��ȫ���������� ��������������ѡ�񣨸���Ϊ��������ͬ��
% ���1:��Ҷ��
baiyeku_p = train_baiyeku;
number_p=size(train_baiyeku,1);
% �������ѵ����������
others=[train_daowenbing;train_humaban];
number_o=size(others,1);
% randperm(n,k)�Ǵ�1��n��������������k��
index1 = randperm(number_o,number_p);
% ���������������ѡ��k��
baiyeku_n = others(index1,:);

train_bai = [baiyeku_p;baiyeku_n];
% �����ʾΪ1�������ʾΪ-1
train_bai_label = [ones(number_p,1);-1*ones(number_p,1)];

% ���2:������
daowenbing_p = train_daowenbing;
number_p=size(train_daowenbing,1);
% �������ѵ����������
others=[train_baiyeku;train_humaban];
number_o=size(others,1);
% randperm(n,k)�Ǵ�1��n��������������k��
index1 = randperm(number_o,number_p);
% ���������������ѡ��k��
daowenbing_n = others(index1,:);

train_dao = [daowenbing_p;daowenbing_n];
% �����ʾΪ1�������ʾΪ-1
train_dao_label = [ones(number_p,1);-1*ones(number_p,1)];

% ���3:�����
humaban_p = train_humaban;
number_p=size(train_humaban,1);
% �������ѵ����������
others=[train_baiyeku;train_daowenbing];
number_o=size(others,1);
% randperm(n,k)�Ǵ�1��n��������������k��
index1 = randperm(number_o,number_p);
% ���������������ѡ��k��
humaban_n = others(index1,:);

train_hu = [humaban_p;humaban_n];
% �����ʾΪ1�������ʾΪ-1
train_hu_label = [ones(number_p,1);-1*ones(number_p,1)];

%
%�ֱ�ѵ��3������SVMģ��
%OptimizeHyperparameters�������Ż�
% model_baiyeku = fitcsvm(train_bai,train_bai_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','OptimizeHyperparameters',{'BoxConstraint','KernelScale'},'HyperparameterOptimizationOptions',struct('ShowPlots',false) );
% model_daowenbing = fitcsvm(train_dao,train_dao_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','OptimizeHyperparameters',{'BoxConstraint','KernelScale'},'HyperparameterOptimizationOptions',struct('ShowPlots',false));
% model_humaban = fitcsvm(train_hu,train_hu_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','OptimizeHyperparameters',{'BoxConstraint','KernelScale'} ,'HyperparameterOptimizationOptions',struct('ShowPlots',false));
% fprintf('-----ģ��ѵ�����-----\n\n');


% % % % ����ѵ���õ�����ģ�͵�BoxConstraint��KernelScale��������������
model_baiyeku = fitcsvm(train_bai,train_bai_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','BoxConstraint', 3.71826944713741,'KernelScale',  0.473812982562996);
model_daowenbing = fitcsvm(train_dao,train_dao_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','BoxConstraint', 12.7016070067197 ,'KernelScale',0.360670302805846);
model_humaban = fitcsvm(train_hu,train_hu_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','BoxConstraint',8.81864834274725      ,'KernelScale',0.260815633743261);
fprintf('-----ģ��ѵ�����-----\n\n');

%%
% �ֱ𱣴�3��SVMģ��
% saveCompactModel(model_baiyeku,'SVM_baiyeku5.mat');
% saveCompactModel(model_daowenbing,'SVM_daowenbing5.mat');
% saveCompactModel(model_humaban,'SVM_humaban5.mat');
save('SVM_baiyeku7.mat', 'model_baiyeku');
save('SVM_daowenbing7.mat', 'model_daowenbing');
save('SVM_humaban7.mat', 'model_humaban');
fprintf('-----ģ�ͱ������-----\n\n');
%%
% label��n*1�ľ���ÿһ���Ƕ�Ӧ����������Ԥ���ǩ��
% score��n*2�ľ��󣬵�һ��ΪԤ��Ϊ�������ĵ÷֣��ڶ���ΪԤ��Ϊ�������ĵ÷֡�
% ��ѵ���õ�3��SVMģ�ͷֱ�Բ�����������Ԥ����࣬�õ�3��Ԥ���ǩ
[predict_baiyeku,score_baiyeku] = predict(model_baiyeku,test_features);
[predict_daowenbing,score_daowenbing] = predict(model_daowenbing,test_features);
[predict_humaban,score_humaban] = predict(model_humaban,test_features);

% �������������3��ģ����Ԥ��Ϊ�������÷ֵ����ֵ����Ϊ�ò�������������Ԥ���ǩ
score = [score_baiyeku(:,2),score_daowenbing(:,2),score_humaban(:,2)];
% ����Ԥ���ǩ
final_labels = zeros(size(test_features,1),1);
for i = 1:size(final_labels,1)
    % ����ÿһ�е����ֵ����λ��
    [m,p] = max(score(i,:));
    % λ�ü�Ϊ��ǩ
    final_labels(i,:) = p;
end
fprintf('-----����Ԥ�����-----\n\n');
% ��������ָ��

group = test_labels; % ��ʵ��ǩ
grouphat = final_labels; % Ԥ���ǩ

% CΪ��������C(i,j)��ʾ��g1�е�i������g2�б�����j��ĸ���������ʵ��ǩ���ֵ��Ĳ��Ա�ǩ
[C,order] = confusionmat(group,grouphat,'Order',[1;2;3]); % 'Order'ָ������˳��

c1_p = C(1,1) / sum(C(:,1));
c1_r = C(1,1) / sum(C(1,:));
c1_F = 2*c1_p*c1_r / (c1_p + c1_r);
fprintf('��Ҷ����Ĳ�׼��Ϊ%f,��ȫ��Ϊ%f,F���Ϊ%f\n\n',c1_p,c1_r,c1_F);

c2_p = C(2,2) / sum(C(:,2));
c2_r = C(2,2) / sum(C(2,:));
c2_F = 2*c2_p*c2_r / (c2_p + c2_r);
fprintf('��������Ĳ�׼��Ϊ%f,��ȫ��Ϊ%f,F���Ϊ%f\n\n',c2_p,c2_r,c2_F);

c3_p = C(3,3) / sum(C(:,3));
c3_r = C(3,3) / sum(C(3,:));
c3_F = 2*c3_p*c3_r / (c3_p + c3_r);
fprintf('�������Ĳ�׼��Ϊ%f,��ȫ��Ϊ%f,F���Ϊ%f\n\n',c3_p,c3_r,c3_F);

c_p=(C(1,1)+C(2,2)+C(3,3))/size(test_features,1);
fprintf('��ʶ��׼ȷ��Ϊ%f\n',c_p);



