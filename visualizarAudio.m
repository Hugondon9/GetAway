%{ 
    Laboratorio de Diseño Electrónico
    Get - Away
    Visualización de Señales
    Fecha: 08/06/20
%}
%% Clearing the working environment %%
clc; clear all; close all;
% Obtener Señales
[a1, Fs] = audioread('EnFase1K.wav');
[a2, Fs] = audioread('Desfasado1K.wav');

% Cálculos
zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);                    % Returns Zero-Crossing Indices Of Argument Vector
intervalX = 1*2.5*10^-3;
a1 = a1(:,1);
a2 = a2(:,1);
t1 = (0:length(a1)-1)./Fs;                   % Time vector
t2 = (0:length(a2)-1)./Fs;
zx1 = zci(a1);   
zx2 = zci(a2);
% Plotteo
figure("Name", "Resultados All - Pass Filter")
subplot(2,4,[1 2])
plot(t1,a1, 'b');
xlabel("t [s]"); ylabel("A"); title("Señal Original"); xlim([0 intervalX]); ylim([-max(a2) max(a2)]); grid on;

subplot(2, 4, [3 4]);
plot(t2,a2, 'r');
xlabel("t [s]"); ylabel("A"); title("Señal Desfasada"); xlim([0 intervalX]); ylim([-max(a2) max(a2)]); grid on;

subplot(2, 4, [5 8]);
plot1 = plot(t1, a1);
plot1.Color(3) = 1;
hold on
plot2 = plot(t2, a2);
plot2.Color(4) = 0.3;
title("Comparación"); xlabel("t [s]"); ylabel("A"); grid on;
xlim([0 intervalX]); ylim([-max(a2) max(a2)]);
legend('Señal Original', 'Señal Desfasada')

% Correlación
figure('name','Cross Correlation');
x = xcorr(a1,a2,'coeff');
tx = (-(length(a1)-1):length(a1)-1)./Fs; 
[mx,ix] = max(x);
lag = tx(ix);
Fmuestreada = 1000;                         % Frecuencia 
gradosDesfase = 360*Fmuestreada*lag;
fprintf('Lag en Tiempo = %.9f ssegundos\nGrados Desfase Real: %3.2f°\n',lag,gradosDesfase);