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
#    Select Run (F5 on Windows, using Spyder) and type the following onto
#    IPython console:
#    
#    buffons_needle()
#    
#--------------------------------------------------------------------------
import matplotlib.pyplot as plt
import numpy as np


def buffons_needle():
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Set problem parameters
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Set the number of simulations
    N = 10 ** 5


    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Run the simulations
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Create the first point
    x1 = 9 * np.random.rand(1, N) + 1
    y1 = 9 * np.random.rand(1, N) + 1

    # Set the angle
    theta = 2*np.pi * np.random.rand(1, N)

    # Create the second point
    x2 = x1 + np.cos(theta)
    y2 = y1 + np.sin(theta)

    # Check if a needle intersects a line
    criterion = np.ceil(np.minimum(y1, y2)) == np.floor(np.maximum(y1, y2))

    # Count how many needles intersect a line
    numWins = np.sum(criterion)


    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Display the results
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Return the probability that a needle intersects a line
    p = numWins / N
    print('The probability that a needle intersects a line is approximately {0:.5f}.\n'.format(p))

    # Approximate the value of pi
    print('pi is approximately {0:.5f}.\n'.format(2 / p))


    #----------------------------------------------------------------------
    #  Draw the first 300 needles on the lined paper
    #----------------------------------------------------------------------
    index = range(300)

    plt.plot([x1[0][index], x2[0][index]], [y1[0][index], y2[0][index]], '-')

    plt.axis([0, 11, 0, 11])

    plt.xticks(range(12))

    plt.yticks(range(12))

    plt.gca().yaxis.grid(True)

    plt.show()
#end