public class Vector3D {
  public float x;
  public float y;
  public float z;
  
  public Vector3D(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public float centermost(){
    if(this.y <= this.x && this.x <= this.z) return this.x;
    if(this.z <= this.x && this.x <= this.y) return this.x;
    if(this.x <= this.y && this.y <= this.z) return this.y;
    if(this.z <= this.y && this.y <= this.x) return this.y;
    if(this.y <= this.z && this.z <= this.x) return this.z;
    if(this.x <= this.z && this.z <= this.y) return this.z;
    return this.y;
  }
}
