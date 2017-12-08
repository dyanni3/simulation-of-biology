/*urxn updates u via the gray scott equation. This is only the "reaction" part of the reaction-diffusion

 du/dt = (Du * del2u)  <------is diffusion equation, del2u=laplacian of u
 
 du/dt = (Du * del2u) - u(v^2) + f(1-u) <-------- gray scott eqn for u
 dv/dt = (Dv *del2v) + u(v^2) -(f+k)v <---------- gray scott eqn for v

urxn calculates -u(v^2) + f(1-u)
vrxn calculates u(v^2) -(f+k)v

 for diffusion operator part see ADI.....

*/

double[][] urxn(double[][]u,double[][]v,double Du,double Dv,double[] k,double f[],double dt,int w,int h){
  double[][] uprime=new double[h][w];
  for(int j=0;j<h;j++){
    for(int i=0;i<w;i++){
      uprime[j][i]=u[j][i]+dt*(f[j]*(1-u[j][i])-(u[j][i]*v[j][i]*v[j][i]));
      if(uprime[j][i]<minu){
        minu=uprime[j][i];
      }
      if(uprime[j][i]>maxu){
        maxu=uprime[j][i];
      }
    }
  }
  return uprime;
}

double[][] vrxn(double[][]u,double[][]v,double Du,double Dv,double k[],double f[],double dt,int w,int h){
  double[][] vprime=new double[h][w];
  for(int j=0;j<h;j++){
    for(int i=0;i<w;i++){
      vprime[j][i]=v[j][i]+dt*((-(f[j]+k[i])*v[j][i])+(u[j][i]*v[j][i]*v[j][i]));
      if(vprime[j][i]<minv){
        minv=vprime[j][i];
      }
      if(vprime[j][i]>maxv){
        maxv=vprime[j][i];
      }
    }
  }
  return vprime;
}