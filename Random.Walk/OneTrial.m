function [s_history, a_history, r_history] = OneTrial(s)
s_history = s;
a_history = [];
r_history = [];
while (s >= 1) && (s <= 5)
    a = randi(2) * 2 - 3;
    s = s + a;
    if s == 6
        r = 1;
    else
        r = 0;
    end
    s_history = [s_history, s];
    a_history = [a_history, a];
    r_history = [r_history, r];
end
end