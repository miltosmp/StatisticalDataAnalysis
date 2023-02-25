addpath("Functions/");

clc
clear

Heathrow = readtable('Heathrow.xlsx');

p_1 = zeros();
p_2 = zeros();
h_1 = zeros();
h_2 = zeros();
type = zeros();

% Full screen view of the graphs is suggested, for a better view
subplot(3, 4, 1);
fprintf("--- T ---\n");
[p_1(1), p_2(1), h(1), type(1)] = PlotParametricTest_func(Heathrow.T);

subplot(3, 4, 2);
fprintf("--- TM ---\n");
[p_1(2), p_2(2), h(2), type(2)] = PlotParametricTest_func(Heathrow.TM);

subplot(3, 4, 3);
fprintf("--- Tm ---\n");
[p_1(3), p_2(3), h(3), type(3)] = PlotParametricTest_func(Heathrow.Tm);

subplot(3, 4, 4);
fprintf("--- PP ---\n");
[p_1(4), p_2(4), h(4), type(4)] = PlotParametricTest_func(Heathrow.PP);

subplot(3, 4, 5);
fprintf("--- V ---\n");
[p_1(5), p_2(5), h(5), type(5)] = PlotParametricTest_func(Heathrow.V);

subplot(3, 4, 6);
fprintf("--- RA ---\n");
[p_1(6), p_2(6), h(6), type(6)] = PlotParametricTest_func(Heathrow.RA);

subplot(3, 4, 7);
fprintf("--- SN ---\n");
[p_1(7), p_2(7), h(7), type(7)] = PlotParametricTest_func(Heathrow.SN);

subplot(3, 4, 8);
fprintf("--- TS ---\n");
[p_1(8), p_2(8), h(8), type(8)] = PlotParametricTest_func(Heathrow.TS);

subplot(3, 4, 9);
fprintf("--- FG ---\n");
[p_1(9), p_2(9), h(9), type(9)] = PlotParametricTest_func(Heathrow.FG);

subplot(3, 4, 10);
fprintf("--- TN ---\n");
[p_1(10), p_2(10), h(10), type(10)] = PlotParametricTest_func(Heathrow.TN);

subplot(3, 4, 11);
fprintf("--- GR ---\n");
[p_1(11), p_2(11), h(11), type(11)] = PlotParametricTest_func(Heathrow.GR);

data_matrix = strings(3, 11);
indicator = ["T", "TM", "Tm", "PP", "V", "RA", "SN", "TS", "FG", "TN", "GR"];
for i = 1:11
    data_matrix(1, i) = indicator(i);
    if(type(i))
        data_matrix(2, i) = "Continous";
        if(h(i) == 1)
            data_matrix(3, i) = "Uniform Distribution";
        elseif(h(i) == 2)
            data_matrix(3, i) = "Normal Distribution";
        else
            data_matrix(3, i) = "Does not fit";
        end
    else
        data_matrix(2, i) = "Discrete";
        if(h(i) == 1)
            data_matrix(3, i) = "Uniform Distribution";
        elseif(h(i) == 2)
            data_matrix(3, i) = "Binomial Distribution";
        else
            data_matrix(3, i) = "Does not fit";
        end
    end
end

% The matrix that has the information of wether the random variable has a
% Discrete or Continous Distribution and its kind is data_matrix.