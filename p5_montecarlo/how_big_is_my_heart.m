%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This program uses Monte Carlo simulation to find the area of a heart,
%    which corresponds to the inequality
%    
%        (x^2 + y^2 - r^2)^3 - x^2 * y^3 <= 0
%    
%    The program then compares the absolute difference between the areas
%    predicted by our model A(r, a) and produced by Monte Carlo simulation,
%    which we take to be the truth.
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%    
%    how_big_is_my_heart()
%    
%--------------------------------------------------------------------------
function how_big_is_my_heart()
    clc;
    close all;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Set problem parameters
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Create a model for the area of our heart
    model = @(r, a) pi * r.^2 + 0.501 * r .* a + 3*pi/512 * a.^2;
    
    % Set the largest value that we consider for each parameter
    n = 100;
    
    % Set the radius and the ear length
    [r, a] = meshgrid(0 : 2 : n, 0 : 2 : n);
    
    r_length = size(r, 2);
    a_length = size(a, 1);
    
    % Find the area of our heart predicted by our model
    area_approx = model(r, a);
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Run the simulations
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Find the area of our heart from Monte Carlo simulation ("exact")
    area_exact = zeros(a_length, r_length);
    
    for j = 1 : r_length
        for i = 1 : a_length
            % Run more simulations for larger radius
            N = floor(10^4 * (1 + log(1 + r(i, j)*a(i, j))));
            
            area_exact(i, j) = calculate_area(r(i, j), a(i, j), N);
        end
    end
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Display the results
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Plot the area predicted by our model
    figure(1);
    
    mesh(r, a, area_approx, 'LineWidth', 1.3);
    
    xlabel('Radius');
    ylabel('Ear length');
    zlabel('Area');
    
    axis([0 n 0 n 0 4e4]);
    
    view([317, 42]);
    
    set(gca, 'FontSize', 24, ...
             'XTick', 0 : 20 : n, ...
             'YTick', 0 : 20 : n);
    
    
    % Plot the area produced by Monte Carlo simulation
    figure(2);
    
    mesh(r, a, area_exact, 'LineWidth', 1.3);
    
    xlabel('Radius');
    ylabel('Ear length');
    zlabel('Area');
    
    axis([0 n 0 n 0 4e4]);
    
    view([317, 42]);
    
    set(gca, 'FontSize', 24, ...
             'XTick', 0 : 20 : n, ...
             'YTick', 0 : 20 : n);
    
    
    % Plot the absolute difference between the two areas
    figure(3);
    
    mesh(r, a, abs(area_approx - area_exact), 'LineWidth', 1.3);
    
    xlabel('Radius');
    ylabel('Ear length');
    zlabel('Error');
    
    axis([0 n 0 n 0 1000]);
    
    view([317, 42]);
    
    set(gca, 'FontSize', 24, ...
             'XTick', 0 : 20 : n, ...
             'YTick', 0 : 20 : n, ...
             'ZTick', 0 : 250 : 1000);
end


%--------------------------------------------------------------------------
%  Perform a Monte Carlo simulation to find the area of the heart
%--------------------------------------------------------------------------
function A = calculate_area(r, a, N)
    % Set the size of the box
    L = max(1.5*r, 0.25*a);
    
    % Generate N points in the box
    x = (2*L) * rand(1, N) - L;
    y = (2*L) * rand(1, N) - L;
    
    % Check if a point is inside the heart
    criterion = ((x.^2 + y.^2 - r^2).^3 - a * x.^2 .* y.^3 <= 0);
    
    % Count how many points are inside the heart
    numWins = sum(criterion);
    
    % Return the area of the heart
    A = (2*L)^2 * (numWins / N);
end