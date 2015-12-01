public class CoryCatfish extends Fish{
  public CoryCatfish(String name){
    this.species = "Cory Catfish";
    this.name = name;
    this.ease = 5;
    this.maxHealth = this.ease*24*60*5;
    this.health = this.maxHealth;
    this.status = "Happy.";
    this.maxFullness = this.ease*24*60*5;
    this.fullness = this.maxFullness;
    this.size = 6;
    this.minPH = 6;
    this.maxPH = 8;
    this.minTemp = 21;
    this.maxTemp = 27;
    this.minHard = 5;
    this.maxHard = 18;
    this.ammonia = .1;
    this.nitrite = .25;
    this.nitrate = 50;
    this.scaleVal = 10;
    this.activity = 3;
    this.swimming = true;
    this.rotate = new Vector3D(0, 0, 0);
    this.model = loadShape("corycatfish.obj");
    this.sprite = "graphics/corycatfish.png";
    this.position = new Vector3D(0, 0, 0);
    this.absolutePosition = new Vector3D(zero.x, zero.y, zero.z);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(9.7*this.scaleVal, 3.6*this.scaleVal, 2.9*this.scaleVal);
    this.eyePosition = new Vector3D(-1/5.0, -1/5.0, 1/3.5);
    this.offset = new Vector3D(0, 0, 0);
    this.setDangerRatings();
    this.region = .7;
    this.aliveSince = new Date().getTime();
    this.happySince = new Date().getTime();
  }
  
  
  //constructor for load
  public CoryCatfish(String[] stats, boolean alive){
    this.species = "Cory Catfish";
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
      this.aliveSince = stats[10];
      this.happySince = stats[11];
    }
    this.ease = 5;
    this.maxHealth = this.ease*24*60*5;
    this.status = "Happy.";
    this.maxFullness = this.ease*24*60*5;
    this.size = 6;
    this.ammonia = .1;
    this.nitrite = .25;
    this.nitrate = 50;
    this.model = loadShape("corycatfish.obj");
    this.scaleVal = 10;
    this.activity = 3;
    this.swimming = true;
    this.rotate = new Vector3D(0, 0, 0);
    this.sprite = "graphics/corycatfish.png";
    this.dimensions = new Vector3D(9.7*this.scaleVal, 3.6*this.scaleVal, 2.9*this.scaleVal);
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
    this.eyePosition = new Vector3D(-1/5.0, -1/5.0, 1/3.5);
    this.offset = new Vector3D(0, 0, 0);
    this.setDangerRatings();
    this.region = .7;
  }
}