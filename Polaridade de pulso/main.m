clc;
% close all; 
clearvars;
load('dadosLesly.mat');

myiPeak = ones(length(iPeak),1);
if ~verifica_picos(myiPeak,iPeak,pulsos); return; end

% ---- Determinando se a primeira oscila��o � um m�nimo ou m�ximo local ----
err_eq = 0.0046;
i = 51;
r = 30;
kk = .8;
pp = 15;
pulso = pulsos(i,:);
pulso = pulso.*(abs(pulso)<err_eq);
figure;
plot(pulso);
% hold on;
% pulso = resample(pulso,r,1);
% ipulso = 1:1/r:size(pulso,2)/r+1-1/r;
% plot(ipulso,pulso);
% plot_pulso_derivada_erro(i,pulso,myiPeak,iPeak,r,kk,pp,0,0);

return;
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