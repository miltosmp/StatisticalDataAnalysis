function [x, x_b] = BootstrapCI_func(data)
    data = data(~isnan(data));
    
    [~, ~, x, ~] = ttest(data);
    
    B = 5000;
    x_b = bootci(B, @mean, data);
end