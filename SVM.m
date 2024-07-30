clc;
clear all;
close all;
tic
fprintf('-----已开始请等待-----\n\n');

%%使用全部10维
% 训练数据
% train_baiyeku=xlsread('.\（new）CCA融合特征参数(标准化数据)\baiyekuTrain.xlsx',1,'C2:L2001');
% train_daowenbing=xlsread('.\（new）CCA融合特征参数(标准化数据)\daowenbingTrain.xlsx',1,'C2:L2001');
% train_humaban=xlsread('.\（new）CCA融合特征参数(标准化数据)\humabanTrain.xlsx',1,'C2:L2001');

% % 测试数据
% test_baiyeku=xlsread('.\（new）CCA融合特征参数(标准化数据)\baiyekuTest.xlsx',1,'C2:L501');
% test_baiyeku_label=xlsread('.\（new）CCA融合特征参数(标准化数据)\baiyekuTest.xlsx',1,'B2:B501');
% test_daowenbing=xlsread('.\（new）CCA融合特征参数(标准化数据)\daowenbingTest.xlsx',1,'C2:L501');
% test_daowenbing_label=xlsread('.\（new）CCA融合特征参数(标准化数据)\daowenbingTest.xlsx',1,'B2:B501');
% test_humaban=xlsread('.\（new）CCA融合特征参数(标准化数据)\humabanTest.xlsx',1,'C2:L501');
% test_humaban_label=xlsread('.\（new）CCA融合特征参数(标准化数据)\humabanTest.xlsx',1,'B2:B501');
% 
% %使用6维
% %训练数据
% train_baiyeku=xlsread('.\（new）CCA融合特征参数(标准化数据)\baiyekuTrain.xlsx',1,'C2:H2001');
% train_daowenbing=xlsread('.\（new）CCA融合特征参数(标准化数据)\daowenbingTrain.xlsx',1,'C2:H2001');
% train_humaban=xlsread('.\（new）CCA融合特征参数(标准化数据)\humabanTrain.xlsx',1,'C2:H2001');
% 
% % 测试数据
% test_baiyeku=xlsread('.\（new）CCA融合特征参数(标准化数据)\baiyekuTest.xlsx',1,'C2:H501');
% test_baiyeku_label=xlsread('.\（new）CCA融合特征参数(标准化数据)\baiyekuTest.xlsx',1,'B2:B501');
% test_daowenbing=xlsread('.\（new）CCA融合特征参数(标准化数据)\daowenbingTest.xlsx',1,'C2:H501');
% test_daowenbing_label=xlsread('.\（new）CCA融合特征参数(标准化数据)\daowenbingTest.xlsx',1,'B2:B501');
% test_humaban=xlsread('.\（new）CCA融合特征参数(标准化数据)\humabanTest.xlsx',1,'C2:H501');
% test_humaban_label=xlsread('.\（new）CCA融合特征参数(标准化数据)\humabanTest.xlsx',1,'B2:B501');

% %使用直接融合
%训练数据
train_baiyeku=xlsread('4CCA融合特征(原始数据).xlsx',1,'C1:D2000');
train_daowenbing=xlsread('4CCA融合特征(原始数据).xlsx',1,'C2501:D4500');
train_humaban=xlsread('4CCA融合特征(原始数据).xlsx',1,'C5001:D7000');

% 测试数据
test_baiyeku=xlsread('4CCA融合特征(原始数据).xlsx',1,'C2001:D2500');
test_baiyeku_label=xlsread('4CCA融合特征(原始数据).xlsx',1,'B2001:B2500');
test_daowenbing=xlsread('4CCA融合特征(原始数据).xlsx',1,'C4501:D5000');
test_daowenbing_label=xlsread('4CCA融合特征(原始数据).xlsx',1,'B4501:B5000');
test_humaban=xlsread('4CCA融合特征(原始数据).xlsx',1,'C7001:D7500');
test_humaban_label=xlsread('4CCA融合特征(原始数据).xlsx',1,'B7001:B7500');

%使用原始图片直接融合
%训练数据
% train_baiyeku=xlsread('newOriginalFeature.xlsx',1,'C1:AT11');
% train_daowenbing=xlsread('newOriginalFeature.xlsx',1,'C12:AT21');
% train_humaban=xlsread('newOriginalFeature.xlsx',1,'C22:AT30');
% 
% % 测试数据
% test_baiyeku=xlsread('newOriginalFeature.xlsx',1,'C1:AT11');
% test_baiyeku_label=xlsread('newOriginalFeature.xlsx',1,'B1:B11');
% test_daowenbing=xlsread('newOriginalFeature.xlsx',1,'C12:AT21');
% test_daowenbing_label=xlsread('newOriginalFeature.xlsx',1,'B12:B21');
% test_humaban=xlsread('newOriginalFeature.xlsx',1,'C22:AT30');
% test_humaban_label=xlsread('newOriginalFeature.xlsx',1,'B22:B30');

% 测试数据汇总
test_features=[test_baiyeku;test_daowenbing;test_humaban];
% 测试数据真实标签汇总
test_labels = [test_baiyeku_label;test_daowenbing_label;test_humaban_label];
                  

%%
% 训练数据分为3类
% 类别i的 正样本 选择类别i的全部，负样本 从其余类别中随机选择（个数为正样本相同）
% 类别1:白叶枯
baiyeku_p = train_baiyeku;
number_p=size(train_baiyeku,1);
% 其余类别训练样本汇总
others=[train_daowenbing;train_humaban];
number_o=size(others,1);
% randperm(n,k)是从1到n的序号中随机返回k个
index1 = randperm(number_o,number_p);
% 从其余样本中随机选择k个
baiyeku_n = others(index1,:);

