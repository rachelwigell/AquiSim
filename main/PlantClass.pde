public class Plant {
  Plant root;
  Line path;
  int numBranches;
  Plant[] branches;
  int level;
  int endLevel;
  
  public Plant(Line path, int numBranches, int endLevel){
    this.path = path;
    this.numBranches = numBranches;
    this.endLevel = endLevel;
    this.level = 1;
    this.branches = new Plant[numBranches];
    for(int i = 0; i < numBranches; i++){
      branches[i] = new Plant(this);
    }
  }
  
  public Plant(float xPos, float zPos, int numBranches, int endLevel){
    this.numBranches = numBranches;
    this.endLevel = endLevel;
    this.level = 1;
    Vector3D startPoint = new Vector3D(xPos, fieldY/2, zPos);
    float height = random(200, 300);
    float xAngle = random(-50, 50);
    float zAngle = random(-50, 50);
    Vector3D endPoint = startPoint.addVector(new Vector3D(xAngle, -height, zAngle));
    this.path = new Line(startPoint, endPoint);
    this.branches = new Plant[numBranches];
    for(int i = 0; i < numBranches; i++){
      branches[i] = new Plant(this);
    }
  }
  
  public Plant(Plant root){
    this.level = root.level+1;
    this.numBranches = root.numBranches;
    this.endLevel = root.endLevel;
    float branchY = root.path.end.y - .8*random((root.path.end.y-(root.path.start.y)));
    Vector3D branchStart = root.path.getPointWithThisY(branchY);
    float branchLength = root.path.length/(random(2, 3));
    float yNorm = random(-.8, .2);
    float xNorm = random(yNorm*yNorm-1, yNorm*yNorm+1);
    float pos = random(-1, 1);
    float zNorm;
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
}