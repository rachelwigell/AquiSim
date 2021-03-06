public class MossPlant extends Plant{
  
  // 3 args
  public MossPlant(Vector3D start, Vector3D RGBcolor, int stack){
    this.position = start;
    this.numBranches = 5-2*stack;
    this.level = 1;
    this.maxLevel = 2;
    this.RGBcolor = RGBcolor;
    Vector3D startPoint = start;
    float yDistRand = random(fieldY/30.0, fieldY/8.0);
    float yDist = yDistRand/(stack+1);
    float xAngle = random(-50, 50);
    float zAngle = random(-50, 50);
    Vector3D endPoint = startPoint.addVector(new Vector3D(xAngle, -yDist, zAngle));
    this.path = new Line(startPoint, endPoint);
    this.branches = new MossPlant[this.numBranches];
    for(int i = 0; i < this.numBranches; i++){
      branches[i] = new MossPlant(this);
    }
  }
  
  // 0 args
  public MossPlant(){
    this.RGBcolor = new Vector3D(int(random(0, 100)), int(random(100, 200)), int(random(50, 150)));
    this.orientation = 0;
    this.seed = (new Date().getTime()) % 99;
    randomSeed(this.seed);
    this.numBranches = 5;
    this.maxLevel = 2;
    this.position = new Vector3D(0, fieldY/2, 0);
    this.absolutePosition = this.position.addVector(new Vector3D(center.x, center.y, center.z));
    this.stack = new MossPlant[12];
    for(int i = 0; i < 12; i++){
      this.stack[i] = new MossPlant(new Vector3D(random(-50, 50), 0, random(-50, 50)), this.colorRGB, 0);
    }
  }
  
  // 1 arg
  public MossPlant(MossPlant root){
    this.level = root.level+1;
    this.maxLevel = 2;
    this.numBranches = root.numBranches-1;
    this.RGBcolor = root.RGBcolor;
    float branchYRand = random(0, .9);
    float branchY = root.path.end.y - branchYRand*(root.path.end.y-root.path.start.y);
    Vector3D branchStart = root.path.getPointWithThisY(branchY);
    float branchLength = root.path.length/random(.9, 1.4);
    float yNorm = -.35;
    float xNorm = random(-.9, .9);
    float zNorm = random(-.9, .9);
    Vector3D branchEnd = branchStart.addVector(new Vector3D(xNorm, yNorm, zNorm).multiplyScalar(branchLength));
    this.path = new Line(branchStart, branchEnd);
    if(this.level < this.maxLevel){
      this.branches = new MossPlant[this.numBranches];
      for(int i = 0; i < this.numBranches; i++){
        branches[i] = new MossPlant(this);
      }
    }
  }

  public void drawStack(){
    pushMatrix();
    float xDiff = (this.path.end.x-this.path.start.x);
    float yDiff = (this.path.end.y-this.path.start.y);
    float zDiff = (this.path.end.z-this.path.start.z);
    translate(this.path.start.x+(xDiff)/2,
             this.path.start.y+(yDiff)/2,
             this.path.start.z+(zDiff)/2);
    xzAngle = -atan(zDiff/xDiff);
    rotateY(xzAngle);
    yAngle = asin(yDiff/this.path.length);
    if(xDiff < 0) yAngle *= -1;
    rotateZ(yAngle);
    scale(1, .05, .2);
    sphere(this.path.length/2);
    popMatrix();
    if(this.level < this.maxLevel){
     for(int i = 0; i < this.numBranches; i++){
       MossPlant b = (MossPlant) this.branches[i];
       b.drawStack();
     }
    }
  }

  public void drawPlant(){
    sphereDetail(6);
    noStroke();
    fill(this.RGBcolor.x, this.RGBcolor.y, this.RGBcolor.z);
    pushMatrix();
    translate(center.x, center.y, center.z);
    translate(this.position.x, this.position.y, this.position.z);
    rotateY(this.orientation);
    for(int j = 0; j < 12; j++){
      this.stack[j].drawStack();
    }
    if(clickMode == "DELETEPLANT"){
      rotateY(-this.orientation);
      if(hasSubstrate()){
        translate(0, -16, 0);
      }
      pushMatrix();
      fill(100, 100, 100);
      stroke(230, 10, 20);
      strokeWeight(2);
      translate(0, -1, 0);
      rotateX(PI/2);
      ellipse(0, 0, 60, 60);
      popMatrix();
      line(-20, -2, 20, 20, -2, -20);
      line(20, -2, 20, -20, -2, -20);
    }
    else if(clickMode == "MOVEPLANT"){
      rotateY(-this.orientation);
      if(hasSubstrate()){
        translate(0, -16, 0);
      }
      pushMatrix();
      fill(100, 100, 100);
      stroke(230, 10, 20);
      strokeWeight(2);
      translate(0, -1, 0);
      rotateX(PI/2);
      ellipse(0, 0, 60, 60);
      popMatrix();
      line(-30, -1, 0, -50, -1, 0);
      line(-50, -1, 0, -40, -1, 10);
      line(-50, -1, 0, -40, -1, -10);
      line(30, -1, 0, 50, -1, 0);
      line(50, -1, 0, 40, -1, 10);
      line(50, -1, 0, 40, -1, -10);
      line(0, -1, 30, 0, -1, 50);
      line(0, -1, 50, 10, -1, 40);
      line(0, -1, 50, -10, -1, 40);
      line(0, -1, -30, 0, -1, -50);
      line(0, -1, -50, 10, -1, -40);
      line(0, -1, -50, -10, -1, -40);
    }
    else if(clickMode == "ROTATEPLANT"){
      rotateY(-this.orientation);
      if(hasSubstrate()){
        translate(0, -16, 0);
      }
      pushMatrix();
      fill(100, 100, 100);
      stroke(230, 10, 20);
      strokeWeight(2);
      translate(0, -1, 0);
      rotateX(PI/2);
      ellipse(0, 0, 60, 60);
      popMatrix();
      line(-30, 0, 0, -40, 0, -10);
      line(-30, 0, 0, -20, 0, -10);
      line(30, 0, 0, 20, 0, 10);
      line(30, 0, 0, 40, 0, 10);
      line(0, 0, -30, 10, 0, -40);
      line(0, 0, -30, 10, 0, -20);
      line(0, 0, 30, -10, 0, 40);
      line(0, 0, 30, -10, 0, 20);
    }
    popMatrix();
  }
  
  // 4 args (for loading)
  public MossPlant(long seed, Vector3D RGBcolor, Vector3D position, float orientation){
    this.RGBcolor = RGBcolor;
    this.orientation = orientation;
    this.seed = seed;
    randomSeed(this.seed);
    this.numBranches = 12;
    this.maxLevel = 2;
    this.position = position;
    this.absolutePosition = this.position.addVector(new Vector3D(center.x, center.y, center.z));
    this.stack = new MossPlant[12];
    for(int i = 0; i < 12; i++){
      this.stack[i] = new MossPlant(new Vector3D(random(-50, 50), 0, random(-50, 50)), this.colorRGB, 0);
    }
  }
  
  public String encode(){
    String code = "";
    code += int(this.RGBcolor.x) + "+" + int(this.RGBcolor.y) + "+" + int(this.RGBcolor.z) + "+";
    code += int(this.position.x) + "+" + int(this.position.z) + "+";
    code += this.orientation.toFixed(2) + "+";
    code += this.seed + "+";
    code += "Moss";
    return LZString.compressToUTF16(code);
  }

}