%guardo mediciones
%T = readtable('..\medicionesControlTP1\rtaEscalon2.csv','HeaderLines',1);
%time = T(:, 1);
time = linspace(0,80e-6,1e6);

%Parametros del demodulador
Vdd=10;
%Parametros del PLL
K0=921352;
Kd= Vdd/pi;

%%%%%%%%%%%%%%%%%%%%%%%%%
%Parametros del circuito%
%%%%%%%%%%%%%%%%%%%%%%%%%

%Parametros del filtro RC
R1 = 10e3;
C1 = 1e-9;
R2 = 1e6;%'R=500','R=1k', 'R=1.65k', 'R=2k', 'R=3k'
%Parametros del filtro a la salida
Rf = 5.6e3;
Cf = 100e-12;
wf = 1/(Rf*Cf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Segundo caso - Utilizano filtro pasabajos RCR%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
offset = 0.073;
tau1 = C1*R1;
tau2 = C1*R2;
eps2 = (1+Kd*K0.*tau2) / (2*sqrt(Kd*K0*(tau1+tau2)) )
s = tf('s');
num = Kd*K0*(tau2*s+1);
first_term = 1*( (tau1+tau2)/wf );
second_term = 1*( (1+Kd*K0*tau2+wf*(tau1+tau2))/wf );
third_term = 1*( (Kd*K0+wf*(1+Kd*K0*tau2))/wf );
fourth_term = Kd*K0;
den = (s^3)*first_term + (s^2)*second_term + s*third_term + fourth_term;
H1 = num/den;
%Respuesta al escalon
step_response = step(H1,time,stepDataOptions('StepAmplitude',offset));
%step_response = step_response - offset;
%Grafica
figure(1);
hold on;
title('Respuesta al escalón con distintos valores de resistencia');
ylabel('Vout(volts)');
xlabel('tiempo(us)');
%time = time*1e6;
plot(time,step_response)
hold on
%plot(time,v1);
legend('R=500','R=1k', 'R=1.65k', 'R=2k', 'R=5k', 'R=100e3','R=1e6');
xlim([0 80e-6]);
grid on;
%[z,p,k] = tf2zp([Kd*K0.*tau2 Kd*K0],[first_term second_term third_term fourth_term]);
%[woi] =abs(p);
