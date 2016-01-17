public class Platy extends Fish{
  public Platy(String name){
    this.species = "Platy";
    this.name = name;
    this.ease = 5;
    this.maxHealth = this.ease*24*60*12;
    this.health = this.maxHealth;
    this.status = "Happy.";
    this.size = 6;
    this.maxFullness = this.ease*this.size*24*60*3;
    this.fullness = this.maxFullness/2;
    this.minPH = 7;
    this.maxPH = 8.5;
    this.minTemp = 18;
    this.maxTemp = 26;
    this.minHard = 8;
    this.maxHard = 25;
    this.ammonia = .1;
    this.nitrite = .25;
    this.nitrate = 50;
    this.scaleVal = 12;
    this.activity = 4;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.model = loadShape("platy.obj");
    this.sprite = "graphics/platy.png";
    this.position = new Vector3D(0, 0, 0);
    this.absolutePosition = new Vector3D(zero.x, zero.y, zero.z);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(7.8*this.scaleVal, 3.6*this.scaleVal, 1.8*this.scaleVal);
    this.eyePosition = new Vector3D(1/5.0, 0, 1/2.5);
    this.offset = new Vector3D(0, 0, 0);
    this.setDangerRatings();
    this.region = -.1;
    this.aliveSince = new Date().getTime();
    this.happySince = new Date().getTime();
    this.schoolingCoefficient = .8;
  }
  
  
  //constructor for load
  public Platy(String[] stats, boolean alive){
    this.species = "Platy";
    this.ease = 5;
    this.maxHealth = this.ease*24*60*12;
    this.status = "Happy.";
    this.size = 6;
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
    this.model = loadShape("platy.obj");
    this.scaleVal = 12;
    this.activity = 5;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.sprite = "graphics/platy.png";
    this.dimensions = new Vector3D(7.8*this.scaleVal, 3.6*this.scaleVal, 1.8*this.scaleVal);
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
    this.eyePosition = new Vector3D(1/5.0, 0, 1/2.5);
    this.offset = new Vector3D(0, 0, 0);
    this.setDangerRatings();
    this.region = -.1;
    this.schoolingCoefficient = .8;
  }
}