%guardo mediciones
T = readtable('..\medicionesControlTP1\rtaEscalon1.csv','HeaderLines',1);
t = T(:, 1);
v1 = T(:,2);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Primer caso - Utilizano filtro pasabajos RC%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wo1 = 1/(R1*C1);
k1 = 1/K0;
eps1 = 0.5*sqrt( wo1/(Kd*K0) );
s = tf('s');
H1 = k1/( (s/wo1)^2 + ((2*eps1)/wo1)*s + 1 );
%Respuesta al escalon
step(H1,t)
grid;
