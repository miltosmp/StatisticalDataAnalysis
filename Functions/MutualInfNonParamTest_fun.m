function [I, p, n] = MutualInfNonParamTest_fun(data1, data2)

    data1 = data1(~isnan(data1));
    data2 = data2(~isnan(data1));
    data1 = data1(~isnan(data2));
    data2 = data2(~isnan(data2));

    n = max(size(data1));
    
    med1 = median(data1);
    med2 = median(data2);
    inf_data1 = zeros(n, 1);
    inf_data2 = zeros(n, 1);
    for i = 1:n
        if data1(i) < med1
            inf_data1(i) = 0;
        else
            inf_data1(i) = 1;
        end
        
        if data2(i) < med2
            inf_data2(i) = 0;
        else
            inf_data2(i) = 1;
        end
    end
    I = mutual_information(inf_data1, inf_data2);
    
    L = 1000;
    pvals = zeros(L, 1);
    inf_shuf_data = zeros(n, 1);
    for i = 1:L
        shuf_data = data2(randperm(length(data2)));
        for j = 1:length(data2)
            if shuf_data(j) < median(shuf_data)
                inf_shuf_data(j) = 0;
            else
                inf_shuf_data(j) = 1;
            end
        end
        I_rand = mutual_information(inf_data1, inf_shuf_data);
        if abs(I_rand) >= abs(I)
            pvals(i) = 1;
        end
    end
    p = mean(pvals);
end

function I = mutual_information(x, y)
    Pxy = histcounts2(x, y);
    Pxy = Pxy/sum(Pxy(:));
    Px = histcounts(x);
    Px = Px/sum(Px);
    Py = histcounts(y);
    Py = Py/sum(Py);
    
    Hxy = 0;
    Hx = 0;
    Hy = 0;
    for i = 1:size(Pxy, 1)
        Hx = Hx - Px(i)*log2(Px(i));
        for j = 1:size(Pxy, 2)
            if Pxy(i,j) ~= 0
                Hxy = Hxy - Pxy(i,j) * log2(Pxy(i,j));
            end 
            if i == 1
                Hy = Hy - Py(j)*log2(Py(j));
            end
        end
    end
    I = Hx + Hy - Hxy;
end