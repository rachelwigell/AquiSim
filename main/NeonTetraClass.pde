public class NeonTetra extends Fish{
  public NeonTetra(String name){
    this.species = "Neon Tetra";
    this.name = name;
    this.ease = 4;
    this.maxHealth = this.ease*24*60*5;
    this.health = this.maxHealth;
    this.status = "Happy.";
    this.maxFullness = this.ease*24*60*5;
    this.fullness = this.maxFullness;
    this.size = 4;
    this.minPH = 5;
    this.maxPH = 7.5;
    this.minTemp = 20;
    this.maxTemp = 26;
    this.minHard = 1;
    this.maxHard = 12;
    this.ammonia = 0.1;
    this.nitrite = 0.1;
    this.nitrate = 25;
    this.scaleVal = 8;
    this.rotate = new Vector3D(0, PI, 0);
    this.model = loadShape("neontetra.obj");
    this.sprite = "graphics/neontetra.PNG";
    this.position = new Vector3D(0, 0, 0);
    this.absolutePosition = new Vector3D(zero.x, zero.y, zero.z);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(9.5*this.scaleVal, 3.8*this.scaleVal, 1.4*this.scaleVal);
    this.eyePosition = new Vector3D(1/3.0, 0, 1/2.4);
    this.offset = new Vector3D(0, 0, 1);
    this.setDangerRatings();
  }
  
  
  //constructor for load
  public NeonTetra(String[] stats, boolean alive){
    this.species = "Neon Tetra";
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
    this.ease = 4;
    this.maxHealth = this.ease*24*60*5;
    this.status = "Happy.";
    this.maxFullness = this.ease*24*60*5;
    this.size = 4;
    this.ammonia = 0.1;
    this.nitrite = 0.1;
    this.nitrate = 25;
    this.model = loadShape("neontetra.obj");
    this.scaleVal = 8;
    this.rotate = new Vector3D(0, PI, 0);
    this.sprite = "graphics/neontetra.PNG";
    this.dimensions = new Vector3D(9.5*this.scaleVal, 3.8*this.scaleVal, 1.4*this.scaleVal);
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
    this.eyePosition = new Vector3D(1/3.0, 0, 1/2.4);
    this.offset = new Vector3D(0, 0, 1);
    this.setDangerRatings();
  }
}