addpath("Functions/");

clc
clear

Heathrow = readtable('Heathrow.xlsx');

% Samples of the data from 1973 and after
T = Heathrow.T(11:55);
T = T(~isnan(T));
TM = Heathrow.TM(11:55);
TM = TM(~isnan(TM));
Tm = Heathrow.Tm(11:55);
Tm = Tm(~isnan(Tm));
PP = Heathrow.PP(11:55);
PP = PP(~isnan(PP));
V = Heathrow.V(11:55);
V = V(~isnan(V));
RA = Heathrow.RA(11:55);
RA = RA(~isnan(RA));
SN = Heathrow.SN(11:55);
SN = SN(~isnan(SN));
TS = Heathrow.TS(11:55);
TS = TS(~isnan(TS));
FG = Heathrow.FG(11:55);
FG = FG(~isnan(FG));

x = zeros(9, 2);
x_b = zeros(9, 2);
[x(1, :), x_b(1, :)] = BootstrapCI_func(T);
[x(2, :), x_b(2, :)] = BootstrapCI_func(TM);
[x(3, :), x_b(3, :)] = BootstrapCI_func(Tm);
[x(4, :), x_b(4, :)] = BootstrapCI_func(PP);
[x(5, :), x_b(5, :)] = BootstrapCI_func(V);
[x(6, :), x_b(6, :)] = BootstrapCI_func(RA);
[x(7, :), x_b(7, :)] = BootstrapCI_func(SN);
[x(8, :), x_b(8, :)] = BootstrapCI_func(TS);
[x(9, :), x_b(9, :)] = BootstrapCI_func(FG);

% Mean values of the data in the period 1949 - 1958 
means = zeros(9, 1);
T1 = Heathrow.T(1:10);
means(1) = mean(T1(~isnan(T1)));
TM1 = Heathrow.TM(1:10);
means(2) = mean(TM1(~isnan(TM1)));
Tm1 = Heathrow.Tm(1:10);
means(3) = mean(Tm1(~isnan(Tm1)));
PP1 = Heathrow.PP(1:10);
means(4) = mean(PP1(~isnan(PP1)));
V1 = Heathrow.V(1:10);
means(5) = mean(V1(~isnan(V1)));
RA1 = Heathrow.RA(1:10);
means(6) = mean(RA1(~isnan(RA1)));
SN1 = Heathrow.SN(1:10);
means(7) = mean(SN1(~isnan(SN1)));
TS1 = Heathrow.TS(1:10);
means(8) = mean(TS1(~isnan(TS1)));
FG1 = Heathrow.FG(1:10);
means(9) = mean(FG1(~isnan(FG1)));

indicator = ["T", "TM", "Tm", "PP", "V", "RA", "SN", "TS", "FG"];
for i= 1:9
    if means(i) > x(i,1) && means(i) < x(i,2)
        fprintf("%i The mean value of the indicator %s is inside the parametric confidence interval\n", i, indicator(i));
    else
        fprintf("%i The mean value of the indicator %s isn't inside the parametric confidence interval\n", i, indicator(i));
    end
    if means(i) > x_b(i,1) && means(i) < x_b(i,2)
        fprintf("  The mean value of the indicator %s is inside the bootstrap confidence interval\n", indicator(i));
    else
        fprintf("  The mean value of the indicator %s isn't inside the bootstrap confidence interval\n", indicator(i));
    end
end

fprintf("\n\n\n");

int_diff = x - x_b;
for i = 1:9
    if abs(int_diff(i,1)) >= 0.1 || abs(int_diff(i,2)) >= 0.1
        fprintf("The intervals of the indicator %s have a significant difference\n", indicator(i));
        fprintf("Parametric confidence interval: [%f, %f]\n", x(i,1), x(i, 2));
        fprintf("Bootstrap confidence interval: [%f, %f]\n\n", x_b(i,1), x_b(i, 2));
    end
end

firstmeans = zeros(9, 1);
firstmeans(1) = mean(T);
firstmeans(2) = mean(TM);
firstmeans(3) = mean(Tm);
firstmeans(4) = mean(PP);
firstmeans(5) = mean(V);
firstmeans(6) = mean(RA);
firstmeans(7) = mean(SN);
firstmeans(8) = mean(TS);
firstmeans(9) = mean(FG);

fprintf("\n\n\n");
mean_diff = means - firstmeans;
for i = 1:9
    if abs(mean_diff(i)) >= 1
        fprintf("The mean values of the indicator %s for the years 1949-1958 and 1973-2017 have a significant difference\n", indicator(i));
        fprintf("Mean value for 1949-1958: %f\n", means(i));
        fprintf("Mean value for 1973-2017: %f\n\n", firstmeans(i));
    end
end