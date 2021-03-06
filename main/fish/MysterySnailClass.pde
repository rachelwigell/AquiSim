public class MysterySnail extends Fish{
  String location; //which wall is he on
  
  public MysterySnail(String name){
    this.species = "Mystery Snail";
    this.name = name;
    this.ease = 5;
    this.maxHealth = this.ease*24*60*12;
    this.health = this.maxHealth;
    this.status = "Happy.";
    this.size = 5;
    this.maxFullness = this.ease*this.size*24*60*3;
    this.fullness = this.maxFullness/2;
    this.scaleVal = 10;
    this.activity = 1;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.model = loadShape("graphics/mysterysnail.obj");
    this.sprite = "graphics/mysterysnail.png";
    this.position = new Vector3D(0, fieldY/2, 0);
    this.absolutePosition = new Vector3D(zero.x, zero.y+fieldY/2, zero.z);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(7.2*this.scaleVal, 5.8*this.scaleVal, 5.4*this.scaleVal);
    this.setDangerRatings();
    this.location = "FLOOR";
    this.region = 0;
    this.aliveSince = new Date().getTime();
    this.happySince = new Date().getTime();
    this.schoolingCoefficient = 0;
    initializeTolerances(0.1, 0.25, 50, 7, 8.5, 18, 27, 5, 20);
  }
  
  
  //constructor for load
  public MysterySnail(String[] stats, boolean alive){
    this.species = "Mystery Snail";
    this.ease = 5;
    this.maxHealth = this.ease*24*60*12;
    this.status = "Happy.";
    this.size = 5;
    this.maxFullness = this.ease*this.size*24*60*3;
    if(alive){
      this.name = stats[1];
      this.health = min(float(stats[2]), this.maxHealth);
      this.fullness = min(float(stats[3]), this.maxFullness);
      initializeTolerances(0.1, 0.25, 50, float(stats[8]), float(stats[9]), float(stats[4]), float(stats[5]), float(stats[6]), float(stats[7]));
      this.aliveSince = stats[10];
      this.happySince = stats[11];
    }
    this.model = loadShape("graphics/mysterysnail.obj");
    this.scaleVal = 10;
    this.activity = 3;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.sprite = "graphics/mysterysnail.png";
    this.dimensions = new Vector3D(7.2*this.scaleVal, 5.8*this.scaleVal, 5.4*this.scaleVal);
    this.position = new Vector3D(0, 0, 0);
    if(!alive){
      this.position.y = (-.5*fieldY*waterLevel);
      this.position.x = random((-.475*fieldX+this.dimensions.x/2.0), (.475*fieldX-this.dimensions.x/2.0));
      this.position.z = random((-.5*fieldZ+this.dimensions.x/2.0), (.5*fieldZ-this.dimensions.x/2.0));
    }
    else{
      float whichWall = random(0, 4);
      if(whichWall <= 1){
        this.location = "FLOOR";
        this.position.y = (.5*fieldY*waterLevel);
        this.position.x = random((-.475*fieldX+this.dimensions.x/2.0), (.475*fieldX-this.dimensions.x/2.0));
        this.position.z = random((-.5*fieldZ+this.dimensions.x/2.0), (.5*fieldZ-this.dimensions.x/2.0));
      }
      else if(whichWall <= 2){
       this.location = "BACK";
       this.position.z = -.5*fieldZ;
       this.position.x = random((-.475*fieldX+this.dimensions.x/2.0), (.475*fieldX-this.dimensions.x/2.0));
       this.position.y = random((-.5*fieldY*waterLevel+this.dimensions.x/2.0), (.5*fieldY*waterLevel-this.dimensions.x/2.0));
      }
      else if(whichWall <= 3){
        this.location = "LEFT";
        this.position.x = -.475*fieldX;
        this.position.z = -.5*fieldZ;
        this.position.y = random((-.5*fieldY*waterLevel+this.dimensions.x/2.0), (.5*fieldY*waterLevel-this.dimensions.x/2.0));
        this.position.z = random((-.5*fieldZ+this.dimensions.x/2.0), (.5*fieldZ-this.dimensions.x/2.0));
      }
      else if(whichWall <= 4){
        this.location = "RIGHT";
        this.position.x = .475*fieldX;
        this.position.z = -.5*fieldZ;
        this.position.y = random((-.5*fieldY*waterLevel+this.dimensions.x/2.0), (.5*fieldY*waterLevel-this.dimensions.x/2.0));
        this.position.z = random((-.5*fieldZ+this.dimensions.x/2.0), (.5*fieldZ-this.dimensions.x/2.0));
      }
    }
    this.absolutePosition = this.position.addVector(new Vector3D(zero.x, zero.y, zero.z));
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.setDangerRatings();
    this.region = 0;
    this.schoolingCoefficient = 0;
  }
  
  public void updatePosition() {
    this.position.x = new Vector3D((-.475*fieldX), this.position.x+30/rate*this.velocity.x, (.475*fieldX)).centermost();
    this.position.y = new Vector3D((-.5*fieldY*waterLevel), this.position.y+30/rate*this.velocity.y, (.5*fieldY*waterLevel)).centermost();
    this.position.z = new Vector3D((-.5*fieldZ), this.position.z+30/rate*this.velocity.z, (.5*fieldZ-this.dimensions.x/2.0)).centermost();
    this.absolutePosition = this.position.addVector(new Vector3D(zero.x, zero.y, zero.z));
    this.updateVelocity();
  }
  
  public void updateAcceleration() {
    if(swimming){
      if(random(0, this.activity*20) < 1){
        swimming = false;
      }
    }
    else{
      if(random(0, 100-this.activity*20) < 1){
        swimming = true;
      }
    }
    if(swimming){
      this.acceleration.x = new Vector3D(-.3, this.acceleration.x+random(-.05, .05), .3).centermost();
      this.acceleration.y = new Vector3D(-.3, this.acceleration.y+random(-.05, .05), .3).centermost();
      this.acceleration.z = new Vector3D(-.3, this.acceleration.z+random(-.05, .05), .3).centermost();
    }
    else{
      this.acceleration.x = new Vector3D(-.3, -.1*this.velocity.x, .3).centermost();
      this.acceleration.y = new Vector3D(-.3, -.1*this.velocity.y, .3).centermost();
      this.acceleration.z = new Vector3D(-.3, -.1*this.velocity.z, .3).centermost();
    }
  }
  
  public Vector3D hungerContribution() {
    Vector3D nearestFood = tank.nearFood(this.absolutePosition);
    if (nearestFood == null) return new Vector3D(0, 0, 0);
    nearestFood = nearestFood.addVector(new Vector3D(-zero.x, -zero.y, -zero.z));
    float percent = max((.8-(max(this.fullness, 0)/((double) this.maxFullness)))*6, 0);
    Vector3D normal = nearestFood.addVector(this.position.multiplyScalar(-1)).normalize();
    return normal.multiplyScalar(percent/3);
  }

  public void updateVelocity() {
    if(this.location == "FLOOR"){
      this.velocity.x = new Vector3D(-.4, this.velocity.x + this.acceleration.x, .4).centermost();
      this.velocity.z = new Vector3D(-.4, this.velocity.z + this.acceleration.z, .4).centermost();
      this.velocity = this.velocity.addVector(this.hungerContribution());
      this.velocity.y = 0;
    }
    else if(this.location == "BACK"){
      this.velocity.x = new Vector3D(-.4, this.velocity.x + this.acceleration.x, .4).centermost();
      this.velocity.y = new Vector3D(-.4, this.velocity.y + this.acceleration.y, .4).centermost();
      this.velocity = this.velocity.addVector(this.hungerContribution());
      this.velocity.z = 0;
    }
    else if(this.location == "LEFT" || this.location == "RIGHT"){
      this.velocity.z = new Vector3D(-.4, this.velocity.z + this.acceleration.z, .4).centermost();
      this.velocity.y = new Vector3D(-.4, this.velocity.y + this.acceleration.y, .4).centermost();
      this.velocity = this.velocity.addVector(this.hungerContribution());
      this.velocity.x = 0;
    }
    if(this.position.z >= (.5*fieldZ-this.dimensions.x/2.0)){
     this.acceleration.z = -.3;
    }
    if(this.position.y <= (-.5*fieldY*waterLevel+this.dimensions.y/2.0)){
      this.acceleration.y = .3;
    }
    this.updateOrientationRelativeToVelocity();
    this.updateAcceleration();
    this.transitionWalls();
  }
  
  public void updateOrientationRelativeToVelocity(){
    if(this.location == "FLOOR"){
      double angle = asin(abs(velocity.z)/velocity.magnitude());
      this.orientation.z = 0;
      this.orientation.x = 0;
      if (velocity.x < 0 && velocity.z > 0) this.orientation.y = PI+angle;
      else if (velocity.x > 0 && velocity.z > 0) this.orientation.y = (-angle);
      else if (velocity.x > 0 && velocity.z < 0) this.orientation.y = (angle);
      else if (velocity.x < 0 && velocity.z < 0) this.orientation.y = PI-angle;
      else if (velocity.z == 0 && velocity.x < 0) this.orientation.y = PI;
      else if (velocity.x == 0 && velocity.z > 0) this.orientation.y = (3*PI/2.0);
      else if (velocity.z == 0 && velocity.x > 0) this.orientation.y = 0;
      else if (velocity.x == 0 && velocity.z < 0) this.orientation.y = (PI/2.0);
    }
    else if(this.location == "RIGHT"){
      angle = asin(abs(this.velocity.z)/this.velocity.magnitude());
      this.orientation.z = -PI/2.0;
      this.orientation.x = 0;
      if(this.velocity.y > 0 && this.velocity.z > 0) this.orientation.y =  angle+PI;
      else if(this.velocity.y < 0 && this.velocity.z > 0) this.orientation.y =  (-angle);
      else if(this.velocity.y < 0 && this.velocity.z < 0) this.orientation.y =  (angle);
      else if(this.velocity.y > 0 && this.velocity.z < 0) this.orientation.y =  PI-angle;
      else if(this.velocity.z == 0 && this.velocity.y > 0) this.orientation.y = PI;
      else if(this.velocity.y == 0 && this.velocity.z > 0) this.orientation.y =  (3*PI/2.0);
      else if(this.velocity.z == 0 && this.velocity.y < 0) this.orientation.y =  0;
      else if(this.velocity.y == 0 && this.velocity.z < 0) this.orientation.y =  (PI/2.0);
    }
    else if(this.location == "LEFT"){
      angle = asin(abs(this.velocity.z)/this.velocity.magnitude());
      this.orientation.z = PI/2.0;
      this.orientation.x = 0;
      if(this.velocity.y < 0 && this.velocity.z > 0) this.orientation.y =  angle+PI;
      else if(this.velocity.y > 0 && this.velocity.z > 0) this.orientation.y =  (-angle);
      else if(this.velocity.y > 0 && this.velocity.z < 0) this.orientation.y =  (angle);
      else if(this.velocity.y < 0 && this.velocity.z < 0) this.orientation.y =  PI-angle;
      else if(this.velocity.z == 0 && this.velocity.y < 0) this.orientation.y = PI;
      else if(this.velocity.y == 0 && this.velocity.z > 0) this.orientation.y =  (3*PI/2.0);
      else if(this.velocity.z == 0 && this.velocity.y > 0) this.orientation.y =  0;
      else if(this.velocity.y == 0 && this.velocity.z < 0) this.orientation.y =  (PI/2.0);
    }
    else if(this.location == "BACK"){
      angle = asin(abs(this.velocity.y)/this.velocity.magnitude());
      this.orientation.z = 0;
      this.orientation.x = -PI/2.0;
      if(this.velocity.y < 0 && this.velocity.x < 0) this.orientation.y =  angle+PI/2;
      else if(this.velocity.y > 0 && this.velocity.x < 0) this.orientation.y =  (-PI/2-angle);
      else if(this.velocity.y > 0 && this.velocity.x > 0) this.orientation.y =  (-PI/2+angle);
      else if(this.velocity.y < 0 && this.velocity.x > 0) this.orientation.y =  -angle+PI/2;
      else if(this.velocity.x == 0 && this.velocity.y < 0) this.orientation.y = PI/2;
      else if(this.velocity.y == 0 && this.velocity.x < 0) this.orientation.y =  (PI);
      else if(this.velocity.x == 0 && this.velocity.y > 0) this.orientation.y =  0;
      else if(this.velocity.y == 0 && this.velocity.x > 0) this.orientation.y =  0;
    }
  }
  
  void drawFish() {
   pushMatrix();
   translate(zero.x, zero.y, zero.z);
   translate(this.position.x, this.position.y, this.position.z);
   if(this.location == "FLOOR" && hasSubstrate()){
     translate(0, -16, 0);
   }
   rotateZ(this.orientation.z);
   rotateX(this.orientation.x);
   rotateY(this.orientation.y);
   scale(this.scaleVal, this.scaleVal, this.scaleVal);
   shape(this.model);
   popMatrix();
  }
  
  public void transitionWalls(){
    if(this.location == "FLOOR"){
      if(this.position.x <= -.475*fieldX+this.dimensions.x/2.0
      && this.velocity.x < 0){
        this.position.x = -.475*fieldX;
        this.velocity.y = -.4;
        this.acceleration.y = -.3;
        this.location = "LEFT";
      }
      else if(this.position.x >= .475*fieldX-this.dimensions.x/2.0
          && this.velocity.x > 0){
        this.position.x = .475*fieldX;
        this.velocity.y = -.4;
        this.acceleration.y = -.3;
        this.location = "RIGHT";
      }
      else if(this.position.z <= -.5*fieldZ+this.dimensions.x/2.0
          && this.velocity.z < 0){
        this.position.z = -.5*fieldZ;
        this.velocity.y = -.4;
        this.acceleration.y = -.3;
        this.location = "BACK";
      }
    }
    else if(this.location == "RIGHT"){
      if(this.position.y >= .5*fieldY*waterLevel-this.dimensions.x/2.0
      && this.velocity.y > 0){
        this.position.y = .5*fieldY*waterLevel;
        this.velocity.x = -.4;
        this.acceleration.x = -.3;
        this.location = "FLOOR";
      }
      else if(this.position.z <= -.5*fieldZ+this.dimensions.x/2.0
          && this.velocity.z < 0){
        this.position.z = -.5*fieldZ;
        this.velocity.x = -.4;
        this.acceleration.x = -.3;
        this.location = "BACK";
      }
    }
    else if(this.location == "LEFT"){
      if(this.position.y >= .5*fieldY*waterLevel-this.dimensions.x/2.0
      && this.velocity.y > 0){
        this.position.y = .5*fieldY*waterLevel;
        this.velocity.x = .4;
        this.acceleration.x = .3;
        this.location = "FLOOR";
      }
      else if(this.position.z <= -.5*fieldZ+this.dimensions.x/2.0
          && this.velocity.z < 0){
        this.position.z = -.5*fieldZ;
        this.velocity.x = .4;
        this.acceleration.x = .3;
        this.location = "BACK";
      }
    }
    else if(location == "BACK"){
      if(this.position.x <= -.475*fieldX+this.dimensions.x/2.0
      && this.velocity.x < 0){
        this.position.x = -.475*fieldX;
        this.velocity.z = .4;
        this.acceleration.z = .3;
        this.location = "LEFT";
      }
      else if(this.position.x >= .475*fieldX-this.dimensions.x/2.0
          && this.velocity.x > 0){
        this.position.x = .475*fieldX;
        this.velocity.z = .4;
        this.acceleration.z = .3;
        this.location = "RIGHT";
      }
      else if(this.position.y >= .5*fieldY*waterLevel-this.dimensions.x/2.0
          && this.velocity.y > 0){
        this.position.y = .5*fieldY*waterLevel;
        this.velocity.z = .4;
        this.acceleration.z = .3;
        this.location = "FLOOR";
      }
    }
  }
}