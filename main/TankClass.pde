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
    this.o2 = 3; //temp/2
    this.co2 = 3; //temp/2
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
    float pH = .0001*this.pH*(14-this.pH)*(-.01*this.co2 - .1*this.ammonia)/(pow(10, abs(this.pH-7.0))*this.volume/this.hardness);
    return pH;
  }

  public float changeTemp(){
    this.roomTemp = 22 + 3*sin(pi/720.0*this.time-pi/2.0); //22 +/- 3
    float temp = .00005*this.surfaceArea*(roomTemp - this.temp)/this.volume; //no heater feature yet
    return temp;  
  }

  public float changeHard(){
    float hardness = -.0008*this.co2*this.hardness/this.volume + .00001*this.surfaceArea/this.hardness; //assuming stones on bottom of tank
    return hardness;
  }

  public float changeO2(){
    float photosynthesis = (.5 + .5*sin(pi/720.0*this.time-pi/2.0))*this.plants.size()*this.co2; //check this
    float respiration = (this.cmFish+this.plants.size())*this.o2; // and this
    float o2 = .02*(photosynthesis-respiration+.01*this.surfaceArea)/(this.volume+5*(this.o2+this.co2)+this.temp);
    return o2;
  }

  public float changeCO2(){
    float photosynthesis = (.5+.5*sin(pi/720.0*this.time-pi/2.0))*this.plants.size()*this.co2;
    float respiration = (this.cmFish+this.plants.size())*this.o2;
    float co2 = .015*(photosynthesis-respiration+.01*this.surfaceArea)/(this.volume+5*(this.o2+this.co2)+this.temp);
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

  public int changeWaste(){
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
  
  public Tank waterChange(double percent){
    percent = .01*percent;
    this.pH = Math.log10(percent*Math.pow(10, 8) + (1-percent)*Math.pow(10, this.pH));
    this.temp = percent*24 + (1-percent)*this.temp;
    this.hardness = percent*6 + (1-percent)*this.hardness;
    this.o2 = percent*3 + (1-percent)*this.o2;
    this.co2 = percent*3 + (1-percent)*this.co2;
    this.ammonia = percent*0 + (1-percent)*this.ammonia;
    this.nitrite = percent*0 + (1-percent)*this.nitrite;
    this.nitrate = percent*0 + (1-percent)*this.nitrate;
    this.nitrosomonas = (percent*.2)*.01 + (1-(percent*.2))*this.nitrosomonas;
    this.nitrobacter = (percent*.2)*.01 + (1-(percent*.2))*this.nitrobacter;
    return this;
  }
  
  public String fishHappiness(Fish f){
    if(f.fullness <= 0){
      f.status = "Hungry!";
    }
    else if(this.ammonia > f.ammonia){
      f.status = "Ammonia too high.";
    }
    else if(this.nitrite > f.nitrite){
      f.status = "Nitrite too high.";
    }
    else if(this.nitrate > f.nitrate){
      f.status = "Nitrate too high.";
    }
    else if(this.pH < f.minPH){
      f.status = "pH too low.";
    }
    else if(this.pH > f.maxPH){
      f.status = "pH too high.";
    }
    else if(this.temp < f.minTemp){
      f.status = "Temperature too low.";
    }
    else if(this.temp > f.maxTemp){
      f.status = "Temperature too high.";
    }
    else if(this.hardness < f.minHard){
      f.status = "Hardness too low.";
    }
    else if(this.hardness > f.maxHard){
      f.status = "Hardness too high.";
    }
    else{ //if none of the above, then  it's happy
      f.status = "Happy.";
    }
    return f.status;
  }
  
  public void progress(){
    //per fish operations
    for(Fish f: this.fish){
      f.changeHunger(); //update fish's hunger level 
      this.fishHappiness(f); //update fish's happiness status
      f.setHealth(); //update fish's health
      //f.handleDeceased(visual); //check if fish is dead and perform necessary operations if so
    }

    //tank operations
    float cmFish = this.changeFish();
    float pH = new Vector3D(.01, this.pH + timeScale * this.changePH(), 13.99).centermost();
    float temp = this.temp + timeScale * this.changeTemp();
    float hardness = max(this.hardness + timeScale * this.changeHard(), .01);
    float o2 = new Vector3D(.01, this.o2 + timeScale * this.changeO2(), 1000000).centermost();
    float co2 = new Vector3D(.01, this.co2 + timeScale * this.changeCO2(), 1000000).centermost();
    float ammonia = new Vector3D(0, this.ammonia + timeScale * this.changeAmmonia(), 1000000).centermost();
    float nitrite = new Vector3D(0, this.nitrite + timeScale * this.changeNitrite(), 1000000).centermost();
    float nitrate = new Vector3D(0, this.nitrate + timeScale * this.changeNitrate(), 1000000).centermost();
    float nitrosomonas = new Vector3D(.01, this.nitrosomonas + timeScale * this.changeNitrosomonas(), 1000000).centermost();
    float nitrobacter = new Vector3D(.01, this.nitrobacter + timeScale * this.changeNitrobacter(), 1000000).centermost();
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
  
  public Vector3D nearestFood(Vector3D position){
    Vector3D closest = null;
    float distance = MAX_FLOAT;
    for(int i = 0; i < this.food.size(); i++){
      Food f = (Food) this.food.get(i);
      float fDistance = f.position.squareDistance(position);
      if(fDistance < distance){
        distance = fDistance;
        closest = f.position;
      }
    }
    return closest;
  }
  
  public boolean eat(Fish fish, Food food){
    if(fish.position.distance(food.position) < food.dimensions.x*4){
      fish.fullness = min(fish.fullness+fish.ease*1800, fish.maxFullness);
      return true;
    }
    return false;
  }
  
  public void allEat(){
    ArrayList eaten = new ArrayList();
    for(int i = 0; i < this.fish.size(); i++){
      Fish aFish = (Fish) this.fish.get(i);
      for(int j = 0; j < this.food.size(); j++){
        Food aFood = (Food) this.food.get(j);
        if(this.eat(aFish, aFood)){
          eaten.add(aFood);
        }
      }
      for(int i = 0; i < eaten.size(); i++){
        Food aFood = (Food) eaten.get(i);
        this.food.remove(aFood);
      }
    }
  }

}
