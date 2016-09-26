function [s_history, a_history, r_history] = OneEpisode(s0, Policy)
DealerHidden = DealOneCard;

s_history = s0;
a_history = zeros([0, 1]);
r_history = zeros([0, 1]);

s = s0;
while s ~= 0
    a = Policy(s);
    [s, r] = OneStep(s, a, DealerHidden);
    
    s_history = cat(1, s_history, s);
    a_history = cat(1, a_history, a);
    r_history = cat(1, r_history, r);
end
end