function [predX,predNames] = aptIncludePredLength(predLength,sequence,predX,predNames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin ~= 4
    error('function needs 4 input arguments')
end
if predLength == 1
    lengthSeq = [];
    for i = 1:length(sequence)
        lengthSeq(i) = length(sequence{i});
    end
    predNames{end+1} = 'length';
    predX = [predX; lengthSeq];
end
end

