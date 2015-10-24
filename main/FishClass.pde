public abstract class Fish {
  public String species;
  public String name;
  public String status;
  public long fullness;
  public long maxFullness;
  public long maxHealth;
  public long health;
  public int ease;
  public double size;
  public double minPH;
  public double maxPH;
  public double minTemp;
  public double maxTemp;
  public double minHard;
  public double maxHard;
  public double ammonia;
  public double nitrite;
  public double nitrate;
  //public PShape model;
  public ArrayList model;
  public String sprite;
  public Vector3D position;
  public Vector3D orientation;
  public Vector3D dimensions;
  public Vector3D velocity;
  public Vector3D acceleration;
  
  public int setHealth(){
    if(this.status == "Happy."){
      this.health = min(this.maxHealth, this.health+1);
    }
    else{
     this.health  = max(0, this.health-1);
    }
    return this.health;
  }

  public long changeHunger(){
    int hunger = (int) (this.size/2); //hunger changes relative to fish size
    this.fullness = Math.max(this.fullness - hunger, 0);
    return hunger;
  }
  
  public void updatePosition(){
    this.position.x = new Vector3D((-.475*fieldX+this.dimensions.x/2.0), this.position.x+this.velocity.x, (.475*fieldX-this.dimensions.x/2.0)).centermost();
    this.position.y = new Vector3D((-.5*fieldY*tank.waterLevel-this.dimensions.y/2.0), this.position.y+this.velocity.y, (.5*fieldY*tank.waterLevel+this.dimensions.y/2.0)).centermost();
    this.position.z = new Vector3D((-.5*fieldZ+this.dimensions.x/2.0), this.position.z+this.velocity.z, (.5*fieldZ-this.dimensions.x/2.0)).centermost();
    this.updateVelocity();
  }
  
  public void updateAcceleration(){
    this.acceleration.x += random(-.25, .25);
    this.acceleration.y += random(-.125, .125);
    this.acceleration.z += random(-.25, .25);
  }
  
  public void updateVelocity(){
    this.velocity.x = new Vector3D(-2, this.velocity.x + this.acceleration.x, 2).centermost();
    this.velocity.y = new Vector3D(-2, this.velocity.y + this.acceleration.y, 2).centermost();
    this.velocity.z = new Vector3D(-2, this.velocity.z + this.acceleration.z, 2).centermost();
    this.velocity = this.velocity.addVector(this.centerPull());
    this.velocity = this.velocity.addVector(this.hungerContribution());
    this.updateOrientationRelativeToVelocity();
    this.updateAcceleration();
  }
  
  public Vector3D hungerContribution(){
    Vector3D nearestFood = tank.nearestFood(this.position);
    if(nearestFood == null) return new Vector3D(0,0,0);
    float percent = max((.8-(max(this.fullness, 0)/((double) this.maxFullness)))*6, 0);
    Vector3D normal = nearestFood.addVector(this.position.multiplyScalar(-1)).normalize();
    return normal.multiplyScalar(percent);
  }
  
  public Vector3D centerPull(){
    Vector3D middle = new Vector3D(0, 0, 0);
    float percent = 1.8*this.position.squareDistance(middle)/(pow(zero.x, 2) + pow(zero.y, 2) + pow(zero.z, 2));
    Vector3D normal = middle.addVector(this.position.multiplyScalar(-1)).normalize();
    return normal.multiplyScalar(percent);
  }
  
  public void updateOrientationRelativeToVelocity(){
    Vector3D velocity = this.velocity;  
    double angle = Math.asin(Math.abs(velocity.z)/velocity.magnitude());
    if(velocity.x < 0 && velocity.z > 0) this.orientation.y = angle;
    else if(velocity.x > 0 && velocity.z > 0) this.orientation.y = (PI - angle);
    else if(velocity.x > 0 && velocity.z < 0) this.orientation.y = (PI + angle);
    else if(velocity.x < 0 && velocity.z < 0) this.orientation.y = -angle;
    else if(velocity.z == 0 && velocity.x < 0) this.orientation.y = 0;
    else if(velocity.x == 0 && velocity.z > 0) this.orientation.y = (PI/2.0);
    else if(velocity.z == 0 && velocity.x > 0) this.orientation.y = PI;
    else if(velocity.x == 0 && velocity.z < 0) this.orientation.y = (3*PI/2.0);
    this.orientation.z = new Vector3D(-1, -velocity.y, 1).centermost() * PI/6;
  }
  
  void drawFish(){
    noStroke();
    pushMatrix();
    translate(zero.x, zero.y, zero.z);
    translate(this.position.x, this.position.y, this.position.z);
    rotateX(this.orientation.x);
    rotateY(this.orientation.y);
    rotateZ(this.orientation.z);
    Vector3D currentColor = (Vector3D) this.model.get(0); //side
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, -6, 7.5);
    vertex(20, -6, 7.5);
    vertex(20, 6, 7.5);
    vertex(-20, 6, 7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(1); //back trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(40, -1.5, 2.5);
    vertex(20, -6, 7.5);
    vertex(20, 6, 7.5);
    vertex(40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(2); //top trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, -6, 7.5);
    vertex(-4, -18, 2.5);
    vertex(4, -18, 2.5);
    vertex(20, -6, 7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(3); //top (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, -18, 2.5);
    vertex(-4, -18, -2.5);
    vertex(4, -18, -2.5);
    vertex(4, -18, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(4); //top back triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, -18, 2.5);
    vertex(20, -6, 7.5);
    vertex(40, -1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(5); //top of top back triangle (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, -18, -2.5);
    vertex(4, -18, 2.5);
    vertex(40, -1.5, 2.5);
    vertex(40, -1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(6); //bottom trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, 6, 7.5);
    vertex(-4, 18, 2.5);
    vertex(4, 18, 2.5);
    vertex(20, 6, 7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(7); //bottom back triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, 18, 2.5);
    vertex(20, 6, 7.5);
    vertex(40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(8); //bottom of bottom trapezoid (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, 18, -2.5);
    vertex(4, 18, 2.5);
    vertex(-4, 18, 2.5);
    vertex(-4, 18, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(9); //bottom of bottom back triangle (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, 18, 2.5);
    vertex(4, 18, -2.5);
    vertex(40, 1.5, -2.5);
    vertex(40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(10); //front trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-40, -1.5, 2.5);
    vertex(-20, -6, 7.5);
    vertex(-20, 6, 7.5);
    vertex(-40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(11); //top front triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, -18, 2.5);
    vertex(-20, -6, 7.5);
    vertex(-40, -1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(12); //top of top front triangle (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, -18, -2.5);
    vertex(-4, -18, 2.5);
    vertex(-40, -1.5, 2.5);
    vertex(-40, -1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(13); //bottom front triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, 18, 2.5);
    vertex(-20, 6, 7.5);
    vertex(-40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(14); //bottom of bottom front triangle (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, 18, -2.5);
    vertex(-4, 18, 2.5);
    vertex(-40, 1.5, 2.5);
    vertex(-40, 1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(15); //front (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-40, 1.5, -2.5);
    vertex(-40, 1.5, 2.5);
    vertex(-40, -1.5, 2.5);
    vertex(-40, -1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(16); //side tail
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(40, -1.5, 2.5);
    vertex(58, -20, 2.5);
    vertex(58, -15, 2.5);
    vertex(52, 0, 2.5);
    vertex(58, 15, 2.5);
    vertex(58, 20, 2.5);
    vertex(40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(17); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(40, -1.5, 2.5);
    vertex(40, -1.5, -2.5);
    vertex(58, -20, -2.5);
    vertex(58, -20, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(18); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(58, -20, -2.5);
    vertex(58, -20, 2.5);
    vertex(58, -15, 2.5);
    vertex(58, -15, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(19); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(58, -15, 2.5);
    vertex(58, -15, -2.5);
    vertex(52, 0, -2.5);
    vertex(52, 0, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(20); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(52, 0, 2.5);
    vertex(52, 0, -2.5);
    vertex(58, 15, -2.5);
    vertex(58, 15, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(21); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(58, 15, 2.5);
    vertex(58, 15, -2.5);
    vertex(58, 20, -2.5);
    vertex(58, 20, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(22); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(58, 20, 2.5);
    vertex(58, 20, -2.5);
    vertex(40, 1.5, -2.5);
    vertex(40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(0); //side
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, -6, -7.5);
    vertex(20, -6, -7.5);
    vertex(20, 6, -7.5);
    vertex(-20, 6, -7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(1); //back trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(40, -1.5, -2.5);
    vertex(20, -6, -7.5);
    vertex(20, 6, -7.5);
    vertex(40, 1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(2); //top trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, -6, -7.5);
    vertex(-4, -18, -2.5);
    vertex(4, -18, -2.5);
    vertex(20, -6, -7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(4); //top back triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, -18, -2.5);
    vertex(20, -6, -7.5);
    vertex(40, -1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(6); //bottom trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, 6, -7.5);
    vertex(-4, 18, -2.5);
    vertex(4, 18, -2.5);
    vertex(20, 6, -7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(7); //bottom back triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, 18, -2.5);
    vertex(20, 6, -7.5);
    vertex(40, 1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(10); //front trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-40, -1.5, -2.5);
    vertex(-20, -6, -7.5);
    vertex(-20, 6, -7.5);
    vertex(-40, 1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(11); //top front triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, -18, -2.5);
    vertex(-20, -6, -7.5);
    vertex(-40, -1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(13); //bottom front triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, 18, -2.5);
    vertex(-20, 6, -7.5);
    vertex(-40, 1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) this.model.get(16); //side tail
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(40, -1.5, -2.5);
    vertex(58, -20, -2.5);
    vertex(58, -15, -2.5);
    vertex(52, 0, -2.5);
    vertex(58, 15, -2.5);
    vertex(58, 20, -2.5);
    vertex(40, 1.5, -2.5);
    endShape(CLOSE);
    fill(0);
    translate(-30, 0, 2.5);
    sphere(4);
    translate(0, 0, -5);
    sphere(4);
    popMatrix();
  }
}