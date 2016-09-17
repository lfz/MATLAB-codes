function [s_new, r] = OneStep(s, a, Map)
Pos = StateFeature(s, Map);
Vec = ActionFeature(a, Map);

Pos = Pos + Vec + [0, Map.Wind(Pos(1))];
if strcmp(Map.Random, 'on')
    Pos(2) = Pos(2) + randi(3) - 2;
end
Pos(1) = min([max(Pos(1), 1), Map.Width]);
Pos(2) = min([max(Pos(2), 1), Map.Height]);

s_new = StateIndex(Pos, Map);
if s_new == 0
    r = 0;
else
    r = -1;
end
end