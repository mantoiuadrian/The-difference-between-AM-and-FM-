Fs=10^5;
T= 2*10^-3;
t= 0:1/Fs:T-1/Fs;
A_mesaj= 2;
f_mesaj=10^3;
A_purtatoare= 2;
f_purtatoare= 15*10^3;
m= 0.8;
x_msj=A_mesaj*cos(2*pi*f_mesaj*t);
s_am= A_purtatoare*(1+m*x_msj).*cos(2*pi*f_purtatoare*t);
SNR=15;
s_am_zg= awgn(s_am, SNR, 'measured');

figure;
subplot(2,1,1);
plot(t*10^3, s_am); grid on;
xlabel('Timp [ms]'); ylabel('Amplitudine');
title('Semnal AM fara zgomot');

subplot(2,1,2);
plot(t*10^3, s_am_zg); grid on;
xlabel('Timp [ms]'); ylabel('Amplitudine');
title(['Semnal AM cu zgomot)']);

s_abs = abs(s_am_zg); 
fc=1.2 * f_mesaj;
[b, a]=butter(2, fc / (Fs/2), 'low'); 
s_demodulat=filter(b, a, s_abs);
s_demodulat=s_demodulat - mean(s_demodulat);

P_semnal=mean(x_msj.^2);
factor_scalare=std(s_demodulat) / std(x_msj);
s_demodulat_scalat=s_demodulat / factor_scalare;
zg_ramas= s_demodulat_scalat- x_msj;
P_zg=mean(zg_ramas.^2);
SNR_out= 10 * log10(P_semnal / P_zg);
fprintf('SNR-ul semnalului demodulat la iesire: %.2f dB\n', SNR_out);


figure;
subplot(3,1,1);
plot(t, s_am_zg);
title('Semnal AM cu zgomot');
xlabel('Timp (s)');
ylabel('Amplitudine');
grid on;

subplot(3,1,2);
plot(t, s_abs);
title('Semnal- valoare absoluta');
xlabel('Timp (s)');
ylabel('Amplitudine');
grid on;

subplot(3,1,3);
plot(t, s_demodulat);
hold on;
plot(t, x_msj, 'r--'); 
title('Semnal demodulat si semnal mesaj original');
xlabel('Timp (s)');
ylabel('Amplitudine');
legend('Semnal Demodulat', 'Semnal Mesaj Original');
grid on;