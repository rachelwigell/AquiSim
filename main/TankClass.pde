public class Tank{
  public double cmFish; //cm
  public double pH; //unitless
  public double temp; //degrees C
  public double hardness; //ppm
  public double o2; //percent
  public double co2; //percent
  public double ammonia; //ppm
  public double nitrite; //ppm
  public double nitrate; //ppm
  public double nitrosomonas; //bacteria
  public double nitrobacter; //bacteria
  public int waste; //poops
  public double volume; //L
  public int surfaceArea; //square cm
  public int time; //min
  public ArrayList fish;
  public ArrayList poops;
  public ArrayList food;
  public ArrayList deadFish;
  public ArrayList plants;
  public String name;

  public final double roomTemp = 22;
  public final double pi = 3.14159;
  public final double waterLevel = .75;
  public final double timeScale = .01; //higher = harder
  
  public Tank(){
    this.cmFish = 0;
    this.plants = new ArrayList();
    this.pH=8;
    this.temp = 24;
    this.hardness = 6;
    this.o2 = 11; //temp/2
    this.co2 = 11; //temp/2
    this.ammonia = 0;
    this.nitrite = 0;
    this.nitrate = 0;
    this.nitrosomonas = .01;
    this.nitrobacter = .01;
    this.waste=0;
    this.time = getTime();
    this.fish = new ArrayList();
    this.poops = new ArrayList();
    this.food = new ArrayList();
    this.deadFish = new ArrayList();
    this.name = "";
  }
  
  public int getTime(){
    Date date = new Date();
    return 60 * date.getHours() + date.getMinutes();
  }

}
