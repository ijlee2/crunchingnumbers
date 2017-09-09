%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This routine uses Conjugate Gradient method to solve the discrete
%    2D Poisson's equation on a square domain with zero Dirichlet BC:
%      
%      -u_{xx} - u_{yy} = f(x, y),  in (0, L) x (0, L)
%      
%      u(x, y) = 0,                 on x = 0, x = L, y = 0, y = L
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%      
%      l2_errors = poissons_equation_cg(N)
%      
%    where,
%      
%      N = number of interior points along each axis
%    
%--------------------------------------------------------------------------
function poissons_equation_cg(N)
    clc;
    close all;
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Initialize the problem
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Model parameters
    a = 1;
    b = 9;
    L = 1;
    
    % Mesh size
    h = L/(N + 1);
    
    % Termination criterion
    numIterations = 100;
    tolerance     = 1e-10;
    
    
    %----------------------------------------------------------------------
    %  Evaluate the RHS function f at all points. Note, we do not actually
    %  use the values of f on the boundary.
    %----------------------------------------------------------------------
    a_normalized = a/L * pi;
    b_normalized = b/L * pi;
    
    f_fcn = @(x, y) (a_normalized^2 + b_normalized^2) * sin(a_normalized * x) .* sin(b_normalized * y);
    
    % Find x- and y-coordinates of all points
    [X, Y] = meshgrid(0 : h : L, 0 : h : L);
    
    % Evaluate f at the points
    f = f_fcn(X, Y);
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Perform CG
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Initialize
    u     = zeros(N + 2);
    r     = h^2 * f;
    p     = h^2 * f;
    r_dot = dotProduct(r, r, N);
    
    for k = 1 : numIterations
        % Sparse matrix-vector multiply
        Kp = sparseMultiply(p, N);
        
        % Find alpha and initialize gamma
        alpha = r_dot / dotProduct(p, Kp, N);
        gamma = r_dot;
        
        % Find the iterate
        u = u + alpha * p;
        
        % Find the residual
        r     = r - alpha * Kp;
        r_dot = dotProduct(r, r, N);
        
        % Compute the 2-norm of the residual, terminate if below tolerance
        if (sqrt(r_dot) < tolerance)
            fprintf('CG completed in %d iterations.\n', k);
            break;
            
        elseif (k == numIterations)
            fprintf('CG did not complete in %d iterations.\n', numIterations);
            break;
            
        end
        
        % Find gamma
        gamma = r_dot / gamma;
        
        % Find the search direction
        p = r + gamma * p;
        
    end
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Post-process
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Graph the computed solution
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

    surf(X, Y, u, 'LineWidth', 0.1);

    view(320.2, 13.63);

    set(gca, 'FontSize', 28, ...
             'XTick', linspace(0, L, 6), ...
             'YTick', linspace(0, L, 6), ...
             'ZTick', linspace(-1, 1, 5));

    title('Conjugate Gradient', 'FontSize', 60);
    axis([0 L 0 L -1 1]);

    xlabel('x', 'FontSize', 48);
    ylabel('y', 'FontSize', 48);
    zlabel('u', 'FontSize', 48, 'Rotation', 0);

    caxis([-1 1]);
    colormap jet;

    position = get(gca, 'Position');

    colorbar('FontSize'  , 24, ...
             'Location'  , 'eastoutside', ...
             'Position'  , [position(1)+position(3)+0.035 position(2) 0.02 position(4)+0.04], ...
             'YTick'     , linspace(-1, 1, 9), ...
             'YTickLabel', {'-1', '', '-0.5', '', '0', '', '0.5', '', '1'});

    print('-dpng' , '-r300', 'plot_solution_cg.png');
end

function Kp = sparseMultiply(p, N)
    Kp = zeros(N + 2);
    
    for i = 2 : (N + 1)
        for j = 2 : (N + 1)
            Kp(i, j) = -p(i, j - 1) - p(i - 1, j) + 4*p(i, j) - p(i + 1, j) - p(i, j + 1);
        end
    end
end

function value = dotProduct(x, y, N)
    value = sum(sum(x(2 : N + 1, 2 : N + 1) .* y(2 : N + 1, 2 : N + 1)));
end