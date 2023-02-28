function r2 = LinearRegressionModel_func(data1, data2)
    
    data1 = data1(~isnan(data1));
    data2 = data2(~isnan(data1));
    data1 = data1(~isnan(data2));
    data2 = data2(~isnan(data2));

    x = linspace(min(data1), max(data1), 100);
    
    n = length(data1);

    C = cov(data1, data2);
    b1 = C(1,2)/C(1,1);
    b0 = mean(data2) - b1 * mean(data1);
    r = b1 * std(data1)/std(data2);
    r2 = r^2;

    scatter(data1, data2);
    hold on;
    plot(x, b0 + b1*x);
    title("r = ", r2);
    
end