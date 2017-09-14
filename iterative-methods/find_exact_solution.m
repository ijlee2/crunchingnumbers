%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This routine uses SSOR with Chebyshev acceleration to determine the
%    solution u to the discrete 2D Poisson's equation, Ku = f.
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%      
%      find_exact_solution(N)
%      
%    where,
%      
%      N = number of interior points along each axis
%    
%--------------------------------------------------------------------------
function find_exact_solution(N)
    clc;
    
    %----------------------------------------------------------------------
    %  Initialize the problem
    %----------------------------------------------------------------------
    % Model parameters
    a = 1;
    b = 9;
    L = 1;
    
    % Mesh size
    h = L / (N + 1);
    
    % Number of iterations
    numIterations = 1000;
    
    
    %----------------------------------------------------------------------
    %  Initialize the solution array using the exact solution to the
    %  continuous 2D Poisson's equation
    %----------------------------------------------------------------------
    a_normalized = a/L * pi;
    b_normalized = b/L * pi;
    
    u_fcn = @(x, y) sin(a_normalized * x) .* sin(b_normalized * y);
    f_fcn = @(x, y) (a_normalized^2 + b_normalized^2) * sin(a_normalized * x) .* sin(b_normalized * y);
    
    % Find x- and y-coordinates of all points
    [X, Y] = meshgrid(0 : h : L, 0 : h : L);
    
    u_exact = u_fcn(X, Y);
    f = f_fcn(X, Y);
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Perform SSOR with Chebyshev acceleration
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Set weight
    omega = 2 / (1 + sqrt(2 - 2*cos(h*pi)));
    
    % Set temporary variables
    rho = 1 - pi/(2*N);
    mu0 = 1;
    mu1 = rho;
    
    
    %----------------------------------------------------------------------
    %  Perform the first iteration
    %----------------------------------------------------------------------
    % Set initial guesses
    u0 = u_exact;
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
    
    
    %----------------------------------------------------------------------
    %  Perform the remaining iterations
    %----------------------------------------------------------------------
    for k = 2 : numIterations
        mu = 1 / (2/(rho * mu1) - 1/mu0);
        u_exact = u1;
        
        % Natural ordering
        for j = 2 : (N + 1)
            for i = 2 : (N + 1)
                u_exact(i, j) = (1 - omega) * u_exact(i, j) + omega * (u_exact(i - 1, j) + u_exact(i + 1, j) + u_exact(i, j - 1) + u_exact(i, j + 1) + h^2*f(i, j)) / 4;
            end
        end
        
        % Reverse ordering
        for j = (N + 1) : -1 : 2
            for i = (N + 1) : -1 : 2
                u_exact(i, j) = (1 - omega) * u_exact(i, j) + omega * (u_exact(i - 1, j) + u_exact(i + 1, j) + u_exact(i, j - 1) + u_exact(i, j + 1) + h^2*f(i, j)) / 4;
            end
        end
        
        % Chebyshev acceleration
        u_exact = 2*mu/(rho*mu1) * u_exact - mu/mu0 * u0;
        
        % Update temporary variables
        mu0 = mu1;
        mu1 = mu;
        u0  = u1;
        u1  = u_exact;
    end
    
    % Store the solution
    save('./exact_solution', 'u_exact', '-v7.3');
end