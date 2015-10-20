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
  
  public float distance(Vector3D to){
    return (float) sqrt(squareDistance(to));
  }
  
  public float squareDistance(Vector3D to){
    return (float) (pow(this.x - to.x, 2) + pow(this.y - to.y, 2) + pow(this.z - to.z, 2));
  }
  
  public Vector3D addScalar(float quantity){
    return new Vector3D(this.x + quantity, this.y + quantity, this.z + quantity);
  }
  
  public Vector3D addVector(Vector3D vector){
    return new Vector3D(this.x + vector.x, this.y + vector.y, this.z + vector.z);
  }
  
  public Vector3D multiplyScalar(float quantity){
    return new Vector3D(this.x * quantity, this.y * quantity, this.z * quantity);
  }
  
  public float magnitude(){
    return (float) sqrt(pow(this.x, 2) + pow(this.y, 2) + pow(this.z, 2));
  }
  
  public Vector3D normalize(){
    float magnitude = this.magnitude();
    return new Vector3D(this.x/magnitude, this.y/magnitude, this.z/magnitude);
  }
  
  public float dotProduct(Vector3D vector){
    return (float) (this.x*vector.x + this.y*vector.y + this.z*vector.z);
  }
}
