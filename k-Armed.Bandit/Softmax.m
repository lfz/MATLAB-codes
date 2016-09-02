function [a, p] = Softmax(H)
p = exp(H) / sum(exp(H));
P = cumsum(p);
a = find(P > rand, 1, 'first');
end