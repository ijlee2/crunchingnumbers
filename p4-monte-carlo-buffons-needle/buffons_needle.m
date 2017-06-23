%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This program uses Monte Carlo simulation to find the probability
%    that a needle intersects a line. It returns the probability, an
%    estimate of pi, and a plot of the first 300 needles on the paper.
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%    
%    buffons_needle()
%    
%--------------------------------------------------------------------------
function buffons_needle()
    clc;
    close all;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Set problem parameters
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Set the number of simulations
    N = 10^5;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Run the simulations
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Create the first point
    x1 = 9 * rand(1, N) + 1;
    y1 = 9 * rand(1, N) + 1;
    
    % Set the angle
    theta = 2*pi * rand(1, N);
    
    % Create the second point
    x2 = x1 + cos(theta);
    y2 = y1 + sin(theta);
    
    % Check if a needle intersects a line
    criterion = (ceil(min(y1, y2)) == floor(max(y1, y2)));
    
    % Count how many needles intersect a line
    numWins = sum(criterion);
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Display the results
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Return the probability that a needle intersects a line
    p = numWins / N;
    fprintf('The probability that a needle intersects a line is approximately %.5f.\n\n', p);
    
    % Approximate the value of pi
    fprintf('pi is approximately %.5f.\n\n', 2/p);
    
    
    %----------------------------------------------------------------------
    %  Draw the first 300 needles on the lined paper
    %----------------------------------------------------------------------
    index = 1 : 300;
    
    plot([x1(index); x2(index)], [y1(index); y2(index)], '-', 'LineWidth', 2);
    
    axis([0 11 0 11]);
    
    axis square;
    
    set(gca, 'FontSize', 14, 'YGrid', 'on');
end