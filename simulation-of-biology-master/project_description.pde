/*

Here are some characteristics of your simulator:

Create a 2D grid that is at least 100 by 100 cells in size.  (You may want to debug at lower resolution, however.)
Draw each cell as a uniformly colored square that is at least 4 by 4 pixels in size.  The gray-scale color should reflect chemical concentration.
You are free to choose what kinds of boundaries you use (toroidal, zero derivative, fixed value, etc.).
Your simulator should act on this group of keyboard commands:

i,I - Initialize the system with a fixed rectangular region that has specific u and v concentrations (more on this below).
space bar - Start or stop the simulation (toggle between these).
u,U - At each timestep, draw values for u for each cell (default).
v,V - At each timestep, draw values for v.
d,D - Toggle between performing diffusion alone or reaction-diffusion (reaction-diffusion is default).
p,P - Toggle between constant parameters for each cell and spatially-varying parameters f and k (more on this below).
1 - Set parameters for spots (k = 0.0625, f = 0.035)
2 - Set parameters for stripes (k = 0.06, f = 0.035)
3 - Set parameters for spiral waves (k = 0.0475, f = 0.0118)
4 - Parameter settings of your choice, but should create some kind of pattern.  Use your spatially-varying parameters image to find good values for k and f.

(mouse click) - Print values for u and v at cell.  If in spatially-varying parameter mode, also print values for k and f at the cell.

Initialization:  The Gray-Scott reaction-diffusion system is quite sensitive to its initial conditions.  If you begin with entirely random cell values, it is not likely to generate interesting patterns. 
To initialize your grid of cells, first set each cell to have values u = 1, v = 0.  Then, within a 10 by 10 block of pixels, set the cell values to be u = 0.5, v = 0.25. 
If you like, you can add small random values to u and v within the cells of the block.  You should feel free to create more than one such block if you want to break up the symmetry of the patterns that will form.
Initially, your simulator should begin in this initial state, and this is also the state that your simulator should re-initialize to when you type the command "i".

Diffusion values:  Fix the diffusion rate constants for u and v to ru = 0.082 and rv = 0.041.

Drawing the grid: At any given time, your simulator should be displaying the values of either chemical u or v.  Each cell should have some gray-scale intensity based on the chemical concentration.
In order for you to see the full range of values, find the minimum and maximum values for concentration at the current timestep.  
Then scale the intensity so that the lowest value is displayed as black and the highest value is white.  Since drawing the grid takes time, you may wish to modify your simulator to display the grid just once every 10 timesteps.
Spatially-varying parameters:  In order to see the range of patterns that the Gray-Scott system, 

      the keyboard command "p" should cause your simulator to vary the parameters k and f across different portions of the grid.
      The parameter k should vary across the x direction (horizontally), and should take on values between 0.03 and 0.07.  That is, cells at the left edge will have k = 0.03, cells at the right edge will have k = 0.07, 
      and in-between cells will linearly vary in k between these two extremes.  The parameter f should vary in the vertical (y) direction from f = 0.0 at the bottom to f = 0.08 at the top.  
      When you switch to this spatially-varying mode, you will find that small grids do not show off these variations well.  

Change to a higher resolution grid and let your simulator run in this mode for a fairly long time in order to get a good picture of the parameter space.
When you have a good picture of the parameter space, pause your simulator and take a snapshot of the current state of the simulator.  
You will turn this in along with your source code.