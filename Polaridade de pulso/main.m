clc;close all; clearvars;
load('dadosLesly.mat');

% plot_pulsos_iPeak(1);

err_per = 0.1; % erro de aproximadamente 0.1%
myiPeak = zeros(length(iPeak),1);
cnt = 0;
for i=1:size(pulsos,1)
    myiPeak(i) = max(abs(pulsos(i,:)));
    if myiPeak(i)-abs(iPeak(i))> err_per/100*abs(iPeak(i))
        fprintf("%d: %d %d\n",i,myiPeak(i),abs(iPeak(i)))
        cnt=cnt+1;
    end
end
coincidiram = size(pulsos,1)-cnt;

% pulso com uma oscila��o gigante no final
i = 4158;
myiPeak(i) = max(abs(pulsos(i,1:end-5)));
if myiPeak(i)-abs(iPeak(i))<= err_per/100*abs(iPeak(i))
    coincidiram = coincidiram + 1;
%     fprintf("%d: %d %d",i,myiPeak(i),abs(iPeak(i)))
%     fprintf(" -> sucesso\n");
else
    return
end

% ---- Determinando se a primeira oscila��o � um m�nimo ou m�ximo local ----
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