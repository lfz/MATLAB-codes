close all;
clear;
rng(0);

for SimID = 1:2
    [MaxCarPark, MaxCarMove, Q_coeff, Q_const] = ProblemParameter(SimID);
    
    % Policy is integers between [-MaxCarMove, MaxCarMove]
    pi = zeros(MaxCarPark + 1, MaxCarPark + 1);
    V = zeros(MaxCarPark + 1, MaxCarPark + 1);
    
    dV_th = 0.05;
    
    PolicyImproveNum = 5;
    for ImproveIter = 1:PolicyImproveNum
        % Policy evaluation
        dV = Inf; EvaluateIter = 0;
        while dV > dV_th
            EvaluateIter = EvaluateIter + 1;
            display(sprintf('Evaluating policy (Iteration %d)...', EvaluateIter));
            V_new = zeros(size(V));
            for n1 = 0:MaxCarPark
                for n2 = 0:MaxCarPark
                    a = pi(n1 + 1, n2 + 1);
                    V_new(n1 + 1, n2 + 1) = QExpectation(n1, n2, a, V, Q_coeff, Q_const, MaxCarMove);
                end
            end
            dV = max(abs(V_new(:) - V(:)));
            display(sprintf('Max value change: %g', dV));
            V = V_new;
        end
        figure('Position', [300 200 400 300]);
        [x_grid, y_grid] = meshgrid(0:MaxCarPark, 0:MaxCarPark);
        mesh(x_grid, y_grid, V);
        xlabel('n_2'); ylabel('n_1'); zlabel('V(s)');
        xlim([0, MaxCarPark]); ylim([0, MaxCarPark]);
        colormap('jet'); colorbar;
        title(sprintf('V_%d', ImproveIter-1));
        set(gca, 'FontSize', 15);
        
        % Policy improvement
        display('Updating policy...');
        ChangeFlag = false;
        for n1 = 0:MaxCarPark
            for n2 = 0:MaxCarPark
                a_set = max([-n2, -MaxCarPark + n1, -MaxCarMove]):min([n1, MaxCarPark - n2, MaxCarMove]);
                Q = zeros(1, length(a_set));
                for a = a_set
                    Q(a_set == a) = QExpectation(n1, n2, a, V, Q_coeff, Q_const, MaxCarMove);
                end
                if a_set(Q == max(Q)) ~= pi(n1 + 1, n2 + 1)
                    pi(n1 + 1, n2 + 1) = a_set(Q == max(Q));
                    ChangeFlag = true;
                end
            end
        end
        if ~ChangeFlag
            display('Policy unchanged.');
        else
            display('New policy applied.');
        end
        figure('Position', [300 200 350 300]);
        imagesc([0, MaxCarPark], [0, MaxCarPark], pi); xlabel('n_2'); ylabel('n_1'); axis('equal');
        title(sprintf('\\pi_%d', ImproveIter - 1));
        colormap('jet'); colorbar;
        set(gca, 'FontSize', 15, 'YDir', 'normal');
    end
end