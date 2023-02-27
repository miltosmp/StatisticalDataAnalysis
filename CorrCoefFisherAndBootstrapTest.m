addpath("Functions/");

clc
clear

Heathrow = readtable('Heathrow.xlsx');

data = zeros(9, max(size(Heathrow)));
data(1, :) = Heathrow.T;
data(2, :) = Heathrow.TM;
data(3, :) = Heathrow.Tm;
data(4, :) = Heathrow.PP;
data(5, :) = Heathrow.V;
data(6, :) = Heathrow.RA;
data(7, :) = Heathrow.SN;
data(8, :) = Heathrow.TS;
data(9, :) = Heathrow.FG;

p1 = zeros(50, 1);
p2 = zeros(50, 1);
ci1 = zeros(50, 2);
ci2 = zeros(50, 2);
n = zeros(50, 1);

indicator = ["T", "TM", "Tm", "PP", "V", "RA", "SN", "TS", "FG"];
indicators = strings(50, 2);
list_ci_p = strings(50, 2);
list_ci_b = strings(50, 2);
list_p_p = strings(50, 2);
list_p_b = strings(50, 2);

k = 1;
for i = 1:8
    for j = i+1:9
        [ci1(k, :), ci2(k, :), p1(k), p2(k), n(k)] = CorrCoefTest_func(data(i, :), data(j, :));
        if ~(ci1(k, 1) < 0 && ci1(k, 2) > 0)
           list_ci_p(k, 1) = indicator(i);
           list_ci_p(k, 2) = indicator(j);
        end
        if ~(ci2(k, 1) < 0 && ci2(k, 2) > 0)
           list_ci_b(k, 1) = indicator(i);
           list_ci_b(k, 2) = indicator(j);
        end
        if p1(k) < 0.05
           list_p_p(k, 1) = indicator(i);
           list_p_p(k, 2) = indicator(j);
        end
        if p2(k) < 0.05
           list_p_b(k, 1) = indicator(i);
           list_p_b(k, 2) = indicator(j);
        end
        indicators(k, :) = [indicator(i), indicator(j)];
        k = k + 1;
    end    
end

l11 = list_ci_p(:, 1);
l12 = list_ci_p(:, 2);
l11 = l11(~(l11 == ""));
l12 = l12(~(l12 == ""));
list_ci_p = strings(max(size(l11)), 2);
list_ci_p(:, 1) = l11;
list_ci_p(:, 2) = l12;

l21 = list_ci_b(:, 1);
l22 = list_ci_b(:, 2);
l21 = l21(~(l21 == ""));
l22 = l22(~(l22 == ""));
list_ci_b = strings(max(size(l21)), 2);
list_ci_b(:, 1) = l21;
list_ci_b(:, 2) = l22;

l11 = list_p_p(:, 1);
l12 = list_p_p(:, 2);
l11 = l11(~(l11 == ""));
l12 = l12(~(l12 == ""));
list_p_p = strings(max(size(l11)), 2);
list_p_p(:, 1) = l11;
list_p_p(:, 2) = l12;

l21 = list_p_b(:, 1);
l22 = list_p_b(:, 2);
l21 = l21(~(l21 == ""));
l22 = l22(~(l22 == ""));
list_p_b = strings(max(size(l21)), 2);
list_p_b(:, 1) = l21;
list_p_b(:, 2) = l22;

for i = 1:max(size(ci1))
    r1 = (ci1(:, 1) + ci1(:, 2))/2;
    r2 = (ci2(:, 1) + ci2(:, 2))/2;
end

[cor_ci_p, i_ci_p] = maxk(abs(r1), 3);
[cor_ci_b, i_ci_b] = maxk(abs(r2), 3);
fprintf("Using Student parametric confidence interval the pairs with the biggest correlation are:\n 1) %s and %s \n 2) %s and %s \n 3) %s and %s \n", indicators(i_ci_p(1), 1), indicators(i_ci_p(1), 2), indicators(i_ci_p(2), 1), indicators(i_ci_p(2), 2), indicators(i_ci_p(3), 1), indicators(i_ci_p(3), 2));
fprintf("Using bootstrap confidence interval the pairs with the biggest correlation are:\n 1) %s and %s \n 2) %s and %s \n 3) %s and %s \n", indicators(i_ci_b(1), 1), indicators(i_ci_b(1), 2), indicators(i_ci_b(2), 1), indicators(i_ci_b(2), 2), indicators(i_ci_b(3), 1), indicators(i_ci_b(3), 2));

[cor_p_p, i_p_p] = mink(p1(~(p1==0)), 3);
[cor_p_b, i_p_b] = mink(p2(~(p2==0)), 3);
fprintf("Using Student parametric method the pairs with the biggest correlation are:\n 1) %s and %s \n 2) %s and %s \n 3) %s and %s \n", indicators(i_p_p(1), 1), indicators(i_p_p(1), 2), indicators(i_p_p(2), 1), indicators(i_p_p(2), 2), indicators(i_p_p(3), 1), indicators(i_p_p(3), 2));
fprintf("Using non-parametric randomization method the pairs with the biggest correlation are:\n 1) %s and %s \n 2) %s and %s \n 3) %s and %s \n", indicators(i_p_b(1), 1), indicators(i_p_b(1), 2), indicators(i_p_b(2), 1), indicators(i_p_b(2), 2), indicators(i_p_b(3), 1), indicators(i_p_b(3), 2));

% -list_ci_p includes the indicator pairs that found to be correlated using 
% the Student parametric confidence interval
% -list_ci_b includes the indicator pairs that found to be correlated using 
% the bootstrap confidence interval 
% -list_ci_p includes the indicator pairs that found to be correlated using 
% the p-values from Student parametric method 
% -list_ci_p includes the indicator pairs that found to be correlated using
% the p-values from randomization method
