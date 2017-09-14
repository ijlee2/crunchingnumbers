%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This driver compares the solutions after 100 iterations, then plots
%    the convergence of each method.
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%    
%    driver
%    
%--------------------------------------------------------------------------
function driver()
    clc;
    close all;
    
    
    %----------------------------------------------------------------------
    %  Initialize the problem
    %----------------------------------------------------------------------
    % Set the number of points along each axis
    N = 200;
    
    % Find the exact solution to the discrete Poisson's equation
    find_exact_solution(N);
    
    % Set labels for method names
    methodNames = {'Exact'; 'Jacobi'; 'Gauss-Seidel'; 'SOR'; 'SSOR'};
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Solve the discrete Poisson's equation with four iterative methods
    %   and compare the results after 100 iterations
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    numIterations = 100;
    
    fprintf('Here are the l2 errors after %d iterations:\n\n', numIterations);
    
    for i = 1 : 5
        l2_errors = poissons_equation_classical(methodNames{i}, N, numIterations, true);
        
        fprintf('%s: %.4f\n', methodNames{i}, l2_errors(end));
    end
    
    fprintf('\n');
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Plot convergence
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    numIterations = [1, 50 : 50 : 500];
    
    l2_errors = zeros(4, length(numIterations));
    
    for i = 2 : 5
        fprintf('Plotting the l2 errors for %s.\n', methodNames{i});
        
        l2_errors(i - 1, :) = poissons_equation_classical(methodNames{i}, N, numIterations(end), false);
        
        methodNames{i} = [' ', methodNames{i}];
    end
    
    fprintf('\n');
    
    
    figure('Units'            , 'normalized', ...
           'OuterPosition'    , [0 0 1 1], ...
           'Color'            , [1 1 1], ...
           'InvertHardcopy'   , 'off', ...
           'MenuBar'          , 'none', ...
           'NumberTitle'      , 'off', ...
           'Resize'           , 'on', ...
           'PaperUnits'       , 'points', ...
           'PaperPosition'    , [0 0 800 600], ...
           'PaperPositionMode', 'auto');
    
    h = plot(numIterations, log10(l2_errors(1, :)), '-o', ...
             numIterations, log10(l2_errors(2, :)), '-o', ...
             numIterations, log10(l2_errors(3, :)), '-o', ...
             numIterations, log10(l2_errors(4, :)), '-o', ...
             'LineWidth', 3.5, 'MarkerSize', 10);
    
    h(1).Color = [0.10, 0.10, 0.10];
    h(2).Color = [0.80, 0.35, 0.45];
    h(3).Color = [0.30, 0.70, 0.40];
    h(4).Color = [0.25, 0.35, 0.60];
    
    h(1).MarkerFaceColor = [0.80, 0.80, 0.80];
    h(2).MarkerFaceColor = [0.95, 0.60, 0.50];
    h(3).MarkerFaceColor = [0.35, 0.95, 0.55];
    h(4).MarkerFaceColor = [0.30, 0.70, 0.85];
    
    set(gca, 'FontSize', 28, ...
             'XTick', linspace(0, 500, 11), ...
             'XTickLabel', {'0', '', '100', '', '200', '', '300', '', '400', '', '500'}, ...
             'YTick', linspace(-15, 3, 7));
    
    grid on;
    
    title('Convergence', 'FontSize', 48);
    axis([0 500 -15 3]);
    
    xlabel('number of iterations'  , 'FontSize', 32);
    ylabel('error (log10)', 'FontSize', 32);
    
    legend(methodNames(2 : 5), 'FontSize', 26, 'Location', 'southwest');
    
    print('-dpng' , '-r300', 'plot_convergence_l2_error.png');
end