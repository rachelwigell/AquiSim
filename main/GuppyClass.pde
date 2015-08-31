public class Guppy extends Fish{
  public Guppy(String name){
    this.species = "Guppy";
    this.name = name;
    this.ease = 5;
    this.health = this.ease*24*60*5;
    this.maxHealth = this.ease*24*60*5;
    this.status = "Happy.";
    this.maxFullness = this.ease*24*60*5;
    this.fullness = this.maxHappyFull;
    this.size = 5;
    this.minPH = 7;
    this.maxPH = 8.5;
    this.minTemp = 20;
    this.maxTemp = 29;
    this.minHard = 8;
    this.maxHard = 20;
    this.ammonia = 10;
    this.nitrite = 10;
    this.nitrate = 60;
    //this.model = new OBJModel(window, "graphics/endlerslivebearer.obj", Visual.POLYGON);
    //this.sprite = "graphics/endlerslivebearer.png";
    //this.model.scale(10);
    //this.model.translateToCenter();
    this.position = new Vector3D(0, 0, 0);
    this.velocity = new Vector3D(0, 0, 0);
    this.acceleration = new Vector3D(0, 0, 0);
    this.orientation = new Vector3D(0, 0, 0);
    this.dimensions = new Vector3D(60, 22, 9);
  }
}
