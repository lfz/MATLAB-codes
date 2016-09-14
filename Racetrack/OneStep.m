function [s_new, r] = OneStep(s, a, Map, MaxVelocity, MaxAcceleration, varargin)
Wind = 'off';
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'Wind'
            Wind = varargin{i + 1};
    end
end
[Pos, Vec] = StateFeature(s, Map.MaxHeight, Map.MaxWidth, MaxVelocity);
Acc = ActionFeature(a, MaxAcceleration);
StayReward = -1;
DriveOffReward = -5;

Vec = Vec + Acc;
Pos_old = Pos;
Pos = Pos + Vec;
if strcmp(Wind, 'on')
    if rand < 0.5
        if rand < 0.5
            Pos = Pos + [1, 0];
        else
            Pos = Pos + [0, 1];
        end
    end
end
if (Pos(1) >= Map.MaxWidth) && (Pos(2) >= Map.FinishLine(1)) && (Pos(2) <= Map.FinishLine(2))
    s_new = 'Terminal';
    r = 0;
    return;
elseif (Pos(2) > Map.MaxHeight) || (Pos(1) < Map.RowSpan(Pos(2), 1)) || (Pos(1) > Map.RowSpan(Pos(2), 2))
    r = DriveOffReward;
    if Pos(2) > Map.MaxHeight
        Pos(2) = Map.MaxHeight;
    end
    Pos(1) = min([Map.RowSpan(Pos(2), 2), max([Map.RowSpan(Pos(2), 1), Pos(1)])]);
    Vec = [0, 0];
    
    if (Pos(1) == Pos_old(1)) && (Pos(2) == Pos_old(2))
        if Pos(1) < Map.RowSpan(Pos(2), 2)
            Pos(1) = Pos(1) + 1;
        else
            Pos(2) = Pos(2) + 1;
        end
    end
    if (Pos(1) >= Map.MaxWidth) && (Pos(2) >= Map.FinishLine(1)) && (Pos(2) <= Map.FinishLine(2))
        s_new = 'Terminal';
        return;
    end
else
    r = StayReward;
end
s_new = StateIndex(Pos, Vec, Map.MaxHeight, Map.MaxWidth, MaxVelocity);
end