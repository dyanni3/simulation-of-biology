class mode{

  boolean state; // 0 (off) or 1 (on)
  
  //generator, is called when a new automaton is instantiated.
  mode(boolean tempstate){
    state=tempstate;
  }
  
  //method to change state (e.g. on --> off)
  void set_state(boolean new_state){
    state=new_state;
  }
  
  void toggle(){
    if(state){
      state=false;
    }
    else{
      state=true;
    }
  }
}