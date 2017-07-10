%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This routine uses classical iterative methods to solve the discrete
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
%      l2_errors = poissons_equation_classical(method, N, numIterations, graphSolution)
%      
%    where,
%      
%      methodName    = 'exact'
%                      'Jacobi'
%                      'Gauss-Seidel'
%                      'SOR'
%                      'SSOR'
%      
%      N             = number of interior points along each axis
%      
%      numIterations = number of iterations to perform
%      
%      graphSolution = false (do not graph; find l2 errors at the first,
%                             middle, and last iterations)
%                      true  (graph; find l2 errors at the first and last
%                             iterations)
%    
%--------------------------------------------------------------------------
function l2_errors = poissons_equation_classical(methodName, N, numIterations, graphSolution)
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
    h = L / (N + 1);
    
    % Create a check point after 50 iterations
    numIterations_checkpoint = 50;
    
    
    %----------------------------------------------------------------------
    %  Initialize the solution array u. We call the zeros function for two
    %  reasons:
    %    
    %    1. We have zero Dirichlet BC.
    %    
    %    2. The zero function seems like an unbiased guess. We can write
    %       u(1 : N, 1 : N) = randn(N) to make a random initial guess,
    %       but this slows down convergence.
    %----------------------------------------------------------------------
    u = zeros(N + 2);
    
    
    %----------------------------------------------------------------------
    %  Load the exact solution
    %----------------------------------------------------------------------
    load('./exact_solution.mat', 'u_exact');
    
    
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
    %  Initialize the array of l2 errors
    %----------------------------------------------------------------------
    if (~graphSolution)
        % We will compute the error at the first iteration, after every
        % 50 iterations, and at the last iteration
        l2_errors = zeros(1 + ceil(numIterations / numIterations_checkpoint), 1);
        
    else
        % We will compute the error at the first and last iterations
        l2_errors = zeros(2, 1);
        
    end
    
    % Counter for the l2 error
    count = 1;
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Perform a finite difference method
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Comment the next two lines once the four iterative methods have been
    % re-implemented. Matlab halts when forming K for large N.
    %{
    % Discrete Laplace operator for 1D Poisson's equation
    K1 = diag(-1 * ones(N - 1, 1), -1) ...
       + diag( 2 * ones(N    , 1),  0) ...
       + diag(-1 * ones(N - 1, 1),  1);
    
    % Discrete Laplace operator for 2D Poisson's equation
    K  = kron(eye(N), K1) + kron(K1, eye(N));
    %}
    
    switch methodName
        case 'Exact'
            u = u_exact;
            
        case 'Jacobi'
            %{
            % Naive approach
            P = diag(diag(K));
            Q = P - K;
            
            for k = 1 : numIterations
                % Natural ordering
                u_vec = reshape(flipud(u(2:(N + 1), 2:(N + 1)))', N^2, 1);
                f_vec = reshape(flipud(f(2:(N + 1), 2:(N + 1)))', N^2, 1);
                
                u(2:(N + 1), 2:(N + 1)) = fliplr(reshape(flipud(P \ (Q*u_vec + h^2*f_vec)), N, N)');
                
                % Compute the l2 error
                if (k == 1 || (~graphSolution && mod(k, numIterations_checkpoint) == 0) || k == numIterations)
                    l2_errors(count) = norm(u - u_exact, 'fro');
                    
                    count = count + 1;
                end
            end
            %}
            
            % Set temporary variable
            uNew = zeros(N + 2);
            
            for k = 1 : numIterations
                % Natural ordering
                for j = 2 : (N + 1)
                    for i = 2 : (N + 1)
                        uNew(i, j) = (u(i - 1, j) + u(i + 1, j) + u(i, j - 1) + u(i, j + 1) + h^2*f(i, j)) / 4;
                    end
                end
                
                % Update iterate
                u = uNew;
                
                % Compute the l2 error
                if (k == 1 || (~graphSolution && mod(k, numIterations_checkpoint) == 0) || k == numIterations)
                    l2_errors(count) = norm(u - u_exact, 'fro');
                    
                    count = count + 1;
                end
            end
            
        case 'Gauss-Seidel'
            %{
            % Naive approach
            P = diag(diag(K)) + tril(K, -1);
            Q = P - K;
            
            for k = 1 : numIterations
                % Natural ordering
                u_vec = reshape(flipud(u(2:(N + 1), 2:(N + 1)))', N^2, 1);
                f_vec = reshape(flipud(f(2:(N + 1), 2:(N + 1)))', N^2, 1);
                
                u(2:(N + 1), 2:(N + 1)) = fliplr(reshape(flipud(P \ (Q*u_vec + h^2*f_vec)), N, N)');
                
                % Compute the l2 error
                if (k == 1 || (~graphSolution && mod(k, numIterations_checkpoint) == 0) || k == numIterations)
                    l2_errors(count) = norm(u - u_exact, 'fro');
                    
                    count = count + 1;
                end
            end
            %}
            
            for k = 1 : numIterations
                % Red points
                for j = 2 : (N + 1)
                    for i = 2 : (N + 1)
                        if (mod(i + j, 2) == 0)
                            u(i, j) = (u(i - 1, j) + u(i + 1, j) + u(i, j - 1) + u(i, j + 1) + h^2*f(i, j)) / 4;
                        end
                    end
                end
                
                % Black points
                for j = 2 : (N + 1)
                    for i = 2 : (N + 1)
                        if (mod(i + j, 2) == 1)
                            u(i, j) = (u(i - 1, j) + u(i + 1, j) + u(i, j - 1) + u(i, j + 1) + h^2*f(i, j)) / 4;
                        end
                    end
                end
                
                % Compute the l2 error
                if (k == 1 || (~graphSolution && mod(k, numIterations_checkpoint) == 0) || k == numIterations)
                    l2_errors(count) = norm(u - u_exact, 'fro');
                    
                    count = count + 1;
                end
            end
            
        case 'SOR'
            %{
            % Naive approach
            omega = 2 / (1 + sin(h*pi));
            P = (1/omega    ) * diag(diag(K)) + tril(K, -1);
            Q = (1/omega - 1) * diag(diag(K)) - triu(K,  1);
            
            for k = 1 : numIterations
                % Natural ordering
                u_vec = reshape(flipud(u(2:(N + 1), 2:(N + 1)))', N^2, 1);
                f_vec = reshape(flipud(f(2:(N + 1), 2:(N + 1)))', N^2, 1);
                
                u(2:(N + 1), 2:(N + 1)) = fliplr(reshape(flipud(P \ (Q*u_vec + h^2*f_vec)), N, N)');
                
                % Compute the l2 error
                if (k == 1 || (~graphSolution && mod(k, numIterations_checkpoint) == 0) || k == numIterations)
                    l2_errors(count) = norm(u - u_exact, 'fro');
                    
                    count = count + 1;
                end
            end
            %}
            
            % Set weight
            omega = 2 / (1 + sin(h*pi));
            
            for k = 1 : numIterations
                % Red points
                for j = 2 : (N + 1)
                    for i = 2 : (N + 1)
                        if (mod(i + j, 2) == 0)
                            u(i, j) = (1 - omega) * u(i, j) + omega * (u(i - 1, j) + u(i + 1, j) + u(i, j - 1) + u(i, j + 1) + h^2*f(i, j)) / 4;
                        end
                    end
                end
                
                % Black points
                for j = 2 : (N + 1)
                    for i = 2 : (N + 1)
                        if (mod(i + j, 2) == 1)
                            u(i, j) = (1 - omega) * u(i, j) + omega * (u(i - 1, j) + u(i + 1, j) + u(i, j - 1) + u(i, j + 1) + h^2*f(i, j)) / 4;
                        end
                    end
                end
                
                % Compute the l2 error
                if (k == 1 || (~graphSolution && mod(k, numIterations_checkpoint) == 0) || k == numIterations)
                    l2_errors(count) = norm(u - u_exact, 'fro');
                    
                    count = count + 1;
                end
            end
            
        case 'SSOR'
            %{
            % Naive approach (w/o Chebyshev acceleration)
            omega = 2 / (1 + sin(h*pi));
            P = (1/omega    ) * diag(diag(K)) + tril(K, -1);
            Q = (1/omega - 1) * diag(diag(K)) - triu(K,  1);
            
            for k = 1 : numIterations
                % On odd iterations,
                if (mod(k, 2) == 1)
                    % Natural ordering
                    u_vec = reshape(flipud(u(2:(N + 1), 2:(N + 1)))', N^2, 1);
                    f_vec = reshape(flipud(f(2:(N + 1), 2:(N + 1)))', N^2, 1);
                    
                    u(2:(N + 1), 2:(N + 1)) = fliplr(reshape(flipud(P \ (Q*u_vec + h^2*f_vec)), N, N)');
                    
                % On even iterations,
                else
                    % Reverse ordering
                    u_vec = flipud(reshape(flipud(u(2:(N + 1), 2:(N + 1)))', N^2, 1));
                    f_vec = flipud(reshape(flipud(f(2:(N + 1), 2:(N + 1)))', N^2, 1));
                    
                    u(2:(N + 1), 2:(N + 1)) = fliplr(reshape(flipud(P \ (Q*u_vec + h^2*f_vec)), N, N)');
                    
                end
                
                % Compute the l2 error
                if (k == 1 || (~graphSolution && mod(k, numIterations_checkpoint) == 0) || k == numIterations)
                    l2_errors(count) = norm(u - u_exact, 'fro');
                    
                    count = count + 1;
                end
            end
            %}
            
            % Set weight
            omega = 2 / (1 + sqrt(2 - 2*cos(h*pi)));
            
            % Set temporary variables
            rho = 1 - pi/(2*N);
            mu0 = 1;
            mu1 = rho;
            
            
            %--------------------------------------------------------------
            %  Perform the first iteration
            %--------------------------------------------------------------
            % Set initial guesses
            u0 = u;
            u1 = u0;
            
            % Natural ordering
            for j = 2 : (N + 1)
                for i = 2 : (N + 1)
                    u1(i, j) = (1 - omega) * u1(i, j) + omega * (u1(i - 1, j) + u1(i + 1, j) + u1(i, j - 1) + u1(i, j + 1) + h^2*f(i, j)) / 4;
                end
            end
            
            % Reverse ordering
            for j = (N + 1) : -1 : 2
                for i = (N + 1) : -1 : 2
                    u1(i, j) = (1 - omega) * u1(i, j) + omega * (u1(i - 1, j) + u1(i + 1, j) + u1(i, j - 1) + u1(i, j + 1) + h^2*f(i, j)) / 4;
                end
            end
            
            
            %--------------------------------------------------------------
            %  Perform the remaining iterations
            %--------------------------------------------------------------
            for k = 2 : numIterations
                mu = 1 / (2/(rho * mu1) - 1/mu0);
                u  = u1;
                
                % Natural ordering
                for j = 2 : (N + 1)
                    for i = 2 : (N + 1)
                        u(i, j) = (1 - omega) * u(i, j) + omega * (u(i - 1, j) + u(i + 1, j) + u(i, j - 1) + u(i, j + 1) + h^2*f(i, j)) / 4;
                    end
                end
                
                % Reverse ordering
                for j = (N + 1) : -1 : 2
                    for i = (N + 1) : -1 : 2
                        u(i, j) = (1 - omega) * u(i, j) + omega * (u(i - 1, j) + u(i + 1, j) + u(i, j - 1) + u(i, j + 1) + h^2*f(i, j)) / 4;
                    end
                end
                
                % Chebyshev acceleration
                u = 2*mu/(rho*mu1) * u - mu/mu0 * u0;
                
                % Update temporary variables
                mu0 = mu1;
                mu1 = mu;
                u0  = u1;
                u1  = u;
                
                % Compute the l2 error
                if (k == 1 || (~graphSolution && mod(k, numIterations_checkpoint) == 0) || k == numIterations)
                    l2_errors(count) = norm(u - u_exact, 'fro');
                    
                    count = count + 1;
                end
            end
        
    end
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Post-process
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Graph the computed solution
    if (graphSolution)
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
        
        title(methodName, 'FontSize', 60);
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
        
        print('-dpng' , '-r300', strcat('plot_solution_', lower(methodName), '.png'));
    end
end