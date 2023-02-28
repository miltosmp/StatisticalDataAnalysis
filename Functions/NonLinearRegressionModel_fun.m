function [r, i, b] = NonLinearRegressionModel_fun(data1, data2)
    
    data1 = data1(~isnan(data1));
    data2 = data2(~isnan(data1));
    data1 = data1(~isnan(data2));
    data1 = data1.';
    data2 = data2(~isnan(data2));
    
    x = linspace(min(data1), max(data1), 100);

    n = length(data1);
    adjR2 = zeros(5, 1);
    
    % First order polynomial
    C = cov(data1, data2);
    b11 = C(1,2)/C(1,1);
    b10 = mean(data2) - b11 * mean(data1);
    y1 = b10 + b11 * data1;
    adjR2(1) = 1 - ((n-1)/(n-2))*(sum((data2 - y1).^2)/sum((data2 - mean(data2)).^2));
    
    subplot(2, 3, 1);
    scatter(data1, data2);
    hold on;
    y1_pl = b10 + b11 * x;
    plot(x, y1_pl);
    title("r = ", adjR2(1));
    
    % Second order polynomial
    A = [n sum(data1) sum(data1.^2); sum(data1) sum(data1.^2) sum(data1.^3); sum(data1.^2) sum(data1.^3) sum(data1.^4)];
    b = [sum(data2); sum(data2.*data1); sum(data2.*data1.^2)];
    b2 = A\b;
    y2 = b2(1) + b2(2) * data1 + b2(3) * data1.^2;
    adjR2(2) = 1 - ((n-1)/(n-3))*(sum((data2 - y2).^2)/sum((data2 - mean(data2)).^2));
    
    subplot(2, 3, 2);
    scatter(data1, data2);
    hold on;
    y2_pl = b2(1) + b2(2) * x + b2(3) * x.^2;
    plot(x, y2_pl);
    title("r = ", adjR2(2));
    
    % Third order polynomial
    A = [n sum(data1) sum(data1.^2) sum(data1.^3); sum(data1) sum(data1.^2) sum(data1.^3) sum(data1.^4); sum(data1.^2) sum(data1.^3) sum(data1.^4) sum(data1.^5); sum(data1.^3) sum(data1.^4) sum(data1.^5) sum(data1.^6)];
    b = [sum(data2); sum(data2.*data1); sum(data2.*data1.^2); sum(data2.*data1.^3)];
    b3 = A\b;
    y3 = b3(1) + b3(2) * data1 + b3(3) * data1.^2 + b3(4) * data1.^3;
    adjR2(3) = 1 - ((n-1)/(n-4))*(sum((data2 - y3).^2)/sum((data2 - mean(data2)).^2));
    
    subplot(2, 3, 3);
    scatter(data1, data2);
    hold on;
    y3_pl = b3(1) + b3(2) * x + b3(3) * x.^2 + b3(4) * x.^3;
    plot(x, y3_pl);
    title("r = ", adjR2(3));
    
    % Exponential 
    data2_e = log(data2);
    C = cov(data1, data2_e);
    b4 = C(1,2)/C(1,1);
    lna4 = mean(data2_e) - b4 * mean(data1);
    a4 = exp(lna4);
    y4 = a4*exp(b4*data1);
    adjR2(4) = 1 - ((n-1)/(n-2))*(sum((data2 - y4).^2)/sum((data2 - mean(data2)).^2));
    
    subplot(2, 3, 4);
    scatter(data1, data2);
    hold on;
    y4_pl = a4*exp(b4*x);
    plot(x, y4_pl);
    title("r = ", adjR2(4));
    
    % Logarithmic
    data1_l = log(data1);
    C = cov(data1_l, data2);
    b5 = C(1,2)/C(1,1);
    a5 = mean(data2) - b5 * mean(data1_l);
    y5 = a5 + b5 * data1_l;
    adjR2(5) = 1 - ((n-1)/(n-2))*(sum((data2 - y5).^2)/sum((data2 - mean(data2)).^2));
    
    subplot(2, 3, 5);
    scatter(data1, data2);
    hold on;
    y5_pl = a5 + b5 * log(x);
    plot(x, y5_pl);
    title("r = ", adjR2(5));
    
    [r, i] = max(adjR2);   
    switch i
        case 1
            b = [b10; b11];
        case 2
            b = b2;
        case 3
            b = b3;
        case 4
            b = [a4; b4];
        case 5
            b = [a5; b5];
    end
end