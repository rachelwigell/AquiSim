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
  
  float dist;
  float xAngle;
  float zAngle;
  float branchY;
  float branchLength;
  float xNorm;
  float yNorm;
  float zNorm;
    
  public Plant(Vector3D start, Vector3D RGBcolor, int stack){
    this.position = start;
    this.numBranches = 7-stack;
    this.level = 1;
    this.RGBcolor = RGBcolor;
    Vector3D startPoint = start;
    this.dist = random(100, 350)/(.8*stack+1);
    this.xAngle = random(-50, 50);
    this.zAngle = random(-50, 50);
    Vector3D endPoint = startPoint.addVector(new Vector3D(xAngle, -dist, zAngle));
    this.path = new Line(startPoint, endPoint);
    this.branches = new Plant[this.numBranches];
    for(int i = 0; i < this.numBranches; i++){
      branches[i] = new Plant(this);
    }
  }
   
  public Plant(){
    Vector3D RGBcolor = new Vector3D(int(random(0, 100)), int(random(100, 200)), int(random(50, 150)));
    while(!isUnique(RGBcolor)){
     RGBcolor = new Vector3D(int(random(0, 100)), int(random(100, 200)), int(random(50, 150)));
    }
    this.RGBcolor = RGBcolor;
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
    
  public Plant(Plant root){
    this.level = root.level+1;
    this.numBranches = root.numBranches-1;
    this.RGBcolor = root.RGBcolor;
    this.branchY = root.path.end.y - .9*random((root.path.end.y-(root.path.start.y)));
    Vector3D branchStart = root.path.getPointWithThisY(branchY);
    this.branchLength = root.path.length/random(fieldY/550.0, fieldY/320.0);
    this.yNorm = random(-.8, .2);
    this.xNorm = random(yNorm*yNorm-1, yNorm*yNorm+1);
    float pos = random(-1, 1);
    if(pos > 0) this.zNorm = 1 - xNorm*xNorm - yNorm*yNorm;
    else this.zNorm = xNorm*xNorm + yNorm*yNorm - 1;
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
    this.position = this.absolutePosition.addVector(new Vector3D(-center.x, -center.y, -center.z));
    return this;
  }
 
  public boolean isUnique(Vector3D RGBcolor){
   for(int i = 0; i < tank.plants.size(); i++){
     Plant p = (Plant) tank.plants.get(i);
     if(p.RGBcolor.isEqual(RGBcolor)){
       return false;
     }
   }
   return true;
  }
  
  public String encode(){
    String code = "";
    code += RGBcolor.x + "+" + RGBcolor.y + "+" + RGBcolor.z + "+";
    code += position.x.toFixed(0) + "+" + position.y.toFixed(0) + "+" + position.z.toFixed(0) + "+";
    code += numBranches + "-";
    for(int i = 0; i < 3; i++){
      Plant s = (Plant) stack[i];
      code += s.dist.toFixed(0) + "+";
      code += s.xAngle.toFixed(0) + "+";
      code += s.zAngle.toFixed(0) + "-";
      code += s.encodeStack() + "-";
    }
    console.log(code);
    return LZString.compressToUTF16(code);
  }
  
  public String encodeStack(){
    String code = "";
    
    if(level < 3){
      for(int i = 0; i < numBranches; i++){
        Plant branch = (Plant) branches[i];
        code += branch.encodeStack();
      }
    }
    return code;
  }
}  