
//Global variables...
Cell[][] cells;
int num_cells=200;
int cellSize=2;
float sticking_thresh=1; //default value
ArrayList<Cell> hot=new ArrayList<Cell>(); //list of CANDIDATE cells
ArrayList <Cell>filled=new ArrayList<Cell>();//list of OCCUPIED cells
Cell newest_charge; //useful for quickly referring to most recently added charge (for debugging and for update_phi)
float eta=3; //default used for debugging
boolean DLA=true; //if false the program will run DBM
int running=1; //if set to 0 everything pauses
boolean special_string=false; //used for the bullet hole seeding

//initial setup
void setup(){
  size(400,500);
  background(0);
  cells=new Cell[num_cells][num_cells];
  for (int y = 0; y < num_cells; y++) {
    for (int x = 0; x < num_cells; x++) {
      stroke(0); 
      fill(0); 
      rect(x*cellSize,y*cellSize,cellSize,cellSize); // every grid site on the board starts "off"
      if(x==99&&y==99){ //except for the center cell
        cells[x][y]= new Cell(x,y,1,0,0,0,0); //state =1 means occupied
        filled.add(cells[x][y]);
        newest_charge=cells[x][y];
      }
      else{
        cells[x][y]= new Cell(x,y,0,0,0,0,0);
      }
   }
 }
 //add the cells around the center cell to the hot list no need to calculate phi for them since the update_phi routine will take care of it
   for(int i=98;i<=100;i++){
     for(int j=98;j<=100;j++){
       if(!(i==99&&j==99)){
       cells[i][j].state=2;
       hot.add(cells[i][j]);
       }
      }
    }
}


//used for re-seeding the simulation mid-run same as initial setup routine but without specifying screen size etc.
void re_setup(){
  background(0);
  filled.clear();
  hot.clear();
  cells=new Cell[num_cells][num_cells];
  for (int y = 0; y < num_cells; y++) {
    for (int x = 0; x < num_cells; x++) {
      stroke(0); 
      fill(0); 
      rect(x*cellSize,y*cellSize,cellSize,cellSize); // every grid site on the board starts "off"
      if(x==99&&y==99){
        cells[x][y]= new Cell(x,y,1,0,0,0,0);
        filled.add(cells[x][y]);
        newest_charge=cells[x][y];
      }
      else{
        cells[x][y]= new Cell(x,y,0,0,0,0,0);
      }
   }
 }
   for(int i=98;i<=100;i++){
     for(int j=98;j<=100;j++){
       if(!(i==99&&j==99)){
       cells[i][j].state=2;
       hot.add(cells[i][j]);
       }
      }
    }
}

//setup for the "Bullet Hole" seeding
void special_setup(){
  filled.clear();
  hot.clear();
  cells=new Cell[num_cells][num_cells];
  for (int y = 0; y < num_cells; y++) {
    for (int x = 0; x < num_cells; x++) {
      stroke(0); 
      fill(0); 
      rect(x*cellSize,y*cellSize,cellSize,cellSize); 
      if(Math.pow(x-99,2)+Math.pow(y-99,2)<Math.pow(25,2)&&Math.pow(x-99,2)+Math.pow(y-99,2)>Math.pow(19,2)){
        cells[x][y]= new Cell(x,y,1,0,0,0,0);
        filled.add(cells[x][y]);
        newest_charge=cells[x][y];
      }
      else if(Math.pow(x-99,2)+Math.pow(y-99,2)<Math.pow(26,2)&&Math.pow(x-99,2)+Math.pow(y-99,2)>Math.pow(25,2)){
        cells[x][y]=new Cell(x,y,2,0,0,0,0);
      }
      else{
        cells[x][y]= new Cell(x,y,0,0,0,0,0);
      }
   }
 }
}

void draw(){
  if(special_string==true){
    textSize(32);
    fill(255);
    text("Bullet Hole",110,450);
  }
  if(running==1){
    if(DLA==true){
      random_walk();
    }
    else{
      update_phi(hot,newest_charge);
      select_site(hot,eta);
    }
     for (int y=0;y<num_cells; y++){
      for (int x=0; x<num_cells; x++){
        cells[x][y].show(cellSize);//have the automaton at (x,y) display itself [either a black square or a white square depends on state]
      }
    }
  }
}

