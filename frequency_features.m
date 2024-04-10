function [C,S,E,F,R,ceps]=frequency_features(filename,windowLength,stepLength)
% example for the extraction of spectral_centroid, spread, rolloff and MFCCs
[y,fs]=audioread(filename);
if size(y,2)==2, y=sum(y,2)/2; end
Ham = window(@hamming, round(windowLength*fs)); % smooths the data in the window
[M,nf]=windowize(y, round(windowLength*fs), round(stepLength*fs)); 
% initialization of the feature vectors
C =[]; %spectral centroid
S =[]; % spectral spread
E =[]; %spectral entropy
F =[]; %spectral flux
R =[]; %spectral Rolloff


C = zeros(1,nf); 
S = zeros(1,nf); 
E = zeros(1,nf); 
F = zeros(1,nf); 
R = zeros(1,nf); 
ceps=zeros(13,nf);
mfccParams = feature_mfccs_init(round(windowLength*fs), fs); % initialization of MFCCs
for i=1:nf
    frame = M(:,i);
    frame  = frame .* Ham;
    frameFFT = getDFT(frame, fs);
    if (i==1) 
        frameFFTPrev = frameFFT; 
    end
    if (sum(abs(frame))>eps)
    [C(i),S(i)] = ...
            feature_spectral_centroid(frameFFT, fs);
    R(i) = feature_spectral_rolloff(frameFFT, 0.9);
    E(i) = feature_spectral_entropy(frameFFT, 10);
    F(i) = feature_spectral_flux(frameFFT,frameFFTPrev);
    ceps(1:13,i) = feature_mfccs(frameFFT, mfccParams);
    frameFFTPrev = frameFFT;
    end
end