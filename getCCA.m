clear all;clc;
file_path = 'CCA';% 图像文件夹路径
img_path_list = dir(fullfile(file_path,'*.jpg'));%获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);%获取图像总数量,即样本数量(训练样本数量和测试样本数量需一致)
half=img_num*2/3;
%预分配内存
name=cell(img_num,1);
biaoqian=zeros(img_num,1);
colorTrain=zeros(half,22);
shapeTrain=zeros(half,7);
textureTrain=zeros(half,15);
CNNTrain=zeros(half,16);
colorTest=zeros(half/2,22);
shapeTest=zeros(half/2,7);
textureTest=zeros(half/2,15);
CNNTest=zeros(half/2,16);

if img_num > 0 %有满足条件的图像
        parfor i = 1:half %逐一读取训练图像
            sample_name = img_path_list(i).name;% 图像名
            name{i,1} = sample_name;
            biaoqian(i,1)=str2num(sample_name(1));
            sample =  imread([file_path,'\',sample_name]);
            
%             sample=tiqubingban(sample);
%             imwrite(sample,sample_name);
            
            fprintf('%d %s\n',i,strcat(file_path,sample_name));% 显示正在处理的图像名
            %图像处理过程 
            
%             sample=imread(sample_name);
            
            colorTrainTemp=getHsvHist(sample);
            shapeTrainTemp=getHuSquare(sample);
            textureTrainTemp=getwenli2(sample);
            CNNTrainTemp=getCNNFeature(sample);
            colorTrain(i,:)=colorTrainTemp;
            shapeTrain(i,:)=shapeTrainTemp;
            textureTrain(i,:)=textureTrainTemp;
            CNNTrain(i,:)=CNNTrainTemp;
        end
        parfor j = 1:half/2 %逐一读取测试图像
            test_name = img_path_list(half+j).name;% 图像名
            name{half+j,1} = test_name;
            biaoqian(half+j,1)=str2num(test_name(1));
            
%             test =  imread([file_path,'\',test_name]);
%             test=tiqubingban(test);
            
            imwrite(test,test_name);
            fprintf('%d %s\n',half+j,strcat(file_path,test_name));% 显示正在处理的图像名
            %图像处理过程 
            
%             test=imread(test_name);
            
            colorTestTemp=getHsvHist(test);
            shapeTestTemp=getHuSquare(test);
            textureTestTemp=getwenli2(test);
            CNNTestTemp=getCNNFeature(test);
            colorTest(j,:)=colorTestTemp;
            shapeTest(j,:)=shapeTestTemp;
            textureTest(j,:)=textureTestTemp;
            CNNTest(j,:)=CNNTestTemp;
        end
end
% 颜色特征和形状特征CCA融合 result=[trainZ,testZ] 
 %   [cs_concat_Train,cs_concat_Test]= ccaFuse(colorTrain, shapeTrain, colorTest, shapeTest, 'concat')
% 颜色特征和纹理特征CCA融合 result=[trainZ,testZ] 
  %  [ct_concat_Train,ct_concat_Test]= ccaFuse(colorTrain, textureTrain, colorTest, textureTest, 'concat')
% 形状特征和纹理特征CCA融合 result=[trainZ,testZ] 
  % [st_concat_Train,st_concat_Test]= ccaFuse(shapeTrain, textureTrain, shapeTest, textureTest, 'concat')
% 颜色特征和形状特征和纹理特征CCA融合 result=[trainZ,testZ] 
   % 首先融合形状和纹理 result=[trainZ,testZ] 
   % [trainXY_concat,testXY_concat] = ccaFuse(shapeTrain, textureTrain, shapeTest, textureTest, 'concat');
   % 再把结果与颜色融合 result=[trainZ,testZ] 
   % [cst_concat_Train,cst_concat_Test]=ccaFuse(trainXY_concat, colorTrain, testXY_concat, colorTest, 'concat');
   

% 颜色、形状、纹理特征直接融合后与卷积特征CCA融合 result=[trainZ,testZ] 
    disp("CCA融合中...");
    cst_Train=[colorTrain,shapeTrain,textureTrain];
    cst_Test=[colorTest,shapeTest,textureTest];
    [cstc_concat_Train,cstc_concat_Test]= ccaFuse(cst_Train, CNNTrain, cst_Test, CNNTest, 'concat');
% 添加标签列：1白叶枯，2稻瘟病，3胡麻斑
   %biaoqian=ones(img_num,1);
   %biaoqian=ones(img_num,1)*2;
   %biaoqian=ones(img_num,1)*3;
   feature=[cstc_concat_Train;cstc_concat_Test];
   % 分行标准化处理 
   %  for m=1:img_num
   %      feature(m,:)=zscore(feature(m,:));
   %  end
   feature=[biaoqian,feature];      
% 特征数据写入表格中 ，同时写入名称列
   xlswrite('newCCA融合特征(原始数据).xlsx',feature,'Sheet1','B1');
   xlswrite('newCCA融合特征(原始数据).xlsx',name,'Sheet1','A1');
   disp("程序结束...");
   
% 直接融合
   feature2=[cst_Train, CNNTrain;cst_Test,CNNTest];
   feature2=[biaoqian,feature2];
   xlswrite('newOriginalFeature.xlsx',feature2,'Sheet1','B1');
   xlswrite('newOriginalFeature.xlsx',name,'Sheet1','A1');
%    % 分行标准化处理 
%    feature1=[cst_Train, CNNTrain;cst_Test,CNNTest];
%      for m=1:img_num
%          feature1(m,:)=zscore(feature1(m,:));
%      end
%    feature1=[biaoqian,feature1];
%    xlswrite('DirectFeature.xlsx',feature1,'Sheet1','B1');
%    xlswrite('DirectFeature.xlsx',name,'Sheet1','A1');


%直接从文件读取特征
% colorTrain=xlsread('OriginalFeature.xlsx',1,'C1:X5000');
% colorTest=xlsread('OriginalFeature.xlsx',1,'C5001:X7500');
% shapeTrain=xlsread('OriginalFeature.xlsx',1,'Y1:AE5000');
% shapeTest=xlsread('OriginalFeature.xlsx',1,'Y5001:AE7500');
% textureTrain=xlsread('OriginalFeature.xlsx',1,'AF1:AT5000');
% textureTest=xlsread('OriginalFeature.xlsx',1,'AF5001:AT7500');
% CNNTrain=xlsread('OriginalFeature.xlsx',1,'AU1:BJ5000');
% CNNTest=xlsread('OriginalFeature.xlsx',1,'AU5001:BJ7500');
%  disp("CCA融合中...");
%     cst_Train=[colorTrain,textureTrain];
%     cst_Test=[colorTest,textureTest];
%     [cstc_concat_Train,cstc_concat_Test]= ccaFuse(cst_Train, shapeTrain, cst_Test, shapeTest, 'concat'); 
%    feature=[cstc_concat_Train;cstc_concat_Test]; 
%    xlswrite('4CCA融合特征(原始数据).xlsx',feature,'Sheet1','A1');
%  disp("程序结束...");
    
    
