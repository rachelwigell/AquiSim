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
  String encoding;
  
  float yDistRand;
  int xAngle;
  int zAngle;
  float branchYRand;
  float xNorm;
  float zNorm;
  
  float[] yDistVals = {fieldY/8.0, fieldY/6.0, 5*fieldY/24.0, fieldY/4.0, 7*fieldY/24.0,
                       fieldY/3.0, 3*fieldY/8.0, 5*fieldY/12.0, 11*fieldY/24.0, fieldY/2.0};
  float[] angleVals = {-50, -39, -28, -17, -6, 5, 16, 27, 38, 49};
  float[] branchYVals = {0, .1, .2, .3, .4, .5, .6, .7, .8, .9};
  float[] normVals = {-.9, -.7, -.5, -.3, -.1, .1, .3, .5, .7, .9};
  
  HashMap yDistEncoding;
  HashMap angleEncoding;
  HashMap branchYEncoding;
  HashMap normEncoding;
  
  HashMap yDistDecoding;
  HashMap angleDecoding;
  HashMap branchYDecoding;
  HashMap normDecoding;
  
  public void initializeEncodingHashes(){
    this.yDistEncoding = new HashMap();
    this.angleEncoding = new HashMap();
    this.branchYEncoding = new HashMap();
    this.normEncoding = new HashMap();
    for(int i = 0; i < 10; i++){
      this.yDistEncoding.put(yDistVals[i], i);
      this.angleEncoding.put(angleVals[i], i);
      this.branchYEncoding.put(branchYVals[i], i);
      this.normEncoding.put(normVals[i], i);
    }
  }
  
  public void initializeDecodingHashes(){
    this.yDistDecoding = new HashMap();
    this.angleDecoding = new HashMap();
    this.branchYDecoding = new HashMap();
    this.normDecoding = new HashMap();
    for(int i = 0; i < 9; i++){
      this.yDistDecoding.put(i, yDistVals[i]);
      this.angleDecoding.put(i, angleVals[i]);
      this.branchYDecoding.put(i, branchYVals[i]);
      this.normDecoding.put(i, normVals[i]);
    }
  }
  
  public float closest(float val, float[] floats){
    float difference = MAX_FLOAT;
    float closest = 0;
    for(int i = 0; i < floats.length; i++){
      float diff = abs(floats[i] - val);
      if(diff < difference){
        closest = floats[i];
        difference = diff;
      }
    }
    return closest;
  }
  
  public Plant(Vector3D start, Vector3D RGBcolor, int stack){
    this.position = start;
    this.numBranches = 7-stack;
    this.level = 1;
    this.RGBcolor = RGBcolor;
    Vector3D startPoint = start;
    this.yDistRand = closest(random(fieldY/8.0, fieldY/2.0), yDistVals);
    float yDist = this.yDistRand/(stack+1);
    this.xAngle = closest(random(-50, 49), angleVals);
    this.zAngle = closest(random(-50, 49), angleVals);
    Vector3D endPoint = startPoint.addVector(new Vector3D(xAngle, -yDist, zAngle));
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
    this.branchYRand = closest(random(0, .9), branchYVals);
    float branchY = root.path.end.y - this.branchYRand*(root.path.end.y-root.path.start.y);
    Vector3D branchStart = root.path.getPointWithThisY(branchY);
    float branchLength = root.path.length/1.7;
    float yNorm = -.35;
    this.xNorm = closest(random(-.9, .9), normVals);
    this.zNorm = closest(random(-.9, .9), normVals);
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
    this.absolutePosition.x = int(this.absolutePosition.x);
    this.absolutePosition.y = int(this.absolutePosition.y);
    this.absolutePosition.z = int(this.absolutePosition.z);
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
    initializeEncodingHashes();
    String code = "";
    code += int(this.RGBcolor.x) + "+" + int(this.RGBcolor.y) + "+" + int(this.RGBcolor.z) + "+";
    code += int(this.position.x) + "+" + int(this.position.y) + "+" + int(this.position.z) + "+";
    for(int i = 0; i < 3; i++){
      Plant s = (Plant) stack[i];
      code += this.yDistEncoding.get(s.yDistRand);
      code += this.angleEncoding.get(s.xAngle);
      code += this.angleEncoding.get(s.zAngle);
      code += s.encodeStack();
    }
    return LZString.compressToUTF16(code) + ";";
  }
  
  public String encodeStack(){
    initializeEncodingHashes();
    String code = "";
    if(level < 3){
      for(int i = 0; i < numBranches; i++){
        Plant branch = (Plant) branches[i];
        code += this.branchYEncoding.get(branch.branchYRand);
        code += this.normEncoding.get(branch.xNorm);
        code += this.normEncoding.get(branch.zNorm);
        code += branch.encodeStack();
      }
    }
    return code;
  }
}  