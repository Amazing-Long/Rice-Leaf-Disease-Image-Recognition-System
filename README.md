# Rice-Leaf-Disease-Image-Recognition-System
# 基于集成特征表示的稻叶病图像识别系统
本系统以计算机视觉、图像处理、特征融合以及模式识别技术为基础，结合稻叶病特征，设计出基于集成特征表示的稻叶病图像识别系统。主要研究内容包括：
1)	稻叶病图像收集与预处理：采集稻叶稻瘟病、白叶枯病、胡麻斑病三种病害的图片，通过双边滤波消除图片噪声，通过基于颜色特征的病斑提取算法来提取稻叶病斑；
2)	稻叶病数据库的建立：建立稻叶病图像库、稻叶病病斑库、稻叶病斑特征库以及稻叶病信息库；
3)	稻叶病集成特征表示：提取稻叶病的颜色特征、形状特征以及纹理特征，利用多集典型相关分析进行特征融合得到集成特征；
4)	稻叶病图像识别技术：采用SVM支持向量机进行稻叶病图像分类训练，得到识别模型；
5)	系统的搭建：利用Matlab软件搭建整体系统。

# 技术路线：
![图片1](https://github.com/user-attachments/assets/e5b7c1a8-4433-4efe-b930-2f77d4e51b8c)


# 系统测试：

| 稻叶病种类 | 查准率 | 查全率 | F测度 |
|:--------:|:------:|:------:|:------:|
| 白叶枯   | 0.742063 | 0.748000 | 0.745020 |	
| 稻瘟病   | 0.713969 | 0.644000 | 0.677182 |	
| 胡麻斑   | 0.699083 | 0.762000 | 0.729187 |
总准确率：0.718000
结果显示，基于SVM的稻叶病图像识别模型在三种稻叶病病斑的查准率、查全率、F1测度都较高，并且总精确度高于70%，符合系统指标预期。


# 系统使用方法见Readme.pdf
