#--------------------------------------------------------------------------
#  Author:
#    
#    Isaac J. Lee (crunchingnumbers.live)
#    
#  Summary:
#    
#    This program uses Monte Carlo simulation to estimate the chance that
#    Player 2 wins Penney's game over 3-grams. It displays probabilities
#    over all possible combinations of choices as an array to the user.
#    
#  Instructions:
#    
#    Select Run (F5 on Windows, using Spyder) and type the following onto
#    IPython console:
#    
#    penney_ante()
#    
#--------------------------------------------------------------------------
# For 2D arrays and random number generation
import numpy as np


def penney_ante():
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Set problem parameters
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # List of all possible 3-grams
    three_grams = np.array(['TTT', 'TTH', 'THT', 'THH', 'HTT', 'HTH', 'HHT', 'HHH'])
    
    # Number of all possible 3-grams (n = 2^3)
    n = len(three_grams)
    
    # Probabilities that Player 2 wins the game; each row (i) corresponds
    # to Player 1's choice, and each column (j) to Player 2's
    p_array = np.zeros((n, n))
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Run the simulations
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    for i in range(n):
        for j in range(n):
            # Calculate the probability that Player 2 wins Penney-ante
            if (j != i):
                p_array[i, j] = calculate_probability(three_grams[i], three_grams[j])
            # end
        # end
    # end
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Display the results
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    print(p_array)
#end


#--------------------------------------------------------------------------
#  Perform a Monte Carlo simulation to estimate the probability that
#  Player 2 wins Penney-ante
#--------------------------------------------------------------------------
def calculate_probability(player1_choice, player2_choice):
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Set problem parameters
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Reset the number of wins
    numWins = 0
    
    # Set the number of simulations
    N = 10**4
    
    # Create a two-sided coin
    coin = np.array(['T', 'H'])
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Run the simulations
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    for i in range(N):
        #------------------------------------------------------------------
        #  Form a 3-gram (i.e. toss the coin 3 times)
        #------------------------------------------------------------------
        # First, create an array of characters
        three_gram = coin[np.random.randint(2, size = 3)]
        
        # Collapse the character array into a string
        three_gram_string = ''.join(three_gram)
        
        
        #------------------------------------------------------------------
        #  Check if either player has won
        #------------------------------------------------------------------
        if (player2_choice == three_gram_string):
            numWins = numWins + 1
            
        elif (player1_choice == three_gram_string):
            # Do nothing
            
            continue
            
        else:
            while (True):
                # Keep the last two tosses and add the new toss
                three_gram[0 : 2] = three_gram[1 : 3]
                three_gram[2]     = coin[np.random.randint(2)]
                three_gram_string = ''.join(three_gram)
                
                if (player2_choice == three_gram_string):
                    numWins = numWins + 1
                    
                    break
                    
                elif (player1_choice == three_gram_string):
                    # Do nothing
                    
                    break
                    
                # end
            # end
        # end
    # end
    
    
    # Return the probability that Player 2 wins
    return numWins / N
# end