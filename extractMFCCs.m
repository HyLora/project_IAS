function ceps = extractMFCCs(filename,windowLength,stepLength)
[y,fs]=audioread(filename);
Ham = window(@hamming, windowLength*fs); % smooths the data of the window
[M,nf] = windowize(y,windowLength*fs,stepLength*fs); 
mfccParams = feature_mfccs_init(windowLength*fs, fs); % initialization of MFCCs
ceps=zeros(13,nf);
for i=1:nf
    frame = M(:,i);
    frame  = frame .* Ham;
    frameFFT = getDFT(frame, fs);
    ceps(1:13,i) = feature_mfccs(frameFFT, mfccParams);
end