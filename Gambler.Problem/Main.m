close all;
clear;
rng(0);

Goal = 100;
p_h = 0.45; % probability of head (winning)
gamma = 1;

V = zeros(Goal - 1, 1); % s = 1, 2, ..., Goal - 1
Q_coeff = cell(Goal - 1, floor(Goal - 1));
Q_const = NaN(Goal - 1, floor(Goal - 1));
for s = 1:(Goal - 1)
    for a = 1:min([s, Goal - s])
        Q_coeff{s, a} = zeros(1, Goal - 1);
        Q_const(s, a) = 0;
        
        if (s + a) < Goal
            Q_coeff{s, a}(s + a) = p_h * gamma;
        else
            Q_const(s, a) = Q_const(s, a) + p_h;
        end
        if (s - a) > 0
            Q_coeff{s, a}(s - a) = (1 - p_h) * gamma;
        end
    end
end

Delta_th = 1e-9;
Delta = Inf; Sweep = 0;
PlotSweep = [1, 2, 3, 32];
figure('Position', [300 200 500 300]); hold on;
while Delta > Delta_th
    Sweep = Sweep + 1;
    Delta = 0;
    for s = 1:(Goal - 1)
        a_set = 1:min([s, Goal - s]);
        Q_set = zeros(size(a_set));
        for a = a_set
            Q_set(a_set == a) = Q_coeff{s, a} * V + Q_const(s, a);
        end
        V_old = V(s);
        V(s) = max(Q_set);
        Delta = max([Delta, abs(V(s) - V_old)]);
    end
    if ismember(Sweep, PlotSweep) || (Delta <= Delta_th)
        plot(V, 'Color', 'k');
    end
end
xlabel('Capital');
ylabel('V(s)');
set(gca, 'FontSize', 15);

pi = zeros(size(V)); eps = Delta_th * 0.1;
figure('Position', [300 200 500 300]); hold on;
for s = 1:(Goal - 1)
    a_set = 1:min([s, Goal - s]);
    Q_set = zeros(size(a_set));
    for a = a_set
        Q_set(a_set == a) = Q_coeff{s, a} * V + Q_const(s, a);
    end
    a_opt = a_set((Q_set - max(Q_set)) > -eps);
    plot(s * ones(size(a_opt)), a_opt, 'bo');
    pi(s) = min(a_opt);
end
xlabel('Capital');
ylabel('Stake');
set(gca, 'XTick', 0:25:100, 'FontSize', 15);
figure('Position', [300 200 500 300]);
stairs(0.5:(Goal - 0.5), [pi; pi(end)]);
xlabel('Capital');
ylabel('Stake');
set(gca, 'XTick', 0:25:100, 'FontSize', 15);