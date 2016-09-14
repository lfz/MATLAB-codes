function [s_history, a_history, r_history, greedy_flag, ActionTable] = OneTrial(Pos0, Vec0, Map, MaxVelocity, MaxAcceleration, Policy, QTable, ActionTable, varargin)
Q1 = 0;
ExploringStart = 'on';
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'ExploringStart'
            ExploringStart = varargin{i + 1};
    end
end
s = StateIndex(Pos0, Vec0, Map.MaxHeight, Map.MaxWidth, MaxVelocity);
s_history = []; a_history = []; r_history = []; greedy_flag = [];
t = 0;
while ~(ischar(s) && strcmp(s, 'Terminal'))
    if isempty(find(ActionTable.StateIndex == s, 1))
        Acc = ActionFeature((1:(2 * MaxAcceleration + 1)^2)', MaxAcceleration);
        [~, Vec] = StateFeature(s, Map.MaxHeight, Map.MaxWidth, MaxVelocity);
        Vec = repmat(Vec, [size(Acc, 1), 1]) + Acc;
        ValidActionSet = find((Vec(:, 1) >= 0) & (Vec(:, 2) >= 0) & (Vec(:, 1) <= MaxVelocity) & (Vec(:, 2) <= MaxVelocity));
        ValidActionSet = setdiff(ValidActionSet, find((Vec(:, 1) == 0) & (Vec(:, 2) == 0)));
        ValidActionSet = ValidActionSet';
        ActionTable.StateIndex = [ActionTable.StateIndex; s];
        ActionTable.ValidSet = [ActionTable.ValidSet; {ValidActionSet}];
    else
        ValidActionSet = ActionTable.ValidSet{find(ActionTable.StateIndex == s, 1)};
    end
    
    Q_list = zeros(1, length(ValidActionSet));
    for a = ValidActionSet
        if isempty(find((QTable.StateIndex == s) & (QTable.ActionIndex == a), 1))
            Q_list(ValidActionSet == a) = Q1;
        else
            Q_list(ValidActionSet == a) = QTable.Value(find((QTable.StateIndex == s) & (QTable.ActionIndex == a), 1));
        end
    end
    
    if isempty(s_history) && strcmp(ExploringStart, 'on')
        a = EpsGreedy(ValidActionSet, Q_list, 1);
    else
        switch Policy.Method
            case 'EpsGreedy'
                N_list = zeros(1, length(ValidActionSet));
                for a = ValidActionSet
                    if isempty(find((QTable.StateIndex == s) & (QTable.ActionIndex == a), 1))
                        N_list(ValidActionSet == a) = 0;
                    else
                        N_list(ValidActionSet == a) = QTable.Count(find((QTable.StateIndex == s) & (QTable.ActionIndex == a), 1));
                    end
                end
                
                a = EpsGreedy(ValidActionSet, Q_list, Policy.epsilon * Policy.gamma^min(N_list));
        end
    end
    
    s_history = [s_history; s]; %#ok<AGROW>
    a_history = [a_history; a]; %#ok<AGROW>
    if Q_list(ValidActionSet == a) == max(Q_list)
        greedy_flag = [greedy_flag; 1]; %#ok<AGROW>
    else
        greedy_flag = [greedy_flag; 0]; %#ok<AGROW>
    end
    
    [s, r] = OneStep(s, a, Map, MaxVelocity, MaxAcceleration, varargin{:});
    r_history = [r_history; r]; %#ok<AGROW>
    
    t = t + 1;
end
end