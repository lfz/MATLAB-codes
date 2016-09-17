function a = ChooseAction(s, Map, QTable, Q_init, varargin)
epsilon = 0.1;
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'epsilon'
            epsilon = varargin{i + 1};
    end
end

if s == 0
    a = 0;
else
    a_list = 1:length(Map.MoveList);
    Q_list = zeros(1, length(a_list));
    for a = a_list
        Q_list(a_list == a) = ExtractQ(s, a, QTable, Q_init);
    end
    a = EpsGreedy(a_list, Q_list, epsilon);
end
end