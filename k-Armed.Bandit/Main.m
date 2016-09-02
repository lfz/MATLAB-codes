close all;
clear;
rng(0);

SimFlag = [true, true, true, true, true];

k = 10; % k-armed bandit
TestBedSize = 2000; % Number of bandits
q = randn(TestBedSize, k); % True expectation of reward

if SimFlag(1)
    T = 1000;
    
    h1 = figure('Position', [300 200 600 300]); hold on;
    h2 = figure('Position', [300 200 600 300]); hold on;
    
    epsilon_set = [0, 0.01, 0.1];
    PlotColor = [0, 0.5, 0; 1, 0, 0; 0, 0, 0];
    legends = cell(1, length(epsilon_set));
    for i = 1:length(epsilon_set)
        legends{i} = sprintf('$\\varepsilon$ %g', epsilon_set(i));
    end
    
    r = zeros(TestBedSize, T);
    p = false(TestBedSize, T);
    for epsilon = epsilon_set
        for i = 1:TestBedSize
            [~, r(i, :), p(i, :)] = LearnBandit(q(i, :), 0, epsilon, T, 'Average');
        end
        figure(h1);
        plot(mean(r), 'Color', PlotColor(epsilon_set == epsilon, :));
        figure(h2);
        plot(mean(double(p)), 'Color', PlotColor(epsilon_set == epsilon, :));
    end
    
    figure(h1);
    xlabel('Steps');
    ylabel('Average reward');
    hL = legend(legends, 'Location', 'SouthEast');
    set(hL, 'interpreter', 'latex');
    set(gca, 'FontSize', 15);
    figure(h2);
    xlabel('Steps');
    ylabel('Optimal Percentage');
    hL = legend(legends, 'Location', 'SouthEast');
    set(hL, 'interpreter', 'latex');
    set(gca, 'FontSize', 15, 'YTick', 0:0.2:1, 'YTickLabel', {'0%', '20%', '40%', '60%', '80%', '100%'});
end

if SimFlag(2)
    q_noise = 2e-2;
    epsilon = 0.1; alpha = 0.1;
    T = 2000;
    
    h1 = figure('Position', [300 200 600 300]); hold on;
    h2 = figure('Position', [300 200 600 300]); hold on;
    legends = {'\alpha=1/n', sprintf('\\alpha=%g', alpha)};
    
    r = zeros(TestBedSize, T);
    p = false(TestBedSize, T);
    
    for i = 1:TestBedSize
        [~, r(i, :), p(i, :)] = LearnBandit(q(i, :), q_noise, epsilon, T, 'Average');
    end
    figure(h1);
    plot(mean(r), 'Color', 'r');
    figure(h2);
    plot(mean(double(p)), 'Color', 'r');
    
    for i = 1:TestBedSize
        [~, r(i, :), p(i, :)] = LearnBandit(q(i, :), q_noise, epsilon, T, 'ConstantStep', 0, alpha);
    end
    figure(h1);
    plot(mean(r), 'Color', 'b');
    figure(h2);
    plot(mean(double(p)), 'Color', 'b');
    
    figure(h1);
    xlabel('Steps');
    ylabel('Average reward');
    legend(legends, 'Location', 'SouthEast');
    set(gca, 'FontSize', 15);
    figure(h2);
    xlabel('Steps');
    ylabel('Optimal Percentage');
    legend(legends, 'Location', 'SouthEast');
    set(gca, 'FontSize', 15, 'YTick', 0:0.2:1, 'YTickLabel', {'0%', '20%', '40%', '60%', '80%', '100%'});
end

if SimFlag(3)
    Q1 = 5; epsilon = 0.1; alpha = 0.1;
    T = 1000;
    
    h1 = figure('Position', [300 200 600 300]); hold on;
    h2 = figure('Position', [300 200 600 300]); hold on;
    legends = {sprintf('$Q_1=0,\\varepsilon=%g$', epsilon), ...
        sprintf('$Q_1=%g,\\varepsilon=0$', Q1)};
    
    r = zeros(TestBedSize, T);
    p = false(TestBedSize, T);
    
    for i = 1:TestBedSize
        [~, r(i, :), p(i, :)] = LearnBandit(q(i, :), 0, epsilon, T, 'ConstantStep', 0, alpha);
    end
    figure(h1);
    plot(mean(r), 'Color', [0.5, 0.5, 0.5]);
    figure(h2);
    plot(mean(double(p)), 'Color', [0.5, 0.5, 0.5]);
    
    for i = 1:TestBedSize
        [~, r(i, :), p(i, :)] = LearnBandit(q(i, :), 0, 0, T, 'ConstantStep', Q1, alpha);
    end
    figure(h1);
    plot(mean(r), 'Color', 'k');
    figure(h2);
    plot(mean(double(p)), 'Color', 'k');
    
    figure(h1);
    xlabel('Steps');
    ylabel('Average reward');
    hL = legend(legends, 'Location', 'SouthEast');
    set(hL, 'interpreter', 'latex');
    set(gca, 'FontSize', 15);
    figure(h2);
    xlabel('Steps');
    ylabel('Optimal Percentage');
    hL = legend(legends, 'Location', 'SouthEast');
    set(hL, 'interpreter', 'latex');
    set(gca, 'FontSize', 15, 'YTick', 0:0.2:1, 'YTickLabel', {'0%', '20%', '40%', '60%', '80%', '100%'});
