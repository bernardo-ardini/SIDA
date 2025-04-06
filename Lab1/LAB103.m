clear;
close all;

%% PART 1

N=100;
u=(1:N)';
lambdas=[1 1 1 10];
betas=[20 1 150 20];

e=randn(N,10); % generazione di 10 vettori casuali di dimensione N con distribuzione Normal(0,eye(N))

for i=1:4
    lambda=lambdas(i);
    beta=betas(i);

    K=lambda*Gaussian_kernel(u,u,beta);
    L=chol(K,"lower");

    subplot(2,2,i);
    plot(L*e); % generiamo 10 vettori casuali di dimensione N con distribuzione Normal(0,K)
    xlabel("t");
    ylabel("g");
    title("lambda="+num2str(lambda)+", beta="+num2str(beta));
end

sgtitle("Generation of Gaussian processes");

%% PART 2

clear;

load("manipulator.mat");

% disegniamo input e output

figure;

subplot(1,2,1);
plot(u1,"r");
hold on;
plot(u1d,"g");
plot(y1,"k");
xlabel("t");
legend("u1","u1d","y1");
title("Dataset 1");

subplot(1,2,2);
plot(u2,"r");
hold on;
plot(u2d,"g");
plot(y2,"k");
xlabel("t");
legend("u2","u2d","y2");
title("Dataset 2");

sgtitle("Input and output");

% calcolo delle accelerazioni angolari

u1d_dot=derivative(u1d,Ts);
u2d_dot=derivative(u2d,Ts);

sigma2=4.2; % varianza del rumore

x1=[u1 u1d u1d_dot];
x2=[u2 u2d u2d_dot];

% stima MAP della funzione g
gmap=@(x,lambda,beta) lambda*Gaussian_kernel(x,x1,beta)*((lambda*Gaussian_kernel(x1,x1,beta)+sigma2*eye(N))\y1);

% disegniamo le previsioni di y2 per diversi valori di lambda e beta

figure;

% lambda=1e4, beta=560
subplot(1,3,1);
plot(gmap(x2,1e4,560),"r");
hold on;
plot(y2,"b");
xlabel("t");
ylabel("y");
legend("y2 predicted","y2 measured");
title("lambda=1e4, beta=560");

% lambda=1, beta=560
subplot(1,3,2);
plot(gmap(x2,1,560),"r");
hold on;
plot(y2,"b");
xlabel("t");
ylabel("y");
legend("y2 predicted","y2 measured");
title("lambda=1, beta=560");

% lambda=1e4, beta=50
subplot(1,3,3);
plot(gmap(x2,1e4,50),"r");
hold on;
plot(y2,"b");
xlabel("t");
ylabel("y");
legend("y2 predicted","y2 measured");
title("lambda=1e4, beta=50");

sgtitle("Comparison between predictions and measurements of y2 for different hyperparameters");

% calcolo degli errori relativi

epsilon1=norm(y1-gmap(x1,1e4,560))/norm(y1,Inf);
epsilon2=norm(y2-gmap(x2,1e4,560))/norm(y2,Inf);

fprintf("\nRelative errors\n\nepsilon1=%f\nepsilon2=%f\n\n",epsilon1,epsilon2);
