%% OE parameter estimation, nB = 2, nF = 1, nk = 1
% true parameter: [5 2 .81], sigma=0.9
clear;clc;close all;

%% plot of input output
load("data.mat");
subplot(1,2,1);
plot(u);
title("Input");
xlabel("t");
ylabel("u");
subplot(1,2,2);
plot(y);
title("Output");
xlabel("t");
ylabel("y");

%% Steepest Descent Algorithm
delta = 1e-4;
flag_stop = true;
k=1;
theta = [0 0 0];
% theta = [10 -2 -0.2]; % other inital condition
print = true;

while (flag_stop)
    % compute current V,dV. the value V is called W not to conflict with the function V
    b = [0 theta(1) theta(2)];
    a = [1 theta(3)];
    yest = filter(b,a,u);
    err = y -yest;
    W = 1/N * sum(err.^2); % V_{k-1}
    Psi = [filter([0 1], [1 theta(3)], u), filter([0 0 1], [1 theta(3)], u), -filter([0 1], [1 theta(3)], yest)];
    dV = -2/N * sum(err.*Psi);

    % backtracking
    mu=1;
    while (abs(theta(3)-mu*dV(3))>=1)
        mu=mu/2;
    end
    while (V(y,u,theta-mu*dV)-W>=0)
        mu=mu/2;
    end

    theta = theta-mu*dV; % new estimate theta^(k)
    
    if (norm(dV)<=delta) % flag_stop on previous iteration gradient -> one iteration more
        flag_stop=false;
    end
    if (print)
        fprintf("Iteration %u:\n", k);
        fprintf("V: %f\n", W);
        fprintf("|dV|: %f\n", norm(dV));
        fprintf("theta: [%f %f %f]\n", theta(1), theta(2), theta(3));
        fprintf("\n");
    end
    k=k+1;
end
% summary for the final estimate
fprintf("Final Estimate in %u iterations:\n", k-1);
fprintf("V: %f\n", W);
fprintf("|dV|: %f\n", norm(dV));
fprintf("theta: [%f %f %f]\n", theta(1), theta(2), theta(3));
fprintf("\n");

%% Comparison with matlab toolbox: 
% OE model estimation
% orders_oe(1) = nB
% orders_oe(2) = nF
% orders_oe(3) = nk
orders_oe = [2 1 1]; 
data = iddata(y,u);
m_oe = oe(data,orders_oe);

% Plot the parameters of the estimated model
fprintf("MATLAB estimate:\n");
fprintf("sigma^2: %f\n", m_oe.NoiseVariance);
fprintf("V: %f\n", V(y,u,[ m_oe.b(2), m_oe.b(3), m_oe.f(2)]))
fprintf("theta: [%f %f %f]\n", m_oe.b(2), m_oe.b(3), m_oe.f(2));

%% One step less -- Stop condition on |V'(\theta^(k)| 
% % compute initial V,dV
% b = [0 theta(1) theta(2)];
% a = [1 theta(3)];
% yest = filter(b,a,u);
% err = y -yest;
% W = 1/N * sum(err.^2); % V_{k-1}
% Psi = [filter([0 1], [1 theta(3)], u), filter([0 0 1], [1 theta(3)], u), -filter([0 1], [1 theta(3)], yest)];
% dV = -2/N * sum(err.*Psi);
% 
% while (flag_stop)
%     % backtracking
%     mu=1;
%     while (abs(theta(3)-mu*dV(3))>=1)
%         mu=mu/2;
%     end
%     while (V(y,u,theta-mu*dV)-W>=0)
%         mu=mu/2;
%     end
%     theta = theta-mu*dV;
% 
%     % compute current V,dV
%     b = [0 theta(1) theta(2)];
%     a = [1 theta(3)];
%     yest = filter(b,a,u);
%     err = y -yest;
%     W = 1/N * sum(err.^2); % V_{k-1}
%     Psi = [filter([0 1], [1 theta(3)], u), filter([0 0 1], [1 theta(3)], u), -filter([0 1], [1 theta(3)], yest)];
%     dV = -2/N * sum(err.*Psi);
% 
%     if (norm(dV)<=delta)
%         flag_stop=false;
%     end
%     fprintf("Iteration %u:\n", k);
%     fprintf("V: %f\n", W);
%     fprintf("|dV|: %f\n", norm(dV));
%     fprintf("theta: [%f %f %f]\n", theta(1), theta(2), theta(3));
%     k=k+1;
%     fprintf("\n");
% end