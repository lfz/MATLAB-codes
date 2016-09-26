close all;
clear;
rng(0);

Sum = 13; DealerShown = 2; UsableAce = 1;
s0 = StateIndex(Sum, DealerShown, UsableAce);

EpisodeNum = 1000000;
G_true = 0;
Policy = @(s)FixedPolicy(s, 'Risky');
for Episode = 1:EpisodeNum
    [s_history, a_history, r_history] = OneEpisode(s0, Policy);
    G_true = G_true + sum(r_history) / EpisodeNum;
end
display(sprintf('Average return: %.5f', G_true));

EpisodeNum = 1000;
SimNum = 100;
Policy = @(s)FixedPolicy(s, 'Random');
V_ordinary_list = zeros(SimNum, EpisodeNum);
for SimID = 1:SimNum
    V = 0;
    N = 0;
    for Episode = 1:EpisodeNum
        [s_history, a_history, r_history] = OneEpisode(s0, Policy);
        rho = 1;
        for t = length(a_history):-1:1
            if a_history(t) == FixedPolicy(s_history(t), 'Risky')
                rho = rho * 2;
            else
                rho = rho * 0;
            end
        end
        N = N + 1;
        V = V + 1 / N * (rho * sum(r_history) - V);
        V_ordinary_list(SimID, Episode) = V;
    end
end

V_weighted_list = zeros(SimNum, EpisodeNum);
for SimID = 1:SimNum
    V = 0;
    C = 0;
    for Episode = 1:EpisodeNum
        [s_history, a_history, r_history] = OneEpisode(s0, Policy);
        rho = 1;
        for t = length(a_history):-1:1
            if a_history(t) == FixedPolicy(s_history(t), 'Risky')
                rho = rho * 2;
            else
                rho = rho * 0;
            end
        end
        C = C + rho;
        if C > 0
            V = V + rho / C * (sum(r_history) - V);
        end
        V_weighted_list(SimID, Episode) = V;
    end
end

figure('Position', [300 200 500 300]);
hold on;
plot(mean((V_ordinary_list - G_true).^2), 'g');
plot(mean((V_weighted_list - G_true).^2), 'r');
xlabel('Episode');
ylabel('Mean Square Error');
legend('Ordinary', 'Weighted', 'Location', 'NorthEast');
set(gca, 'FontSize', 15, 'XScale', 'log');