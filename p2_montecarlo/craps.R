#--------------------------------------------------------------------------
# -------------------------------------------------------------------------
#   Set problem parameters
# -------------------------------------------------------------------------
#--------------------------------------------------------------------------
# Reset the number of wins
numWins <- 0

# Set the number of simulations that we will run
N <- 10^5


#--------------------------------------------------------------------------
# -------------------------------------------------------------------------
#   Run the simulations
# -------------------------------------------------------------------------
#--------------------------------------------------------------------------
for (i in 1 : N)
{
  #------------------------------------------------------------------------
  #  Roll the dice and find their sum
  #------------------------------------------------------------------------
  die1 <- sample(1 : 6, 1)
  die2 <- sample(1 : 6, 1)
  sum  <- die1 + die2
  
  
  #------------------------------------------------------------------------
  #  Check if we have a natural
  #------------------------------------------------------------------------
  if (sum == 7 || sum == 11)
  {
    numWins <- numWins + 1
  }  
    
  #------------------------------------------------------------------------
  #  Check if we have craps
  #------------------------------------------------------------------------
  else if (sum == 2 || sum == 3 || sum == 12)
  {
    # Do nothing
  }  
    
  #----------------------------------------------------------------------
  #  Otherwise, we roll the dice until we get the initial sum
  #  or a sum of 7
  #------------------------------------------------------------------------
  else
  {
    while (TRUE)
    {
      # Roll the dice and find their sum
      die1    <- sample(1 : 6, 1)
      die2    <- sample(1 : 6, 1)
      sum_new <- die1 + die2
      
      if (sum_new == sum)
      {
        numWins <- numWins + 1
        
        break
      }
      else if (sum_new == 7)
      {
        # Do nothing
        
        break
      }
    }
  }
}


#--------------------------------------------------------------------------
# -------------------------------------------------------------------------
#   Display the results
# -------------------------------------------------------------------------
#--------------------------------------------------------------------------
# Exact probability of winning a game of craps
p_exact <- 244 / 495

# Approximate probability of winning the game
p_approx <- numWins / N

# Calculate the relative error of the approximate probability
relative_error <- abs((p_approx - p_exact) / p_exact)


# Display these messages to the user
print(sprintf('The exact probability of winning craps is %.6f.', p_exact))
print(sprintf('From %d simulations, we get an approximate value of %.6f.', N, p_approx))
print(sprintf('The relative error of the approximate probability is %.5f.', relative_error))