public class CoryCatfish extends Fish{
  public CoryCatfish(String name){
    this.species = "Cory Catfish";
    this.name = name;
    this.ease = 5;
    this.maxHealth = this.ease*24*60*12;
    this.health = this.maxHealth;
    this.status = "Happy.";
    this.size = 6;
    this.maxFullness = this.ease*this.size*24*60*3;
    this.fullness = this.maxFullness/2;
    this.scaleVal = 10;
    this.activity = 3;
    this.swimming = true;
    this.rotate = new Vector3D(0, 0, 0);
    this.model = loadShape("graphics/corycatfish.obj");
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
    this.schoolingCoefficient = .6;
    initializeTolerances(0.1, 0.25, 50, 6, 8, 21, 27, 5, 18);
  }
  
  
  //constructor for load
  public CoryCatfish(String[] stats, boolean alive){
    this.species = "Cory Catfish";
    this.ease = 5;
    this.maxHealth = this.ease*24*60*12;
    this.status = "Happy.";
    this.size = 6;
    this.maxFullness = this.ease*this.size*24*60*3;
    if(alive){
      this.name = stats[1];
      this.health = min(float(stats[2]), this.maxHealth);
      this.fullness = min(float(stats[3]), this.maxFullness);
      initializeTolerances(0.1, 0.25, 50, float(stats[8]), float(stats[9]), float(stats[4]), float(stats[5]), float(stats[6]), float(stats[7]));
      this.aliveSince = stats[10];
      this.happySince = stats[11];
    }
    this.model = loadShape("graphics/corycatfish.obj");
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
    this.schoolingCoefficient = .6;
  }
}