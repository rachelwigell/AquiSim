public class Plant {
  Plant root;
  Line path;
  int numBranches;
  Plant[] branches;
  Plant[] stack;
  int level;
  int endLevel;
  Vector3D RGBcolor;
  Vector3D position;
  Vector3D absolutePosition;
    
  public Plant(float xVal, float yVal, float zVal, int numBranches, int endLevel, Vector3D RGBcolor, float stack){
    this.position = new Vector3D(xVal, yVal, zVal);
    this.numBranches = numBranches-stack;
    this.endLevel = endLevel;
    this.level = 1;
    this.RGBcolor = RGBcolor;
    Vector3D startPoint = new Vector3D(xVal, yVal, zVal);
    float dist = random(100, 350)/(.8*stack+1);
    float xAngle = random(-50, 50);
    float zAngle = random(-50, 50);
    Vector3D endPoint = startPoint.addVector(new Vector3D(xAngle, -dist, zAngle));
    this.path = new Line(startPoint, endPoint);
    this.branches = new Plant[numBranches];
    for(int i = 0; i < numBranches; i++){
      branches[i] = new Plant(this);
    }
  }
   
  public Plant(float xVal, float zVal, int numBranches, int endLevel){
    Vector3D RGBcolor = new Vector3D(int(random(0, 100)), int(random(100, 200)), int(random(50, 150)));
    while(!isUnique(RGBcolor)){
     RGBcolor = new Vector3D(int(random(0, 100)), int(random(100, 200)), int(random(50, 150)));
    }
    this.RGBcolor = RGBcolor;
    this.position = new Vector3D(xVal, fieldY/2, zVal);
    this.absolutePosition = this.position.addVector(new Vector3D(center.x, center.y, center.z));
    this.stack = new Plant[3];
    Plant bottom = new Plant(xVal, 0, zVal, numBranches, endLevel, this.colorRGB, 0);
    Plant middle = new Plant(bottom.path.end.x, bottom.path.end.y, bottom.path.end.z, numBranches, endLevel, this.colorRGB, 1);
    Plant top = new Plant(middle.path.end.x, middle.path.end.y, middle.path.end.z, numBranches, endLevel, this.colorRGB, 2);
    this.stack[0] = bottom;
    this.stack[1] = middle;
    this.stack[2] = top;
  }
    
  public Plant(Plant root){
    this.level = root.level+1;
    this.numBranches = root.numBranches;
    this.endLevel = root.endLevel;
    this.RGBcolor = root.RGBcolor;
    float branchY = root.path.end.y - .9*random((root.path.end.y-(root.path.start.y)));
    Vector3D branchStart = root.path.getPointWithThisY(branchY);
    float branchLength = root.path.length/random(fieldY/550.0, fieldY/320.0);
    float yNorm = random(-.8, .2);
    float xNorm = random(yNorm*yNorm-1, yNorm*yNorm+1);
    float pos = random(-1, 1);
    if(pos > 0) zNorm = 1 - xNorm*xNorm - yNorm*yNorm;
    else zNorm = xNorm*xNorm + yNorm*yNorm - 1;
    Vector3D branchEnd = branchStart.addVector(new Vector3D(xNorm, yNorm, zNorm).multiplyScalar(branchLength));
    this.path = new Line(branchStart, branchEnd);
    if(this.level < this.endLevel){
      this.branches = new Plant[numBranches];
      for(int i = 0; i < numBranches; i++){
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
    code += RGBcolor.x + "/" + RGBcolor.y + "/" + RGBcolor.z + "/";
    code += position.x + "/" + position.y + "/" + position.z + "/";
    code += endLevel + "/";
    for(int i = 0; i < 3; i++){
      Plant s = (Plant) stack[i];
      code += s.encodeStack() + "+";
    }
    return code;
  }
  
  public String encodeStack(){
    String code = "";
    code += this.path.start.x.toFixed(2) + "/" + this.path.start.y.toFixed(2) + "/" + this.path.start.z.toFixed(2) + "/";
    code += this.path.end.x.toFixed(2) + "/" + this.path.end.y.toFixed(2) + "/" + this.path.end.z.toFixed(2) + "/";
    code += numBranches + "/";
    code += level + "-";
    if(level < endLevel){
      for(int i = 0; i < numBranches; i++){
        Plant branch = (Plant) branches[i];
        code += branch.encodeStack();
      }
    }
    return code;
  }
}  