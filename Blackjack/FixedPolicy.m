function a = FixedPolicy(s, Type)
switch Type
    case 'Random'
        a = randi(2);
    case 'Risky'
        if s < 20
            a = ActionIndex('hit');
        else
            a = ActionIndex('stick');
        end
end
end