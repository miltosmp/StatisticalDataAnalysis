function [p1, p2, ci1, ci2] = MeanDifferenceTest_fun(dates, data)
    n_m = 0;
    for i = 1:size(dates)-1
        if dates(i) ~= dates(i+1)-1
            n_m = i;
        end
    end
    if n_m == 0
        fprintf("Error, there was no gap in the dates data"); 
    else
        data1 = data(1:n_m);
        data1 = data1(~isnan(data1));
        data2 = data(n_m+1:max(size(data)));
        data2 = data2(~isnan(data2));
        
        [~, p1, ci1, ~] = ttest2(data1, data2);
        
        B = 1000;
        bootstat1 = bootstrp(B, @mean, data1);
        bootstat2 = bootstrp(B, @mean, data2);
        bootstat12 = bootstat1 - bootstat2;
        bootstat12 = sort(bootstat12);
        k_low = floor((B+1)*0.05/2);
        k_up = B + 1 - k_low;
        ci2 = [bootstat12(k_low) bootstat12(k_up)];
        
        t_bar = mean(data1) - mean(data2);
        pvals = zeros(B, 1);
        for i = 1:B
            shuf_data = [data1; data2];
            shuf_data = shuf_data(randperm(length(data1)+length(data2)));
            diff_mean = mean(shuf_data(1:length(data1))) - mean(shuf_data(length(data1)+1:end));
            if abs(diff_mean) > abs(t_bar)
                pvals(i) = 1;
            end
        end
        p2 = mean(pvals);
    end
end