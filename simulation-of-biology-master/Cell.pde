class Cell{
  
  //used for DLA and DBM
  int x;
  int y;
  int state; //0 for empty, 1 for filled, 2 for candidate (hot)
  
  //used only for DBM
  float phi;
  float phi_eta;
  float p;
  float partial_sum;
  
  
  Cell(int tempx, int tempy, int tempstate,float tempphi, float tempphi_eta,float tempp, float temppartial_sum){
    x=tempx;
    y=tempy;
    state=tempstate;
    phi=tempphi;
    phi_eta=tempphi_eta;
    p=tempp;
    partial_sum=temppartial_sum;
  }
  
  //method for cell to display itself
  void show(int cellSize){
    stroke(0);
    if(state==1){
      fill(255);}
    else if(state==2){ //to show hot cells for debugging
      //float r=phi_eta*255;
      float r=0;
      float b=0;
      fill(r,0,b);//show hot cells for debugging
    }
    else{
      fill(0);
    }
    rect(x*cellSize,y*cellSize,cellSize,cellSize);
  }
}