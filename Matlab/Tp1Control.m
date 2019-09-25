%guardo mediciones
close all;
T = readtable('..\medicionesControlTP1\rtaEscalon1.csv','HeaderLines',1);
time = T(:, 1);
time = table2array(time);
i=1;
while( time(i) < 0 )
   i = i+1; 
end
time = time(i:end);
v1 = T(:,3);
v1 = table2array(v1);
v1 = v1(i:end);
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
R2 = 1.8e3;
%Parametros del filtro a la salida
Rf = 5.6e3;
Cf = 100e-12;
wf = 1/(Rf*Cf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Primer caso - Utilizando filtro pasabajos RC%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
offset = 0.07;
wo1 = 1/(R1*C1);
eps1 = 0.5*sqrt( wo1/(Kd*K0) )
s = tf('s');
num = Kd*K0;
first_term = 1/(wo1*wf);
second_term = 1*( (wf+wo1)/(wo1*wf) );
third_term = 1*( (wf+Kd*K0)/wf );
fourth_term = Kd*K0;
den = (s^3)*first_term + (s^2)*second_term + s*third_term + fourth_term;
H1 = num/den;
%Respuesta al escalon
step_response = step(H1,time,stepDataOptions('StepAmplitude',offset*2));
step_response = step_response - offset;
%Grafica
figure(1);
hold on;
title('Respuesta al escalón del circuito con F1(s)');
ylabel('Vout(volts)');
xlabel('tiempo(us)');
time = time*1e6;
plot(time,step_response)
hold on
plot(time,v1);
legend('Teórica', 'Medida');
hold off
grid;
[z,p,k] = tf2zp(num,[first_term second_term third_term fourth_term])
[woi] =abs(p);
H1