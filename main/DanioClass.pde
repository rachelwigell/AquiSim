public class Danio extends Fish{
  public Danio(String name){
    this.species = "Danio";
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
    this.minTemp = 18;
    this.maxTemp = 28;
    this.minHard = 5;
    this.maxHard = 19;
    this.ammonia = .1;
    this.nitrite = .25;
    this.nitrate = 50;
    this.scaleVal = 12;
    this.activity = 4;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.model = loadShape("danio.obj");
    this.sprite = "graphics/danio.PNG";
    this.position = new Vector3D(0, 0, 0);
    this.absolutePosition = new Vector3D(zero.x, zero.y, zero.z);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(7.5*this.scaleVal, 2.6*this.scaleVal, 1.2*this.scaleVal);
    this.eyePosition = new Vector3D(1/3.0, 0, 1/3.0);
    this.offset = new Vector3D(0, 0, 0);
    this.setDangerRatings();
    this.region = -.1;
    this.aliveSince = new Date().getTime();
    this.happySince = new Date().getTime();
    this.schoolingCoefficient = .8;
  }
  
  
  //constructor for load
  public Danio(String[] stats, boolean alive){
    this.species = "Danio";
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
    this.size = 5;
    this.ammonia = .1;
    this.nitrite = .25;
    this.nitrate = 50;
    this.model = loadShape("danio.obj");
    this.scaleVal = 12;
    this.activity = 5;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.sprite = "graphics/danio.PNG";
    this.dimensions = new Vector3D(7.5*this.scaleVal, 2.6*this.scaleVal, 1.2*this.scaleVal);
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
    this.eyePosition = new Vector3D(1/3.0, 0, 1/3.0);
    this.offset = new Vector3D(0, 0, 0);
    this.setDangerRatings();
    this.region = -.1;
    this.schoolingCoefficient = .8;
  }
}