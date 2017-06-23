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
#    Select Run (F5 on Windows, using Spyder) and type the following onto
#    IPython console:
#    
#    how_big_is_my_heart()
#    
#--------------------------------------------------------------------------
import matplotlib.pyplot as plt
from matplotlib import cm
import numpy as np


def how_big_is_my_heart():
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Set problem parameters
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Set the largest value that we consider for each parameter
    n = 100
    
    # Set the radius and the ear length
    [r, a] = np.meshgrid(np.arange(0, n + 1, 2), np.arange(0, n + 1, 2))
    
    r_length = np.shape(r)[1]
    a_length = np.shape(a)[0]
    
    # Find the area of our heart predicted by our model
    area_approx = calculate_area_model(r, a)
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Run the simulations
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Find the area of our heart from Monte Carlo simulation ("exact")
    area_exact = np.zeros((a_length, r_length))
    
    for j in range(r_length):
        for i in range(a_length):
            # Run more simulations for larger radius
            N = np.floor(10**4 * (1 + np.log(1 + r[i, j]*a[i, j])))
            
            area_exact[i, j] = calculate_area(r[i, j], a[i, j], N)
        #end
    #end
    
    
    #----------------------------------------------------------------------
    # ---------------------------------------------------------------------
    #   Display the results
    # ---------------------------------------------------------------------
    #----------------------------------------------------------------------
    # Plot the area predicted by our model
    fig = plt.figure()
    
    ax = fig.gca(projection = '3d')
    
    ax.plot_surface(r, a, area_approx,
                    rstride = 1, cstride = 1,
                    linewidth = 0.5,
                    cmap = cm.coolwarm)
    
    ax.set_xlabel('Radius')
    ax.set_ylabel('Ear length')
    ax.set_zlabel('Area')
    
    ax.set_xlim([0, 100])
    ax.set_ylim([0, 100])
    ax.set_zlim([0, 40000])
    
    ax.set_xticks([0, 20, 40, 60, 80, 100])
    ax.set_yticks([0, 20, 40, 60, 80, 100])
    ax.set_zticks([0, 10000, 20000, 30000, 40000])
    
    ax.view_init(azim = 223, elev = 42)
    
    
    # Plot the area predicted by our model
    fig = plt.figure()
    
    ax = fig.gca(projection = '3d')
    
    ax.plot_surface(r, a, area_exact,
                    rstride = 1, cstride = 1,
                    linewidth = 0.5,
                    cmap = cm.coolwarm)
    
    ax.set_xlabel('Radius')
    ax.set_ylabel('Ear length')
    ax.set_zlabel('Area')
    
    ax.set_xlim([0, 100])
    ax.set_ylim([0, 100])
    ax.set_zlim([0, 40000])
    
    ax.set_xticks([0, 20, 40, 60, 80, 100])
    ax.set_yticks([0, 20, 40, 60, 80, 100])
    ax.set_zticks([0, 10000, 20000, 30000, 40000])
    
    ax.view_init(azim = 223, elev = 42)
    
    
    # Plot the absolute difference between the two areas
    fig = plt.figure()
    
    ax = fig.gca(projection = '3d')
    
    ax.plot_surface(r, a, abs(area_approx - area_exact),
                    rstride = 1, cstride = 1,
                    linewidth = 0.5,
                    cmap = cm.coolwarm)
    
    ax.set_xlabel('Radius')
    ax.set_ylabel('Ear length')
    ax.set_zlabel('Error')
    
    ax.set_xlim([0, 100])
    ax.set_ylim([0, 100])
    ax.set_zlim([0, 1000])
    
    ax.set_xticks([0, 20, 40, 60, 80, 100])
    ax.set_yticks([0, 20, 40, 60, 80, 100])
    ax.set_zticks([0, 250, 500, 750, 1000])
    
    ax.view_init(azim = 223, elev = 42)
#end


#--------------------------------------------------------------------------
#  Use our model to predict the area of the heart
#--------------------------------------------------------------------------
def calculate_area_model(r, a):
    # Return the area of the heart
    return np.pi * r**2 + 0.501 * r * a + 3*np.pi/512 * a**2
#end


#--------------------------------------------------------------------------
#  Perform a Monte Carlo simulation to find the area of the heart
#--------------------------------------------------------------------------
def calculate_area(r, a, N):
    # Set the size of the box
    L = max(1.5*r, 0.25*a)
    
    # Generate N points in the box
    x = (2*L) * np.random.rand(1, int(N)) - L
    y = (2*L) * np.random.rand(1, int(N)) - L
    
    # Check if a point is inside the heart
    criterion = ((x**2 + y**2 - r**2)**3 - a * x**2 * y**3 <= 0)
    
    # Count how many points are inside the heart
    numWins = np.sum(criterion)
    
    # Return the area of the heart
    return (2*L)**2 * (numWins / N)
#end