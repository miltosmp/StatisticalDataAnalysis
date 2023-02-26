addpath("Functions/");

clc
clear

Heathrow = readtable('Heathrow.xlsx');

p1 = zeros(9, 1);
p2 = zeros(9, 1);
ci1 = zeros(9, 2);
ci2 = zeros(9, 2);

[p1(1), p2(1), ci1(1, :), ci2(1, :)] = MeanDifferenceTest_fun(Heathrow.Year, Heathrow.T);
[p1(2), p2(2), ci1(2, :), ci2(2, :)] = MeanDifferenceTest_fun(Heathrow.Year, Heathrow.TM);
[p1(3), p2(3), ci1(3, :), ci2(3, :)] = MeanDifferenceTest_fun(Heathrow.Year, Heathrow.Tm);
%[p1(4), p2(4), ci1(4, :), ci2(4, :)] = MeanDifferenceTest_fun(Heathrow.Year, Heathrow.PP);
% Cant use the function on PP indicator because it doesn't have anny
% observation in the first part
[p1(5), p2(5), ci1(5, :), ci2(5, :)] = MeanDifferenceTest_fun(Heathrow.Year, Heathrow.V);
[p1(6), p2(6), ci1(6, :), ci2(6, :)] = MeanDifferenceTest_fun(Heathrow.Year, Heathrow.RA);
[p1(7), p2(7), ci1(7, :), ci2(7, :)] = MeanDifferenceTest_fun(Heathrow.Year, Heathrow.SN);
[p1(8), p2(8), ci1(8, :), ci2(8, :)] = MeanDifferenceTest_fun(Heathrow.Year, Heathrow.TS);
[p1(9), p2(9), ci1(9, :), ci2(9, :)] = MeanDifferenceTest_fun(Heathrow.Year, Heathrow.FG);

indicator = ["T", "TM", "Tm", "PP", "V", "RA", "SN", "TS", "FG"];

[~, it1] = max(p1);
[~, it2] = max(p2);
    
fprintf(" With parametric check (student) the %s indicator has the biggest difference in mean values\n", indicator(it1));
fprintf(" With resampling check the %s indicator has the biggest difference in mean values\n", indicator(it2));

if indicator(it1) == indicator(it2)
    fprintf(" The two checks (parametric and resampling) agree\n")
else
    fprintf(" The two checks (parametric and resampling) do not agree\n")
end
