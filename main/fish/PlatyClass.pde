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
    this.scaleVal = 12;
    this.activity = 4;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.model = loadShape("graphics/platy.obj");
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
    initializeTolerances(0.1, 0.25, 50, 7, 8.5, 18, 26, 8, 25);
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
      initializeTolerances(0.1, 0.25, 50, float(stats[8]), float(stats[9]), float(stats[4]), float(stats[5]), float(stats[6]), float(stats[7]));
      this.aliveSince = stats[10];
      this.happySince = stats[11];
    }
    this.model = loadShape("graphics/platy.obj");
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