function Acc = ActionFeature(a, MaxAcceleration)
[ax, ay] = ind2sub([2 * MaxAcceleration + 1, 2 * MaxAcceleration + 1], a);
Acc = [ax, ay] - MaxAcceleration - 1;
end