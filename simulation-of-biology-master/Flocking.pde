Fish test_fish;
float dt= 0.045;
School test_school=new School();
double max_v=120;
int p=0; //for leaving a path or not
int a=1;
int running=1;
int fc=1;
int ca=1;
int vm=1;
int w=1;
int t=0;

void setup(){
    size(1000,1000);
    background(30,30,100);
    PVector rr=new PVector(width*random(1),height*random(1));
    PVector vr=new PVector(10*width*random(1),10*height*random(1));
    test_fish=new Fish(rr,vr,5);
    //System.out.println(true_dist(0,0,999,999));
    //test_school.addFish(test_fish);
    for(int i=0;i<16;i++){
      //PVector rr=new PVector(width*random(1),height*random(1));
      //PVector vr=new PVector(10*width*random(1),10*height*random(1));
      test_school.addFish(new Fish(new PVector(width*random(1),height*random(1)),new PVector(.10*width*random(-2,1),.10*height*random(-2,1)),5));
    } 
}

void randomize(ArrayList<Fish> fishes){
  for(Fish f: fishes){
    f.r=new PVector(width*random(1),height*random(1));
  }
}

void draw() {
  t++;
  /*
a,A - Switch to attraction mode (for when mouse is held down).
r,R - Switch to repulsion mode (for when mouse is held down).
s,S - Cause all creatures to be instantly scattered to random positions in the window.
p,P - Toggle whether to have creatures leave a path, that is, whether the window is cleared each display step or not.
c,C - Clear the window (useful when creatures are leaving paths).
1 - Toggle the flock centering forces on/off.
2 - Toggle the velocity matching forces on/off.
3 - Toggle the collision avoidance forces on/off.
4 - Toggle the wandering force on/off.
=,+ - Add one new creature to the simulation. You should allow up to 100 creatures to be created.
- (minus sign) - Remove one new creature from the simulation (unless there are none already).
space bar - Start or stop the simulation (toggle between these).
  */
  
  if(running==1){
    if(p==0){
      background(30,30,100);
    }
    test_school.run();
  }
  display_text(fc,ca,vm,w);
}

void display_text(int fc, int ca, int vm, int w){
  textSize(18);
  fill(255);
  text("||   Flock Centering: "+yn(fc)+"||   Collision Avoidance: "+yn(ca)+"||   Velocity Matching: "+yn(vm)+"||   Wander: "+yn(w),10,30);
}

String yn(int z){
  if(z==1){
    return("ON       ");
  }
  else{
    return("OFF      ");
  }
}

void keyPressed(){
  if(key=='p'||key=='P'){
    p=1-p;
  }
  if(key=='='||key=='+'){
    test_school.addFish(new Fish(new PVector(width*random(1),height*random(1)),new PVector(.10*width*random(-2,1),.10*height*random(-2,1)),5));
  }
  if(key=='a'||key=='A'){
    a=1;
  }
  if(key=='r'||key=='R'){
    a=0;
  }
  if(key=='s'||key=='S'){
    randomize(test_school.fishes);
  }
  if(key=='c'||key=='C'){
    background(0);
  }
  if(key=='-'){
    if(!(test_school.fishes.size()<2)){
      test_school.fishes.remove(0);
    }
  }
  if(key==32){
    running=1-running;
  }
  if(key=='1'){
    fc=1-fc;
  }
  if(key=='2'){
    ca=1-ca;
  }
  if(key=='3'){
    vm=1-vm;
  }
  if(key=='4'){
    w=1-w;
  }
}

PVector flock_centering(Fish fish, ArrayList<Fish> fishes,float cut_off){
  PVector c=new PVector(0,0);
  int count=0;
  PVector r;
  for(Fish f: fishes){
    r=t_r(fish.r.x,fish.r.y,f.r.x,f.r.y);
    //r=dist(fish.r.x,fish.r.y,f.r.x,f.r.y);
    if(r.mag()<cut_off){
      c.add(r.x,r.y);
      count++;
    }
  }
  c.div(count);
  return c;
}

PVector velocity_matching(Fish fish, ArrayList<Fish> fishes,float cut_off){
  PVector v=new PVector(0,0);
  int count=0;
  PVector r;
  //PVector r_sep;
  //float r_sep_mag;
  for(Fish f: fishes){
    //r_sep=t_r(fish.r.x,fish.r.y,f.r.x,f.r.y);
    //r_sep_mag=r_sep.mag();
    r=t_r(fish.r.x,fish.r.y,f.r.x,f.r.y);
    //r=dist(fish.r.x,fish.r.y,f.r.x,f.r.y);
    if(r.mag()<cut_off){
      v.x=v.x+(f.v.x);///r_sep_mag);
      v.y=v.y+(f.v.y);///r_sep_mag);
      count=count+1;
    }
  }
  v.div(count);
  PVector vavg=new PVector(0,0);
  vavg.x=v.x-fish.v.x;
  vavg.y=v.y-fish.v.y;
  return vavg;
}
  

/*

Useful for floating point toroidal boundary conditions.

if e.g. x==538.68 and size==500, then this returns 38.68

*/
float pb(int size,float x){ 
  int intpart=(floor(x)+size)%size;
  float floatpart=x-(int)x;
  return floatpart+intpart;
}

/*
PVector t_r(float x1,float y1,float x2, float y2){
  PVector r=new PVector(x2-x1,y2-y1);
  PVector r_hat=r.normalize();
  if(height<2*Math.abs(r.y)){
    r.y=-(height-Math.abs(r.y))*r_hat.y;
  }
  if(width<2*Math.abs(r.x)){
    r.x=-(width-Math.abs(r.x))*r_hat.x;
  }
  return r;
}
   */ 
   
PVector t_r(float x1,float y1,float x2,float y2){
    float xmag=1000; float ymag=1000;
    float x; float y;
    for(int i=-1;i<=1;i++){
        x=x2+(i*1000)-x1;
        y=y2+(i*1000)-y1;
        if(abs(x)<abs(xmag)){
            xmag=x;
        }
        if(abs(y)<abs(ymag)){
            ymag=y;
        }
    }
    return(new PVector(xmag,ymag));
}
    
//f_net=aggregate_force(f_fc,f_ca,f_vm,weights);
PVector aggregate_force(PVector f_fc, PVector f_ca, PVector f_vm, PVector f_w, float wfc,float wca, float wvm, float ww){
  PVector f_net=new PVector(0,0);
  if(fc==1){
    f_net.add(f_fc.mult(wfc));
  }
  if(ca==1){
    f_net.add(f_ca.mult(wca));
  }
  if(vm==1){
    f_net.add(f_vm.mult(wvm));
  }
  if(w==1){
    f_net.add(f_w.mult(ww));
  }
  return f_net;
}

void wander(Fish fish, ArrayList<Fish> fishes){
  if(t%5==0&&random(1)>.5){
    fish.v.add(PVector.random2D().mult(10));
    PVector A=(t_r(fish.r.x,fish.r.y,width/2,height/2));
    float Amag=A.mag();
    A.normalize();
    fish.v.add(A.mult(200/(10+Amag)));
  }
  if(random(1)>.25){
    PVector groupRand=PVector.random2D().mult(.5);
    for(Fish f:fishes){
      f.v.add(groupRand);
    }
  }
}
  