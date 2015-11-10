public class MysterySnail extends Fish{
  public MysterySnail(String name){
    this.species = "Mystery Snail";
    this.name = name;
    this.ease = 5;
    this.maxHealth = this.ease*24*60*5;
    this.health = this.maxHealth;
    this.status = "Happy.";
    this.maxFullness = this.ease*24*60*5;
    this.fullness = this.maxFullness;
    this.size = 5;
    this.minPH = 7;
    this.maxPH = 8.5;
    this.minTemp = 18;
    this.maxTemp = 27;
    this.minHard = 5;
    this.maxHard = 20;
    this.ammonia = 1;
    this.nitrite = 5;
    this.nitrate = 60;
    this.scaleVal = 10;
    this.activity = 1;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.model = loadShape("mysterysnail.obj");
    this.sprite = "graphics/mysterysnail.png";
    this.position = new Vector3D(0, fieldY/2, 0);
    this.absolutePosition = new Vector3D(zero.x, zero.y, zero.z);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(7.2*this.scaleVal, 5.8*this.scaleVal, 5.4*this.scaleVal);
    this.eyePosition = new Vector3D(0, 0, 0);
    this.offset = new Vector3D(0, 20, 0);
    this.setDangerRatings();
  }
  
  
  //constructor for load
  public MysterySnail(String[] stats, boolean alive){
    this.species = "Mystery Snail";
    if(alive){
      this.name = stats[1];
      this.health = float(stats[2]);
      this.fullness = float(stats[3]);
      this.minTemp = float(stats[4]);
      this.maxTemp = float(stats[5]);
      this.minHard = float(stats[6]);
      this.maxHard = float(stats[7]);
      this.minPH = float(stats[8]);
      this.maxPH = float(stats[9]);
    }
    this.ease = 5;
    this.maxHealth = this.ease*24*60*5;
    this.status = "Happy.";
    this.maxFullness = this.ease*24*60*5;
    this.size = 5;
    this.ammonia = 1;
    this.nitrite = 5;
    this.nitrate = 60;
    this.model = loadShape("mysterysnail.obj");
    this.scaleVal = 10;
    this.activity = 3;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.sprite = "graphics/mysterysnail.png";
    this.dimensions = new Vector3D(7.2*this.scaleVal, 5.8*this.scaleVal, 5.4*this.scaleVal);
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
    this.eyePosition = new Vector3D(0, 0, 0);
    this.offset = new Vector3D(0, 20, 0);
    this.setDangerRatings();
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
      this.acceleration.x = new Vector3D(-.3, this.acceleration.x+random(-.1, .1), .3).centermost();
      this.acceleration.y = 0;
      this.acceleration.z = new Vector3D(-.3, this.acceleration.z+random(-.1, .1), .3).centermost();
    }
    else{
      this.acceleration.x = new Vector3D(-.3, -.1*this.velocity.x, .3).centermost();
      this.acceleration.y = 0;
      this.acceleration.z = new Vector3D(-.3, -.1*this.velocity.z, .3).centermost();
    }
  }

  public void updateVelocity() {
    if(this.position.x <= (-.475*fieldX+this.dimensions.x/2.0)){
      this.acceleration.x = 1;
    }
    else if(this.position.x >= (.475*fieldX-this.dimensions.x/2.0)){
      this.acceleration.x = -1;
    }
    this.velocity.x = new Vector3D(-.4, this.velocity.x + this.acceleration.x, .4).centermost();
    
    if(this.position.z == (-.5*fieldZ+this.dimensions.x/2.0)){
     this.acceleration.z = 1;
    }
    else if(this.position.z == (.5*fieldZ-this.dimensions.x/2.0)){
     this.acceleration.z = -1;
    }
    this.velocity.z = new Vector3D(-.4, this.velocity.z + this.acceleration.z, .4).centermost();
    this.velocity = this.velocity.addVector(this.hungerContribution());
    this.velocity.y = 0;
    this.updateOrientationRelativeToVelocity();
    this.updateAcceleration();
  }
}