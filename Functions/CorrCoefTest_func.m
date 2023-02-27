function [ci1, ci2, p1, p2, n, r] = CorrCoefTest_func(data1, data2)

    data1 = data1(~isnan(data1));
    data2 = data2(~isnan(data1));
    data1 = data1(~isnan(data2));
    data2 = data2(~isnan(data2));
    
    n = max(size(data1));
    r = correlation(data1, data2);

    z = 0.5*log((1+r)/(1-r));
    z_interval = norminv(1-0.05/2)*sqrt(1/(n-3));
    ci_z = [z - z_interval, z + z_interval];
    rl = (exp(2*ci_z(1))-1)/(exp(2*ci_z(1))+1);
    ru = (exp(2*ci_z(2))-1)/(exp(2*ci_z(2))+1);
    ci1 = [rl, ru];
    
    B = 1000;
    ci2 = bootci(B, @correlation , data1, data2);
    ci2 = ci2.';
    
    t = r*sqrt((n-2)/(1-r^2));
    p1 = 1-tcdf(t, n-2);

    L = 1000;
    pvals = zeros(L, 1);
    for i = 1:L
        shuf_data = data2(randperm(length(data2)));
        corr = correlation(data1, shuf_data);
        if abs(corr) >= abs(r)
            pvals(i) = 1;
        end
    end
    p2 = mean(pvals);
end

function c = correlation(x,y)
    c = corrcoef(x, y);
    c = c(1,2);
end