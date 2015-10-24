public class Guppy extends Fish{
  public Guppy(String name){
    this.species = "Guppy";
    this.name = name;
    this.ease = 5;
    this.health = this.ease*24*60*5;
    this.maxHealth = this.ease*24*60*5;
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
    this.sprite = "graphics/guppy.png";
    this.position = new Vector3D(0, 0, 0);
    this.absolutePosition = new Vector3D(fieldX/2, fieldY/2, -fieldZ);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(80, 36, 15);
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