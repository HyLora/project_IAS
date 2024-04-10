function [allFrequencyFeatsNorm, allTimeFeatsNorm, allTogetherNorm, C, C1, C2] = visualize_features(dir1,dir2,dir3,extension,windowLength,stepLength, type)
drinksipTrainFiles=dir([dir1,extension]);
waterdropsTrainFiles=dir([dir2,extension]);
windTrainFiles=dir([dir3,extension]);

drinksipFrequencyFeats=[];
waterdropFrequencyFeats=[];
windFrequencyFeats=[];

drinksipTimeFeats=[];
waterdropTimeFeats=[];
windTimeFeats=[];

allTogetherDrinkSipFeats = [];
allTogetherWaterDropFeats = [];
allTogetherWindFeats = [];

for i=1:length(drinksipTrainFiles) % number of files
    [C, S, E, F, R, ceps] = frequency_features(drinksipTrainFiles(i).name, windowLength, stepLength);
    [e, Z, EE] = time_domain_features(drinksipTrainFiles(i).name, windowLength, stepLength); 
    frequency = [C' S' E' F' R' ceps'];
    time = [e' Z' EE'];
    drinksipFrequencyFeats = [drinksipFrequencyFeats; frequency];
    drinksipTimeFeats = [drinksipTimeFeats; time];
    allTogetherDrinkSipFeats = [allTogetherDrinkSipFeats; C' S' E' F' R' ceps' e' Z' EE'];
end
for i=1:length(waterdropsTrainFiles) % number of files
    [C, S, E, F, R, ceps] = frequency_features(waterdropsTrainFiles(i).name, windowLength, stepLength);
    [e, Z, EE] = time_domain_features(waterdropsTrainFiles(i).name, windowLength, stepLength); 
    frequency = [C' S' E' F' R' ceps'];
    time = [e' Z' EE'];
    waterdropFrequencyFeats = [waterdropFrequencyFeats; frequency];
    waterdropTimeFeats = [waterdropTimeFeats; time];
    allTogetherWaterDropFeats = [allTogetherWaterDropFeats; C' S' E' F' R' ceps' e' Z' EE'];
end
for i=1:length(windTrainFiles) % number of files
    [C, S, E, F, R, ceps] = frequency_features(windTrainFiles(i).name, windowLength, stepLength);
    [e, Z, EE] = time_domain_features(windTrainFiles(i).name, windowLength, stepLength); 
    frequency = [C' S' E' F' R' ceps'];
    time = [e' Z' EE'];
    windFrequencyFeats = [windFrequencyFeats; frequency];
    windTimeFeats = [windTimeFeats; time];
    allTogetherWindFeats = [allTogetherWindFeats; C' S' E' F' R' ceps' e' Z' EE'];
end

% concatenate frequency features from all classes
allFrequencyFeats = [drinksipFrequencyFeats; waterdropFrequencyFeats; windFrequencyFeats];

% concatenate time features from all classes
allTimeFeats = [drinksipTimeFeats; waterdropTimeFeats; windTimeFeats];

% concatenate time alltogether from all classes
allTogether = [allTogetherDrinkSipFeats; allTogetherWaterDropFeats; allTogetherWindFeats];

% normalize frequency
mn = mean(allFrequencyFeats);
st = std(allFrequencyFeats);
allFrequencyFeatsNorm =  (allFrequencyFeats - repmat(mn,size(allFrequencyFeats,1),1))./repmat(st,size(allFrequencyFeats,1),1);

% normalize time
mn = mean(allTimeFeats);
st = std(allTimeFeats);
allTimeFeatsNorm =  (allTimeFeats - repmat(mn,size(allTimeFeats,1),1))./repmat(st,size(allTimeFeats,1),1);

% normalize alltogheter
mn = mean(allTogether);
st = std(allTogether);
allTogetherNorm =  (allTogether - repmat(mn,size(allTogether,1),1))./repmat(st,size(allTogether,1),1);

% apply PCA frequency
[coeff1,score1,latent1,tsquared1,explained1] = pca(allFrequencyFeatsNorm);
disp('explained variance of frequency feats...')
coeff1(explained1 >= 0.8)

% apply PCA time
[coeff2,score2,latent2,tsquared2,explained2] = pca(allTimeFeatsNorm);
disp('explained variance of time feats...')
coeff2(explained2 >= 0.8)

% apply PCA alltogether
[coeff3,score3,latent3,tsquared3,explained3] = pca(allTogetherNorm);
disp('explained variance of alltogether...')
coeff3(explained3 >= 0.8)

% plotting
S=[]; % size of each point, empty for all equal
C=[repmat(1,length(drinksipFrequencyFeats),1); repmat(2,length(waterdropFrequencyFeats),1); repmat(3,length(windFrequencyFeats),1)];
    % define color R G B
figure;
scatter3(score1(:,1),score1(:,2),score1(:,3),S,C,'filled')
axis equal
title(strcat('Drink Sip -',type,' after PCA'))
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
zlabel('3rd Principal Component')
figure;
scatter3(allFrequencyFeats(:,1),allFrequencyFeats(:,2),allFrequencyFeats(:,3),S,C, 'filled')
title(strcat('Drink Sip -',type,' before PCA'))

% plotting
S1=[]; % size of each point, empty for all equal
C1=[repmat(1,length(drinksipTimeFeats),1); repmat(2,length(waterdropTimeFeats),1); repmat(3,length(windTimeFeats),1)];
    % define color R G B
figure;
scatter3(score2(:,1),score2(:,2),score2(:,3),S1,C1,'filled')
axis equal
title(strcat('Water Drops -',type,' after PCA'))
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
zlabel('3rd Principal Component')
figure;
scatter3(allTimeFeats(:,1),allTimeFeats(:,2),allTimeFeats(:,3),S1,C1, 'filled')
title(strcat('Water Drops -',type,' before PCA'))

% plotting
S2=[]; % size of each point, empty for all equal
C2=[repmat(1,length(allTogetherDrinkSipFeats),1); repmat(2,length(allTogetherWaterDropFeats),1); repmat(3,length(allTogetherWindFeats),1)];
    % define color R G B
figure;
scatter3(score3(:,1),score3(:,2),score3(:,3),S2,C2,'filled')
axis equal
title(strcat('Wind -',type,' after PCA'))
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
zlabel('3rd Principal Component')
figure;
scatter3(allTogether(:,1),allTogether(:,2),allTogether(:,3),S2,C2, 'filled')
title(strcat('Wind -',type,' before PCA'))