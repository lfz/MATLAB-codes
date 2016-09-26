function [Sum, DealerShown, UsableAce] = StateFeature(s)
[Sum, DealerShown, UsableAce] = ind2sub([10, 10, 2], s);
Sum = Sum + 11;
UsableAce = UsableAce - 1;
end