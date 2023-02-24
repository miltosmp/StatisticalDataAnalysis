function [p_1, p_2, h, type] = Plot_ParametricTest(data)
    data_u = unique(data);
    n = max(size(data_u)); 
    if n > 10
        histogram(data);
        [h_1, p_1] = chi2gof(data);
        [h_2, p_2] = chi2gof(data, 'CDF', makedist('Uniform'));
        
        txt = ["p-value for Normal Distribution fit: ", p_1, "p-value for Uniform Distribution fit: ", p_2];
        title(txt);
        
        if h_1 == 1 && h_2 == 0 % Uniform Distribution fit
            fprintf(" The distribution of the input data fit on a Uniform Distribution\n");
            h = 1;
        elseif h_1 == 0 && h_2 == 1 % Normal Distribution fit   
            fprintf(" The distribution of the input data fit on a Normal Distribution\n");
            h = 2;
        elseif h_1 == 0 && h_2 == 0 % Both
            fprintf(" The distribution of the input data fit both on a Normal and a Uniform Distribution\n"); 
        else
            fprintf(" The distribution of the input data does not fit on a Normal or Uniform Distribution\n");
            h = 0;
        end
        
        type = 1;
    else
        bar(data);        
        [h_1, p_1] = chi2gof(data, 'CDF', makedist('Binomial'));
        [h_2, p_2] = chi2gof(data, 'CDF', makedist('Uniform'));
        
        txt = ["p-value for Binomial Distribution fit: ", p_1, "p-value for Uniform Distribution fit: ", p_2];
        title(txt);
        
        if h_1 == 1 && h_2 == 0 % Uniform Distribution fit
            fprintf(" The distribution of the input data fit on a Uniform Distribution\n");
            h = 1;
        elseif h_1 == 0 && h_2 == 1 % Binomial Distribution fit   
            fprintf(" The distribution of the input data fit on a Binomial Distribution\n");
            h = 2;
        elseif h_1 == 0 && h_2 == 0 % Both
            fprintf(" The distribution of the input data fit both on a Binomial and a Uniform Distribution\n"); 
        else
            fprintf(" The distribution of the input data does not fit on a Binomial or Uniform Distribution\n");
            h = 0;
        end
        
        type = 0;
    end


end