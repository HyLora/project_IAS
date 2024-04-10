function [E,EE,Z] = time_domain_features(filename, windowLength, stepLength)

[y,fs]=audioread(filename);
if size(y,2)==2, y=sum(y,2)/2; end
Ham = window(@hamming, round(windowLength*fs)); % smooths the data in the window
[M,nf]=windowize(y, round(windowLength*fs), round(stepLength*fs)); 
for i=1:nf
    frame = M(:,i);
    frame  = frame .* Ham;
    E(i) = feature_energy(frame);
    EE(i) = feature_energy_entropy(frame, 10);
    Z(i) = feature_zcr(frame);
end