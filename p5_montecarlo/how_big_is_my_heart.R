#--------------------------------------------------------------------------
#  Author:
#    
#    Isaac J. Lee (crunchingnumbers.live)
#    
#  Summary:
#    
#    This program uses Monte Carlo simulation to find the area of a heart,
#    which corresponds to the inequality
#    
#        (x^2 + y^2 - r^2)^3 - x^2 * y^3 <= 0
#    
#    The program then compares the absolute difference between the areas
#    predicted by our model A(r, a) and produced by Monte Carlo simulation,
#    which we take to be the truth.
#    
#  Instructions:
#    
#    Select Source (Ctrl + Shift + S on Windows, using RStudio), and type
#    the following onto the console:
#    
#    how_big_is_my_heart()
#    
#--------------------------------------------------------------------------
how_big_is_my_heart <- function()
{
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Set problem parameters
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Set the largest value that we consider for each parameter
    n <- 100
    
    # Set the radius and the ear length
    r <- seq(0, n, 2)
    a <- seq(0, n, 2)
    
    r_size <- size(r, 2)
    a_size <- size(a, 2)
    
    # Find the area of our heart predicted by our model
    area_approx <- t(outer(r, a, calculate_area_model))
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Run the simulations
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Find the area of our heart from Monte Carlo simulation ("exact")
    area_exact <- matrix(nrow = a_size, ncol = r_size)
    
    for (j in 1 : r_size)
    {
        for (i in 1 : a_size)
        {
            # Run more simulations for larger radius
            N <- floor(10^4 * (1 + log(1 + r[j]*a[i])))
            
            area_exact[i, j] <- calculate_area(r[j], a[i], N)
        }
    }
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Display the results
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Plot the area predicted by our model
    plot.new()
    
    persp(r, a, area_approx,
          
          xlab = 'Radius', ylab = 'Ear length', zlab = 'Area',
          
          xlim = c(0, 100), ylim = c(0, 100), zlim = c(0, 40000),
          
          col = rainbow(50, s = 0.9, v = 1, start = 0.07, end = 0.57, alpha = 1),
          
          theta = 317, phi = 42)
    
    
    # Plot the area produced by Monte Carlo simulation
    plot.new()
    
    persp(r, a, area_exact,
          
          xlab = 'Radius', ylab = 'Ear length', zlab = 'Area',
          
          xlim = c(0, 100), ylim = c(0, 100), zlim = c(0, 40000),
          
          col = rainbow(50, s = 0.9, v = 1, start = 0.07, end = 0.57, alpha = 1),
          
          theta = 317, phi = 42)
    
    
    # Plot the absolute difference between the two areas
    plot.new()
    
    persp(r, a, abs(area_approx - area_exact),
          
          xlab = 'Radius', ylab = 'Ear length', zlab = 'Error',
          
          xlim = c(0, 100), ylim = c(0, 100), zlim = c(0, 1000),
          
          col = rainbow(50, s = 0.9, v = 1, start = 0.07, end = 0.57, alpha = 1),
          
          theta = 317, phi = 42)
}


#--------------------------------------------------------------------------
#  Use our model to predict the area of the heart
#--------------------------------------------------------------------------
calculate_area_model <- function(r, a)
{
    # Return the area of the heart
    return(pi * r^2 + 0.501 * r * a + 3*pi/512 * a^2)
}


#--------------------------------------------------------------------------
#  Perform a Monte Carlo simulation to find the area of the heart
#--------------------------------------------------------------------------
calculate_area <- function(r, a, N)
{
    # Set the size of the box
    L <- max(c(1.5*r, 0.25*a))
    
    # Generate N points in the box
    x <- runif(N, -L, L)
    y <- runif(N, -L, L)
    
    # Check if a point is inside the heart
    criterion <- ((x^2 + y^2 - r^2)^3 - a * x^2 * y^3 <= 0)
    
    # Count how many points are inside the heart
    numWins <- sum(criterion)
    
    # Return the area of the heart
    return((2*L)^2 * (numWins / N))
}