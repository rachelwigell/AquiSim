public class NeonTetra extends Fish{
  public NeonTetra(String name){
    this.species = "Neon Tetra";
    this.name = name;
    this.ease = 4;
    this.maxHealth = this.ease*24*60*12;
    this.health = this.maxHealth;
    this.status = "Happy.";
    this.size = 4;
    this.maxFullness = this.ease*this.size*24*60*3;
    this.fullness = this.maxFullness/2;
    this.scaleVal = 8;
    this.activity = 4;
    this.swimming = true;
    this.rotate = new Vector3D(0, PI, 0);
    this.model = loadShape("graphics/neontetra.obj");
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
    this.region = .1;
    this.aliveSince = new Date().getTime();
    this.happySince = new Date().getTime();
    this.schoolingCoefficient = .8;
    initializeTolerances(0.05, 0.1, 25, 5, 7.5, 20, 26, 1, 12);
  }
  
  
  //constructor for load
  public NeonTetra(String[] stats, boolean alive){
    this.species = "Neon Tetra";
    this.ease = 4;
    this.maxHealth = this.ease*24*60*12;
    this.status = "Happy.";
    this.size = 4;
    this.maxFullness = this.ease*this.size*24*60*3;
    if(alive){
      this.name = stats[1];
      this.health = min(float(stats[2]), this.maxHealth);
      this.fullness = min(float(stats[3]), this.maxFullness);
      initializeTolerances(0.05, 0.1, 25, float(stats[8]), float(stats[9]), float(stats[4]), float(stats[5]), float(stats[6]), float(stats[7]));
      this.aliveSince = stats[10];
      this.happySince = stats[11];
    }
    this.model = loadShape("graphics/neontetra.obj");
    this.scaleVal = 8;
    this.activity = 5;
    this.swimming = true;
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
    this.region = .1;
    this.schoolingCoefficient = .8;
  }
}