train_bai = [baiyeku_p;baiyeku_n];
% 正类表示为1，负类表示为-1
train_bai_label = [ones(number_p,1);-1*ones(number_p,1)];

% 类别2:稻瘟病
daowenbing_p = train_daowenbing;
number_p=size(train_daowenbing,1);
% 其余类别训练样本汇总
others=[train_baiyeku;train_humaban];
number_o=size(others,1);
% randperm(n,k)是从1到n的序号中随机返回k个
index1 = randperm(number_o,number_p);
% 从其余样本中随机选择k个
daowenbing_n = others(index1,:);

train_dao = [daowenbing_p;daowenbing_n];
% 正类表示为1，负类表示为-1
train_dao_label = [ones(number_p,1);-1*ones(number_p,1)];

% 类别3:胡麻斑
humaban_p = train_humaban;
number_p=size(train_humaban,1);
% 其余类别训练样本汇总
others=[train_baiyeku;train_daowenbing];
number_o=size(others,1);
% randperm(n,k)是从1到n的序号中随机返回k个
index1 = randperm(number_o,number_p);
% 从其余样本中随机选择k个
humaban_n = others(index1,:);

train_hu = [humaban_p;humaban_n];
% 正类表示为1，负类表示为-1
train_hu_label = [ones(number_p,1);-1*ones(number_p,1)];

%
%分别训练3个类别的SVM模型
%OptimizeHyperparameters超参数优化
% model_baiyeku = fitcsvm(train_bai,train_bai_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','OptimizeHyperparameters',{'BoxConstraint','KernelScale'},'HyperparameterOptimizationOptions',struct('ShowPlots',false) );
% model_daowenbing = fitcsvm(train_dao,train_dao_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','OptimizeHyperparameters',{'BoxConstraint','KernelScale'},'HyperparameterOptimizationOptions',struct('ShowPlots',false));
% model_humaban = fitcsvm(train_hu,train_hu_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','OptimizeHyperparameters',{'BoxConstraint','KernelScale'} ,'HyperparameterOptimizationOptions',struct('ShowPlots',false));
% fprintf('-----模型训练完毕-----\n\n');


% % % % 带入训练好的三个模型的BoxConstraint和KernelScale两个参数并运行
model_baiyeku = fitcsvm(train_bai,train_bai_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','BoxConstraint', 3.71826944713741,'KernelScale',  0.473812982562996);
model_daowenbing = fitcsvm(train_dao,train_dao_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','BoxConstraint', 12.7016070067197 ,'KernelScale',0.360670302805846);
model_humaban = fitcsvm(train_hu,train_hu_label,'ClassNames',{'-1','1'},'Standardize',true,'KernelFunction','rbf','BoxConstraint',8.81864834274725      ,'KernelScale',0.260815633743261);
fprintf('-----模型训练完毕-----\n\n');

%%
% 分别保存3个SVM模型
% saveCompactModel(model_baiyeku,'SVM_baiyeku5.mat');
% saveCompactModel(model_daowenbing,'SVM_daowenbing5.mat');
% saveCompactModel(model_humaban,'SVM_humaban5.mat');
save('SVM_baiyeku7.mat', 'model_baiyeku');
save('SVM_daowenbing7.mat', 'model_daowenbing');
save('SVM_humaban7.mat', 'model_humaban');
fprintf('-----模型保存完毕-----\n\n');
%%
% label是n*1的矩阵，每一行是对应测试样本的预测标签；
% score是n*2的矩阵，第一列为预测为“负”的得分，第二列为预测为“正”的得分。
% 用训练好的3个SVM模型分别对测试样本进行预测分类，得到3个预测标签
[predict_baiyeku,score_baiyeku] = predict(model_baiyeku,test_features);
[predict_daowenbing,score_daowenbing] = predict(model_daowenbing,test_features);
[predict_humaban,score_humaban] = predict(model_humaban,test_features);

% 求出测试样本在3个模型中预测为“正”得分的最大值，作为该测试样本的最终预测标签
score = [score_baiyeku(:,2),score_daowenbing(:,2),score_humaban(:,2)];
% 最终预测标签
final_labels = zeros(size(test_features,1),1);
for i = 1:size(final_labels,1)
    % 返回每一行的最大值和其位置
    [m,p] = max(score(i,:));
    % 位置即为标签
    final_labels(i,:) = p;
end
fprintf('-----样本预测完毕-----\n\n');
% 分类评价指标

group = test_labels; % 真实标签
grouphat = final_labels; % 预测标签

% C为混淆矩阵，C(i,j)表示在g1中的i类数在g2中被分在j类的个数，即真实标签被分到的测试标签
[C,order] = confusionmat(group,grouphat,'Order',[1;2;3]); % 'Order'指定类别的顺序

c1_p = C(1,1) / sum(C(:,1));
c1_r = C(1,1) / sum(C(1,:));
c1_F = 2*c1_p*c1_r / (c1_p + c1_r);
fprintf('白叶枯类的查准率为%f,查全率为%f,F测度为%f\n\n',c1_p,c1_r,c1_F);

c2_p = C(2,2) / sum(C(:,2));
c2_r = C(2,2) / sum(C(2,:));
c2_F = 2*c2_p*c2_r / (c2_p + c2_r);
fprintf('稻瘟病类的查准率为%f,查全率为%f,F测度为%f\n\n',c2_p,c2_r,c2_F);

c3_p = C(3,3) / sum(C(:,3));
c3_r = C(3,3) / sum(C(3,:));
c3_F = 2*c3_p*c3_r / (c3_p + c3_r);
fprintf('胡麻斑类的查准率为%f,查全率为%f,F测度为%f\n\n',c3_p,c3_r,c3_F);

c_p=(C(1,1)+C(2,2)+C(3,3))/size(test_features,1);
fprintf('总识别准确率为%f\n',c_p);