end

if SimFlag(4)
    epsilon = 0.1; c = 2;
    T = 1000;
    
    h1 = figure('Position', [300 200 600 300]); hold on;
    h2 = figure('Position', [300 200 600 300]); hold on;
    legends = {sprintf('$\\varepsilon=%g$', epsilon), sprintf('UCB c=%g', c)};
    
    r = zeros(TestBedSize, T);
    p = false(TestBedSize, T);
    
    for i = 1:TestBedSize
        [~, r(i, :), p(i, :)] = LearnBandit(q(i, :), 0, epsilon, T, 'Average');
    end
    figure(h1);
    plot(mean(r), 'Color', [0.5, 0.5, 0.5]);
    figure(h2);
    plot(mean(double(p)), 'Color', [0.5, 0.5, 0.5]);
    
    for i = 1:TestBedSize
        [~, r(i, :), p(i, :)] = LearnBandit(q(i, :), 0, [], T, 'UCB', c);
    end
    figure(h1);
    plot(mean(r), 'Color', 'b');
    figure(h2);
    plot(mean(double(p)), 'Color', 'b');
    
    figure(h1);
    xlabel('Steps');
    ylabel('Average reward');
    ylim([-0.1, 1.55]);
    hL = legend(legends, 'Location', 'SouthEast');
    set(hL, 'interpreter', 'latex');
    set(gca, 'FontSize', 15);
    figure(h2);
    xlabel('Steps');
    ylabel('Optimal Percentage');
    hL = legend(legends, 'Location', 'SouthEast');
    set(hL, 'interpreter', 'latex');
    set(gca, 'FontSize', 15, 'YTick', 0:0.2:1, 'YTickLabel', {'0%', '20%', '40%', '60%', '80%', '100%'});
end

if SimFlag(5)
    q_bias = 4;
    T = 1000;
    
    h1 = figure('Position', [300 200 500 300]); hold on;
    h2 = figure('Position', [300 200 500 300]); hold on;
    
    alpha_set = [0.1, 0.4];
    OffColor = [0, 0.5, 0];
    OnColor = [0, 0, 1];
    legends = cell(1, length(alpha_set) * 2);
    for i = 1:length(alpha_set)
        legends{2 * i - 1} = sprintf('\\alpha=%g,without', alpha_set(i));
        legends{2 * i} = sprintf('\\alpha=%g,with', alpha_set(i));
    end
    
    r = zeros(TestBedSize, T);
    p = false(TestBedSize, T);
    for alpha = alpha_set
        for i = 1:TestBedSize
            [~, r(i, :), p(i, :)] = LearnBandit(q(i, :) + q_bias, 0, [], T, 'Gradient', alpha, 'off');
        end
        i = find(alpha_set == alpha);
        figure(h1);
        plot(mean(r), 'Color', (OffColor * (length(alpha_set) + 1 - i) + i - 1) / length(alpha_set));
        figure(h2);
        plot(mean(double(p)), 'Color', (OffColor * (length(alpha_set) + 1 - i) + i - 1) / length(alpha_set));
        
        for i = 1:TestBedSize
            [~, r(i, :), p(i, :)] = LearnBandit(q(i, :) + q_bias, 0, [], T, 'Gradient', alpha, 'on');
        end
        i = find(alpha_set == alpha);
        figure(h1);
        plot(mean(r), 'Color', (OnColor * (length(alpha_set) + 1 - i) + i - 1) / length(alpha_set));
        figure(h2);
        plot(mean(double(p)), 'Color', (OnColor * (length(alpha_set) + 1 - i) + i - 1) / length(alpha_set));
    end
    
    figure(h1);
    xlabel('Steps');
    ylabel('Average reward');
    legend(legends, 'Location', 'SouthEast');
    set(gca, 'FontSize', 15);
    figure(h2);
    xlabel('Steps');
    ylabel('Optimal Percentage');
    legend(legends, 'Location', 'SouthEast');
    set(gca, 'FontSize', 15, 'YTick', 0:0.2:1, 'YTickLabel', {'0%', '20%', '40%', '60%', '80%', '100%'});
end