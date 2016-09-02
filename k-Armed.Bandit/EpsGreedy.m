function a = EpsGreedy(Q, epsilon)
if rand < epsilon
    a = randi(length(Q));
else
    a_opt = find(Q == max(Q));
    a = a_opt(randi(length(a_opt)));
end
end