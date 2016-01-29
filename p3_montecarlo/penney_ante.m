%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This program uses Monte Carlo simulation to estimate the chance that
%    Player 2 wins Penney's game over 3-grams. It displays probabilities
%    over all possible combinations of choices as a table to the user.
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%    
%    penney_ante()
%    
%--------------------------------------------------------------------------
function penney_ante()
    clc;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Set problem parameters
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % List of all possible 3-grams
    three_grams = {'TTT'; 'TTH'; 'THT'; 'THH'; 'HTT'; 'HTH'; 'HHT'; 'HHH'};
    
    % Number of all possible 3-grams (n = 2^3)
    n = length(three_grams);
    
    % Probabilities that Player 2 wins the game; each row (i) corresponds
    % to Player 1's choice, and each column (j) to Player 2's
    p_array = zeros(n, n);
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Run the simulations
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    for i = 1 : n
        for j = 1 : n
            % Calculate the probability that Player 2 wins Penney-ante
            if (j ~= i)
                p_array(i, j) = calculate_probability(three_grams{i}, three_grams{j});
            end
        end
    end
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Display the results
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % For aesthetics, we use a table to display the probabilities. This
    % allows us to print the row and column labels easily.
    p_table = array2table(p_array, 'RowNames', three_grams, 'VariableNames', three_grams);
    
    % For each Player 1's choice, find which of Player 2's choices gives
    % him the highest probability of winning
    [~, index] = max(p_array, [], 2);
    
    % Display Player 2's optimal strategy as an additional column
    p_table.OptimalStrategy = three_grams(index)
end


%--------------------------------------------------------------------------
%  Perform a Monte Carlo simulation to estimate the probability that
%  Player 2 wins Penney-ante
%--------------------------------------------------------------------------
function p = calculate_probability(player1_choice, player2_choice)
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Set problem parameters
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Reset the number of wins
    numWins = 0;
    
    % Set the number of simulations
    N = 10^4;
    
    % Create a two-sided coin
    coin = 'TH';
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Run the simulations
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    for i = 1 : N
        %------------------------------------------------------------------
        %  Form a 3-gram (i.e. toss the coin 3 times)
        %------------------------------------------------------------------
        three_gram = coin(randi(2, 1, 3));
        
        
        %------------------------------------------------------------------
        %  Check if either player has won
        %------------------------------------------------------------------
        if (strcmp(player2_choice, three_gram))
            numWins = numWins + 1;
            
        elseif (strcmp(player1_choice, three_gram))
            % Do nothing
            
        else
            while (true)
                % Keep the last two tosses and add the new toss
                three_gram(1) = three_gram(2);
                three_gram(2) = three_gram(3);
                three_gram(3) = coin(randi(2));
                
                if (strcmp(player2_choice, three_gram))
                    numWins = numWins + 1;
                    
                    break;
                    
                elseif (strcmp(player1_choice, three_gram))
                    % Do nothing
                    
                    break;
                    
                end
            end
        end
    end
    
    
    % Return the probability that Player 2 wins
    p = numWins / N;
end