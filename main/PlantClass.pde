public class Plant {
 Plant root;
 Line path;
 int numBranches;
 Plant[] branches;
 Plant[] stack;
 int level;
 int endLevel;
 Vector3D RGBcolor;
  
 public Plant(float xVal, float yVal, float zVal, int numBranches, int endLevel, Vector3D RGBcolor, float stack){
   this.numBranches = numBranches;
   this.endLevel = endLevel;
   this.level = 1;
   this.RGBcolor = RGBcolor;
   Vector3D startPoint = new Vector3D(xVal, yVal, zVal);
   float height = random(100, 350)/(.8*stack+1);
   float xAngle = random(-50, 50);
   float zAngle = random(-50, 50);
   Vector3D endPoint = startPoint.addVector(new Vector3D(xAngle, -height, zAngle));
   this.path = new Line(startPoint, endPoint);
   this.branches = new Plant[numBranches];
   for(int i = 0; i < numBranches; i++){
     branches[i] = new Plant(this);
   }
 }
 
 public Plant(float xVal, float zVal, int numBranches, int endLevel){
   this.colorRGB = new Vector3D(random(0, 100), random(150, 200), random(80, 150));
   this.stack = new Plant[3];
   Plant bottom = new Plant(xVal, fieldY/2, zVal, numBranches, endLevel, this.colorRGB, 0);
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
   float branchLength = root.path.length/random(1.5, 2.5);
   float yNorm = random(-.8, .2);
   float xNorm = random(yNorm*yNorm-1, yNorm*yNorm+1);
   float pos = random(-1, 1);
   float zNorm;
   if(pos > 0) zNorm = 1 - xNorm*xNorm - yNorm*yNorm;
   else zNorm = xNorm*xNorm + yNorm*yNorm - 1;
   Vector3D branchEnd = branchStart.addVector(new Vector3D(xNorm, yNorm, zNorm).multiplyScalar(branchLength));
   //branchEnd.x = new Vector3D(-.475*fieldX, branchEnd.x, .475*fieldX).centermost();
   //branchEnd.z = new Vector3D(-.5*fieldZ, branchEnd.z, .5*fieldZ).centermost();
   this.path = new Line(branchStart, branchEnd);
   if(this.level < this.endLevel){
     this.branches = new Plant[numBranches];
     for(int i = 0; i < numBranches; i++){
       branches[i] = new Plant(this);
     }
   }
 }
}