clc; clear; close all;
load("bike.mat");

data = iddata(y,u);
figure
plot(data);
mu = getTrend(data,0);
data_d = detrend(data,mu);


%% MODEL 1
disp("Model 1");
orders_bj1 = [1 1 1 1 1];

m_bj1 = bj(data_d,orders_bj1);

m_bj1.b % B(z)
m_bj1.c % C(z)
m_bj1.d % D(z) 
m_bj1.f % F(z)
m_bj1.NoiseVariance % sigma^2

figure(7)
sgtitle("ZERO POLE CANCELLATION ANALYSIS")
subplot(2,3,1);
iopzplot(m_bj1);
title("Model 1");

ai1 = aic(m_bj1);
bic1 = bic(m_bj1);
sure1 = sure(m_bj1);


%% MODEL 2
disp("Model 2");
% Estimation of a Box-Jenkins model

% coefficients of the BJ model
% orders_bj(1) = nB
% orders_bj(2) = nC
% orders_bj(3) = nD
% orders_bj(4) = nF
% orders_bj(5) = nk
orders_bj2 = [2 2 2 1 1];

% BJ model generation
m_bj2 = bj(data_d,orders_bj2);

% Plot the coefficient of the estimated model
m_bj2.b % B(z)
m_bj2.c % C(z)
m_bj2.d % D(z) 
m_bj2.f % F(z)
m_bj2.NoiseVariance % sigma^2

figure(7)
subplot(2,3,2);
iopzplot(m_bj2);
title("Model 2");

ai2 = aic(m_bj2);
bic2 = bic(m_bj2);
sure2 = sure(m_bj2);

%% MODEL 3
disp("Model 3");
% Estimation of a Box-Jenkins model

% coefficients of the BJ model
% orders_bj(1) = nB
% orders_bj(2) = nC
% orders_bj(3) = nD
% orders_bj(4) = nF
% orders_bj(5) = nk
orders_bj3 = [4 4 4 3 1];

% BJ model generation
m_bj3 = bj(data_d,orders_bj3);

% Plot the coefficient of the estimated model
m_bj3.b % B(z)
m_bj3.c % C(z)
m_bj3.d % D(z) 
m_bj3.f % F(z)
m_bj3.NoiseVariance % sigma^2

figure(7)
subplot(2,3,3);
iopzplot(m_bj3);
title("Model 3");

ai3 = aic(m_bj3);
bic3 = bic(m_bj3);
sure3 = sure(m_bj3);

%% MODEL 4
% Estimation of a Box-Jenkins model
disp("Model 4");
% coefficients of the BJ model
% orders_bj(1) = nB
% orders_bj(2) = nC
% orders_bj(3) = nD
% orders_bj(4) = nF
% orders_bj(5) = nk
orders_bj4 = [6 6 6 5 1];

% BJ model generation
m_bj4 = bj(data_d,orders_bj4);

% Plot the coefficient of the estimated model
m_bj4.b % B(z)
m_bj4.c % C(z)
m_bj4.d % D(z) 
m_bj4.f % F(z)
m_bj4.NoiseVariance % sigma^2

figure(7)
subplot(2,3,4);
iopzplot(m_bj4);
title("Model 4");

ai4 = aic(m_bj4);
bic4 = bic(m_bj4);
sure4 = sure(m_bj4);

% it shows two poles near two zeros

%% MODEL 4
% Estimation of a Box-Jenkins model
disp("Model 4new");
% coefficients of the BJ model
% orders_bj(1) = nB
% orders_bj(2) = nC
% orders_bj(3) = nD
% orders_bj(4) = nF
% orders_bj(5) = nk
orders_bj4new = [4 6 6 3 1];

% BJ model generation
m_bj4new = bj(data_d,orders_bj4new);

% Plot the coefficient of the estimated model
m_bj4new.b % B(z)
m_bj4new.c % C(z)
m_bj4new.d % D(z) 
m_bj4new.f % F(z)
m_bj4new.NoiseVariance % sigma^2

figure(7)
subplot(2,3,5);
iopzplot(m_bj4new);
title("Model 4new"); %% non ha più la zero pole cancellation

ai4new = aic(m_bj4new);
bic4new = bic(m_bj4new);
sure4new = sure(m_bj4new);

