% FG
clc
clear

Heathrow = readtable('Heathrow.xlsx');

indicators = ["T", "TM", "Tm", "PP", "V", "RA", "SN", "TS", "GR"];

FG = Heathrow.FG(11:55);

T = Heathrow.T(11:55);
TM = Heathrow.TM(11:55);
Tm = Heathrow.Tm(11:55);
PP = Heathrow.PP(11:55);
V = Heathrow.V(11:55);
RA = Heathrow.RA(11:55);
SN = Heathrow.SN(11:55);
TS = Heathrow.TS(11:55);
GR = Heathrow.GR(11:55);

ind = (~isnan(T))&(~isnan(TM))&(~isnan(Tm))&(~isnan(PP))&(~isnan(V))&(~isnan(RA))&(~isnan(SN))&(~isnan(TS))&(~isnan(GR))&(~isnan(FG));

FG = FG(ind);
n = length(FG);

data = zeros(9, n);
data(1, :) = T(ind);
data(2, :) = TM(ind);
data(3, :) = Tm(ind);
data(4, :) = PP(ind);
data(5, :) = V(ind);
data(6, :) = RA(ind);
data(7, :) = SN(ind);
data(8, :) = TS(ind);
data(9, :) = GR(ind);

% Multiple Regression
fprintf("---- Multiple Linear Regression model ---\n");
A = zeros(10);
b = zeros(10, 1);
for i = 1:9
    for j = 1:9
        A(i+1, j+1) = sum(data(i,:).*data(j,:));
    end
end
A(1, :) = [n sum(data(1, :)) sum(data(2, :)) sum(data(3, :)) sum(data(4, :)) sum(data(5, :)) sum(data(6, :)) sum(data(7, :)) sum(data(8, :)) sum(data(9, :))];
A(:, 1) = [n sum(data(1, :)) sum(data(2, :)) sum(data(3, :)) sum(data(4, :)) sum(data(5, :)) sum(data(6, :)) sum(data(7, :)) sum(data(8, :)) sum(data(9, :))];

for i = 1:9
    b(i+1) = sum(data(i,:)*FG);
end
b(1) = sum(FG);

bi = A\b;
y = bi(1)*ones(n, 1);
for i = 1:9
    y = y + bi(i+1)*(data(i,:).');
end

adjR2 = 1 - ((n-1)/(n-10))*(sum((FG - y).^2)/sum((FG - mean(FG)).^2));
R2 = 1-(sum((FG - y).^2)/sum((FG - mean(FG)).^2));
se2 = (1/(n-10))*(sum((FG - y).^2));

fprintf("The dispersion of the error is %f\n", se2);
fprintf("R2 = %f\n", R2);
fprintf("adjR2 = %f\n", adjR2);

sb = zeros(10,1);
s_r = zeros(10, 1);
for i = 2:10
    c = cov(data(i-1,:), FG);
    sii = c(1,1)*(n-1);
    sb(i) = sqrt(se2)/sii;
    s_r(i) = mean(data(i-1,:))/sii;
end
sb(1) = sqrt(se2)*sqrt(1/n + sum(s_r));

for i = 1:10
    ci = [bi(i) - tinv(1-0.05/2,n-10)*sb(i) bi(i) + tinv(1-0.05/2,n-10)*sb(i)];
    if ~(ci(1) < 0 && ci(2) > 0)
        if i >= 2
            fprintf("The b%d coefficient of the indicator %s is statistically important\n", i-1, indicators(i-1));
        else
            fprintf("The b%d coefficient is statistically important\n", i-1);
        end
    end
end
fprintf("\n\n\n\n");


% Stepwise
fprintf("--- Stepwise Regression model ---");
[b_2,se_2,p_2,inmodel,stats,nextstep,hist]=stepwisefit(data.', FG);
b0_2 = stats.intercept;
for i=1:length(b_2)
    if inmodel(i) == 0
        b_2(i) = 0;
    end
end
b_2 = [b0_2; b_2];
yfit = [ones(n,1) data.']*b_2;
e = FG - yfit;
SSresid = sum(e.^2);
SStotal = (n-1) * var(FG);
R2_2= 1 - SSresid/SStotal;
adjR2_2 = 1 - SSresid/SStotal * (n-1)/(n-length(b_2)-1);

fprintf("The dispersion of the error is %f\n", (1/(n-10))*SSresid);
fprintf("R2 = %f\n", R2_2);
fprintf("adjR2 = %f\n", adjR2_2);

for i = 1:9
    ci = [b_2(i) - tinv(1-0.05/2,n-10)*se_2(i) b_2(i) + tinv(1-0.05/2,n-10)*se_2(i)];
    if ~(ci(1) < 0 && ci(2) > 0)
        if i >= 2
            fprintf("The b%d coefficient of the indicator %s is statistically important\n", i-1, indicators(i-1));
        else
            fprintf("The b%d coefficient is statistically important\n", i-1);
        end
    end
end
fprintf("\n\n\n\n");



%Ridge Regression
fprintf("---- Ridge Regression model ---\n");
k = 0:1e-3:5e-1;
bRRv = ridge(FG, data.', k, 0);

idx = -1;
bRR = bRRv(:,1);
yfitRR = [ones(n,1) data.']*bRR;
for i=1:length(k)
    yfittemp = [ones(n,1) data.']*bRRv(:,i);
    if(sum(sqrt(FG-yfittemp)) < sum(sqrt(FG-yfitRR)))
        bRR = bRRv(:,i);    
        yfitRR = yfittemp;
        idx = i;
    end
end

adjR2_3 = 1 - ((n-1)/(n-10))*(sum((FG - yfitRR).^2)/sum((FG - mean(FG)).^2));
R2_3 = 1-(sum((FG - yfitRR).^2)/sum((FG - mean(FG)).^2));
se2_3 = (1/(n-10))*(sum((FG - yfitRR).^2));

fprintf("The dispersion of the error is %f\n", se2_3);
fprintf("R2 = %f\n", R2_3);
fprintf("adjR2 = %f\n", adjR2_3);

sb = zeros(10,1);
s_r = zeros(10, 1);
for i = 2:10
    c = cov(data(i-1,:), FG);
    sii = c(1,1)*(n-1);
    sb(i) = sqrt(se2_3)/sii;
    s_r(i) = mean(data(i-1,:))/sii;
end
sb(1) = sqrt(se2_3)*sqrt(1/n + sum(s_r));

for i = 1:10
    ci = [bRR(i) - tinv(1-0.05/2,n-10)*sb(i) bRR(i) + tinv(1-0.05/2,n-10)*sb(i)];
    if ~(ci(1) < 0 && ci(2) > 0)
        if i >= 2
            fprintf("The b%d coefficient of the indicator %s is statistically important\n", i-1, indicators(i-1));
        else
            fprintf("The b%d coefficient is statistically important\n", i-1);
        end
    end
end
