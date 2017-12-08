/* 

This is the automaton class to creat automata. Now "automaton" will be a recognized type, like int or float.

So I can do stuff like: 

int x=5;
boolean bubbles;
automaton my_cell_one;
automaton my_cell_two = new automaton(3,3,0);

That last line of code will call the generator function and instantiate a new automaton at position (3,3) in state==off.

*/

class automaton{
  
  int x;
  int y;
  int state; // 0 (off) or 1 (on)
  
  //generator, is called when a new automaton is instantiated.
  automaton(int tempx, int tempy, int tempstate){
    x=tempx;
    y=tempy;
    state=tempstate;
  }
  
  //method to change state (e.g. on --> off)
  void set_state(int new_state){
    state=new_state;
  }
  
  //method for automaton to display itself
  void show(int gridSize){
    stroke(255);
    int w = state==1? 255:0;
    fill(w);
    rect(x*gridSize,y*gridSize,gridSize,gridSize);
  }
}