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
  public final float timeScale = .01; //higher = harder
  public final float volume = waterLevel*60*30*40/1000.0;
  public final float surfaceArea = 60*30;
  
  public Tank(){  
    this.cmFish = 0;
    this.plants = new ArrayList();
    this.pH=8;
    this.temp = 24;
    this.roomTemp = 22;
    this.hardness = 8;
    this.o2 = 3; //temp/2
    this.co2 = 3; //temp/2
    this.ammonia = 0;
    this.nitrite = 0;
    this.nitrate = 0;
    this.nitrosomonas = 1;
    this.nitrobacter = 1;
    this.waste = 0;
    this.time = getTime();
    this.fish = new ArrayList();
    this.poops = new ArrayList();
    this.food = new ArrayList();
    this.deadFish = new ArrayList();
    this.name = "";
  }
  
  public Tank(String cookieString){ 
    String[] stats = splitTokens(cookieString, "/");
    this.cmFish = 0;
    this.plants = new ArrayList();
    this.pH = float(stats[0]);
    this.temp = float(stats[1]);
    this.roomTemp = 22;
    this.hardness = float(stats[2]);
    this.o2 = float(stats[6]);
    this.co2 = float(stats[7]);
    this.ammonia = float(stats[3]);
    this.nitrite = float(stats[4]);
    this.nitrate = float(stats[5]);
    this.nitrosomonas = float(stats[8]);
    this.nitrobacter = float(stats[9]);
    this.waste = 0;
    this.time = getTime();
    this.fish = new ArrayList();
    for(int i = 0; i < 20; i++){
      cookie = get_cookie("f_" + i);
      if(cookie != ""){
        String[] fishStats = splitTokens(cookie, "/");
        if(fishStats[0] == "Guppy"){
          this.fish.add(new Guppy(fishStats, true)); 
        }
      }
    }
    this.poops = new ArrayList();
    for(int i = 0; i < float(stats[11]); i++){
      this.poops.add(new Poop());
      this.waste++;
    }
    this.food = new ArrayList();
    for(int i = 0; i < float(stats[10]); i++){
      this.food.add(new Food());
    }
    this.deadFish = new ArrayList();
    for(int i = 0; i < 20; i++){
      cookie = get_cookie("d_" + i);
      if(cookie != ""){
        String[] fishStats = splitTokens(cookie, "/");
        if(fishStats[0] == "Guppy"){
          this.deadFish.add(new DeadFish(new Guppy(fishStats, false))); 
          this.waste += 5;
        }
      }
    }
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
    float temp = .001*this.surfaceArea*(roomTemp - this.temp)/this.volume;
    return temp;  
  }

  public float changeHard(){
    float hardness = -.0008*this.co2*this.hardness/this.volume + .000002*this.surfaceArea/this.hardness; //assuming stones on bottom of tank
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
    float ammonia = (.000008*this.temp*this.pH*(this.waste + this.food.size() + .01*this.cmFish) - .001*this.nitrosomonas*this.ammonia)/this.volume;
    return ammonia;
  }

  public float changeNitrite(){
    float nitrite = (.001*this.ammonia*this.nitrosomonas - .001*this.nitrite*this.nitrobacter)/this.volume;
    return nitrite;
  }

  public float changeNitrate(){
    float nitrate = (.001*this.nitrite*this.nitrobacter-.001*this.plants.size()*this.nitrate)/this.volume;
    return nitrate;
  }

  public float changeNitrosomonas(){
    float nitrosomonas = .008*this.ammonia*this.nitrosomonas-.001*this.nitrosomonas;
    return nitrosomonas;
  }

  public float changeNitrobacter(){
    float nitrobacter = .008*this.nitrite*this.nitrobacter-.001*this.nitrobacter;
    return nitrobacter;
  }
  
  public void addFood(Food food){
    this.food.add(food);
  }

  public int changeWaste(){
    int waste = 0;
    for(Fish f: this.fish){
      int threshold = (int) (((float) max(f.fullness, 0)) / ((float) f.maxFullness) * f.size/2.0);
      int rand = random(5000);
      if(rand < threshold){
        waste++;
        addPoop(f);
      }
    }
    return waste;
  }
  
  public Tank waterChange(double percent){
    percent = .01*percent;
    this.pH = Math.log10(percent*Math.pow(10, 8) + (1-percent)*Math.pow(10, this.pH));
    this.temp = percent*24 + (1-percent)*this.temp;
    this.hardness = percent*8 + (1-percent)*this.hardness;
    this.o2 = percent*3 + (1-percent)*this.o2;
    this.co2 = percent*3 + (1-percent)*this.co2;
    this.ammonia = percent*0 + (1-percent)*this.ammonia;
    this.nitrite = percent*0 + (1-percent)*this.nitrite;
    this.nitrate = percent*0 + (1-percent)*this.nitrate;
    this.nitrosomonas = (percent*.2)*1 + (1-(percent*.2))*this.nitrosomonas;
    this.nitrobacter = (percent*.2)*1 + (1-(percent*.2))*this.nitrobacter;
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
  
  public float getParameter(String parameter){
    if(parameter == "Ammonia"){
      return this.ammonia;
    }
    if(parameter == "Nitrite"){
      return this.nitrite;
    }
    if(parameter == "Nitrate"){
      return this.nitrate;
    }
    if(parameter == "pH"){
      return this.pH;
    }
    if(parameter == "Temperature"){
      return this.temp;
    }
    if(parameter == "Hardness"){
      return this.hardness;
    }
  }
  
  public void progress(){
    //per fish operations
    for(Fish f: this.fish){
      f.changeHunger(); //update fish's hunger level 
      this.fishHappiness(f); //update fish's happiness status
      f.setHealth(); //update fish's health
      f.adapt();
      this.handleDeceased(f); //check if fish is dead and perform necessary operations if so
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
    float nitrosomonas = new Vector3D(1, this.nitrosomonas + timeScale * this.changeNitrosomonas(), 1000000).centermost();
    float nitrobacter = new Vector3D(1, this.nitrobacter + timeScale * this.changeNitrobacter(), 1000000).centermost();
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
  
  public Vector3D nearestFood(Vector3D absolutePosition){
    Vector3D closest = null;
    float distance = MAX_FLOAT;
    for(int i = 0; i < this.food.size(); i++){
      Food f = (Food) this.food.get(i);
      float fDistance = f.absolutePosition.squareDistance(absolutePosition);
      if(fDistance < distance){
        distance = fDistance;
        closest = f.absolutePosition;
      }
    }
    return closest;
  }
  
  public boolean eat(Fish fish, Food food){
    if(fish.absolutePosition.distance(food.absolutePosition) < food.dimensions.x*8){
      fish.fullness = min(fish.fullness+fish.ease*1800, fish.maxFullness);
      return true;
    }
    return false;
  }
  
  public void allEat(){
    for(int i = 0; i < this.fish.size(); i++){
      Fish aFish = (Fish) this.fish.get(i);
      ArrayList eaten = new ArrayList();
      for(int j = 0; j < this.food.size(); j++){
        Food aFood = (Food) this.food.get(j);
        if(this.eat(aFish, aFood)){
          eaten.add(aFood);
        }
      }
      for(int k = 0; k < eaten.size(); k++){
        Food aFood = (Food) eaten.get(k);
        this.food.remove(aFood);
      }
    }
  }
  
  public void addPoop(Fish f){
    this.poops.add(new Poop(f));
  }
  
  public void handleDeceased(Fish f){
    if(f.health <= 0){
      this.fish.remove(f);
      this.waste += f.size;
      this.addDeadFish(f);
      selected_fish = "select";
      update_fish_stats();
      update_fish_dropdown();
    }
  }
  
  public void addDeadFish(VFish f){
    this.deadFish.add(new DeadFish(f));
  }

}