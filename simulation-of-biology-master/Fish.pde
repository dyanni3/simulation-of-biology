class Fish {
  PVector r;
  PVector v;
  double bearing;
  float fish_size;
  
  Fish(PVector tempr,PVector tempv, float tempsize){
    r=tempr;
    v=tempv;
    bearing=Math.atan(-v.y/v.x);
    if(v.x<0&&-v.y<0){
      bearing=bearing+Math.PI;
    }
    //bearing=tempbearing;
    fish_size=tempsize;
  }
  
  void show(){ //fish displays its beautiful self.
    fill(0,130, 130);
    noStroke();
    pushMatrix();
    translate(r.x-6*fish_size, r.y);
    rotate((float) -bearing);
    
    //tail...
    beginShape(TRIANGLES);
    vertex(3*fish_size, 0);
    vertex(0, -fish_size);
    vertex(0,fish_size);
    endShape();
    
    //body...
    ellipse(5*fish_size,0,6*fish_size,2*fish_size);
    
    //eye...
    fill(0);
    ellipse(6*fish_size,0,fish_size/2,fish_size/2);
    popMatrix();
  }
  
  void update(ArrayList<Fish> fishes){
    
    PVector f_net=new PVector(0,0);
    PVector f_fc=flock_centering(this, fishes,200);
    f_fc.normalize();
    PVector f_ca=flock_centering(this,fishes,30);
    f_ca.normalize();
    PVector f_vm=velocity_matching(this,fishes,100);
    f_vm.normalize();
    if(w==1){
      wander(this,fishes);
    }
    PVector f_w=new PVector(0.0,0.0);
    
    f_net=aggregate_force(f_fc, f_ca, f_vm, f_w, 5,-8, .7, 1).mult(10);
    //f_net.add(f_fc.mult(3));
    //f_net.sub(f_ca.mult(160.0));
    //f_net.add(f_vm.mult(2.3));
    
    //f_net.add(f_w.mult(15));
    
    if(mousePressed){
      if(a==1){
        PVector A=(t_r(r.x,r.y,mouseX,mouseY));
        float Amag=A.mag();
        A.normalize();
        f_net.add(A.mult(100000/(10+Amag)));
      }
      else{
        f_net.sub(t_r(r.x,r.y,mouseX,mouseY).mult(1));
      }
    }
    boolean skip=false;
    //v.x=v.x+f_net.x*dt;
    //v.y=v.y+f_net.y*dt;
    if(((10*random(1))%2)==0){
      skip=true;
    }
    else if(v.x<0){
      v.x=(float) Math.max(-max_v,v.x+f_net.x*dt);
    }
    else if(v.x>0){
      v.x=(float) Math.min(max_v,v.x+f_net.x*dt);
    }
    if(v.y<0&&!skip){
      v.y=(float) Math.max(-max_v,v.y+f_net.y*dt);
    }
    else if(v.y>0){
      v.y=(float) Math.min(max_v,v.y+f_net.y*dt);
    }
    
    
    r.x=pb(width,r.x+dt*v.x);
    r.y=pb(height,r.y+dt*v.y);
    
    bearing=Math.atan(-v.y/v.x);
    if(v.x<0&&v.y>0){
      bearing=bearing+Math.PI;
    }
    else if(v.x<0){
      bearing=bearing+Math.PI;
    } 
}

}