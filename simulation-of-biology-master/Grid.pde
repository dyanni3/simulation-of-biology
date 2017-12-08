//A data structure to contain all the voxels, label their distance from the pillar's center, and a rendering function (which just asks each voxel in the grid to render itself)
class Grid{
  
  int size;
  Voxel[][][] voxels;
  float voxel_size;
  
  Grid(int size,float voxel_size){
    voxels=new Voxel[size][size][size];
    this.voxel_size=voxel_size;
    this.size=size;
    
  //initialize the column
  for(int x=0;x<size;x++){
    for(int y=0; y<size; y++){
      for(int z=0; z<size; z++){
        
        PVector r=new PVector(x*voxel_size-column_center.x,0,z*voxel_size-column_center.z);
        voxels[x][y][z]=new Voxel((int)((r.mag()-column_radius)/voxel_size),new PVector(x*voxel_size,y*voxel_size,z*voxel_size));
        
        }
      }
    }
    
  }
  
  void show(){
    for(int x=0;x<size;x++){
      for(int y=0;y<size;y++){
        for(int z=0;z<size; z++){
          voxels[x][y][z].show();
        }
      }
    }
  }
}
          