function s = StateIndex(Sum, DealerShown, UsableAce)
s = sub2ind([10, 10, 2], Sum - 11, DealerShown, UsableAce + 1);
end