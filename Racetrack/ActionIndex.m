function a = ActionIndex(Acc, MaxAcceleration)
a = sub2ind([2 * MaxAcceleration + 1, 2 * MaxAcceleration + 1], ...
    Acc(:, 1) + MaxAcceleration + 1, Acc(:, 2) + MaxAcceleration + 1);
end