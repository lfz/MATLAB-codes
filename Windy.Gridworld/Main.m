close all;
clear;
rng(0);

EpisodeNum_list = [3000, 4000, 4000, 10000];
for SimID = 1:4
    display(sprintf('Simulating condition %d...', SimID));
    Map.Width = 10;
    Map.Height = 7;
    Map.Wind = [0, 0, 0, 1, 1, 1, 2, 2, 1, 0];
    switch SimID
        case 1
            Map.MoveList = [0, 1; 0, -1; 1, 0; -1, 0];
        case 2
            Map.MoveList = [0, 1; 1, 1; 1, 0; 1, -1; 0, -1; -1, -1; -1, 0; -1, 1];
        case 3
            Map.MoveList = [0, 1; 1, 1; 1, 0; 1, -1; 0, -1; -1, -1; -1, 0; -1, 1; 0, 0];
        case 4
            Map.MoveList = [0, 1; 0, -1; 1, 0; -1, 0];
    end
    if ismember(SimID, 1:3)
        Map.Random = 'off';
    else
        Map.Random = 'on';
    end
    Map.StartPos = [1, 4];
    Map.GoalPos = [8, 4];
    gamma = 1;
    
    QTable = struct('s', 0, 'a', 0, 'Val', 0);
    Q_init = 0;
    
    alpha = 0.5; epsilon = 0.1;
    EpisodeNum = EpisodeNum_list(SimID);
    TimeStep = zeros(1, EpisodeNum); t = 0;
    tStart = tic;
    for EpisodeID = 1:EpisodeNum
        s = StateIndex(Map.StartPos, Map);
        a = ChooseAction(s, Map, QTable, Q_init, 'epsilon', epsilon);
        t = t + 1;
        
        while s ~= 0
            [s_new, r] = OneStep(s, a, Map);
            a_new = ChooseAction(s_new, Map, QTable, Q_init, 'epsilon', epsilon);
            t = t + 1;
            
            delta = alpha * (r + gamma * ExtractQ(s_new, a_new, QTable, Q_init) - ExtractQ(s, a, QTable, Q_init));
            QTable = UpdateQ(s, a, delta, QTable, Q_init);
            
            s = s_new; a = a_new;
        end
        TimeStep(EpisodeID) = t;
        if mod(EpisodeID, 500) == 0
            tElapse = toc(tStart);
            display(sprintf('%d episodes simulated, elapsed time: %.1fs', EpisodeID, tElapse));
        end
    end
    
    V = zeros(Map.Height, Map.Width);
    for x = 1:Map.Width
        for y = 1:Map.Height
            s = StateIndex([x, y], Map);
            a = ChooseAction(s, Map, QTable, Q_init, 'epsilon', 0);
            V(y, x) = ExtractQ(s, a, QTable, Q_init);
        end
    end
    figure('Position', [300 200 600 400]);
    imagesc(V); axis('equal');
    h_t = title('State value of $\varepsilon$-greedy');
    set(h_t, 'interpreter', 'latex');
    colormap('jet'); colorbar;
    s = StateIndex(Map.StartPos, Map);
    s_history = s;
    while s ~= 0
        a = ChooseAction(s, Map, QTable, Q_init, 'epsilon', epsilon / 10);
        [s, ~] = OneStep(s, a, Map);
        s_history = [s_history; s]; %#ok<AGROW>
    end
    hold on;
    Pos = StateFeature(s_history, Map);
    plot(Pos(:, 1), Pos(:, 2), 'ro');
    set(gca, 'YDir', 'normal', 'FontSize', 15);
    
    if SimID == 1
        figure('Position', [300 200 500 300]);
        plot(TimeStep, 1:EpisodeNum);
        xlim([0, 8000]); ylim([0, 170]);
        xlabel('Time Steps');
        ylabel('Episodes');
        set(gca, 'FontSize', 15);
    end
end