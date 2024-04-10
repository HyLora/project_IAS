function experimentTime(cat,wind,train,extension)
E1 = [];
Z1 = [];
files1 = dir([cat,'*.',extension]);
files2 = dir([wind,'*.',extension]);
files3 = dir([train,'*.',extension]);
for i=1:length(cat)
  [E,Z] = time_domain_features(files1(i).name,0.03,0.01);  
  E1 = [E1 E];
  Z1 = [Z1 Z];
end

E2=[];
Z2=[];
for i=1:length(wind)
  [E,Z] = time_domain_features(files2(i).name,0.03,0.01);  
  E2 = [E2 E];
  Z2 = [Z2 Z];
end

E3=[];
Z3=[];
for i=1:length(train)
  [E,Z] = time_domain_features(files3(i).name,0.03,0.01);  
  E3 = [E3 E];
  Z3 = [Z3 Z];
end

disp('plotting...')
scatter(E1,Z1,'filled');
hold on;
scatter(E2,Z2,'filled');
hold on;
scatter(E3,Z3,'filled');
legend('cat', 'wind','train')
grid on
xlabel('Energy')
ylabel('ZCR')

% normalization
allFeats = [E1 E2 E3(1:length(E1)); Z1 Z2 Z3(1:length(E1))];
allFeats = allFeats';
mn = mean(allFeats);
st = std(allFeats);
allFeatsNorm =  (allFeats - repmat(mn,size(allFeats,1),1))./repmat(st,size(allFeats,1),1);

figure
disp('plotting...')
scatter(allFeatsNorm(1:3541,1),allFeatsNorm(1:3541,2),'filled');
grid on
hold on;
scatter(allFeatsNorm(3542:end,1),allFeatsNorm(3542:end,2),'filled'); 
legend('cat', 'wind','train')
xlabel('Energy')
ylabel('ZCR')

%distances
energydiff = (E1-E2(1:length(E1))).^2;
ZCRdiff = (Z1-Z2(1:length(Z1))).^2;
figure
subplot(2,1,1)
stem(energydiff)
title('energydiff')
subplot(2,1,2)
stem(ZCRdiff)
title('ZCRdiff')
disp('the average distances of the features w.r.t two speakers')
mean(energydiff)
mean(ZCRdiff)
%which feature is more discriminative