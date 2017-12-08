class Voxel{
  
  int state;
  PVector position;
  float age; //this allows the vines to thicken over time.
  int flowered; //keeps track of whether a vine "joint" has flowered
  PVector rotation; //rotation of the flower
  boolean leaf;
  int[] leaf_vals;
  
  //STATE DESCRIPTION
  //999 ==occupied by a vine
  // <0 == occupied by a structure (pillar)
  // 0<state<size== boundary layer (0 is closest to structure). Vines can grow here. At state>cut_off vines are prohibited. I stick with a cut_off of 6
  
  Voxel(int state, PVector position){
    this.state=state;
    this.position=position;
    this.age=.1;
    this.rotation=new PVector(random(PI),random(PI),random(PI));
    this.flowered=0;
    leaf_vals=new int[4];
    leaf_vals[0]=0;
    leaf_vals[1]=120;
    leaf_vals[2]=0;
    leaf_vals[3]=150;
    if(random(1)>.5){
      this.leaf=true;
    }
    else{
      this.leaf=false;
    }
  }
  
  void show(){
    
    //stroke(20);
    noStroke();
    
    if(state==999&&leaf==true){ //filled by vine joint
    
     fill(20,100,5,200);
     pushMatrix();
     translate(position.x,position.y,position.z);
     rotateZ(rotation.z);
     rotateX(rotation.x);
     rotateY(rotation.y);
     
     //sphere(age);
     flower(new PVector(0,0,0),leaf_vals,age/5);
     popMatrix();
     
     if(age<=5.12){//thicken up to maximal value
     age=age+.01;
     }
     
     if(age>5){ //mature joints may flower with a probability based on lighting conditions (not ray tracing)
       if(Math.pow((500-position.x)/100,3)*random(1)>flowering_prob){
         flowered=1;
       }
     }
     
       if(flowered==1){ //then render the flower
         pushMatrix();
         translate(position.x,position.y,position.z);
         rotateZ(rotation.z);
         rotateY(rotation.y);
         rotateX(rotation.x);
         int[] fill_vals=new int[4];
         fill_vals[0]=100;
         fill_vals[1]=20;
         fill_vals[2]=40;
         fill_vals[3]=255;
         flower(new PVector(-15,0,0),fill_vals,2);
         popMatrix();
       }
       
     }

  }
}