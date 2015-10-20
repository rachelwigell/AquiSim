public abstract class Fish {
  public String species;
  public String name;
  public String status;
  public long fullness;
  public long maxFullness;
  public long maxHealth;
  public long health;
  public int ease;
  public double size;
  public double minPH;
  public double maxPH;
  public double minTemp;
  public double maxTemp;
  public double minHard;
  public double maxHard;
  public double ammonia;
  public double nitrite;
  public double nitrate;
  //public PShape model;
  public ArrayList model;
  public String sprite;
  public Vector3D position;
  public Vector3D orientation;
  public Vector3D dimensions;
  public Vector3D velocity;
  public Vector3D acceleration;
  
  public int setHealth(){
    if(this.status == "Happy."){
      this.health = min(this.maxHealth, this.health+1);
    }
    else{
     this.health  = max(0, this.health-1);
    }
    return this.health;
  }

  public long changeHunger(){
    int hunger = (int) (this.size/2); //hunger changes relative to fish size
    this.fullness = Math.max(this.fullness - hunger, 0);
    return hunger;
  }
}
