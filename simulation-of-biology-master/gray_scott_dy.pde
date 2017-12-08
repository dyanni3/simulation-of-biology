// set up the u and v fields

//(w=250 and h=250 is a good balance between speed and resolution)
int w=750;
int h=750;
double[][] u= new double[h][w];
double[][] v= new double[h][w];
double[][] to_screen_u=new double[h][w];
double[][] to_screen_v=new double[h][w];

//set up i/o variables 
int running=1; //set default to time evolution "on" (running==0 means paused)
int drawU=1; //set default to render the values of the u field
int drawV=0; //when set to 1 the draw() function renders the v field (u is transparent)
int drawBoth=0; // when set to 1 draws u in blue and v in red.
int diffusion_only=0; //when set to 1 only diffusion term
int const_params=1;
String settingString="Parameters: Default (k=.05, f=.02)";
String valuesString="u(x,y) = ..., v(x,y) = ...";

// k and f for the spatially varying parameters sim
double[] kl = new double[w];//k list for varying parameters
double [] fl = new double[h];// f list for varying parameters
//k and f for const parameters sim
double[] k = new double[w];
double [] f = new double[h];

// diffusion constants, value for dt. (made as large as possible while stable and accurate)
double Du=0.082;
double Dv=0.041;
double dx=(1/100.);
double dt=(1/Du)*900*.9*(dx*dx)/(2*Du);

//keep track of min and max values for u and v and some others for image enhancement
double minu;
double maxu;
double minv;
double maxv;
double value;
double scale;
double new_min;
double mean;

//initial conditions for u, v.
void initialize(){
  minv=0;
  maxv=.25;
  minu=.5;
  maxu=1;
  for(int i=0;i<w;i++){
    for(int j=0;j<h;j++){
        u[j][i]=1;
        v[j][i]=0;
        if(i>45&&i<55&&j>45&&j<55){
          u[j][i]=.5;
          v[j][i]=.25;
        }
        if(i>80&&i<90&&j>80&&j<90){
          u[j][i]=.5;
          v[j][i]=.25;
        }
      }
    }
}
  
void setup(){
  size(750,800);
  
  // k and f default values for const params (parameters in reaction part of gray-scott)
  if(const_params==1){
    for(int x=0;x<w;x++){
      k[x]=.05;
    }
    for(int y=0; y<h;y++){
      f[y]=.02;
    }
  }
  
  //k and f default values for varying params
  for(int x=0;x<w;x++){
    kl[x]=((0.04/w)*x)+.03;
  }
  for(int y=0; y<h;y++){
    fl[y]=0.08-((0.08/h)*y);
  }

// initialize the u and v fields
  initialize();
  }
  
// update fields and render fields according to i/o options
void draw(){
  
  //---------UPDATE FIELDS------------ (if time evolution is "on")
  if(running==1){
    
    if(diffusion_only==0){//update by diffusion-reaction rules 
    
    //set the appropriate settings string for printing to screen
    if(k[0]==.062){
      settingString="Parameters: Spots";
    }
    if(k[0]==.06){
      settingString="Parameters: Stripes";
    }
    if(k[0]==.0475){
      settingString="Parameters: Spiral Waves";
    }
    if(k[0]==.052){
      settingString="Parameters: Puffs (smoky unstable spots, k=0.052, f=0.012)";
    }
    if(const_params==0){
      settingString="Parameters: varying";
    }
    
    //the actual diffusion
      u=ADI(u,dt,Du,Du,dt,w,h);
      v=ADI(v,dt,Dv,Dv,dt,w,h);
      
      //if parameters constant then reaction operator with const k and f
      if(const_params==1){
      for(int t=0;t<80;t++){
        u=urxn(u,v,Du,Dv,k,f,dt/80,w,h);
        v=vrxn(u,v,Du,Dv,k,f,dt/80,w,h);
      }
      }
      
      // if parameters vary spatially then reaction operator with variable k and f
      else if(const_params==0){
      for(int t=0;t<80;t++){
        u=urxn(u,v,Du,Dv,kl,fl,dt/80,w,h);
        v=vrxn(u,v,Du,Dv,kl,fl,dt/80,w,h);
      }
      }
      
    }
    else if(diffusion_only==1){//update by diffusion-only rules 
    settingString="Diffusion only";
      u=ADI(u,dt/10,Du,Du,dt/10,w,h);
      v=ADI(v,dt/10,Dv,Dv,dt/10,w,h);
    }
  }
  
  //------------RENDER FIELDS---------------
  background(10,20,0);
  for(int i=0;i<w;i++){
    for(int j=0;j<h;j++){
      
      if(drawU==1){
        
        //enhance
        value=u[j][i];
        mean=(maxu+minu)/2;
        scale=(1/(maxu-minu));
        new_min=(minu-mean)*scale;
        value=(value-mean);
        value=value*scale;
        value=value+new_min+1;
        
        //fill
        fill((int)(255*value));
        }
        
      else if(drawV==1){
        
        //enhance
        value=v[j][i];
        mean=(maxv+minv)/2;
        scale=(1/(maxv-minv));
        new_min=(minv-mean)*scale;
        value=(value-mean);
        value=value*scale;
        value=value+new_min+1;
        
        //fill
        fill((int)(255*value));   
      }
      
      else if(drawBoth==1){
        fill(30,(int)(255*v[j][i]),(int)(255*v[j][i]));
      }
      
      else{
        fill(0);
      }
      
      noStroke();
      pushMatrix();
      translate((int)(width*i)/w,50+(int)((height-50)*j)/h);
      rect(0,0,(width)/w,(height-50)/h);
      popMatrix();
  }
  
  //print parameter settings and u,v,k,f values to screen according to i/o options
  textSize(12);
  fill(200,150,30);
  if(const_params==1){
  text(settingString,.020*width,30);
  text(valuesString, .70*width,30);
  }
  else if(const_params==0){
    settingString="Parameter Sweep";
    text(settingString,.010*width,30);
    text(valuesString,.30*width,30);
  }
}
}

