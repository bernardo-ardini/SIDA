function obj = V(y,u,theta)
    % compute yest
    b = [0 theta(1) theta(2)];
    a = [1 theta(3)];
    yest = filter(b,a,u);
    % compute err_est
    err = y - yest;
    N = length(u);
    % compute V
    obj = 1/N * sum(err.^2);
end
