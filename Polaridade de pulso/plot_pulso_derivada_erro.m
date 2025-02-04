function plot_pulso_derivada_erro(i,pulsos,myiPeak,iPeak,r,kk,pp,sub,mostrar_derivada)
    myiPeak_ = abs(myiPeak(i));
    if size(pulsos,1)==1
        pulso = pulsos;
    else
        pulso = pulsos(i,:);
    end
    pulso = resample(pulso,r,1);
    n = 1:size(pulso,2);
    
    % M�dia m�vel
    k = kk/100*size(pulso,2);
    pulso_mm = conv(pulso,ones(1,k)/k,'same');
    derivada = diff(pulso_mm);
    derivada = [0 derivada];
    condicao = ((abs(derivada)<=1/100*max(abs(derivada))) & (abs(pulso_mm)>=pp/100*max(abs(pulso_mm)))); 
    s = pulso_mm(condicao);
    n = n(condicao);
    myiPeak_ = s(1)/abs(s(1)) * myiPeak_;
    
    % Gr�fico
    if sub == 0
        fh = figure;
        fh.WindowState = 'maximized';
    end
    plot(pulso);
    hold on;
    plot(pulso_mm);
    line ([size(pulso,2) 0], [iPeak(i,1) iPeak(i,1)], "linestyle", "-", "color", "g"); 
    scatter(n,s,'r','filled');
    
    if mostrar_derivada
        yyaxis right
        plot(derivada);
    end
%     v_err = abs((myiPeak_-iPeak(i,1))/iPeak(i,1)*100);
    iPolaridade = iPeak(i,1)/abs(iPeak(i,1));
    v_err = (myiPeak_~=iPolaridade)*100;
    title([i,myiPeak_,iPeak(i,1), v_err]);
    xlim([0 size(pulso,2)]);
    if sub == 0
        legend("original","mm","derivada");
    end
end