void keyPressed(){
  /*
  i,I - Initialize the system with a fixed rectangular region that has specific u and v concentrations (more on this below).
  space bar - Start or stop the simulation (toggle between these).
  u,U - At each timestep, draw values for u for each cell (default).
  v,V - At each timestep, draw values for v.
  b.B- At each timestep draw values for u in blue, v in red
  d,D - Toggle between performing diffusion alone or reaction-diffusion (reaction-diffusion is default).
  p,P - Toggle between constant parameters for each cell and spatially-varying parameters f and k (more on this below).
  1 - Set parameters for spots (k = 0.0625, f = 0.035)
  2 - Set parameters for stripes (k = 0.06, f = 0.035)
  3 - Set parameters for spiral waves (k = 0.0475, f = 0.0118)
  4 - Parameter settings of your choice, but should create some kind of pattern.  Use your spatially-varying parameters image to find good values for k and f.
  */
  if(key=='i'||key=='I'){//re-initialize the field
    initialize(); 
  }
  if(key==32){//toggle on/off the time evolution
    running=1-running; //
  }
  if(key=='u'||key=='U'){
    drawU=1;
    drawV=0;
    drawBoth=0;
  }
  if(key=='v'||key=='V'){
    drawV=1;
    drawU=0;
    drawBoth=0;
  }
    if(key=='b'||key=='B'){
    drawV=0;
    drawU=0;
    drawBoth=1;
  }
   if(key=='d'||key=='D'){//toggle on/off the diffusion_only option
    diffusion_only=1-diffusion_only; //
  }
  if(key=='p'||key=='P'){ // toggle between constant parameters (f and k) and spatially varying
    const_params=1-const_params;
  }
  if(key=='1'||key=='2'||key=='3'||key=='4'){
    const_params=1;
      if(key=='1'){ //spots
        //k=0.0625;
        //f=0.035;
        for(int x=0;x<w;x++){
          k[x]=.062;
        }
        for(int y=0; y<h;y++){
          f[y]=.033;
        }
        settingString="Parameters: Spots";
      }
      else if(key=='2'){//stripes
        //k=.06;
        //f=.035;
        for(int x=0;x<w;x++){
          k[x]=.06;
        }
        for(int y=0; y<h;y++){
          f[y]=.035;
        }
        settingString="Parameters: Stripes";
      }
      else if(key=='3'){//spiral waves
        //k=0.0475;
        //f=0.018;
        for(int x=0;x<w;x++){
          k[x]=.0475;
        }
        for(int y=0; y<h;y++){
          f[y]=.018;
        }
        settingString="Parameters: Spiral Waves";
      }
      else if(key=='4'){ //puffs (unstable smoky spots)
      
      for(int x=0;x<w;x++){
          k[x]=.052;
        }
        for(int y=0; y<h;y++){
          f[y]=.012;
        }
        settingString="Parameters: Puffs (smoky unstable spots, k=0.052, f=0.012)";
      } 
  }
  
}
  
void mousePressed(){
  // prints values of u,v of cell at mouse position.
  // if varying k and f parameters, also prints those values
  //background(0);
  textSize(28);
  int x=(int)((w*mouseX/width));
  int y=(int)( (mouseY-50)*(h)/(( height-50)));
  double uval=round(u[y][x],3);
  double vval=round(v[y][x],3);
  String string_uval=Double.toString(uval);
  String string_vval=Double.toString(vval);
  valuesString=" u(x,y) = "+string_uval+", v(x,y) = "+string_vval;
  if(const_params==0){
    double kval=round(kl[x],3);
    double fval=round(fl[y],3);
    String string_kval=Double.toString(kval);
    String string_fval=Double.toString(fval);
    valuesString="u(x,y) = "+string_uval+", v(x,y) = "+string_vval+", k(x) = "+string_kval+", f(y) = "+string_fval;
  }
}

// rounding function thanks stackOverflow user Jonik
double round(double value, int places) {
    long factor = (long) Math.pow(10, places);
    value = value * factor;
    long tmp = Math.round(value);
    return (double) tmp / factor;
}
  