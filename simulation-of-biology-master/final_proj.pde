//tuneable parameters
int size=200; //the voxel grid contains size^3 voxels
float voxel_size=5; //size of each voxel
int step_size=1; //size of step taken by random walking vine tip
PVector column_center=new PVector(500,0,500); //xz position of center of column
float column_radius=100;
float twist=-2.15; //vine twisting bias. The larger this is the more likely the vine is to crawl clockwise (viewed from above) around pillar. If this is negative then chirality is reversed.
float climb=.85;// vertical climbing bias. The larger this is the more likely the vine to crawl upward
float branching_thresh=.045; //the larger this is, the more probable branching events are
float flowering_prob=1.3;

//data structures
ArrayList<Voxel> nodes; //a list of actively growing vine tips
ArrayList<Float[]> lines=new ArrayList<Float[]>(); //a list of lines to render (to show the vine)
Grid grid; //the voxel grid

void setup(){
  
  size(1000,1000,P3D);
  //lights();
  directionalLight(250,250,250,1,-1,0); //white(ish) light coming in from left/top of screen
  background(0);
  sphereDetail(6);
  background(0);
  init();
  
}

void init(){
  
  //initialize data structures and add a seed node to start the vine
  nodes=new ArrayList<Voxel>();
  grid=new Grid(size, voxel_size);
  
  grid.voxels[100][120][120].state=999;
  nodes.add(grid.voxels[100][120][120]); 
         
}

void draw(){
  //refresh lights and background
  background(0);
  directionalLight(250,250,250,1,-1,0);
  //lights();
  
  //show all the voxels (including vine "joints")
  grid.show();
  
  //show the cylinder
  fill(120,80,25,200);
  stroke(25);
  cylinder(95,95,1000,500);
  
  //show the lines (vine segments)
  draw_lines();
  
  //grow the vine
  update_nodes();  
}


int[] random_walk(int[] start){
  
  //pick theta and phi
  float theta=random((float)Math.PI);
  float phi=random((float)(2*Math.PI));
  
  //calculate unit step
  PVector s= new PVector((float)(Math.sin(theta)*Math.cos(phi)),(float)(Math.sin(theta)*Math.sin(phi)),(float)(Math.cos(theta)));
  
  //incorporate twist and climb bias
  
  //twist
  PVector r_hat=new PVector((start[0]*voxel_size)-column_center.x,0,(start[2]*voxel_size)-column_center.z);
  r_hat.div(r_hat.mag());
  PVector t=new PVector(0,-1,0);
  t.div(t.mag());
  t=t.cross(r_hat,t);
  t.mult(twist);
  
  //climb
  PVector c=new PVector(0,-1,0);
  c.mult(climb);
  
  //add them
  s.add(t);
  s.add(c);
  s.div(s.mag());
  
  //add to start and determine grid cell that step landed in.
  s.add(new PVector(start[0]+.5,start[1]+.5,start[2]+.5));
  int[] end=new int[3];
  end[0]=(int)s.x;
  end[1]=(int)s.y;
  end[2]=(int)s.z;
  
  return end;
}

void update_nodes(){
  
  ArrayList<Voxel> toRemove=new ArrayList<Voxel>();
  ArrayList<Voxel> toAdd=new ArrayList<Voxel>();
  int nodes_length=nodes.size();
  
  for(Voxel v:nodes){
    
    //get the current grid coordinates in voxel space
    int[] grid_coords=new int[3];
    grid_coords[0]=(int)(v.position.x/voxel_size);
    grid_coords[1]=(int)(v.position.y/voxel_size);
    grid_coords[2]=(int)(v.position.z/voxel_size);
    
    //random walk with bias and constraints, get the new grid coordinates and displacement vector
    int[] new_coords=random_walk(grid_coords);
    int[] disp=new int[3];
    disp[0]=new_coords[0]-grid_coords[0];
    disp[1]=new_coords[1]-grid_coords[1];
    disp[2]=new_coords[2]-grid_coords[2];
    
    //if new coordinates along displacement line are allowed, set voxel state for voxels along path to 999 (occupied) and add a line
    if(grid.voxels[pb(new_coords[0])][pb(new_coords[1])][pb(new_coords[2])].state>=0&&grid.voxels[pb(new_coords[0])][pb(new_coords[1])][pb(new_coords[2])].state<6&&grid.voxels[pb(new_coords[0])][pb(new_coords[1])][pb(new_coords[2])].state!=999){
      for(int i=1;i<=step_size;i++){
      grid.voxels[pb(grid_coords[0]+i*disp[0])][pb(grid_coords[1]+i*disp[1])][pb(grid_coords[2]+i*disp[2])].state=999;
      }
      
      // add line
      Float[] this_line=new Float[6];
      this_line[0]=v.position.x;
      this_line[1]=v.position.y;
      this_line[2]=v.position.z;
      this_line[3]=(grid_coords[0]+step_size*disp[0])*voxel_size;
      this_line[4]=(grid_coords[1]+step_size*disp[1])*voxel_size;
      this_line[5]=(grid_coords[2]+step_size*disp[2])*voxel_size;
      lines.add(this_line);
      
      //add the new position to the actively growing tips list, and remove the old one
      toAdd.add(grid.voxels[pb(grid_coords[0]+step_size*disp[0])][pb(grid_coords[1]+step_size*disp[1])][pb(grid_coords[2]+step_size*disp[2])]);
      toRemove.add(v);
      
    }
    
    //if the coordinates along the displacement line are not allowed, then remove this node from the growing tip (as long as there are at least a few nodes growing)
    else if(nodes_length>7){
      toRemove.add(v);
    }
  }
  
  // remove the nodes that were marked for removal. However, with some probability set by branching_thresh DON'T remove a node. This, in effect, leads to branching.
  for(Voxel v: toRemove){
    if(random(1)>branching_thresh){
    nodes.remove(v);
    }
  }
  
  //add the nodes that were marked to be added
  for(Voxel v: toAdd){
    nodes.add(v);
  }
  
}

//toroidal wrapping just in case
int pb(int x){ 
  return((x+size)%size);
}

//function to draw the lines of the vine
void draw_lines(){
  for(Float[] line: lines){
      stroke(10,50,2.5);
      strokeWeight(4);
      fill(0,255,0);
      line(line[0],line[1],line[2],line[3],line[4],line[5]);
      strokeWeight(1);
  }
}
    
  