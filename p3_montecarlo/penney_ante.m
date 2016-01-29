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
    
    % A double array of probabilities of winning the game; each row (i)
    % corresponds to the opponent's choice, and each column (j) to ours
    p_array = zeros(n, n);
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Run the simulations
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    for i = 1 : n
        for j = 1 : n
            % Calculate the probability of winning Penney-ante
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
    % For aesthetics, we use a table to display the probabilities. A table
    % also allows us to print row and column labels easily.
    p_table = array2table(p_array, 'RowNames', three_grams, 'VariableNames', three_grams);
    
    % Given the opponent's choice, find which of our choices results in
    % the highest probability of winning
    [~, index] = max(p_array, [], 2);
    
    % Display our optimal strategy as an additional column
    p_table.OptimalStrategy = three_grams(index)
end


%--------------------------------------------------------------------------
%  Perform a Monte Carlo simulation to find the probability of winning
%  a game of Penney-ante
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
        if (strcmp(three_gram, player2_choice))
            numWins = numWins + 1;
            
        elseif (strcmp(three_gram, player1_choice))
            % Do nothing
            
        else
            while (true)
                % Keep the last two tosses and add the new toss
                three_gram(1) = three_gram(2);
                three_gram(2) = three_gram(3);
                three_gram(3) = coin(randi(2));
                
                if (strcmp(three_gram, player2_choice))
                    numWins = numWins + 1;
                    
                    break;
                    
                elseif (strcmp(three_gram, player1_choice))
                    % Do nothing
                    
                    break;
                    
                end
            end
        end
    end
    
    
    % Return the probability that Player 2 wins
    p = numWins / N;
end