function [v,naocoincidem,i_erros] = log_v(myiPeak,iPeak)
    v_erros = abs((myiPeak(:)-iPeak(:))./iPeak(:)*100);
    v = [myiPeak(:),iPeak(:), v_erros];
    n = 1:size(iPeak,1);
    i_erros = n(v_erros>50);
    naocoincidem = length(i_erros);
end