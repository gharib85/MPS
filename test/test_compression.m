% This script test the compression routines using both the SVD decomposition
% and the iterative compression from a random guess.
% close all
clear all

%% Parameters
N = 15;
d = 3;

D_rand = 30;
D_force = 20;

truncation = 1e-6;
tolerance = 1e-6;
iter_max = 200;
maxbond = @(s) max(cellfun(@(x) max(size(x,1),size(x,2)),s));


%% Compare Canonization Methods
Mrand = randomMPS(N,D_rand,d,1);
Mrand = addMPS(Mrand,Mrand);
Mrand{N} = Mrand{N}/2;
fprintf('Testing exact truncation...');
Msvd = sweep(Mrand,{},-1,2*D_rand,truncation);
Miter = sweep_iter(Mrand,{},randomMPS(N,maxbond(Msvd),d,1),iter_max,tolerance);
assert(1 - norm(braket(Mrand,Miter)) < tolerance);
assert(1 - norm(braket(Mrand,Msvd)) < 2*truncation);
fprintf('\tdone\n');
fprintf('\t initial bond dimension: %d\n',maxbond(Mrand));
fprintf('\t final bond dimension: %d\n',maxbond(Msvd));
fprintf('\t distance original-SVD\t %.3g\n',abs(1 - norm(braket(Mrand,Msvd))));
fprintf('\t distance original-iter\t %.3g\n',abs(1 - norm(braket(Mrand,Miter))));
fprintf('\t distance SVD-iter %.3g\n',abs(1 - norm(braket(Msvd,Miter))));


fprintf('Testing forced truncation...');
Msvd = sweep(Mrand,{},-1,D_force,truncation);
[Miter,norm_iter] = sweep_iter(Mrand,{},randomMPS(N,D_force,d,1),iter_max,tolerance);
assert(norm(1 - abs(braket(Mrand,Miter)) - abs(1 - norm_iter)) < 1e-12);
fprintf('\tdone\n');
fprintf('\t initial bond dimension: %d\n',maxbond(Mrand));
fprintf('\t final bond dimension: %d\n',maxbond(Msvd));
fprintf('\t distance original-SVD\t %.3g\n',abs(1 - norm(braket(Mrand,Msvd))));
fprintf('\t distance original-iter\t %.3g\n',abs(1 - norm(braket(Mrand,Miter))));
fprintf('\t distance SVD-iter %.3g\n',abs(1 - norm(braket(Msvd,Miter))));


fprintf('All tests passed!\n');