addpath("Functions/");

clc
clear

Heathrow = readtable('Heathrow.xlsx');

% The pairs we will compare are:
% T & TM, Tm & PP, RA & SN, PP & RA, T & FG, TS & V, V & SN, Tm & FG

I = zeros(8, 1);
p = zeros(8, 1);
r = zeros(8, 1);
p_r = zeros(8, 1);

[I(1), p(1)] = MutualInfNonParamTest_fun(Heathrow.T, Heathrow.TM);
[~, ~, ~, p_r(1), ~, r(1)] = CorrCoefTest_func(Heathrow.T, Heathrow.TM);

[I(2), p(2)] = MutualInfNonParamTest_fun(Heathrow.Tm, Heathrow.PP);
[~, ~, ~, p_r(2), ~, r(2)] = CorrCoefTest_func(Heathrow.Tm, Heathrow.PP);

[I(3), p(3)] = MutualInfNonParamTest_fun(Heathrow.RA, Heathrow.SN);
[~, ~, ~, p_r(3), ~, r(3)] = CorrCoefTest_func(Heathrow.RA, Heathrow.SN);

[I(4), p(4)] = MutualInfNonParamTest_fun(Heathrow.PP, Heathrow.RA);
[~, ~, ~, p_r(4), ~, r(4)] = CorrCoefTest_func(Heathrow.PP, Heathrow.RA);

[I(5), p(5)] = MutualInfNonParamTest_fun(Heathrow.T, Heathrow.FG);
[~, ~, ~, p_r(5), ~, r(5)] = CorrCoefTest_func(Heathrow.T, Heathrow.FG);

[I(6), p(6)] = MutualInfNonParamTest_fun(Heathrow.TS, Heathrow.V);
[~, ~, ~, p_r(6), ~, r(6)] = CorrCoefTest_func(Heathrow.TS, Heathrow.V);

[I(7), p(7)] = MutualInfNonParamTest_fun(Heathrow.V, Heathrow.SN);
[~, ~, ~, p_r(7), ~, r(7)] = CorrCoefTest_func(Heathrow.V, Heathrow.SN);

[I(8), p(8)] = MutualInfNonParamTest_fun(Heathrow.Tm, Heathrow.FG);
[~, ~, ~, p_r(8), ~, r(8)] = CorrCoefTest_func(Heathrow.Tm, Heathrow.FG);

for i = 1:8
    fprintf("%d: I = %f with p-value: %f, corr = %f with p-value: %f\n", i, I(i), p(i), r(i), p_r(i));    
end

% According to the correlation factor, the mutual information and their
% p-values, we can conclude that T & TM, T & FG, Tm & FG have linear
% correlation. 
% For the pairs examined, there is no evidence of non-linear correlation
% between them from this check.