void keyPressed(){
//space bar - Start or stop the pattern growth (toggle between these).
//s,S - Take one simulation step.
//1 - From a single seed, run DLA with a sticking factor of 1 (always sticks).
//2 - From a single seed, run DLA with a sticking factor of 0.1.
//3 - From a single seed, run DLA with a sticking factor of 0.01.
//4 - From a single seed, run DBM with eta = 0.
//5 - From a single seed, run DBM with eta = 3.
//6 - From a single seed, run DBM with eta = 6.
//0 - Run DLA with a seed pattern and a sticking factor of your own choosing. Do not just use one seed cell!
if(key==32){
  running=1-running;
}
if(key=='s'||key=='S'){
  if(running==0){
    if(DLA==true){
        random_walk();
      }
      else{
        update_phi(hot,newest_charge);
        select_site(hot,eta);
      }
       for (int y=0;y<num_cells; y++){
        for (int x=0; x<num_cells; x++){
          cells[x][y].show(cellSize);//have the automaton at (x,y) display itself [either a black square or a white square depends on state]
        }
      }
    }
  }
if(key=='1'){
  DLA=true;
  running=1;
  sticking_thresh=1;
  re_setup();
  special_string=false;
}
if(key=='2'){
  DLA=true;
  running=1;
  sticking_thresh=.1;
  re_setup();
  special_string=false;
}
if(key=='3'){
  DLA=true;
  running=1;
  sticking_thresh=.01;
  re_setup();
  special_string=false;
}
if(key=='4'){
  DLA=false;
  running=1;
  eta=0;
  re_setup();
  special_string=false;
}
if(key=='5'){
  DLA=false;
  running=1;
  eta=3;
  re_setup();
  special_string=false;
}
if(key=='6'){
  DLA=false;
  running=1;
  eta=6;
  re_setup();
  special_string=false;
}
if(key=='0'){
  DLA=true;
  running=1;
  sticking_thresh=.7;
  special_setup();
  special_string=true;
}
}

int pb(int z){
  return((z+num_cells)%num_cells);
}

int random_step(int x0){
  return(x0+int(random(3))-1);
}

void random_walk(){
  int x0=int(random(200));
  int y0=int(random(200));
  boolean stuck=false;
  while(stuck==false){
    x0=pb(random_step(x0));
    y0=pb(random_step(y0));
      if(cells[x0][y0].state==2){
        if(random(1)<sticking_thresh){
        cells[x0][y0].state=1;
        newest_charge=cells[x0][y0];
        filled.add(cells[x0][y0]);
        hot.remove(cells[x0][y0]);
        for(int i=x0-1;i<=x0+1;i++){
          for(int j=y0-1;j<=y0+1;j++){
            if(cells[pb(i)][pb(j)].state==0){
              cells[pb(i)][pb(j)].state=2;
              calculate_phi(filled,cells[pb(i)][pb(j)]);
              hot.add(cells[pb(i)][pb(j)]);
            }
          }
        }
        stuck=true;
        }
        //walker_on=0;
    }
  }
}

float d(Cell a, Cell b){
  return((float)Math.pow(Math.pow(2*b.y-2*a.y,2)+Math.pow(2*b.x-2*a.x,2),.5));
}

void calculate_phi(ArrayList<Cell> filled, Cell target){
  float phi_fresh=0;
  for(Cell c:filled){
    phi_fresh=phi_fresh+(1-(1./d(c,target)));
  }
  target.phi=phi_fresh;
}

void update_phi(ArrayList<Cell> hot, Cell new_charge){
  for(Cell h:hot){
    h.phi=h.phi+1-(1./d(h,new_charge));
  }
}

void select_site(ArrayList<Cell> hot, float eta){
  float phi_min=hot.get(1).phi;
  float phi_max=hot.get(0).phi;
  
  //find min and max phi values.
  for(Cell h:hot){
    if(h.phi<=phi_min){
      phi_min=h.phi;
    }
    else if(h.phi>=phi_max){
      phi_max=h.phi;
    }
  }
  
  //rescale all phi values to 0<=phi<=1. Also, find phi^eta for each and store those as phi_eta
  //and compute the sum of all phi_eta
  float sum_phi_eta=0;
  for(Cell h: hot){
    h.phi_eta=(h.phi-phi_min)/(phi_max-phi_min);
    h.phi_eta=(float)Math.pow(h.phi_eta,eta);
    sum_phi_eta=sum_phi_eta+h.phi_eta;
  }
  
  //loop through yet again to find p_i for each hot cell
  //Also calculate the sum of all p_i
  float sum_p=0;
  for(Cell h:hot){
    h.p=h.phi_eta/sum_phi_eta;
    sum_p=sum_p+h.p;
  }
  
  //loop through to find partial sum for each hot cell
  float total_yet=0;
  for(Cell h: hot){
    total_yet=total_yet+h.p;
    h.partial_sum=total_yet;
  }
  
  float R=random(sum_p);
  //loop through final time to select the site
  for(Cell h:hot){
    if(h.partial_sum>R){
      filled.add(h);
      hot.remove(h);
      newest_charge=h;
      cells[h.x][h.y].state=1;
      for(int i=h.x-1;i<=h.x+1;i++){
        for(int j=h.y-1;j<=h.y+1;j++){
          if(cells[pb(i)][pb(j)].state==0){
              cells[pb(i)][pb(j)].state=2;
              calculate_phi(filled,cells[pb(i)][pb(j)]);
              hot.add(cells[pb(i)][pb(j)]);
            }
          }
        }
      break;
    }
  }
}