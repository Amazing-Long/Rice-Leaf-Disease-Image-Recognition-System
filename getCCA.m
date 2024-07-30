clear all;clc;
file_path = 'CCA';% ͼ���ļ���·��
img_path_list = dir(fullfile(file_path,'*.jpg'));%��ȡ���ļ���������jpg��ʽ��ͼ��
img_num = length(img_path_list);%��ȡͼ��������,����������(ѵ�����������Ͳ�������������һ��)
half=img_num*2/3;
%Ԥ�����ڴ�
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

if img_num > 0 %������������ͼ��
        parfor i = 1:half %��һ��ȡѵ��ͼ��
            sample_name = img_path_list(i).name;% ͼ����
            name{i,1} = sample_name;
            biaoqian(i,1)=str2num(sample_name(1));
            sample =  imread([file_path,'\',sample_name]);
            
%             sample=tiqubingban(sample);
%             imwrite(sample,sample_name);
            
            fprintf('%d %s\n',i,strcat(file_path,sample_name));% ��ʾ���ڴ����ͼ����
            %ͼ������� 
            
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
        parfor j = 1:half/2 %��һ��ȡ����ͼ��
            test_name = img_path_list(half+j).name;% ͼ����
            name{half+j,1} = test_name;
            biaoqian(half+j,1)=str2num(test_name(1));
            
%             test =  imread([file_path,'\',test_name]);
%             test=tiqubingban(test);
            
            imwrite(test,test_name);
            fprintf('%d %s\n',half+j,strcat(file_path,test_name));% ��ʾ���ڴ����ͼ����
            %ͼ������� 
            
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
% ��ɫ��������״����CCA�ں� result=[trainZ,testZ] 
 %   [cs_concat_Train,cs_concat_Test]= ccaFuse(colorTrain, shapeTrain, colorTest, shapeTest, 'concat')
% ��ɫ��������������CCA�ں� result=[trainZ,testZ] 
  %  [ct_concat_Train,ct_concat_Test]= ccaFuse(colorTrain, textureTrain, colorTest, textureTest, 'concat')
% ��״��������������CCA�ں� result=[trainZ,testZ] 
  % [st_concat_Train,st_concat_Test]= ccaFuse(shapeTrain, textureTrain, shapeTest, textureTest, 'concat')
% ��ɫ��������״��������������CCA�ں� result=[trainZ,testZ] 
   % �����ں���״������ result=[trainZ,testZ] 
   % [trainXY_concat,testXY_concat] = ccaFuse(shapeTrain, textureTrain, shapeTest, textureTest, 'concat');
   % �ٰѽ������ɫ�ں� result=[trainZ,testZ] 
   % [cst_concat_Train,cst_concat_Test]=ccaFuse(trainXY_concat, colorTrain, testXY_concat, colorTest, 'concat');
   

% ��ɫ����״����������ֱ���ںϺ���������CCA�ں� result=[trainZ,testZ] 
    disp("CCA�ں���...");
    cst_Train=[colorTrain,shapeTrain,textureTrain];
    cst_Test=[colorTest,shapeTest,textureTest];
    [cstc_concat_Train,cstc_concat_Test]= ccaFuse(cst_Train, CNNTrain, cst_Test, CNNTest, 'concat');
% ��ӱ�ǩ�У�1��Ҷ�ݣ�2��������3�����
   %biaoqian=ones(img_num,1);
   %biaoqian=ones(img_num,1)*2;
   %biaoqian=ones(img_num,1)*3;
   feature=[cstc_concat_Train;cstc_concat_Test];
   % ���б�׼������ 
   %  for m=1:img_num
   %      feature(m,:)=zscore(feature(m,:));
   %  end
   feature=[biaoqian,feature];      
% ��������д������ ��ͬʱд��������
   xlswrite('newCCA�ں�����(ԭʼ����).xlsx',feature,'Sheet1','B1');
   xlswrite('newCCA�ں�����(ԭʼ����).xlsx',name,'Sheet1','A1');
   disp("�������...");
   
% ֱ���ں�
   feature2=[cst_Train, CNNTrain;cst_Test,CNNTest];
   feature2=[biaoqian,feature2];
   xlswrite('newOriginalFeature.xlsx',feature2,'Sheet1','B1');
   xlswrite('newOriginalFeature.xlsx',name,'Sheet1','A1');
%    % ���б�׼������ 
%    feature1=[cst_Train, CNNTrain;cst_Test,CNNTest];
%      for m=1:img_num
%          feature1(m,:)=zscore(feature1(m,:));
%      end
%    feature1=[biaoqian,feature1];
%    xlswrite('DirectFeature.xlsx',feature1,'Sheet1','B1');
%    xlswrite('DirectFeature.xlsx',name,'Sheet1','A1');


%ֱ�Ӵ��ļ���ȡ����
% colorTrain=xlsread('OriginalFeature.xlsx',1,'C1:X5000');
% colorTest=xlsread('OriginalFeature.xlsx',1,'C5001:X7500');
% shapeTrain=xlsread('OriginalFeature.xlsx',1,'Y1:AE5000');
% shapeTest=xlsread('OriginalFeature.xlsx',1,'Y5001:AE7500');
% textureTrain=xlsread('OriginalFeature.xlsx',1,'AF1:AT5000');
% textureTest=xlsread('OriginalFeature.xlsx',1,'AF5001:AT7500');
% CNNTrain=xlsread('OriginalFeature.xlsx',1,'AU1:BJ5000');
% CNNTest=xlsread('OriginalFeature.xlsx',1,'AU5001:BJ7500');
%  disp("CCA�ں���...");
%     cst_Train=[colorTrain,textureTrain];
%     cst_Test=[colorTest,textureTest];
%     [cstc_concat_Train,cstc_concat_Test]= ccaFuse(cst_Train, shapeTrain, cst_Test, shapeTest, 'concat'); 
%    feature=[cstc_concat_Train;cstc_concat_Test]; 
%    xlswrite('4CCA�ں�����(ԭʼ����).xlsx',feature,'Sheet1','A1');
%  disp("�������...");
    
    
