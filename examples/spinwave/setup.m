%% Initialize All Physical Parameters
N = 12;				% Number of physical states (keep < 20 for conventional evolution)
dt = 0.1;			% Time step
time_steps = 100;	% Total number of time steps

% Location where to save
filename = 'workspaces/spinwave.mat';

%% Simulation Parameters

D_max = 16;			% Maximum bond dimension for SVD
epsilon = 1e-6;		% Truncation error for SVD (sum of the square of the singular values to discart)
iter_max = 10;		% Maximum number of iterative sweeps
D_static = 8;		% Fixed bond dimension for iterative compression and TDVP
tolerance = 1e-4;	% Tolerance for iterative compression

% Other Data Structures
d = 2;				% Local Hilbert space size
sigma = struct('x',[0,1;1,0],'y',[0,-1i;1i,0],'z',[1,0;0,-1],'plus',[0,1;0,0],'minus',[0,0;1,0],'id',eye(2));

if ~exist(filename,'file')
	save(filename);
end
