public class WhiteCloudMountainMinnow extends Fish{
  public WhiteCloudMountainMinnow(String name){
    this.species = "White Cloud Mountain Minnow";
    this.name = name;
    this.ease = 5;
    this.maxHealth = this.ease*24*60*5;
    this.health = this.maxHealth;
    this.status = "Happy.";
    this.maxFullness = this.ease*24*60*5;
    this.fullness = this.maxFullness;
    this.size = 4;
    this.minPH = 6;
    this.maxPH = 8.5;
    this.minTemp = 7;
    this.maxTemp = 24;
    this.minHard = 5;
    this.maxHard = 25;
    this.ammonia = 1;
    this.nitrite = 5;
    this.nitrate = 60;
    this.scaleVal = 6;
    this.rotate = new Vector3D(0, 0, 0);
    this.model = loadShape("whitecloudmountainminnow.obj");
    this.sprite = "graphics/whitecloudmountainminnow.PNG";
    this.position = new Vector3D(0, 0, 0);
    this.absolutePosition = new Vector3D(zero.x, zero.y, zero.z);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(12*this.scaleVal, 4.6*this.scaleVal, 1.4*this.scaleVal);
    this.eyePosition = new Vector3D(-1/3.0, 0, 1/2.5);
    this.offset = new Vector3D(0, 0, 0);
    this.setDangerRatings();
  }
  
  
  //constructor for load
  public WhiteCloudMountainMinnow(String[] stats, boolean alive){
    this.species = "White Cloud Mountain Minnow";
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
    this.size = 4;
    this.ammonia = 1;
    this.nitrite = 5;
    this.nitrate = 60;
    this.model = loadShape("whitecloudmountainminnow.obj");
    this.scaleVal = 6;
    this.rotate = new Vector3D(0, 0, 0);
    this.sprite = "graphics/whitecloudmountainminnow.PNG";
    this.dimensions = new Vector3D(12*this.scaleVal, 4.6*this.scaleVal, 1.4*this.scaleVal);
    this.position = new Vector3D(0, 0, 0);
    this.position.x = random((-.475*fieldX+this.dimensions.x/2.0), (.475*fieldX-this.dimensions.x/2.0));
    if(alive){
      this.position.y = random((-.5*fieldY*waterLevel+this.dimensions.y/2.0), (.5*fieldY*waterLevel-this.dimensions.y/2.0));
    }
    else{
      this.position.y = (-.5*fieldY*waterLevel);
    }
    this.position.z = random((-.5*fieldZ+this.dimensions.x/2.0), (.5*fieldZ-this.dimensions.x/2.0));
    this.absolutePosition = this.position.addVector(new Vector3D(zero.x, zero.y, zero.z));
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.eyePosition = new Vector3D(-1/3.0, 0, 1/2.5);
    this.offset = new Vector3D(0, 0, 0);
    this.setDangerRatings();
  }
}