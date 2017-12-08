int gridSize = 10;
automaton[][] cells; // declare a 2D array of automaton objects
int num_cells = 60; // going to have a 60 x 60 grid
int[][] next_gen; // array to hold buffer values (to be filled in next time step)

/* 

---------------------INITIAL SETUP----------------------------------

*/

void setup() {  // runs once at the beginning. Just builds the screen.
  size(600,600); //makes the screen
  background(0); //makes the background black
  cells = new automaton[num_cells][num_cells]; //initializes the array cells
  for (int y = 0; y < num_cells; y++) {
    for (int x = 0; x < num_cells; x++) {
      stroke(255); // grab a white pen for drawing outlines
      fill(0); // grab a black paint bucket for filling shapes
      rect(x*gridSize,y*gridSize,gridSize,gridSize); //make a square (with white outline black fill) at (x,y) sidelength==gridSize
      cells[x][y]=new automaton(x,y,0); //initialize an automaton at (x,y) to the state false
    }
  }
}

void mousePressed(){//occurs if the mouse is pressed. Use the mouse at the beginning to set up initial conditions.
  int x=(int)mouseX/gridSize; //round the mouse position to the nearest integer...
  int y=(int)mouseY/gridSize; // and then divide by gridSize to find the position in cells array that this square on the screen corresponds to
  cells[x][y].set_state(1); //so if i've clicked a square set its state to true
}

/*

------------- Game of life --------------

*/

void draw() {//loops continuously through the grid and has each automaton display itself.
  for (int y=0;y<num_cells; y++){
    for (int x=0; x<num_cells; x++){
      cells[x][y].show(gridSize);//have the automaton at (x,y) display itself [either a black square or a white square depends on state]
    }
  }
}

void keyPressed(){ // updates the board according to the current state and the rules of game of life
  int tick=0;
  while(tick<31){ //update three times for every time a key is pressed
    tick++;
    int num_nbh; //an integer to keep track of number of neighbors
    next_gen=new int[num_cells][num_cells]; //initialize the buffer array
    for (int y=0; y<60; y++){
      for(int x=0; x<60; x++){
        
        //get the number of "on" neighbors
        num_nbh=cells[pb(x-1)][pb(y)].state+cells[pb(x+1)][pb(y)].state+cells[pb(x-1)][pb(y-1)].state
        +cells[pb(x)][pb(y-1)].state+cells[pb(x+1)][pb(y-1)].state+cells[pb(x-1)][pb(y+1)].state+cells[pb(x)][pb(y+1)].state
        +cells[pb(x+1)][pb(y+1)].state;
        
        //obey conway's rules. Load the future state of this site into the buffer array.
        if (cells[x][y].state>=3-num_nbh && num_nbh<4){
          next_gen[x][y]=1;
        }
        else{
          next_gen[x][y]=0;
        } 
      }
    }
    
    // now load the values from the buffer array into the cells array
    for(int y=0; y<60; y++){
      for(int x=0; x<60; x++){
        if(next_gen[x][y]==1){
          cells[x][y].set_state(1);
        }
        else{
          cells[x][y].set_state(0);
        }
      }
     }
  }
 }