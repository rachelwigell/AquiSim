public class Guppy extends Fish{
  public Guppy(String name){
    this.species = "Guppy";
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
    this.minTemp = 20;
    this.maxTemp = 29;
    this.minHard = 8;
    this.maxHard = 20;
    this.ammonia = 1;
    this.nitrite = 5;
    this.nitrate = 60;
    this.model = setModel();
    this.sprite = "graphics/guppy.PNG";
    this.position = new Vector3D(0, 0, 0);
    this.absolutePosition = new Vector3D(zero.x, zero.y, zero.z);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(80, 36, 15);
    this.setDangerRatings();
  }
  
  
  //constructor for load
  public Guppy(String[] stats, boolean alive){
    this.species = "Guppy";
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
    this.model = setModel();
    this.sprite = "graphics/guppy.PNG";
    this.dimensions = new Vector3D(80, 36, 15);
    this.position = new Vector3D(0, 0, 0);
    this.position.x = random((-.475*fieldX+this.dimensions.x/2.0), (.475*fieldX-this.dimensions.x/2.0));
    this.position.y = random((-.5*fieldY*waterLevel+this.dimensions.y/2.0), (.5*fieldY*waterLevel-this.dimensions.y/2.0));
    this.position.z = random((-.5*fieldZ+this.dimensions.x/2.0), (.5*fieldZ-this.dimensions.x/2.0));
    this.absolutePosition = this.position.addVector(new Vector3D(zero.x, zero.y, zero.z));
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.setDangerRatings();
  }
  
  public ArrayList setModel(){
    ArrayList model = new ArrayList();
    model.add(new Vector3D(0, 250, 154));
    model.add(new Vector3D(0, 250, 154));
    model.add(new Vector3D(255, 140, 0));
    model.add(new Vector3D(255, 140, 0));
    model.add(new Vector3D(72, 61, 139));
    model.add(new Vector3D(72, 61, 139));
    model.add(new Vector3D(72, 61, 139));
    model.add(new Vector3D(72, 61, 139));
    model.add(new Vector3D(72, 61, 139));
    model.add(new Vector3D(72, 61, 139));
    model.add(new Vector3D(186, 185, 162));
    model.add(new Vector3D(186, 185, 162));
    model.add(new Vector3D(186, 185, 162));
    model.add(new Vector3D(72, 61, 139));
    model.add(new Vector3D(72, 61, 139));
    model.add(new Vector3D(186, 185, 162));
    model.add(new Vector3D(186, 185, 162));
    model.add(new Vector3D(186, 185, 162));
    model.add(new Vector3D(186, 185, 162));
    model.add(new Vector3D(186, 185, 162));
    model.add(new Vector3D(186, 185, 162));
    model.add(new Vector3D(186, 185, 162));
    model.add(new Vector3D(186, 185, 162));
    return model;
  }
}