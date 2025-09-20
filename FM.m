fs=600; 
fc=150;  
t=(0:1/fs:0.2)';
x=sin(2*pi*30*t)+2*sin(2*pi*60*t);
fDev=30;
y=fmmod(x,fc,fs,fDev);
SNR=10;

s_fm_zg= awgn(y, SNR, 'measured');
subplot(2,1,1)
plot(t,y,'b-')
xlabel('Timp [ms]')
ylabel('Amplitudine')
title(['Semnal FM fara zgomot)']);

subplot(2,1,2);
plot(t, s_fm_zg); grid on;
xlabel('Timp [ms]'); ylabel('Amplitudine');
title(['Semnal FM cu zgomot)']);

x_demodulat=fmdemod(s_fm_zg, fc, fs, fDev);
x_demodulat=x_demodulat - mean(x_demodulat);
x_demodulat=x_demodulat * (max(x) / max(x_demodulat));


P_semnal=mean(x.^2);
factor_scalare=std(x_demodulat) / std(x);
x_demodulat_scalat =x_demodulat / factor_scalare;
zg_ramas=x_demodulat_scalat - x;
P_zg = mean(zg_ramas.^2);
SNR_out = 10 * log10(P_semnal / P_zg);
fprintf('SNR-ul semnalului demodulat la iesire: %.2f dB\n', SNR_out);



figure;
subplot(3,1,1);
plot(t, x, 'k-');
title('Semnal mesaj original');
xlabel('Timp (s)');
ylabel('Amplitudine');
grid on;

subplot(3,1,2);
plot(t, s_fm_zg, 'b-');
title('Semnal FM cu zgomot (SNR=5)');
xlabel('Timp (s)');
ylabel('Amplitudine');
grid on;

subplot(3,1,3);
plot(t, x_demodulat, 'r-');
hold on;
plot(t, x, 'k--');
title('Semnal demodulat vs. Semnal original');
xlabel('Timp (s)');
ylabel('Amplitudine');
legend('Semnal Demodulat', 'Semnal Original');
grid on;