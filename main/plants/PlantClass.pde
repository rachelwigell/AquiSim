public abstract class Plant {
  Plant root;
  Line path;
  int numBranches;
  Plant[] branches;
  Plant[] stack;
  int level;
  Vector3D RGBcolor;
  Vector3D position;
  Vector3D absolutePosition;
  float orientation;
  int seed;
  
  
 
  public Plant changePosition(Vector3D start, Vector3D end){
    Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
    float y = fieldY;
    float factor = (y-start.y)/normal.y;
    this.absolutePosition = start.addVector(normal.multiplyScalar(factor));
    this.absolutePosition.x = new Vector3D(int(.05*fieldX), int(this.absolutePosition.x), int(.95*fieldX)).centermost();
    this.absolutePosition.y = int(fieldY);
    this.absolutePosition.z = new Vector3D(int(-1.5*fieldZ), int(this.absolutePosition.z), int(-.6*fieldZ)).centermost();
    this.position = this.absolutePosition.addVector(new Vector3D(-center.x, -center.y, -center.z));
    return this;
  }
  
  public String encode(){
    String code = "";
    code += int(this.RGBcolor.x) + "+" + int(this.RGBcolor.y) + "+" + int(this.RGBcolor.z) + "+";
    code += int(this.position.x) + "+" + int(this.position.z) + "+";
    code += this.orientation.toFixed(2) + "+";
    code += this.seed;
    return LZString.compressToUTF16(code);
  }
}  