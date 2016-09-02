function [a_history, r_history, p_history] = LearnBandit(q, q_noise, epsilon, T, Method, varargin)
k = length(q);
switch Method
    case 'Average'
        Q = zeros(1, k);
        N = zeros(1, k);
    case 'ConstantStep'
        Q1 = varargin{1};
        alpha = varargin{2};
        Q = ones(1, k) * Q1;
    case 'UCB'
        c = varargin{1};
        Q = zeros(1, k);
        N = zeros(1, k);
    case 'Gradient'
        alpha = varargin{1};
        Baseline = varargin{2};
        H = zeros(1, k);
        R_bar = 0;
end

a_history = zeros(1, T);
r_history = zeros(1, T);
p_history = false(1, T);
for t = 1:T
    switch Method
        case {'Average', 'ConstantStep'}
            a = EpsGreedy(Q, epsilon);
        case 'UCB'
            if ~isempty(find(N == 0, 1))
                a_opt = find(N == 0);
                a = a_opt(randi(length(a_opt)));
            else
                a = EpsGreedy(Q + c * (log(t) ./ N).^0.5, 0);
            end
        case 'Gradient'
            [a, p] = Softmax(H);
    end
    r = PullBandit(a, q);
    switch Method
        case {'Average', 'UCB'}
            N(a) = N(a) + 1;
            Q(a) = Q(a) + 1 / N(a) * (r - Q(a));
        case 'ConstantStep'
            Q(a) = Q(a) + alpha * (r - Q(a));
        case 'Gradient'
            if strcmp(Baseline, 'on')
                R_bar = R_bar + 1 / t * (r - R_bar);
            end
            H = H - alpha * (r - R_bar) * p;
            H(a) = H(a) + alpha * (r - R_bar);
    end
    a_history(t) = a;
    r_history(t) = r;
    p_history(t) = a == find(q == max(q));
    
    q = q + randn(size(q)) * q_noise;
end
end