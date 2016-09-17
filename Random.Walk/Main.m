close all;
clear;
rng(0);

V_gt = (1:5) / 6;
gamma = 1;

EpisodeNum = 100;
alpha = 0.1;
V = ones(1, 5) * 0.5;
figure('Position', [300 200 500 400]); hold on;
plot(V, 'k--');
plot(V_gt, 'r--');
PlotEpisode = [1, 10, 100];
for Episode = 1:EpisodeNum
    [s_history, a_history, r_history] = OneTrial(randi(length(V)));
    T = length(a_history);
    for t = 1:(T - 1)
        V(s_history(t)) = V(s_history(t)) + alpha * (r_history(t) + gamma * V(s_history(t + 1)) - V(s_history(t)));
    end
    V(s_history(T)) = V(s_history(T)) + alpha * (r_history(T) - V(s_history(T)));
    if ismember(Episode, PlotEpisode)
        plot(V, 'Color', 'b');
    end
end
set(gca, 'XTick', 1:5, 'XTickLabel', {'A', 'B', 'C', 'D', 'E'}, 'FontSize', 15);

hRMS = figure('Position', [300 200 500 300]); hold on;
for alpha = [0.05, 0.1, 0.15]
    SimNum = 100;
    RMS = zeros(1, EpisodeNum);
    for SimID = 1:SimNum
        V = ones(1, 5) * 0.5;
        for Episode = 1:EpisodeNum
            [s_history, a_history, r_history] = OneTrial(randi(length(V)));
            T = length(a_history);
            for t = 1:(T - 1)
                V(s_history(t)) = V(s_history(t)) + alpha * (r_history(t) + gamma * V(s_history(t + 1)) - V(s_history(t)));
            end
            V(s_history(T)) = V(s_history(T)) + alpha * (r_history(T) - V(s_history(T)));
            RMS(Episode) = RMS(Episode) + mean((V - V_gt).^2)^0.5 / SimNum;
        end
    end
    plot(RMS);
end
xlabel('Episodes');
ylabel('RMS'); ylim([0, 0.25]);
legend('0.05', '0.1', '0.15', 'Location', 'NorthEast');
set(gca, 'FontSize', 15);

hMC = figure('Position', [300 200 500 300]); hold on;
for alpha = [0.01, 0.02, 0.03, 0.04]
    SimNum = 100;
    RMS = zeros(1, EpisodeNum);
    for SimID = 1:SimNum
        V = ones(1, 5) * 0.5;
        for Episode = 1:EpisodeNum
            [s_history, a_history, r_history] = OneTrial(randi(length(V)));
            g = r_history(end);
            for t = 1:length(a_history)
                V(s_history(t)) = V(s_history(t)) + alpha * (g - V(s_history(t)));
            end
            RMS(Episode) = RMS(Episode) + mean((V - V_gt).^2)^0.5 / SimNum;
        end
    end
    plot(RMS);
end
xlabel('Episodes');
ylabel('RMS'); ylim([0, 0.25]);
legend('0.01', '0.02', '0.03', '0.04', 'Location', 'SouthWest');
set(gca, 'FontSize', 15);

alpha = 1e-3;
SimNum = 100;
RMS = zeros(1, SimNum);
EpisodeNum = 100;
s_history = cell(1, EpisodeNum);
a_history = cell(1, EpisodeNum);
r_history = cell(1, EpisodeNum);
figure('Position', [300 200 500 300]); hold on;
for SimID = 1:SimNum
    V = ones(1, 5) * 0.5;
    for Episode = 1:EpisodeNum
        [s_history{Episode}, a_history{Episode}, r_history{Episode}] = OneTrial(randi(length(V)));
        dV = Inf * ones(1, 5);
        while max(abs(dV)) > 1e-3
            dV = zeros(1, 5);
            for BatchIter = 1:Episode
                T = length(a_history{BatchIter});
                for t = 1:(T - 1)
                    dV(s_history{BatchIter}(t)) = dV(s_history{BatchIter}(t)) + ...
                        alpha * (r_history{BatchIter}(t) + gamma * V(s_history{BatchIter}(t + 1)) - V(s_history{BatchIter}(t)));
                end
                dV(s_history{BatchIter}(T)) = dV(s_history{BatchIter}(T)) + alpha * (r_history{BatchIter}(T) - V(s_history{BatchIter}(T)));
            end
            V = V + dV;
        end
        RMS(Episode) = RMS(Episode) + mean((V - V_gt).^2)^0.5 / SimNum;
    end
end
plot(RMS);
RMS = zeros(1, SimNum);
for SimID = 1:SimNum
    V = ones(1, 5) * 0.5;
    for Episode = 1:EpisodeNum
        [s_history{Episode}, a_history{Episode}, r_history{Episode}] = OneTrial(randi(length(V)));
        dV = Inf * ones(1, 5);
        while max(abs(dV)) > 1e-3
            dV = zeros(1, 5);
            for BatchIter = 1:Episode
                T = length(a_history{BatchIter});
                g = r_history{BatchIter}(end);
                for t = 1:T
                    dV(s_history{BatchIter}(t)) = dV(s_history{BatchIter}(t)) + ...
                        alpha * (g - V(s_history{BatchIter}(t)));
                end
            end
            V = V + dV;
        end
        RMS(Episode) = RMS(Episode) + mean((V - V_gt).^2)^0.5 / SimNum;
    end
end
plot(RMS);
xlabel('Episodes');
ylabel('RMS'); ylim([0, 0.25]);
title('Batch updating');
legend('TD', 'MC');
set(gca, 'FontSize', 15);