function [features1, features2, features3] = extract_from_path_mfccs(path1,path2,path3,extension,windowLength,stepLength)
files1 = dir([path1,'*.',extension]);
files2 = dir([path2,'*.',extension]);
files3 = dir([path3,'*.',extension]);
features1=[];
for i=1:length(files1)
    ceps = extractMFCCs(files1(i).name,windowLength,stepLength);
    features1 = [features1 ceps];
end
features2=[];
for i=1:length(files2)
    ceps = extractMFCCs(files2(i).name,windowLength,stepLength);
    features2 = [features2 ceps];
end
features3=[];
for i=1:length(files3)
    ceps = extractMFCCs(files3(i).name,windowLength,stepLength);
    features3 = [features3 ceps];
end
