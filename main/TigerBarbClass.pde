public class TigerBarb extends Fish{
  public TigerBarb(String name){
    this.species = "Tiger Barb";
    this.name = name;
    this.ease = 4;
    this.maxHealth = this.ease*24*60*12;
    this.health = this.maxHealth;
    this.status = "Happy.";
    this.size = 5;
    this.maxFullness = this.ease*this.size*24*60*3;
    this.fullness = this.maxFullness;
    this.minPH = 6;
    this.maxPH = 7.5;
    this.minTemp = 20;
    this.maxTemp = 26;
    this.minHard = 4;
    this.maxHard = 20;
    this.ammonia = .1;
    this.nitrite = .25;
    this.nitrate = 50;
    this.scaleVal = 11;
    this.activity = 5;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.model = loadShape("tigerbarb.obj");
    this.sprite = "graphics/tigerbarb.png";
    this.position = new Vector3D(0, 0, 0);
    this.absolutePosition = new Vector3D(zero.x, zero.y, zero.z);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(6.7*this.scaleVal, 4.9*this.scaleVal, 1.1*this.scaleVal);
    this.eyePosition = new Vector3D(1/3.0, 0, 1/2.0);
    this.offset = new Vector3D(0, 0, 1);
    this.setDangerRatings();
    this.region = -.1;
    this.aliveSince = new Date().getTime();
    this.happySince = new Date().getTime();
    this.schoolingCoefficient = .9;
  }
  
  
  //constructor for load
  public TigerBarb(String[] stats, boolean alive){
    this.species = "Tiger Barb";
    this.ease = 4;
    this.maxHealth = this.ease*24*60*12;
    this.status = "Happy.";
    this.size = 5;
    this.maxFullness = this.ease*this.size*24*60*3;
    if(alive){
      this.name = stats[1];
      this.health = min(float(stats[2]), this.maxHealth);
      this.fullness = min(float(stats[3]), this.maxFullness);
      this.minTemp = float(stats[4]);
      this.maxTemp = float(stats[5]);
      this.minHard = float(stats[6]);
      this.maxHard = float(stats[7]);
      this.minPH = float(stats[8]);
      this.maxPH = float(stats[9]);
      this.aliveSince = stats[10];
      this.happySince = stats[11];
    }
    this.ammonia = .1;
    this.nitrite = .25;
    this.nitrate = 50;
    this.model = loadShape("tigerbarb.obj");
    this.scaleVal = 11;
    this.activity = 5;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.sprite = "graphics/tigerbarb.png";
    this.dimensions = new Vector3D(6.7*this.scaleVal, 4.9*this.scaleVal, 1.1*this.scaleVal);
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
    this.eyePosition = new Vector3D(1/3.0, 0, 1/2.0);
    this.offset = new Vector3D(0, 0, 1);
    this.setDangerRatings();
    this.region = -.1;
    this.schoolingCoefficient = .9;
  }
}