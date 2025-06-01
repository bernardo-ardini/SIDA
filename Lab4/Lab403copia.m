clc; clear; close all;
load("bike.mat");

data = iddata(y,u);
figure; plot(data);
mu = getTrend(data,0);
data_d = detrend(data,mu);

%% orders of the models
orders_bj1 = [1 1 1 1 1];
orders_bj2 = [2 2 2 1 1];
orders_bj3 = [4 4 4 3 1];
orders_bj4 = [6 6 6 5 1];
orders_bj5 = [1 4 4 1 1];
%% ESTIMATES
m_bj1 = bj(data_d,orders_bj1);
m_bj2 = bj(data_d,orders_bj2);
m_bj3 = bj(data_d,orders_bj3);
m_bj4 = bj(data_d,orders_bj4);
m_bj5 = bj(data_d,orders_bj5);

%% ZERO-POLE CANCELLATION ANALYSIS
figure(7)
sgtitle("ZERO POLE CANCELLATION ANALYSIS")
subplot(2,3,1);   
iopzplot(m_bj1);  
title("Model 1"); 
subplot(2,3,2);
iopzplot(m_bj2);
title("Model 2");
subplot(2,3,3);
iopzplot(m_bj3);
title("Model 3");
subplot(2,3,4);
iopzplot(m_bj4);
title("Model 4"); % it shows two poles near two zeros
subplot(2,3,5);
iopzplot(m_bj5);
title("Model 5");

%% VALIDATION CRITERIA
ai1 = aic(m_bj1);   ai2 = aic(m_bj2);    ai3 = aic(m_bj3);    
bic1 = bic(m_bj1);  bic2 = bic(m_bj2);   bic3 = bic(m_bj3);   
sure1 = sure(m_bj1);sure2 = sure(m_bj2); sure3 = sure(m_bj3); 

ai4 = aic(m_bj4);    ai5 =    aic(m_bj5);
bic4 = bic(m_bj4);   bic5 =   bic(m_bj5);
sure4 = sure(m_bj4); sure5 = sure(m_bj5);

%% CRITERIA WITH COMPLEXITY TERM
aic_vec = [ai1, ai2, ai3, ai4, ai5];
bic_vec = [bic1, bic2, bic3, bic4, bic5];
sure_vec = [sure1, sure2, sure3, sure4,sure5];

figure(8)
sgtitle("CRITERIA WITH COMPLEXITY TERM")
ax = subplot(1,3,1);
plot(aic_vec);
ax.XTick = [1, 2, 3,4,5];
xticklabels(["M1","M2", "M3", "M4", "M5"])
title("AIC")
ax2 = subplot(1,3,2);
plot(bic_vec);
ax2.XTick = [1, 2, 3,4,5];
xticklabels(["M1","M2", "M3","M4", "M5"])
title("BIC")
ax3 =subplot(1,3,3);
plot(sure_vec);
ax3.XTick = [1, 2, 3,4,5];
xticklabels(["M1","M2", "M3", "M4", "M5"])
title("SURE")

%%  HOLD OUT CROSS VALIDATION
M = length(u)/2;
data_t = data_d(1:M);
data_v = data_d(M+1:end);

%% Train on training data
m_bj1 = bj(data_t,orders_bj1);
m_bj2 = bj(data_t,orders_bj2);
m_bj3 = bj(data_t,orders_bj3);
m_bj4 = bj(data_t,orders_bj4);
m_bj5 = bj(data_t,orders_bj5);
% compare on validation
opt = compareOptions('InitialCondition','z');
hhs = [1,2,3,4];
figure(9)
sgtitle("HOLD OUT CROSS VALIDATION")
for h = hhs
    subplot(2,2,h)
    compare(data_v,m_bj1, m_bj2, m_bj3, m_bj4, m_bj5,h,opt)
end
