addpath("Functions/");

clc
clear

Heathrow = readtable('Heathrow.xlsx');

indicators = ["T", "TM", "Tm", "PP", "V", "RA", "SN", "TS", "GR"];

data = zeros(9, max(size(Heathrow)));
data(1, :) = Heathrow.T;
data(2, :) = Heathrow.TM;
data(3, :) = Heathrow.Tm;
data(4, :) = Heathrow.PP;
data(5, :) = Heathrow.V;
data(6, :) = Heathrow.RA;
data(7, :) = Heathrow.SN;
data(8, :) = Heathrow.TS;
data(9, :) = Heathrow.GR;

r = zeros(9, 1);
p = zeros(9, 1);

for i = 1:9
    [r(i), p(i)] = NonLinearRegresRandomTest_fun(data(i, :), Heathrow.FG);
    if p(i) < 0.05
        fprintf("The indicators %s with adjR2 = %f and p-value = %f\n", indicators(i), r(i), p(i));   
    end
end
