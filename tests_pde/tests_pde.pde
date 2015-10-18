void setup(){
  size(1500, 800, P3D);
}

void draw(){
  background(255);
  spotLight(255, 255, 255, 700, 0, 400, 0, 0, -1, PI/2, 0);
  noStroke();
  
  pushMatrix();
  translate(750, 400, -230);
  fill(color(0, 255, 182));
  box(100, 100, 0);
//  beginShape();
//  vertex(-50, -50, 0);
//  vertex(50, -50, 0);
//  vertex(50, 50, 0);
//  vertex(-50, 50, 0);
//  endShape(CLOSE);
  popMatrix();
}
