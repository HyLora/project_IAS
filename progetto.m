clear; clc
addpath(genpath(pwd))

windowLength = 0.03;
stepLength = 0.01;

% extract train and test features for the three classes
trainDrinkSipPath = [pwd,'\drink_sip\train\'];
trainWaterDropsPath = [pwd,'\water_drops\train\'];
trainWindPath = [pwd,'\wind\train\'];


testDrinkSipPath = [pwd,'\drink_sip\test\'];
testWaterDropsPath = [pwd,'\water_drops\test\'];
testWindPath = [pwd,'\wind\test\'];

%train
disp('extract train features...')
[trainfrequencyfeats, traintime_feats, trainalltogetherfeats, trainlabelfrequency, trainlabeltime, trainlabelalltogether] = visualize_features(trainDrinkSipPath, trainWaterDropsPath, trainWindPath,'*.wav',windowLength,stepLength,'train');

%test
disp('extract test features...')
[testfrequencyfeats, testtimefeats, testalltogetherfeats, testlabelfrequency, testlabeltime, testlabelalltogether] = visualize_features(testDrinkSipPath, testWaterDropsPath, testWindPath,'*.wav',windowLength,stepLength,'test');

%kNN 
k=[1 7 15 30 60 120];  
disp('knn for the time domain features') 
[rateTime, predLTime]=kNN(k,traintime_feats, trainlabeltime, testtimefeats, testlabeltime); 
disp('knn for the frequency domain features') 
disp('') 
[rateFrequency, predLFrequency]=kNN(k, trainfrequencyfeats, trainlabelfrequency, testfrequencyfeats, testlabelfrequency); 
disp('kNN for all the features') 
disp('') 
[rateAll, predLAll]=kNN(k, trainalltogetherfeats, trainlabelalltogether, testalltogetherfeats, testlabelalltogether); 
 
%kNN per le time domain features    
figure
plot(k,predLTime) 
title('kNN time features') 
xlabel('k') 
ylabel('recognition rate (%)') 
grid on 
 
%kNN per le frequency domain features 
figure
plot(k,predLFrequency) 
title('kNN frequency features') 
xlabel('k') 
ylabel('recognition rate (%)') 
grid on 

%kNN per tutte le features 
figure 
plot(k,predLAll) 
title('kNN all features') 
xlabel('k') 
ylabel('recognition rate (%)') 
grid on

