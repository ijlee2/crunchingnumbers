#--------------------------------------------------------------------------
#  Author:
#    
#    Isaac J. Lee (crunchingnumbers.live)
#    
#  Summary:
#    
#    This program uses Monte Carlo simulation to find the probability
#    that a needle intersects a line. It returns the probability, an
#    estimate of pi, and a plot of the first 300 needles on the paper.
#    
#  Instructions:
#    
#    Select Source (Ctrl + Shift + S on Windows, using RStudio), and type
#    the following onto the console:
#    
#    buffons_needle()
#    
#--------------------------------------------------------------------------
buffons_needle <- function()
{
    # Clear all plots
    dev.off()
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Set problem parameters
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Set the number of simulations
    N <- 10^5
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Run the simulations
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Create the first point
    x1 <- runif(N, 1, 10)
    y1 <- runif(N, 1, 10)
    
    # Set the angle
    theta <- runif(N, 0, 2*pi)
    
    # Create the second point
    x2 <- x1 + cos(theta)
    y2 <- y1 + sin(theta)
    
    # Check if a needle intersects a line
    criterion <- (ceiling(pmin(y1, y2)) == floor(pmax(y1, y2)))
    
    # Count how many needles intersect a line
    numWins <- sum(criterion)
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Display the results
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Return the probability that a needle intersects a line
    p = numWins / N
    print(sprintf('The probability that a needle intersects a line is approximately %.5f.', p))
    
    # Approximate the value of pi
    print(sprintf('pi is approximately %.5f', 2/p))
    
    
    #----------------------------------------------------------------------
    #  Draw the first 300 needles on the lined paper
    #----------------------------------------------------------------------
    index <- 1 : 300
    
    x_range <- 0 : 11
    y_range <- 0 : 11
    
    plot.new()
    plot.window(c(0, 11), c(0, 11), xaxs = 'i', yaxs = 'i')
    
    segments(x1[index], y1[index], 
             x2[index], y2[index],
             col = rainbow(300, s = 1, v = 1, start = 0, end = 299/300, alpha = 1),
             lwd = 2)
    
    axis(1, at = x_range, labels = x_range)
    axis(2, at = y_range, labels = y_range)
    
    grid(nx = NA, ny = 11)
}