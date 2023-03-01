function [adjR2, p] = NonLinearRegresRandomTest_fun(data1, data2)
    
    data1 = data1(~isnan(data1));
    data2 = data2(~isnan(data1));
    data1 = data1(~isnan(data2));
    data1 = data1.';
    data2 = data2(~isnan(data2));
    
    [adjR2, ~] = PolynomialRegression(data1, data2);
    
    L = 1000;
    pvals = zeros(L, 1);
    for i = 1:L
        shuf_data = data2(randperm(length(data2)));
        [adjR2_r, ~] = PolynomialRegression(data1, shuf_data);
        if abs(adjR2_r) >= abs(adjR2)
            pvals(i) = 1;
        end
    end
    p = mean(pvals);
end

function [adjR2, bi] = PolynomialRegression(data1, data2)
    n = length(data1);
    A = [n sum(data1) sum(data1.^2); sum(data1) sum(data1.^2) sum(data1.^3); sum(data1.^2) sum(data1.^3) sum(data1.^4)];
    b = [sum(data2); sum(data2.*data1); sum(data2.*data1.^2)];
    bi = A\b;
    y = bi(1) + bi(2) * data1 + bi(3) * data1.^2;
    adjR2 = 1 - ((n-1)/(n-3))*(sum((data2 - y).^2)/sum((data2 - mean(data2)).^2));
end