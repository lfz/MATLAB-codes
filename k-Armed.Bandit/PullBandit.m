function r = PullBandit(a, q)
sigma = 1;
r = q(a) + randn * sigma;
end