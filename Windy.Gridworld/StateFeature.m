function Pos = StateFeature(s, Map)
[x, y] = ind2sub([Map.Width, Map.Height], s);
Pos = [x, y];
end