%% CRITERIA WITH COMPLEXITY TERM
aic_vec = [ai1, ai2, ai3, ai4, ai4new];
bic_vec = [bic1, bic2, bic3, bic4, bic4new];
sure_vec = [sure1, sure2, sure3, sure4, sure4new];

figure(8)
sgtitle("CRITERIA WITH COMPLEXITY TERM")
subplot(1,3,1)
plot(aic_vec);
title("AIC")
subplot(1,3,2)
plot(bic_vec);
title("BIC")
subplot(1,3,3)
plot(sure_vec);
title("SURE")


%%  HOLD OUT CROSS VALIDATION

M = length(u)/2;
data_t = iddata(data_d.y(1:M), data_d.u(1:M)); % data_d(1:M)
data_v = iddata(data_d.y(M+1:end), data_d.u(M+1:end));


%% MODEL 1
disp("Model 1");
% coefficients of the BJ model
% orders_bj(1) = nB
% orders_bj(2) = nC
% orders_bj(3) = nD
% orders_bj(4) = nF
% orders_bj(5) = nk
orders_bj1 = [1 1 1 1 1];

% BJ model generation
m_bj1 = bj(data_t,orders_bj1);

% Plot the coefficient of the estimated model
m_bj1.b % B(z)
m_bj1.c % C(z)
m_bj1.d % D(z) 
m_bj1.f % F(z)
m_bj1.NoiseVariance % sigma^2



%% MODEL 2
disp("Model 2");
% Estimation of a Box-Jenkins model

% coefficients of the BJ model
% orders_bj(1) = nB
% orders_bj(2) = nC
% orders_bj(3) = nD
% orders_bj(4) = nF
% orders_bj(5) = nk
orders_bj2 = [2 2 2 1 1];

% BJ model generation
m_bj2 = bj(data_t,orders_bj2);

% Plot the coefficient of the estimated model
m_bj2.b % B(z)
m_bj2.c % C(z)
m_bj2.d % D(z) 
m_bj2.f % F(z)
m_bj2.NoiseVariance % sigma^2


%% MODEL 3
disp("Model 3");
% Estimation of a Box-Jenkins model

% coefficients of the BJ model
% orders_bj(1) = nB
% orders_bj(2) = nC
% orders_bj(3) = nD
% orders_bj(4) = nF
% orders_bj(5) = nk
orders_bj3 = [4 4 4 3 1];

% BJ model generation
m_bj3 = bj(data_t,orders_bj3);

% Plot the coefficient of the estimated model
m_bj3.b % B(z)
m_bj3.c % C(z)
m_bj3.d % D(z) 
m_bj3.f % F(z)
m_bj3.NoiseVariance % sigma^2


%% MODEL 4
% Estimation of a Box-Jenkins model
disp("Model 4");
% coefficients of the BJ model
% orders_bj(1) = nB
% orders_bj(2) = nC
% orders_bj(3) = nD
% orders_bj(4) = nF
% orders_bj(5) = nk
orders_bj4 = [6 6 6 5 1];

% BJ model generation
m_bj4 = bj(data_t,orders_bj4);

% Plot the coefficient of the estimated model
m_bj4.b % B(z)
m_bj4.c % C(z)
m_bj4.d % D(z) 
m_bj4.f % F(z)
m_bj4.NoiseVariance % sigma^2

% it shows two poles near two zeros

%% MODEL 4
% Estimation of a Box-Jenkins model
disp("Model 4new");
% coefficients of the BJ model
% orders_bj(1) = nB
% orders_bj(2) = nC
% orders_bj(3) = nD
% orders_bj(4) = nF
% orders_bj(5) = nk
orders_bj4new = [4 6 6 3 1];

% BJ model generation
m_bj4new = bj(data_t,orders_bj4new);

% Plot the coefficient of the estimated model
m_bj4new.b % B(z)
m_bj4new.c % C(z)
m_bj4new.d % D(z) 
m_bj4new.f % F(z)
m_bj4new.NoiseVariance % sigma^2


% one step ahead prediction to compute generalization error
opt = compareOptions('InitialCondition','z');
hhs = [1,2,3,4];
figure(9)
sgtitle("HOLD OUT CROSS VALIDATION")
for h = hhs
    subplot(2,2,h)
    compare(data_v,m_bj1, m_bj2, m_bj3, m_bj4, m_bj4new,h,opt)
end
