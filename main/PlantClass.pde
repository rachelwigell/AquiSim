public class Plant {
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
  long seed;
  
  // 3 args
  public Plant(Vector3D start, Vector3D RGBcolor, int stack){
    this.position = start;
    this.numBranches = 7-stack;
    this.level = 1;
    this.RGBcolor = RGBcolor;
    Vector3D startPoint = start;
    float yDistRand = random(fieldY/10.0, fieldY/1.5);
    float yDist = yDistRand/(stack+1);
    float xAngle = random(-50, 50);
    float zAngle = random(-50, 50);
    Vector3D endPoint = startPoint.addVector(new Vector3D(xAngle, -yDist, zAngle));
    this.path = new Line(startPoint, endPoint);
    this.branches = new Plant[this.numBranches];
    for(int i = 0; i < this.numBranches; i++){
      branches[i] = new Plant(this);
    }
  }
  
  // 0 args
  public Plant(){
    this.RGBcolor = new Vector3D(int(random(0, 100)), int(random(100, 200)), int(random(50, 150)));
    this.orientation = 0;
    this.seed = random(1, 99).toFixed(2);
    randomSeed(this.seed);
    this.numBranches = 7;
    this.position = new Vector3D(0, fieldY/2, 0);
    this.absolutePosition = this.position.addVector(new Vector3D(center.x, center.y, center.z));
    this.stack = new Plant[3];
    Plant bottom = new Plant(new Vector3D(0, 0, 0), this.colorRGB, 0);
    Plant middle = new Plant(bottom.path.end, this.colorRGB, 1);
    Plant top = new Plant(middle.path.end, this.colorRGB, 2);
    this.stack[0] = bottom;
    this.stack[1] = middle;
    this.stack[2] = top;
  }
  
  // 1 arg
  public Plant(Plant root){
    this.level = root.level+1;
    this.numBranches = root.numBranches-1;
    this.RGBcolor = root.RGBcolor;
    float branchYRand = random(0, .9);
    float branchY = root.path.end.y - branchYRand*(root.path.end.y-root.path.start.y);
    Vector3D branchStart = root.path.getPointWithThisY(branchY);
    float branchLength = root.path.length/1.7;
    float yNorm = -.35;
    float xNorm = random(-.9, .9);
    float zNorm = random(-.9, .9);
    Vector3D branchEnd = branchStart.addVector(new Vector3D(xNorm, yNorm, zNorm).multiplyScalar(branchLength));
    this.path = new Line(branchStart, branchEnd);
    if(this.level < 3){
      this.branches = new Plant[this.numBranches];
      for(int i = 0; i < this.numBranches; i++){
        branches[i] = new Plant(this);
      }
    }
  }
 
  public Plant changePosition(Vector3D start, Vector3D end){
    Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
    float y = fieldY;
    float factor = (y-start.y)/normal.y;
    this.absolutePosition = start.addVector(normal.multiplyScalar(factor));
    this.absolutePosition.x = new Vector3D(int(.05*fieldX), int(this.absolutePosition.x), int(.95*fieldX)).centermost();
    this.absolutePosition.y = int(fieldY);
    this.absolutePosition.z = new Vector3D(int(-1.5*fieldZ), int(this.absolutePosition.z), int(-.5*fieldZ)).centermost();
    this.position = this.absolutePosition.addVector(new Vector3D(-center.x, -center.y, -center.z));
    return this;
  }
  
  // 4 args (for loading)
  public Plant(long seed, Vector3D RGBcolor, Vector3D position, float orientation){
    this.RGBcolor = RGBcolor;
    this.orientation = orientation;
    this.seed = seed;
    randomSeed(this.seed);
    this.numBranches = 7;
    this.position = position;
    this.absolutePosition = this.position.addVector(new Vector3D(center.x, center.y, center.z));
    this.stack = new Plant[3];
    Plant bottom = new Plant(new Vector3D(0, 0, 0), this.colorRGB, 0);
    Plant middle = new Plant(bottom.path.end, this.colorRGB, 1);
    Plant top = new Plant(middle.path.end, this.colorRGB, 2);
    this.stack[0] = bottom;
    this.stack[1] = middle;
    this.stack[2] = top;
  }
  
  public String encode(){
    String code = "";
    code += int(this.RGBcolor.x) + "+" + int(this.RGBcolor.y) + "+" + int(this.RGBcolor.z) + "+";
    code += int(this.position.x) + "+" + int(this.position.y) + "+" + int(this.position.z) + "+";
    code += this.orientation.toFixed(2) + "+";
    code += this.seed;
    return LZString.compressToUTF16(code);
  }
}  