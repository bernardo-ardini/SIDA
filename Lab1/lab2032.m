%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %      
%  Tutorial of the basic functions of the System Identification Toolbox   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
clc;

%% Model generation / Data generation

N = 200; % length of the data
Ts = 1;  % sampling time

% Coefficientes of the actual model (e.g. ARX model):
% numerators and denominators of the model with feedback
Fnum = [0 2.99 -0.2];  
Fden = [1 -0.96 0.97];    
Gnum = [1 -0.96 0.97];
Gden = [1 0 0];

% Input generation: e.g. sum of sinusoids whose frequencies are in the
% interval [pi*alpha1 pi*alpha2]
alpha1 = 0.125;
alpha2 = 0.5;
k_sin = 5; % number of sinusoids
u = idinput(N,'sine',[alpha1 alpha2],[],k_sin);

% Generate NORMALIZED WGN noise en0 (i.e. en0 has variance equal to one)
en0 = idinput(N,'rgs'); 

% noise variance sigma0^2 of e0=sigma_0*en0
noiseVar = 4.6;

% Creation of the actual model (Ts is the sampling time, this parameter
% is optional and the default value is Ts = 1)
m0 = idpoly([],Fnum,Gnum,Gden,Fden,noiseVar,Ts); 

% Creation of the iddata object (a container for all the identification 
% data), in this case we store only the input data u
u = iddata([],u,Ts); 

% Creation of the iddata object, in this case we store only the normalized 
% noise data en0
en0 = iddata([],en0,Ts); 

% Generation of the output data given model, input and noise
y = sim(m0, [u en0]);

% Creation of an iddata object for the output and input data 
data = iddata(y,u);

%% PEM method

% Estimation of an ARX model

% orders of the ARX model
% orders_arx(1) = nA
% orders_arx(2) = nB
% orders_arx(3) = nk
orders_arx = [2 2 1]; 

% ARX model estimation
m_arx = arx(data,orders_arx);

disp("ARX estimate:");
% Plot the coefficients of the estimated model
fprintf("a: "); disp(m_arx.a); % A(z)
fprintf("b: "); disp(m_arx.b); % B(z)
fprintf("sigma^2: "); disp(m_arx.NoiseVariance); % sigma^2


% Estimation of an ARMAX model

% orders of the ARMAX model
% orders_armax(1) = nA
% orders_armax(2) = nB
% orders_armax(3) = nC
% orders_armax(4) = nk
orders_armax = [2 2 1 1];

% ARMAX model estimation
m_armax = armax(data,orders_armax);

disp("ARMAX estimate:");
% Plot the coefficient of the estimated model
fprintf("a: "); disp(m_armax.a);  % A(z)
fprintf("b: "); disp(m_armax.b);  % B(z)
fprintf("c: "); disp(m_armax.c);  % C(z)
fprintf("sigma^2: "); disp(m_armax.NoiseVariance); % sigma^2


% Estimation of an OE model

% orders of the OE model
% orders_oe(1) = nB
% orders_oe(2) = nF
% orders_oe(3) = nk
orders_oe = [2 1 1]; 

% OE model estimation
m_oe = oe(data,orders_oe);

disp("OE model estimation:")
% Plot the coefficient of the estimated model
fprintf("b: "); disp(m_oe.b); % B(z)
fprintf("f: "); disp(m_oe.f); % F(z)
fprintf("sigma^2: "); disp(m_oe.NoiseVariance); % sigma^2


% Estimation of a Box-Jenkins model

% coefficients of the BJ model
% orders_bj(1) = nB
% orders_bj(2) = nC
% orders_bj(3) = nD
% orders_bj(4) = nF
% orders_bj(5) = nk
orders_bj = [2 1 1 2 1];

% BJ model generation
m_bj = bj(data,orders_bj);
disp("Box Jensin estimate:")
% Plot the coefficient of the estimated model
fprintf("b: "); disp(m_bj.b); % B(z)
fprintf("c: "); disp(m_bj.c); % C(z)
fprintf("d: "); disp(m_bj.d); % D(z) 
fprintf("f: "); disp(m_bj.f); % F(z)
fprintf("sigma^2: "); disp(m_bj.NoiseVariance); % sigma^2

% figure(1)
% bodeplot(m0, m_arx);
% title('Arx estimate');
% 
% figure(2)
% bodeplot(m0, m_armax);
% title('Armax estimate');
% 
% figure(3)
% bodeplot(m0, m_oe);
% title('OE estimate');
% 
% figure(4)
% bodeplot(m0, m_bj);
% title('BJ estimate');
