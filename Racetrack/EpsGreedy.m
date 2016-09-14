function a = EpsGreedy(a_list, Q_list, epsilon)
if rand < epsilon
    a = a_list(randi(length(a_list)));
else
    a_opt = a_list(Q_list == max(Q_list));
    a = a_opt(randi(length(a_opt)));
end
end