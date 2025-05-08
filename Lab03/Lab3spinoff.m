clear; clc; close all;
numIt = 500;
N = 8000;
Ts=1;
k_sin = 5;
Fden = [1, -0.96, 0.97];  a10 = -0.96; a20 = 0.97;
Fnum = [0, 2.99, -0.2];   b00 = 2.99;  b10 = -0.2;  
Gden = [1, -0.96, 0.97];
Gnum = [1, 0, 0];
noiseVar = 4.6;
out_of_int = zeros(4,1);

for i=1:numIt

    m0 = idpoly([],Fnum,Gnum,Gden,Fden,noiseVar,Ts); 
    u = idinput(N,'sine',[1/8 1/2],[-4 4],k_sin);

    u = iddata([],u,Ts); 
    en0 = idinput(N,'rgs'); 
    en0 = iddata([],en0,Ts); 

    % Generation of the output data given model, input and noise
    y = sim(m0, [u en0]);

    % Creation of an iddata object for the output and input data 
    data = iddata(y,u);
    
    orders_arx = [2 2 1]; 

    m_arx = arx(data,orders_arx);
        
    y = data.OutputData;
    u = data.InputData;
    
    Psi = [[0;-y(1:end-1)], [0;0;-y(1:end-2)], [0;u(1:end-1)], [0;0;u(1:end-2)]]';
    
    P = m_arx.NoiseVariance * N* inv(Psi*Psi');
    % aPEM = m_arx.a';
    % bPEM = m_arx.b';
    theta = [m_arx.a(2:end)'; m_arx.b(2:end)'];
    theta0 = [a10; a20; b00; b10];
    err = abs(theta - theta0);
    confInt = 1.96/sqrt(N) * sqrt(diag(P));
    out_of_int = out_of_int + (err>confInt);
end

disp(out_of_int/numIt * 100);