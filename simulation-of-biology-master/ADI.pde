/* ----------------ADI ------------------

Alternating Direction Implicit method to numerically approximate 2D laplacian (or in this case 2D heat equation)

See e.g. https://en.wikipedia.org/wiki/Alternating_direction_implicit_method

another good resource here: http://georg.io/2013/12/Alternating_Direction_Implicit_Method/

*/


//-----Forward Euler laplacian in one dimension----

double[] FELaplace(double[] u, int len){
    double[] v=new double[len];
    
    //Neumann b.c. (derivatives zero at boundary)
    v[0]=-u[0]+u[1];
    
    
    for(int i=1; i<len-1;i++){
      //computational stencil is [-1,2,-1]
        v[i]=-2*u[i]+u[i-1]+u[i+1];
    }
    
    //Neumann b.c. (derivatives zero at boundary)
    v[len-1]=-u[len-1]+u[len-2];
    return(v);
}


//----Forward Euler diffusion (heat equation) in 1D ------
double[] FEHeqn( double[] u, double D, double time, double dt, int len){
  
  //calculate laplacian using forward euler
  double[] del2u=new double[len]; 
  del2u=FELaplace(u,len);
  
  //heat eqtn: du/dt =  D* del2u ---> u = u+du = u+dt*D*del2u
    for(int t=0;t<(int)(time/dt);t++){
      for(int i=0;i<len;i++){
        u[i]=u[i]+dt*D*del2u[i];
      }
    }
    return(u);
}

//Backward Euler diffusion in 1D
//uses "Tridiagonal Matrix Algorithm" to solve system. see "thomas algorithm"
double[] BEHeqn(double[] u,double D,double time,double dt, int len){
    for(int t=0; t<(int)(time/dt);t++){
        double alpha=(D*dt);
        double[] d=new double[len];
        double[] c=new double[len];
        c[0]=-alpha/(1+alpha);
        d[0]=u[0]/(1+alpha);
        for(int i=1;i<len-1;i++){
            c[i]=-alpha/(1+(2+c[i-1])*alpha);
            d[i]=(u[i]+alpha*d[i-1])/(1+(2+c[i-1])*alpha);
        }
        d[len-1]=(u[len-1]+alpha*d[len-2])/(1+((1+c[len-2])*alpha));
        u[len-1]=d[len-1];
        for(int i=len-2;i>=0;i--){
            u[i]=d[i]-c[i]*u[i+1];
        }
    }
    return u;
    }
 
//Alternating direct/implicit method to numerically approximate 2D heat equation.    
double[][] ADI(double[][] u,double time,double Dx,double Dy,double dt,int h,int w){
    
  for(int t=0;t<(time/dt);t++){
      
        //  --------1/4--------Run Forward-Euler on each column
        for(int j=0;j<w;j++){
          
          //make a new array to hold u[:,j] values
          double[] v= new double[h];
          for(int y=0;y<h;y++){
            v[y]=u[y][j];
          }
          
          //run forward euler on v
          v=BEHeqn(v,Dy,dt,dt,h);
          
          //update u[:,j] with FE(v)
          for(int y=0;y<h;y++){
            u[y][j]=v[y];
          }
        }
          
        // ------2/4-------- Run Backward-Euler on each row
        for(int i=0;i<h;i++){
          
           //make a new array to hold u[:,j] values
          double[] v= new double[w];
          for(int x=0;x<w;x++){
            v[x]=u[i][x];
          }
          
          //run backward euler on v
          v=BEHeqn(v,Dx,dt, dt, w);
          
          //update u[i,:] with BE(v)
          for(int x=0;x<w;x++){
            u[i][x]=v[x];
          }
        }
        
        // TIME STEP 1/2 COMPLETED
        
        //-----------3/4----------Run forward euler on each row
        for(int i=0;i<h;i++){
          
           //make a new array to hold u[:,j] values
          double[] v= new double[w];
          for(int x=0;x<w;x++){
            v[x]=u[i][x];
          }
          
          //run forward euler on v
          v=BEHeqn(v,Dx,dt, dt, w);
          
          //update u[i,:] with BE(v)
          for(int x=0;x<w;x++){
            u[i][x]=v[x];
          }
        }
        
        //-------4/4------- Run Backward-Euler on each column
        for(int j=0;j<w;j++){
          
          //make a new array to hold u[:,j] values
          double[] v= new double[h];
          for(int y=0;y<h;y++){
            v[y]=u[y][j];
          }
          
          //run backward euler on v
          v=BEHeqn(v,Dy,dt,dt,h);
          
          //update u[:,j] with FE(v)
          for(int y=0;y<h;y++){
            u[y][j]=v[y];
          }
        }
    }
    return(u);
}