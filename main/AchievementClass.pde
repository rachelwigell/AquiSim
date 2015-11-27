public abstract class Achievement {
  public PShape rewardModel;
  public String rewardSprite;
  public String rewardDescription;
  public String condition;
  public String rewardName;
  public boolean earned;
  public boolean used;
  public Vector3D position;
  public Vector3D absolutePosition;
  public float orientation;
  public int scaleVal;
  public Vector3D dimensions;
  
  public boolean checkFulfilled(){}
  
  void drawAchievement() {
    if(this.earned && this.used){
      noStroke();
      pushMatrix();
      translate(center.x, center.y, center.z);
      translate(this.position.x, this.position.y, this.position.z);
      rotateY(this.orientation);
      scale(this.scaleVal, this.scaleVal, this.scaleVal);
      shape(this.rewardModel);
      if(clickMode == "DELETEACHIEVEMENT"){
        rotateY(-this.orientation);
        scale(1/this.scaleVal, 1/this.scaleVal, 1/this.scaleVal);
        pushMatrix();
        translate(0, 0, this.dimensions.x/2+20);
        fill(100, 100, 100);
        stroke(230, 10, 20);
        strokeWeight(2);
        translate(0, -1, 0);
        rotateX(PI/2);
        ellipse(0, 0, 60, 60);
        rotateX(-PI/2);
        line(-20, 0, 20, 20, 0, -20);
        line(20, 0, 20, -20, 0, -20);
        popMatrix();
      }
      else if(clickMode == "MOVEACHIEVEMENT"){
        rotateY(-this.orientation);
        scale(1/this.scaleVal, 1/this.scaleVal, 1/this.scaleVal);
        pushMatrix();
        translate(0, 0, this.dimensions.x/2+20);
        fill(100, 100, 100);
        stroke(230, 10, 20);
        strokeWeight(2);
        translate(0, -1, 0);
        rotateX(PI/2);
        ellipse(0, 0, 60, 60);
        rotateX(-PI/2);
        line(-30, 0, 0, -50, 0, 0);
        line(-50, 0, 0, -40, 0, 10);
        line(-50, 0, 0, -40, 0, -10);
        line(30, 0, 0, 50, 0, 0);
        line(50, 0, 0, 40, 0, 10);
        line(50, 0, 0, 40, 0, -10);
        line(0, 0, 30, 0, 0, 50);
        line(0, 0, 50, 10, 0, 40);
        line(0, 0, 50, -10, 0, 40);
        line(0, 0, -30, 0, 0, -50);
        line(0, 0, -50, 10, 0, -40);
        line(0, 0, -50, -10, 0, -40);
        popMatrix();
      }
      else if(clickMode == "ROTATEACHIEVEMENT"){
        rotateY(-this.orientation);
        scale(1/this.scaleVal, 1/this.scaleVal, 1/this.scaleVal);
        pushMatrix();
        translate(0, 0, this.dimensions.x/2+20);
        fill(100, 100, 100);
        stroke(230, 10, 20);
        strokeWeight(2);
        translate(0, -1, 0);
        rotateX(PI/2);
        ellipse(0, 0, 60, 60);
        rotateX(-PI/2);
        line(-30, 0, 0, -40, 0, -10);
        line(-30, 0, 0, -20, 0, -10);
        line(30, 0, 0, 20, 0, 10);
        line(30, 0, 0, 40, 0, 10);
        line(0, 0, -30, 10, 0, -40);
        line(0, 0, -30, 10, 0, -20);
        line(0, 0, 30, -10, 0, 40);
        line(0, 0, 30, -10, 0, 20);
        popMatrix();
      }
      popMatrix();
    }
  }
  
  void drawPreview(){
    noStroke();
    pushMatrix();
    translate(center.x, center.y, center.z);
    translate(this.position.x, this.position.y, this.position.z);
    rotateY(this.orientation);
    scale(this.scaleVal, this.scaleVal, this.scaleVal);
    shape(this.rewardModel);
    popMatrix();
  }
  
  public Achievement changePosition(Vector3D start, Vector3D end){
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
  
  public HashMap tankEffects(){}
}