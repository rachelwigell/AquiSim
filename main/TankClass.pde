public class Tank{
  public float cmFish; //cm
  public float pH; //unitless
  public float temp; //degrees C
  public float roomTemp; //degrees C
  public float hardness; //ppm
  public float o2; //percent
  public float co2; //percent
  public float ammonia; //ppm
  public float nitrite; //ppm
  public float nitrate; //ppm
  public float nitrosomonas; //bacteria
  public float nitrobacter; //bacteria
  public int waste; //poops
  public int time; //min
  public ArrayList fish;
  public ArrayList poops;
  public ArrayList food;
  public ArrayList deadFish;
  public ArrayList plants;
  public String name;

  public final float pi = 3.14159;
  public final float waterLevel = .75;
  public final float timeScale = .01; //higher = harder
  public final float volume = waterLevel*60*30*40/1000.0;
  public final float surfaceArea = 60*30;
  
  public Tank(){
    this.cmFish = 0;
    this.plants = new ArrayList();
    this.pH=8;
    this.temp = 24;
    this.roomTemp = 22;
    this.hardness = 6;
    this.o2 = 11; //temp/2
    this.co2 = 11; //temp/2
    this.ammonia = 0;
    this.nitrite = 0;
    this.nitrate = 0;
    this.nitrosomonas = .01;
    this.nitrobacter = .01;
    this.waste = 0;
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
  
  public void addFish(Fish aFish){
    this.fish.add(aFish);
    this.cmFish = this.cmFish + aFish.size;
  }
  
  public float changeFish(){
    float cmFish = 0;
    for(Fish f: this.fish){
      cmFish = cmFish + f.size;
    }
    return cmFish;
  }
  
  public float changePH(){
    float pH = .001*this.pH*(14-this.pH)*(-.01*this.co2 - .1*this.ammonia + .16*this.hardness)/(pow(10, abs(this.pH-7.0))*this.volume);
    return pH;
  }

  public float changeTemp(){
    this.roomTemp = 22 + 3*sin(pi/720.0*this.time-pi/2.0); //22 +/- 3
    float temp = .001*this.surfaceArea*(roomTemp - this.temp)/this.volume; //no heater feature yet
    return temp;  
  }

  public float changeHard(){
    float hardness = -.1*this.co2*this.hardness/this.volume + .003*this.surfaceArea/this.hardness; //assuming stones on bottom of tank
    return hardness;
  }

  public float changeO2(){
    float photosynthesis = (.5 + .5*sin(pi/720.0*this.time-pi/2.0))*this.plants.size()*this.co2; //check this
    float respiration = (this.cmFish+this.plants.size())*this.o2; // and this
    float o2 = .2*(photosynthesis-respiration+this.surfaceArea)/this.volume+(this.o2+this.co2)*((100-this.temp)-(this.o2+this.co2))/this.volume;
    return o2;
  }

  public float changeCO2(){
    float photosynthesis = (.5+.5*sin(pi/720.0*this.time-pi/2.0))*this.plants.size()*this.co2;
    float respiration = (this.cmFish+this.plants.size())*this.o2;
    float co2 = .15*(respiration-photosynthesis+this.surfaceArea)/this.volume+(this.co2+this.o2)*((100-this.temp)-(this.co2+this.o2))/this.volume;
    return co2;
  }

  public float changeAmmonia(){
    float ammonia = (.1*this.temp*this.pH*(this.waste + this.food.size() + .5*this.cmFish) - .1*this.nitrosomonas*this.ammonia)/this.volume;
    return ammonia;
  }

  public float changeNitrite(){
    float nitrite = (.2*this.ammonia*this.nitrosomonas - .2*this.nitrite*this.nitrobacter)/this.volume;
    return nitrite;
  }

  public float changeNitrate(){
    float nitrate = (.2*this.nitrite*this.nitrobacter-10*this.plants.size()*this.nitrate)/this.volume;
    return nitrate;
  }

  public float changeNitrosomonas(){
    float nitrosomonas = .002*this.ammonia*this.nitrosomonas-.0019*this.nitrosomonas;
    return nitrosomonas;
  }

  public float changeNitrobacter(){
    float nitrobacter = .002*this.nitrite*this.nitrobacter-.0019*this.nitrobacter;
    return nitrobacter;
  }
  
  public void addFood(Food food){
    this.food.add(food);
  }

  public int changeWaste(l){
    int waste = 0;
    for(Fish f: this.fish){
      int threshold = (int) (((float) max(f.fullness, 0)) / ((float) f.maxFullness) * f.size/2.0);
      int rand = random(2000);
      if(rand < threshold){
        waste++;
        //addPoop(visual, f);
      }
    }
    return waste;
  }
  
  public void progress(){
    //per fish operations
    for(Fish f: this.fish){
      //f.changeHunger(); //update fish's hunger level 
      //f.happy(this); //update fish's happiness status
      //f.setHealth(); //update fish's health
      //f.handleDeceased(visual); //check if fish is dead and perform necessary operations if so
    }

    //tank operations
    float cmFish = this.changeFish();
    float pH = this.pH + timeScale * this.changePH();
    if(pH <=0) pH = .01;
    else if(pH >=14) pH = 13.99;
    float temp = this.temp + timeScale * this.changeTemp();
    float hardness = max(this.hardness + timeScale * this.changeHard(), .01);
    float o2 = max(this.o2 + timeScale * this.changeO2(), .01);
    float co2 = max(this.co2 + timeScale * this.changeCO2(), .01);
    float ammonia = min(max(this.ammonia + timeScale * this.changeAmmonia(), 0), 1000000);
    float nitrite = min(max(this.nitrite + timeScale * this.changeNitrite(), 0), 1000000);
    float nitrate = min(max(this.nitrate + timeScale * this.changeNitrate(), 0), 1000000);
    float nitrosomonas = min(max(this.nitrosomonas + timeScale * this.changeNitrosomonas(), .01), 1000000);
    float nitrobacter = min(max(this.nitrobacter + timeScale * this.changeNitrobacter(), .01), 1000000);
    int waste = this.waste + this.changeWaste();
    int time = this.getTime();

    //do assignment after so that all calculations are accurate
    this.cmFish = cmFish;
    this.pH = pH;
    this.temp = temp;
    this.hardness = hardness;
    this.o2 = o2;
    this.co2 = co2;
    this.ammonia = ammonia;
    this.nitrite = nitrite;
    this.nitrate = nitrate;
    this.nitrosomonas = nitrosomonas;
    this.nitrobacter = nitrobacter;
    this.waste = waste;
    this.time = time;
  }

}
