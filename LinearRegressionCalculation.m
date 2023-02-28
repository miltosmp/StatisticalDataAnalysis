addpath("Functions/");

clc
clear

Heathrow = readtable('Heathrow.xlsx');

r = zeros(10, 10);

indicator = ["T", "TM", "Tm", "PP", "V", "RA", "SN", "TS", "FG", "GR"];

data = zeros(10, max(size(Heathrow)));
data(1, :) = Heathrow.T;
data(2, :) = Heathrow.TM;
data(3, :) = Heathrow.Tm;
data(4, :) = Heathrow.PP;
data(5, :) = Heathrow.V;
data(6, :) = Heathrow.RA;
data(7, :) = Heathrow.SN;
data(8, :) = Heathrow.TS;
data(9, :) = Heathrow.FG;
data(10, :) = Heathrow.GR;

for i = 1:10
    figure(i)
    k = 0;
    for j = 1:10
        if(j ~= i)
            k = k+1;
            subplot(3, 3, k);
            r(i,j) = LinearRegressionModel_func(data(j,:), data(i,:));
            if(j < i)
                r(i,j) = 0;
            end
            ylabel(indicator(i));
            xlabel(indicator(j));
        end
    end
end

[max_r, max_ind] = max(r);
[m, max_j] = maxk(max_r, 2);
max_i = [max_ind(max_j(1)) max_ind(max_j(2))];

fprintf("The pairs with the biggest correlation factors are:\n 1) %s and %s with %f\n 2) %s and %s with %f\n", indicator(max_i(1)), indicator(max_j(1)), m(1), indicator(max_i(2)), indicator(max_j(2)), m(2));
