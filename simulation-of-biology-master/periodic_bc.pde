/* A simple function to ensure periodic boundary conditions...

Since the cells array is 60 x 60, we want behavior like:

cells[x+1]==cells[0] if x==59.
cells[x-1]==cells[59] if x==0.

we can get this type of behavior by calling 

cells[pb(x+1)]

since pb(x+1)==x+1 for 0<=x<59
pb(x+1)==0 for x==59
pb(x-1)=59 for x==0.

*/

int pb(int z){
  return (z+60)%60;
}