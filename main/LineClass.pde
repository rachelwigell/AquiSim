public class Line {
  Vector3D start;
  Vector3D end;
  float length;
  
  public Line(Vector3D start, Vector3D end){
    this.start = start;
    this.end = end;
    this.length = end.distance(start);
  }
  
  public void drawLine(PApplet visual){
    visual.line(start.x, start.y,  start.z, end.x, end.y, end.z);
  }
  
  public Vector3D getPointWithThisY(float y){
    float percent = (y-start.y)/(end.y-start.y);
    float x = percent*(end.x-start.x)+start.x;
    float z = percent*(end.z-start.z)+start.z;
    return new Vector3D(x, y, z);
  }
}