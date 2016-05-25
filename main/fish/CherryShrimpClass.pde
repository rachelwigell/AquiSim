public class CherryShrimp extends Fish{
  public CherryShrimp(String name){
    this.species = "Cherry Shrimp";
    this.name = name;
    this.ease = 5;
    this.maxHealth = this.ease*24*60*12;
    this.health = this.maxHealth;
    this.status = "Happy.";
    this.size = 3;
    this.maxFullness = this.ease*this.size*24*60*3;
    this.fullness = this.maxFullness/2;
    this.scaleVal = 25;
    this.activity = 3;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.model = loadShape("graphics/cherryshrimp.obj");
    this.sprite = "graphics/cherryshrimp.png";
    this.position = new Vector3D(0, fieldY/2, 0);
    this.absolutePosition = new Vector3D(zero.x, zero.y, zero.z);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(3.3*this.scaleVal, .6*this.scaleVal, 1.4*this.scaleVal);
    this.eyePosition = new Vector3D(1/9.0, -1/1.5, 1/8.0);
    this.offset = new Vector3D(-50, 0, 3);
    this.setDangerRatings();
    this.region = 0;
    this.aliveSince = new Date().getTime();
    this.happySince = new Date().getTime();
    this.schoolingCoefficient = .5;
    initializeTolerances(0.1, 0.25, 25, 7, 8, 15, 28, 3, 15);
  }
  
  
  //constructor for load
  public CherryShrimp(String[] stats, boolean alive){
    this.species = "Cherry Shrimp";
    this.ease = 5;
    this.maxHealth = this.ease*24*60*12;
    this.status = "Happy.";
    this.size = 3;
    this.maxFullness = this.ease*this.size*24*60*3;
    if(alive){
      this.name = stats[1];
      this.health = min(float(stats[2]), this.maxHealth);
      this.fullness = min(float(stats[3]), this.maxFullness);
      initializeTolerances(0.1, 0.25, 25, float(stats[8]), float(stats[9]), float(stats[4]), float(stats[5]), float(stats[6]), float(stats[7]));
      this.aliveSince = stats[10];
      this.happySince = stats[11];
    }
    this.model = loadShape("graphics/cherryshrimp.obj");
    this.scaleVal = 25;
    this.activity = 3;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.sprite = "graphics/cherryshrimp.png";
    this.dimensions = new Vector3D(3.3*this.scaleVal, .6*this.scaleVal, 1.4*this.scaleVal);
    this.position = new Vector3D(0, 0, 0);
    this.position.x = random((-.475*fieldX+this.dimensions.x/2.0), (.475*fieldX-this.dimensions.x/2.0));
    if(alive){
      this.position.y = fieldY/2;
    }
    else{
      this.position.y = (-.5*fieldY*waterLevel);
    }
    this.position.z = random((-.5*fieldZ+this.dimensions.x/2.0), (.5*fieldZ-this.dimensions.x/2.0));
    this.absolutePosition = this.position.addVector(new Vector3D(zero.x, zero.y, zero.z));
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.eyePosition = new Vector3D(1/9.0, -1/1.5, 1/8.0);
    this.offset = new Vector3D(-50, 0, 3);
    this.setDangerRatings();
    this.region = 0;
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
      this.acceleration.x = new Vector3D(-.8, this.acceleration.x+random(-.2, .2), .8).centermost();
      this.acceleration.y = 0;
      this.acceleration.z = new Vector3D(-.8, this.acceleration.z+random(-.2, .2), .8).centermost();
    }
    else{
      this.acceleration.x = new Vector3D(-.8, -.1*this.velocity.x, .8).centermost();
      this.acceleration.y = 0;
      this.acceleration.z = new Vector3D(-.8, -.1*this.velocity.z, .8).centermost();
    }
  }

  public void updateVelocity() {
    if(this.position.x <= (-.475*fieldX+this.dimensions.x/2.0)){
      this.acceleration.x = 1;
    }
    else if(this.position.x >= (.475*fieldX-this.dimensions.x/2.0)){
      this.acceleration.x = -1;
    }
    this.velocity.x = new Vector3D(-1, this.velocity.x + this.acceleration.x, 1).centermost();
    
    if(this.position.z == (-.5*fieldZ+this.dimensions.x/2.0)){
     this.acceleration.z = 1;
    }
    else if(this.position.z == (.5*fieldZ-this.dimensions.x/2.0)){
     this.acceleration.z = -1;
    }
    this.velocity.z = new Vector3D(-1, this.velocity.z + this.acceleration.z, 1).centermost();
    this.velocity = this.velocity.addVector(this.hungerContribution());
    this.velocity.y = 0;
    this.updateOrientationRelativeToVelocity();
    this.updateAcceleration();
    this.schoolingCoefficient = .5;
  }
  
  void drawFish() {
    noStroke();
    pushMatrix();
    translate(this.absolutePosition.x, this.absolutePosition.y, this.absolutePosition.z);
    if(hasSubstrate()){
      translate(0, -16, 0);
    }
    rotateX(this.orientation.x);
    rotateY(this.orientation.y);
    rotateZ(this.orientation.z);
    rotateX(this.rotate.x);
    rotateY(this.rotate.y);
    rotateZ(this.rotate.z);
    translate(this.offset.x, this.offset.y, this.offset.z);
    scale(this.scaleVal, this.scaleVal, this.scaleVal);
    shape(this.model);
    //draw eyes
    fill(0);
    sphereDetail(8);
    scale(1/this.scaleVal, 1/this.scaleVal, 1/this.scaleVal);
    translate(-this.offset.x, -this.offset.y, -this.offset.z);
    translate(this.dimensions.x*this.eyePosition.x, this.dimensions.y*this.eyePosition.y, this.dimensions.z*this.eyePosition.z);
    sphere(2.5);
    translate(0, 0, -2*this.dimensions.z*this.eyePosition.z);
    sphere(2.5);
    popMatrix();
  }
}