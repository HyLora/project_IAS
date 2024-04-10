clear; clc
addpath(genpath(pwd))

% extract train and test features for the three classes
trainDrinkSipPath = [pwd,'\drink_sip\train\'];
trainWaterDropsPath = [pwd,'\water_drops\train\'];
trainWindPath = [pwd,'\wind\train\'];


testDrinkSipPath = [pwd,'\drink_sip\test\'];
testWaterDropsPath = [pwd,'\water_drops\test\'];
testWindPath = [pwd,'\wind\test\'];

windowLength = [0.03, 0.05, 0.1, 0.5];
stepLength = 0.01;

for i=1:4
%train
disp('extract train features...')
[trainfrequencyfeats, traintime_feats, trainalltogetherfeats, trainlabelfrequency, trainlabeltime, trainlabelalltogether] = visualize_features(trainDrinkSipPath, trainWaterDropsPath, trainWindPath,'*.wav',windowLength(i),stepLength,'train');

%test
disp('extract test features...')
[testfrequencyfeats, testtimefeats, testalltogetherfeats, testlabelfrequency, testlabeltime, testlabelalltogether] = visualize_features(testDrinkSipPath, testWaterDropsPath, testWindPath,'*.wav',windowLength(i),stepLength,'test');

%kNN 
k=[1 7 15 30 60 120];  
disp('knn per le all-together domain features') 
[rateTime, predLTime]=kNN(k,trainalltogetherfeats, trainlabelalltogether, testalltogetherfeats, testlabelalltogether); 

%kNN per le time domain features    
figure
plot(k,predLTime) 
title('kNN alltogether features ', windowLength(i)) 
xlabel('k') 
ylabel('recognition rate (%)') 
grid on 
end