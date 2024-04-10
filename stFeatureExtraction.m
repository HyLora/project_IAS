function [EE,EN,ZCR] = stFeatureExtraction(file, windowLength, step)

% function Features = stFeatureExtraction(signal, fs, win, step)
%
% This function computes basic audio feature sequencies for an audio
% signal, on a short-term basis.
%
% ARGUMENTS:
%  - signal:    the audio signal
%  - fs:        the sampling frequency
%  - win:       short-term window size (in seconds)
%  - step:      short-term step (in seconds)
%
% RETURNS:
%  - Features: a [MxN] matrix, where M is the number of features and N is
%  the total number of short-term windows. Each line of the matrix
%  corresponds to a seperate feature sequence
%
% (c) 2014 T. Giannakopoulos, A. Pikrakis

% if STEREO ...
[y,fs] = audioread(file);

if size(y,2)==2, y=sum(y,2)/2; end
[M,nf]=windowize(y, round(windowLength*fs), round(step*fs)); 

Ham = window(@hamming, round(windowLength*fs)); % smooths the data in the window


C = zeros(1,nf); 
S = zeros(1,nf); 
E = zeros(1,nf); 
F = zeros(1,nf); 
R = zeros(1,nf);
ZCR = zeros(1,nf);
EN = zeros(1,nf);
EE = zeros(1,nf);
ceps = zeros(1,nf);

for i=1:nf % for each frame
    % get current frame:
    frame = M(:,i);
    frame  = frame .* Ham;
        % compute time-domain features:
        ZCR(1,i) = feature_zcr(frame);
        EN(2,i) = feature_energy(frame);
        EE(3,i) = feature_energy_entropy(frame, 10);
end
