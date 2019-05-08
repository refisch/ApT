%APTINIT Initializing apt which is global structure
%   Detailed explanation goes here

rng(10) % initialize random number generator for results that are reproducible

global apt
apt = struct([]);
apt(1).stop = 0;
aptGetGitHash

function aptGetGitHash
wd = pwd;
cd(strrep(which('aptInit.m'),'/aptInit.m',''))
[~,myhash] = system('git rev-parse HEAD');
apt.info.githash = myhash(1:(end-1));
cd(wd)
end