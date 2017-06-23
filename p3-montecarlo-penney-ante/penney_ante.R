#--------------------------------------------------------------------------
#  Author:
#    
#    Isaac J. Lee (crunchingnumbers.live)
#    
#  Summary:
#    
#    This program uses Monte Carlo simulation to estimate the chance that
#    Player 2 wins Penney's game over 3-grams. It displays probabilities
#    over all possible combinations of choices as a data frame to the user.
#    
#  Instructions:
#    
#    Select Source (Ctrl + Shift + S on Windows, using RStudio), and type
#    the following onto the console:
#    
#    penney_ante()
#    
#--------------------------------------------------------------------------
penney_ante <- function()
{
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Set problem parameters
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # List of all possible 3-grams
    three_grams <- c('TTT', 'TTH', 'THT', 'THH', 'HTT', 'HTH', 'HHT', 'HHH')
    
    # Number of all possible 3-grams (n = 2^3)
    n <- length(three_grams)
    
    # Probabilities that Player 2 wins the game; each row (i) corresponds
    # to Player 1's choice, and each column (j) to Player 2's
    p_array <- matrix(nrow = n, ncol = n)
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Run the simulations
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    for (i in 1 : n)
    {
        for (j in 1 : n)
        {
            # Calculate the probability that Player 2 wins Penney-ante
            if (j != i)
            {
                p_array[i, j] <- calculate_probability(three_grams[i], three_grams[j])
            }
        }
    }
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Display the results
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # For aesthetics, we use a data frame to display the probabilities.
    # This allows us to print the row and column labels easily.
    p_dataframe <- as.data.frame(p_array, row.names = three_grams)
    colnames(p_dataframe) <- three_grams
    
    # Replace the NA's with a value of 0
    p_dataframe[is.na(p_dataframe)] <- 0
    
    # For each Player 1's choice, find which of Player 2's choices gives
    # him the highest probability of winning
    max_probability <- apply(p_dataframe, MARGIN = 1, max)
    
    # Display the data frame
    p_dataframe
}


#--------------------------------------------------------------------------
#  Perform a Monte Carlo simulation to estimate the probability that
#  Player 2 wins Penney-ante
#--------------------------------------------------------------------------
calculate_probability <- function(player1_choice, player2_choice)
{
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Set problem parameters
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Reset the number of wins
    numWins <- 0
    
    # Set the number of simulations
    N <- 10^4
    
    # Create a two-sided coin
    coin <- c('T', 'H')
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Run the simulations
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    for (i in 1 : N)
    {
        #------------------------------------------------------------------
        #  Form a 3-gram (i.e. toss the coin 3 times)
        #------------------------------------------------------------------
        # First, create an array of characters
        three_gram <- coin[sample(1 : 2, 3, replace = TRUE)]
        
        # Collapse the character array into a string
        three_gram <- paste(three_gram, collapse = '')
        
        
        #------------------------------------------------------------------
        #  Check if either player has won
        #------------------------------------------------------------------
        if (player2_choice == three_gram)
        {
            numWins <- numWins + 1
        }
        
        else if (player1_choice == three_gram)
        {
            # Do nothing
        }
        
        else
        {
            while (TRUE)
            {
                # Keep the last two tosses and add the new toss
                substr(three_gram, 1, 2) <- substr(three_gram, 2, 3)
                substr(three_gram, 3, 3) <- coin[sample(1 : 2, 1)]
                
                if (player2_choice == three_gram)
                {
                    numWins <- numWins + 1
                    
                    break
                }
                
                else if (player1_choice == three_gram)
                {
                    # Do nothing
                    
                    break
                }
            }
        }
    }
    
    
    # Return the probability that Player 2 wins
    return(numWins / N)
}