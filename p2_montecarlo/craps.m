%--------------------------------------------------------------------------
%  Summary:
%    
%    This program uses Monte Carlo simulation to approximate the chance of
%    winning a game of craps. It then displays the following values to the
%    user: the exact and approximate probabilities, and the relative error
%    between these two values.
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%    
%    craps()
%    
%--------------------------------------------------------------------------
function craps()
    clc;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Set problem parameters
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Reset the number of wins
    numWins = 0;
    
    % Set the number of simulations that we will run
    N = 10^5;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Run the simulations
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    for i = 1 : N
        %------------------------------------------------------------------
        %  Roll the dice and find their sum
        %------------------------------------------------------------------
        die1 = randi(6);
        die2 = randi(6);
        sum  = die1 + die2;
        
        
        %------------------------------------------------------------------
        %  Check if we have a natural
        %------------------------------------------------------------------
        if (sum == 7 || sum == 11)
            numWins = numWins + 1;
            
            
        %------------------------------------------------------------------
        %  Check if we have craps
        %------------------------------------------------------------------
        elseif (sum == 2 || sum == 3 || sum == 12)
            % Do nothing
            
            
        %------------------------------------------------------------------
        %  Otherwise, we roll the dice until we get the initial sum
        %  or a sum of 7
        %------------------------------------------------------------------
        else
            while (true)
                % Roll the dice and find their sum
                die1    = randi(6);
                die2    = randi(6);
                sum_new = die1 + die2;
                
                if (sum_new == sum)
                    numWins = numWins + 1;
                    
                    break;
                    
                elseif (sum_new == 7)
                    % Do nothing
                    
                    break;
                    
                end
            end
        end
    end
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Display the results
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Exact probability of winning a game of craps
    p_exact = 244 / 495;
    
    % Approximate probability of winning the game
    p_approx = numWins / N;
    
    % Calculate the relative error of the approximate probability
    relative_error = abs((p_approx - p_exact) / p_exact);
    
    
    % Display these messages to the user
    fprintf('\n');
    fprintf('The exact probability of winning craps is %.6f.\n\n', p_exact);
    fprintf('From %d simulations, we get an approximate value of %.6f.\n\n', N, p_approx);
    fprintf('The relative error of the approximate probability is %.5f.\n\n', relative_error);
end