close all;
clear;
rng(0);

SimID = 1; WindFlag = 'off';
GreedyPolicy = struct('Method', 'EpsGreedy', 'epsilon', 0, 'gamma', 1);
if ~exist(sprintf('Sim%d_%s.mat', SimID, WindFlag), 'file')
    Map = GenerateMap(SimID);
    MaxVelocity = 5; MaxAcceleration = 1;
    QTable = struct('StateIndex', [], 'ActionIndex', [], 'Value', [], 'Count', []);
    ActionTable = struct('StateIndex', [], 'ValidSet', []);
    Count_tau = 1000;
    alpha = 0.1;
    
    SimTrialNum = 200000;
    ValidTrialNum = 5; ValidStepSize = 1000;
    GreedyReturn = NaN(Map.RowSpan(1, 2) - Map.RowSpan(1, 1) + 1, SimTrialNum + 1);
    eps = 0.2; tau = Count_tau / 100;
    ExplorePolicy = struct('Method', 'EpsGreedy', 'epsilon', eps, 'gamma', exp(-1 / tau));
    for p0 = Map.RowSpan(1, 1):Map.RowSpan(1, 2)
        ValidReturn = zeros(1, ValidTrialNum);
        for ValidTrial = 1:ValidTrialNum
            [~, ~, r_history, ~, ActionTable] = ...
                OneTrial([p0, 1], [0, 0], Map, MaxVelocity, MaxAcceleration, GreedyPolicy, QTable, ActionTable, 'ExploringStart', 'off', 'Wind', WindFlag);
            ValidReturn(ValidTrial) = sum(r_history);
        end
        GreedyReturn(p0 - Map.RowSpan(1, 1) + 1, 1) = mean(ValidReturn);
    end
    TailLength = 0; SimStep = 0; gamma_t = 0.9;
    tStart = tic;
    for SimTrial = 1:SimTrialNum
        Pos0 = [randi(Map.RowSpan(1, 2) - Map.RowSpan(1, 1) + 1) + Map.RowSpan(1, 1) - 1, 1];
        Vec0 = [0, 0];
        [s_history, a_history, r_history, greedy_flag, ActionTable] = ...
            OneTrial(Pos0, Vec0, Map, MaxVelocity, MaxAcceleration, ExplorePolicy, QTable, ActionTable, 'Wind', WindFlag);
        
        return_history = flipud(cumsum(flipud(r_history)));
        TailInd = find(greedy_flag == 0, 1, 'last');
        if isempty(TailInd)
            TailInd = 1;
        end
        SimStep = SimStep * gamma_t + length(greedy_flag) * (1 - gamma_t);
        TailLength = TailLength * gamma_t + (length(greedy_flag) - TailInd + 1) * (1 - gamma_t);
        for t = length(greedy_flag):-1:TailInd
            s = s_history(t); a = a_history(t); g = return_history(t);
            if isempty(find((QTable.StateIndex == s) & (QTable.ActionIndex == a), 1))
                QTable.StateIndex = [QTable.StateIndex; s];
                QTable.ActionIndex = [QTable.ActionIndex; a];
                QTable.Value = [QTable.Value; g];
                QTable.Count = [QTable.Count; 1];
            else
                Ind = find((QTable.StateIndex == s) & (QTable.ActionIndex == a), 1);
                QTable.Value(Ind) = QTable.Value(Ind) + alpha * (g - QTable.Value(Ind));
                QTable.Count(Ind) = QTable.Count(Ind) + 1;
            end
        end
        QTable.Count = QTable.Count * exp(-1 / Count_tau);
        
        if mod(SimTrial, ValidStepSize) == 0
            for p0 = Map.RowSpan(1, 1):Map.RowSpan(1, 2)
                ValidReturn = zeros(1, ValidTrialNum);
                for ValidTrial = 1:ValidTrialNum
                    [~, ~, r_history, ~, ActionTable] = ...
                        OneTrial([p0, 1], [0, 0], Map, MaxVelocity, MaxAcceleration, GreedyPolicy, QTable, ActionTable, 'ExploringStart', 'off', 'Wind', WindFlag);
                    ValidReturn(ValidTrial) = sum(r_history);
                end
                GreedyReturn(p0 - Map.RowSpan(1, 1) + 1, SimTrial + 1) = mean(ValidReturn);
            end
            
            if mod(SimTrial, 1000) == 0
                tElapse = toc(tStart);
                display(sprintf('%d trials simulated, elapsed time: %.1fs', SimTrial, tElapse));
                display(sprintf('Average return of a greedy pilot: %.1f', mean(GreedyReturn(:, SimTrial + 1))));
                display(sprintf('Recent greedy tail length: %.1f/%.1f', TailLength, SimStep));
            end
        end
    end
    save(sprintf('Sim%d_%s.mat', SimID, WindFlag), 'SimID', 'WindFlag', 'Map', 'MaxVelocity', 'MaxAcceleration', 'QTable', 'ActionTable', 'SimTrialNum', 'ValidTrialNum', 'ValidStepSize', 'GreedyReturn');
else
    load(sprintf('Sim%d_%s.mat', SimID, WindFlag));
end

for p0 = Map.RowSpan(1, 1):Map.RowSpan(1, 2)
    PlotMap(Map);
    hold on;
    [s_history, ~, r_history, ~, ActionTable] = ...
        OneTrial([p0, 1], [0, 0], Map, MaxVelocity, MaxAcceleration, GreedyPolicy, QTable, ActionTable, 'ExploringStart', 'off', 'Wind', WindFlag);
    [Pos, ~] = StateFeature(s_history, Map.MaxHeight, Map.MaxWidth, MaxVelocity);
    plot(Pos(:, 1), Pos(:, 2), 'ro');
    title(sprintf('Return: %d', sum(r_history)));
    set(gca, 'FontSize', 15);
end

Ind = find(~isnan(GreedyReturn(1, :)));
figure('Position', [200 200 700 400]);
hold on;
plot(0:ValidStepSize:SimTrialNum, GreedyReturn(:, Ind), 'LineWidth', 1);
plot(0:ValidStepSize:SimTrialNum, mean(GreedyReturn(:, Ind)), 'k--', 'LineWidth', 2);
xlabel('Trial'); ylabel('Return'); title('Greedy policy performance');
set(gca, 'FontSize', 15);