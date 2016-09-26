function [s_new, r] = OneStep(s, a, DealerHidden)
[Sum, DealerShown, UsableAce] = StateFeature(s);
Move = ActionFeature(a);

switch Move
    case 'hit'
        k = DealOneCard;
        if (Sum + k) < 21
            s_new = StateIndex(Sum + k, DealerShown, UsableAce);
            r = 0;
        elseif (Sum + k) == 21
            s_new = 0;
            r = DealerPlay(Sum + k, DealerShown, DealerHidden);
        elseif ((Sum + k) < 31) && (UsableAce == 1)
            s_new = StateIndex(Sum + k - 10, DealerShown, 0);
            r = 0;
        elseif ((Sum + k) == 31) && (UsableAce == 1)
            s_new = 0;
            r = DealerPlay(Sum + k - 10, DealerShown, DealerHidden);
        else
            s_new = 0;
            r = -1;
        end
    case 'stick'
        s_new = 0;
        r = DealerPlay(Sum, DealerShown, DealerHidden);
end
end

function r = DealerPlay(PlayerSum, DealerShown, DealerHidden)
if (DealerShown == 1) || (DealerHidden == 1)
    DealerSum = DealerShown + DealerHidden + 10;
    UsableAce = 1;
else
    DealerSum = DealerShown + DealerHidden;
    UsableAce = 0;
end
while DealerSum < 17
    k = DealOneCard;
    DealerSum = DealerSum + k;
    if (DealerSum > 21) && (UsableAce == 1)
        DealerSum = DealerSum - 10;
        UsableAce = 0;
    end
end
if DealerSum > 21
    r = 1;
else
    if DealerSum > PlayerSum
        r = -1;
    elseif DealerSum < PlayerSum
        r = 1;
    else
        r = 0;
    end
end
end