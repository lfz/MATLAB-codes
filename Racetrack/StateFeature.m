function [Pos, Vec] = StateFeature(s, MaxHeight, MaxWidth, MaxVelocity)
[px, py, vx, vy] = ind2sub([MaxWidth, MaxHeight, MaxVelocity + 1, MaxVelocity + 1], s);
vx = vx - 1;
vy = vy - 1;
Pos = [px, py];
Vec = [vx, vy];
end