function K = Gaussian_kernel(x,xt,beta)
%GAUSSIAN_KERNEL computes the kernel matrix corresponding to the input 
%                locations specified by x and xt.
%                
%                - x,xt are marices whose k-th row represents the input 
%                  location at the k-th measurement
%                - beta is the hyper-parameter
%                - K is the kernel matrix

K = zeros(size(x,1),size(xt,1));
for t=1:size(x,1)
    for s=1:size(xt,1)
        K(t,s) = exp(-0.5*norm(x(t,:)-xt(s,:))^2/beta);
    end
end
try
    chol(K);
catch
    K=K+1e-6*eye(size(K,1));
end
