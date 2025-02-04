clc; clearvars; close all; 
load('..\dadosLesly.mat');
err_eq = 0.0045;
plot_info_pulso = 1;
i = 1;

n_pulsos = size(pulsos,1);

pulso_original = pulsos(i,:);
f_norm = sqrt(sum(pulso_original.^2)); 

% Normaliza
pulso = pulso_original/f_norm;
peak = iPeak(i)/f_norm;

% Calcula T e F (TF-map)
ti = 1:numel(pulso);
Ts = ti(2)-ti(1);
t_end = ti(end);
t0 = centroide(ti,pulso,0.5);
n = 1;

T2 = centroide(ti-t0,pulso,n);
sigmaT = sqrt(T2);

finit = ceil(t_end/2)+1;
pulso_fft = fftshift(fftn(pulso)/t_end);
pulso_fft = pulso_fft(finit:end);
pulso_fft_abs = abs(pulso_fft);
freqs = ((-t_end/2:t_end/2-1)/(t_end*Ts));
freqs = freqs(finit:end);
F2 = centroide(freqs, pulso_fft, n);
sigmaF = sqrt(F2);
f0 = centroide(freqs,pulso_fft,0.5);

% figure(2);
% scatter(F2,T2,10,'b','filled'); hold on;
% scatter(sigmaF,sigmaT,10,'r','filled');

% trigger = (err_eq*1.001)/f_norm;
% start = find(pulso>trigger,1);
% stop = find(pulso>trigger,1,"last");
% t_start = sum(ti(start:floor(t0)).*(pulso(start:floor(t0)).^2))/ sum(pulso(start:floor(t0)).^2);
% t_stop = sum(ti(ceil(t0):stop).*(pulso(ceil(t0):stop).^2))/ sum(pulso(ceil(t0):stop).^2);
t_start = 1;
t_stop = t_end;

if plot_info_pulso
fh = figure(1);
% fh.WindowState = 'maximized';
subplot(121);
plot(pulso);
line_h(peak,"g")
line_v(t0,"c",pulso);
line_v(sigmaT,"m",pulso);

teste = sigmaT;
line_v(teste,"g",pulso);
fprintf("Divis�o da energia: %.4g e %.4g\n",energia_div(pulso,ti,teste))

title(energia_div(pulso,ti,t0));
ylabel("Corrente");
xlabel("Tempo/Amostras");

subplot(122);
finit = 1;
plot(freqs,pulso_fft_abs,'linewidth',1.5,'color',[0 0 0]);
line_v(f0,"c",pulso_fft_abs); 
line_v(sigmaF,"m",pulso_fft_abs); 
ylabel("Magnitude");
xlabel("Freqs (Hz)");
title(energia_div(pulso_fft_abs,freqs,f0));
suptitle(sprintf("Dados do pulso: %.3g - %.3g",energia_div(pulso,ti,t0) ));

% fprintf("t_start: %d\n",t_start);
fprintf("t0: %d\n",t0);
% fprintf("t_stop: %d\n",t_stop);

fprintf("\n")

fprintf("T: %d\n",sigmaT);
fprintf("W: %d\n",sigmaF);
fprintf("Energia do pulso original: %d\n", energia(pulso_original,1,t_end));
fprintf("Divis�o da energia: %.4g e %.4g\n",energia_div(pulso,ti,t0))
fprintf("Divis�o da energia: %.4g e %.4g\n",energia_div(pulso_fft_abs,freqs,f0))
fprintf("Divis�o da energia: %.4g e %.4g\n",energia_div(pulso_fft_abs,freqs,sigmaF))

end

function e = energia_div(y,x,x0)
    x0 = x0/(x(2)-x(1));
    e1 = energia(y,1,x0);
    e2 = energia(y,x0,numel(x));
    etot = energia(y,1,numel(x));
    e = [e1 e2]/etot*100;
end

function e = energia(y,xinit,xend)
    try
        e = sum(abs(y(floor(xinit):ceil(xend))).^2);
    catch
        fprintf("index: %d %d\n\t\t %d %d\n",xinit,xend,floor(xinit),ceil(xend))
    end
end
function c = centroide(x,y,n)
    c = sum(x.^(2*n) .* abs(y).^2) / sum(abs(y).^2);
end

function line_h(yconst,color)
line ([1000 0], [yconst yconst], "linestyle", "-", "color", color); 
end
function line_v(xconst,color,y)
line ([xconst xconst], [min(y) max(y)], "linestyle", "-", "color", color); 
end