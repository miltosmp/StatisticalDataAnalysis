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
ind = zeros(9, 1);

for i = 1:9
    figure(i);
    [r(i), ind(i)] = NonLinearRegressionModel_fun(data(i, :), Heathrow.FG);
end

[max_r, max_i] = maxk(r, 3);
fprintf("FG is correlated with the indicators:\n");
fprintf("1) %s with adjR2 = %f using the regression method %d\n", indicators(max_i(1)), max_r(1), ind(max_i(1)));
fprintf("2) %s with adjR2 = %f using the regression method %d\n", indicators(max_i(2)), max_r(2), ind(max_i(2)));
fprintf("3) %s with adjR2 = %f using the regression method %d\n", indicators(max_i(3)), max_r(3), ind(max_i(3)));
fprintf("The methods are numbered as:\n 1) Linear regression\n 2) 2nd grade Polynomial regression\n");
fprintf(" 3) 3rd grade Polynomial regression\n 4) Exponential non-linear regression\n");
fprintf(" 5) Logarithmic non-linear regression\n");