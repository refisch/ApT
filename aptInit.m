%APTINIT Initializing apt which is global structure
%   Detailed explanation goes here

rng(10) % initialize random number generator for results that are reproducible

global apt
apt = struct([]);
apt(1).stop = 0;

