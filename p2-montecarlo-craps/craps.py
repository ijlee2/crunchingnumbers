#--------------------------------------------------------------------------
#  Author:
#    
#    Isaac J. Lee (crunchingnumbers.live)
#    
#  Summary:
#    
#    This program uses Monte Carlo simulation to approximate the chance of
#    winning a game of craps. It then displays the following values to the
#    user: the exact and approximate probabilities, and the relative error
#    between these two values.
#    
#  Instructions:
#    
#    Select Run (F5 on Windows, using Spyder) and type the following onto
#    IPython console:
#    
#    craps()
#    
#--------------------------------------------------------------------------
# For random number generation
import random


def craps():
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Set problem parameters
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Reset the number of wins
    numWins = 0
    
    # Set the number of simulations
    N = 10**5
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Run the simulations
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    for i in range(N):
        #------------------------------------------------------------------
        #  Roll the dice and find their sum
        #------------------------------------------------------------------
        die1 = random.randint(1, 6)
        die2 = random.randint(1, 6)
        sum  = die1 + die2
                
                
        #------------------------------------------------------------------
        #  Check if we have a natural
        #------------------------------------------------------------------
        if (sum == 7) | (sum == 11):
            numWins = numWins + 1
            
            
        #------------------------------------------------------------------
        #  Check if we have craps
        #------------------------------------------------------------------
        elif (sum == 2) | (sum == 3) | (sum == 12):
            # Do nothing
            
            continue
        
            
        #------------------------------------------------------------------
        #  Otherwise, we roll the dice until we get the initial sum or a
        #  sum of 7
        #------------------------------------------------------------------
        else:
            while (True):
                # Roll the dice and find their sum
                die1    = random.randint(1, 6)
                die2    = random.randint(1, 6)
                sum_new = die1 + die2
                
                if (sum_new == sum):
                    numWins = numWins + 1
                    
                    break
                
                elif (sum_new == 7):
                    # Do nothing
                    
                    break
                
                # end
            # end
        # end
    # end
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Display the results
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------     
    # Exact probability of winning a game of craps
    p_exact = 244 / 495
    
    # Approximate probability of winning the game
    p_approx = numWins / N
    
    # Calculate the relative error of the approximate probability
    relative_error = abs((p_approx - p_exact) / p_exact)
    
    
    # Display these messages to the user
    print('The exact probability of winning craps is {0:.6f}.\n'.format(p_exact))
    print('From {0:d} simulations, we get an approximate value of {1:.6f}.\n'.format(N, p_approx))
    print('The relative error of the approximate probability is {0:.5f}.\n'.format(relative_error))
# end