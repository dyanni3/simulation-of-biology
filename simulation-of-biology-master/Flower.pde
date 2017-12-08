//Draws a flower

//The flower is just a pink hexagon rotated by a random amount in each direction. It uses a triangle fan to make the hexagon
void flower(PVector position, int[] fill_vals, float size){

pushMatrix();

translate(position.x,position.y,position.z);

fill(fill_vals[0],fill_vals[1],fill_vals[2],fill_vals[3]);
stroke(30,20,30);

beginShape(TRIANGLE_FAN);
vertex(0, 0);
vertex(-2.5*size, -5*size); 
vertex(2.5*size, -5*size); 
vertex(5*size, 0); 
vertex(2.5*size, 5*size); 
vertex(-2.5*size, 5*size);
vertex(-5*size,0);
vertex(-2.5*size,-5*size);
endShape();

popMatrix();
}