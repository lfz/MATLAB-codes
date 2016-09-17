function s = StateIndex(Pos, Map)
if (Pos(1) == Map.GoalPos(1)) && (Pos(2) == Map.GoalPos(2))
    s = 0;
else
    s = sub2ind([Map.Width, Map.Height], Pos(1), Pos(2));
end
end