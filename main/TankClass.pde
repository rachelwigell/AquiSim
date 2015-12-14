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
  public int sinkingFood; //noms
  public int floatingFood; //noms
  public int time; //min
  public ArrayList fish;
  public ArrayList poops;
  public ArrayList food;
  public ArrayList floatingFood;
  public ArrayList sinkingFood;
  public ArrayList deadFish;
  public ArrayList plants;
  public String name;
  public long createdAt;
  public ArrayList achievements;

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
    this.floatingFood = 0;
    this.sinkingFood = 0;
    this.time = getTime();
    this.fish = new ArrayList();
    this.poops = new ArrayList();
    this.food = new ArrayList();
    this.sinkingFood = new ArrayList();
    this.floatingFood = new ArrayList();
    this.deadFish = new ArrayList();
    this.name = "";
    this.createdAt = new Date().getTime();
    this.achievements = new ArrayList();
    for(int i = 0; i < achievementsList.size(); i++){
      Achievement a = (Achievement) achievementsList.get(i);
      achievements.add(a);
    }
  }
  
  public Tank(String cookieString){ 
    cookieString = LZString.decompressFromUTF16(cookieString);
    String[] stats = splitTokens(cookieString, "+");
    this.cmFish = 0;
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
    this.createdAt = stats[14];
    playMode = stats[15];
    if(playMode == "" || playMode == null){
      playMode = "normal_mode";
    }
    $("#"+playMode).attr("checked", "checked");
    this.fish = new ArrayList();
    for(int i = 0; i < maxFish; i++){
     cookie = localStorage.getItem("f" + i);
     if(cookie != "" && cookie != null){
       String[] fishStats = splitTokens(LZString.decompressFromUTF16(cookie), "+");
       if(fishStats[0] == "Guppy"){
         this.fish.add(new Guppy(fishStats, true)); 
       }
       else if(fishStats[0] == "Neon Tetra"){
         this.fish.add(new NeonTetra(fishStats, true));
       }
       else if(fishStats[0] == "Cherry Barb"){
         this.fish.add(new CherryBarb(fishStats, true));
       }
       else if(fishStats[0] == "White Cloud Mountain Minnow"){
         this.fish.add(new WhiteCloudMountainMinnow(fishStats, true));
       }
       else if(fishStats[0] == "Cherry Shrimp"){
         this.fish.add(new CherryShrimp(fishStats, true));
       }
       else if(fishStats[0] == "Mystery Snail"){
         this.fish.add(new MysterySnail(fishStats, true));
       }
       else if(fishStats[0] == "Cory Catfish"){
         this.fish.add(new CoryCatfish(fishStats, true));
       }
       else if(fishStats[0] == "Platy"){
         this.fish.add(new Platy(fishStats, true));
       }
       else if(fishStats[0] == "Danio"){
         this.fish.add(new Danio(fishStats, true));
       }
       else if(fishStats[0] == "Tiger Barb"){
         this.fish.add(new TigerBarb(fishStats, true));
       }
     }
    }
    this.poops = new ArrayList();
    for(int i = 0; i < float(stats[12]); i++){
     this.poops.add(new Poop());
     this.waste++;
    }
    this.food = new ArrayList();
    this.sinkingFood = new ArrayList();
    this.floatingFood = new ArrayList();
    for(int i = 0; i < float(stats[10]); i++){
      Food f = new SinkingFood();
      this.food.add(f);
      this.sinkingFood.add(f);
    }
    for(int i = 0; i < float(stats[11]); i++){
      Food f = new FloatingFood();
      this.food.add(f);
      this.floatingFood.add(f);
    }
    this.deadFish = new ArrayList();
    for(int i = 0; i < maxFish; i++){
     cookie = localStorage.getItem("d" + i);
     if(cookie != "" && cookie != null){
       String[] fishStats = splitTokens(LZString.decompressFromUTF16(cookie), "+");
       if(fishStats[0] == "Guppy"){
         this.deadFish.add(new DeadFish(new Guppy(fishStats, false))); 
         this.waste += 5;
       }
       else if(fishStats[0] == "Neon Tetra"){
         this.deadFish.add(new DeadFish(new NeonTetra(fishStats, false))); 
         this.waste += 4;
       }
       else if(fishStats[0] == "Cherry Barb"){
         this.deadFish.add(new DeadFish(new CherryBarb(fishStats, false))); 
         this.waste += 5;
       }
       else if(fishStats[0] == "White Cloud Mountain Minnow"){
         this.deadFish.add(new DeadFish(new WhiteCloudMountainMinnow(fishStats, false))); 
         this.waste += 4;
       }
       else if(fishStats[0] == "Cherry Shrimp"){
         this.deadFish.add(new DeadFish(new CherryShrimp(fishStats, false))); 
         this.waste += 3;
       }
       else if(fishStats[0] == "Mystery Snail"){
         this.deadFish.add(new DeadFish(new MysterySnail(fishStats, false))); 
         this.waste += 5;
       }
       else if(fishStats[0] == "Cory Catfish"){
         this.deadFish.add(new DeadFish(new CoryCatfish(fishStats, false))); 
         this.waste += 6;
       }
       else if(fishStats[0] == "Platy"){
         this.deadFish.add(new DeadFish(new Platy(fishStats, false))); 
         this.waste += 6;
       }
       else if(fishStats[0] == "Danio"){
         this.deadFish.add(new DeadFish(new Danio(fishStats, false))); 
         this.waste += 6;
       }
       else if(fishStats[0] == "Tiger Barb"){
         this.deadFish.add(new DeadFish(new TigerBarb(fishStats, false))); 
         this.waste += 5;
       }
     }
    }
    this.plants = new ArrayList();
    for(int i = 0; i < maxPlants; i++){
     cookie = localStorage.getItem("p" + i);
     if(cookie != "" && cookie != null){
       String[] plantStats = splitTokens(LZString.decompressFromUTF16(cookie), "+");
       this.plants.add(new Plant(plantStats[6],
                       new Vector3D(int(plantStats[0]), int(plantStats[1]), int(plantStats[2])),
                       new Vector3D(new Vector3D(-.475*fieldX, float(plantStats[3]), .475*fieldX).centermost(),
                       fieldY-center.y,
                       new Vector3D(-.5*fieldZ, float(plantStats[4]), .5*fieldZ).centermost()),
                       float(plantStats[5])));
     }
    }
    this.achievements = new ArrayList();
    for(int i = 0; i < achievementsList.size(); i++){
      cookie = localStorage.getItem("a" + i);
      if(cookie != "" && cookie != null){
        String[] achievementStats = splitTokens(LZString.decompressFromUTF16(cookie), "+");
      }
      else{
        String[] achievementStats = {"f", "f"};
      }
      if(i == 0){
        this.achievements.add(new ScallopShell(achievementStats));
      }
      else if(i == 1){
        this.achievements.add(new ConchShell(achievementStats));
      }
      else if(i == 2){
       this.achievements.add(new Bubbler(achievementStats));
      }
      else if(i == 3){
       this.achievements.add(new Substrate(achievementStats));
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
    float pH = .001*this.pH*(14-this.pH)*(-.01*this.co2 - .1*this.ammonia)/(pow(10, abs(this.pH-7.0))*this.volume/this.hardness);
    return pH;
  }

  public float changeTemp(){
    this.roomTemp = 22 + 3*sin(pi/720.0*this.time-pi/2.0); //22 +/- 3
    float temp = .001*this.surfaceArea*(roomTemp - this.temp)/this.volume;
    return temp;  
  }

  public float changeHard(){
    float hardness = -.0001*this.co2*this.hardness/this.volume;
    return hardness;
  }

  public float changeO2(){
    float photosynthesis = (1+sin(pi/720.0*this.time-pi/2.0))*this.plants.size()*this.co2; //check this
    float respiration = .1*(this.cmFish+this.plants.size())*this.o2; // and this
    float o2 = .01*(photosynthesis-respiration+.05*this.surfaceArea)/(this.volume+5*(this.o2+this.co2)+this.temp);
    return o2;
  }

  public float changeCO2(){
    float photosynthesis = (1+sin(pi/720.0*this.time-pi/2.0))*this.plants.size()*this.co2;
    float respiration = .1*(this.cmFish+this.plants.size())*this.o2;
    float co2 = .01*(respiration-photosynthesis+.05*this.surfaceArea)/(this.volume+5*(this.o2+this.co2)+this.temp);
    return co2;
  }

  public float changeAmmonia(){
    float ammonia = (.00001*this.temp*this.pH*(this.waste + this.food.size() + .1*this.cmFish) - .001*this.nitrosomonas*this.ammonia)/this.volume;
    return ammonia;
  }

  public float changeNitrite(){
    float nitrite = (.001*this.ammonia*this.nitrosomonas - .001*this.nitrite*this.nitrobacter)/this.volume;
    return nitrite;
  }

  public float changeNitrate(){
    float nitrate = (.001*this.nitrite*this.nitrobacter-.0001*this.plants.size()*this.nitrate)/this.volume;
    return nitrate;
  }

  public float changeNitrosomonas(){
    float nitrosomonas = .05*this.ammonia*this.nitrosomonas-.0001*this.nitrosomonas;
    return nitrosomonas;
  }

  public float changeNitrobacter(){
    float nitrobacter = .05*this.nitrite*this.nitrobacter-.0001*this.nitrobacter;
    return nitrobacter;
  }
  
  public void addFood(Food food){
    this.food.add(food);
    food.addToAppropriateList(this);
  }
  
  public void removeFood(Food f){
    this.food.remove(f);
    f.removeFromAppropriateList(this);
  }

  public int changeWaste(){
    int waste = 0;
    for(Fish f: this.fish){
      float threshold = (((float) max(f.fullness, 0)) / ((float) f.maxFullness) * f.size/2.0);
      float rand = random(30/float(tank.timeScale));
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
  
  public void checkAchievementsFulfilled(){
    for(int i = 0; i < this.achievements.size(); i++){
      Achievement a = (Achievement) this.achievements.get(i);
      a.checkFulfilled();
    }
  }
  
  public void progress(){
    //per fish operations
    for(int i = 0; i < this.fish.size(); i++){
      Fish f = (Fish) this.fish.get(i);
      f.changeHunger(); //update fish's hunger level 
      f.fishHappiness(); //update fish's happiness status
      f.setHealth(); //update fish's health
      if(playMode != "casual_mode"){
        f.adapt();
      }
      this.handleDeceased(f); //check if fish is dead and perform necessary operations if so
    }
    
    //achievement operations
    this.checkAchievementsFulfilled();
    if(playMode != "casual_mode"){
      float achievementPH = 0;
      float achievementTemp = 0;
      float achievementHard = 0;
      float achievementO2 = 0;
      float achievementCO2 = 0;
      float achievementAmmonia = 0;
      float achievementNitrite = 0;
      float achievementNitrate = 0;
      float achievementNitrosomonas = 0;
      float achievementNitrobacter = 0;
      for(int j = 0; j < this.achievements.size(); j++){
        Achievement a = (Achievement) this.achievements.get(j);
        if(a.used){
          HashMap effects = a.tankEffects();
          Iterator i = effects.entrySet().iterator();
          while (i.hasNext()) {
            Map.Entry parameter = (Map.Entry) i.next();
            String parameterKey = (String) parameter.getKey();
            float parameterValue = (float) effects.get(parameterKey);
            if(parameterKey == "pH") achievementPH += parameterValue;
            else if(parameterKey == "pH") achievementPH += parameterValue;
            else if(parameterKey == "temperature") achievementTemp += parameterValue;
            else if(parameterKey == "hardness") achievementHard += parameterValue;
            else if(parameterKey == "o2") achievementO2 += parameterValue;
            else if(parameterKey == "co2") achievementCO2 += parameterValue;
            else if(parameterKey == "ammonia") achievementAmmonia += parameterValue;
            else if(parameterKey == "nitrite") achievementNitrite += parameterValue;
            else if(parameterKey == "nitrate") achievementNitrate += parameterValue;
            else if(parameterKey == "nitrosomonas") achievementNitrosomonas += parameterValue;
            else if(parameterKey == "nitrobacter") achievementNitrobacter += parameterValue;
          }
        }
      }
    }

    //tank operations
    float cmFish = this.changeFish();
    if(playMode != "casual_mode"){
      console.log(playMode);
      float pH = new Vector3D(.01, this.pH + timeScale * this.changePH() + timeScale * achievementPH, 13.99).centermost();
      float temp = new Vector3D(19, this.temp + timeScale * this.changeTemp() + timeScale * achievementTemp, 25).centermost();
      float hardness = new Vector3D(.01, this.hardness + timeScale * this.changeHard() + timeScale * achievementHard, 99).centermost();
      float o2 = new Vector3D(.01, this.o2 + timeScale * this.changeO2() + timeScale * achievementO2, 99).centermost();
      float co2 = new Vector3D(.01, this.co2 + timeScale * this.changeCO2() + timeScale * achievementCO2, 99).centermost();
      float ammonia = new Vector3D(0, this.ammonia + timeScale * this.changeAmmonia() + timeScale * achievementAmmonia, 99).centermost();
      float nitrite = new Vector3D(0, this.nitrite + timeScale * this.changeNitrite() + timeScale * achievementNitrite, 99).centermost();
      float nitrate = new Vector3D(0, this.nitrate + timeScale * this.changeNitrate() + timeScale * achievementNitrate, 99).centermost();
      float nitrosomonas = new Vector3D(1, this.nitrosomonas + timeScale * this.changeNitrosomonas() + timeScale * achievementNitrosomonas, 9999).centermost();
      float nitrobacter = new Vector3D(1, this.nitrobacter + timeScale * this.changeNitrobacter() + timeScale * achievementNitrobacter, 9999).centermost();
    }
    int waste = this.waste + this.changeWaste();
    int time = this.getTime();

    //do assignment after so that all calculations are accurate
    this.cmFish = cmFish;
    if(playMode != "casual_mode"){
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
    }
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
    if(fish.fullness >= fish.maxFullness){
      return false;
    }
    if(fish.absolutePosition.distance(food.absolutePosition) < 40){
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
    }
    for(int k = 0; k < eaten.size(); k++){
      Food aFood = (Food) eaten.get(k);
      this.removeFood(aFood);
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
  
  public boolean randomizedEating(Fish fish){
    double percentChance = .005*max(1-(max(fish.fullness, 0)/fish.maxFullness), 0);
    float rand = random(0, 1);
    if(rand < percentChance){
      fish.fullness = min(fish.fullness+fish.ease*1800, fish.maxFullness);
      return true;
    }
    return false;
  }
  
  public void allRandomizedEat(){
    ArrayList eaten = new ArrayList();
    for(int i = 0; i < this.fish.size(); i++){
      Fish fish = (Fish) this.fish.get(i);
      for(int j = 0; j < this.food.size(); j++){
        Food food = (Food) this.food.get(j);
        if(this.randomizedEating(fish)){
          eaten.add(food);
        }
      }
      for(int j = 0; j < eaten.size(); j++){
        Food food = (Food) eaten.get(j);
        this.removeFood(food);
      }
    }
  }
  
  public void skipAhead(int minutes){
    for(int i = 0; i < minutes; i++){
      this.progress();
      this.allRandomizedEat();
    }
  }

}