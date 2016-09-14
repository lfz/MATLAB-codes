function s = StateIndex(Pos, Vec, MaxHeight, MaxWidth, MaxVelocity)
s = sub2ind([MaxWidth, MaxHeight, MaxVelocity + 1, MaxVelocity + 1], ...
    Pos(:, 1), Pos(:, 2), Vec(:, 1) + 1, Vec(:, 2) + 1);
end