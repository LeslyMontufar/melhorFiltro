clc;
close all; 
clearvars;
load('dadosLesly.mat');

myiPeak = ones(length(iPeak),1);
if ~verifica_picos(myiPeak,iPeak,pulsos); return; end

% ---- Determinando se a primeira oscila��o � um m�nimo ou m�ximo local ----
err_eq = 0.0045;
% i = 51;
% r = 30;
% kk = .8;
% pp = 15;
% pulso = pulsos(i,:);
% ipulso2 = 1:1/r:size(pulso,2)+1-1/r;
% pulso2 = spline(1:size(pulso,2),pulso,ipulso2);
 

% figure;
% plot(pulso);
% hold on;
% plot(ipulso2,pulso2);
% line ([size(pulso,2) 0], [iPeak(i,1) iPeak(i,1)], "linestyle", "-", "color", "g");
% 
% ipulso3 = 1:1/r:size(pulso,2)+1-1/r;
% pulso3 = resample(pulso,r,1);
% plot(ipulso3,pulso3);

% metodo
% sub = 0;
% myiPeak_ = abs(myiPeak(i));
% n = 1:size(pulso,2);
% k = floor(kk/100*size(pulso,2));
% pulso_mm = conv(pulso,ones(1,k)/k,'same');
% derivada = diff(pulso_mm);
% derivada = [0 derivada];
% 
% ider = 1:1/r:size(derivada,2)+1-1/r;
% der = spline(1:size(derivada,2),derivada,ider);
% der0 = round(ider(abs(der)<=1/100*max(abs(der))));
% [~,der0] = findgroups(der0);
% 
% s = pulso_mm(der0);
% n = n(der0);
% 
% condicao = (abs(pulso_mm(der0))>=.4*err_eq);%pp/100*max(abs(pulso_mm(der0)))); 
% s = s(condicao);
% n = n(condicao);
% myiPeak_ = s(1)/abs(s(1)) * myiPeak_;
% 
% if sub == 0
%     fh = figure;
%     fh.WindowState = 'maximized';
% end
% plot(pulso);
% hold on;
% plot(pulso_mm);
% line ([size(pulso,2) 0], [iPeak(i,1) iPeak(i,1)], "linestyle", "-", "color", "g"); 
% scatter(n,s,'r','filled');
% 
% plot(.05*max(abs(pulso))/max(abs(derivada))*derivada);
% 
% v_err = abs((myiPeak_-iPeak(i,1))/iPeak(i,1)*100);
% title([i,myiPeak_,iPeak(i,1), v_err]);
% xlim([0 size(pulso,2)]);
% if sub == 0
%     legend("original","mm","derivada");
% end

% return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot_pulso_derivada_erro(2,pulsos,myiPeak,iPeak);

% Dado: 0.0045 � o passo em y, � erro m�nimo do equipamento
% Tem mais erros qnd iPeak ~ 0.25, logo qnd o erro � 1.8% do pico de
% corrente.

% Gerando resultado final
r = 30;
kk = .8;
pp = 15;
k = floor(kk/100*size(pulsos,2)*r);
derivada = zeros(1,size(pulsos,2)*r);
for i=1:size(pulsos,1)
    pulso = pulsos(i,:);
    pulso = resample(pulso,r,1);
    n = 1:size(pulso,2);
    
    % M�dia m�vel
    pulso_mm = conv(pulso,ones(1,k)/k,'same');
    derivada(2:end) = diff(pulso_mm);

    condicao = ((abs(derivada)<=1/100*max(abs(derivada))) & (abs(pulso_mm)>=pp/100*myiPeak(i))); 
    s = pulso_mm(condicao);
    myiPeak(i) = s(1)/abs(s(1)) * myiPeak(i);
    if iPeak(i)/abs(iPeak(i)) ~= myiPeak(i)/abs(myiPeak(i))
        ss(end+1) = s(1);
    end
end
[v,naocoincidem,i_erros] = log_v(myiPeak,iPeak,ss);

% Para testar
% close all;
fh = figure;
fh.WindowState = 'maximized';
for sub=1:9
    i=i_erros(sub);
    subplot(3,3,sub);
    plot_pulso_derivada_erro(i,pulsos,myiPeak,iPeak,r,kk,pp,1,0);
%     plot_pulso_erro(i,pulsos,iPeak,"~");
end 

% plot_pulso_erro(550,pulsos,iPeak,0);
% plot_pulso_erro(286,pulsos,iPeak,0);
% plot_pulso_derivada_erro(552,pulsos,myiPeak,iPeak,kk,pp,0);