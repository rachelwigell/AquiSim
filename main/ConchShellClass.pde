public class ConchShell extends Achievement{
  public ConchShell(){
    this.rewardModel = loadShape("conchshell.obj");
    this.rewardSprite = "graphics/conchshell.png";
    this.rewardDescription = "A conch shell!";
    this.condition = "keeping a fish happy for one week";
    this.rewardName = "Conch Shell";
    this.scaleVal = 8;
    this.position = new Vector3D(0, 0, 0);
    this.absolutePosition = new Vector3D(0, 0, 0);
    this.orientation = 0;
    this.earned = false;
    this.used = false;
    this.dimensions = new Vector3D(this.scaleVal*11.2, this.scaleVal*5.6, this.scaleVal*5.7);
  }
  
  public ConchShell(String[] stats){
    this.rewardModel = loadShape("conchshell.obj");
    this.rewardSprite = "graphics/conchshell.png";
    this.rewardDescription = "A conch shell!";
    this.condition = "keeping a fish happy for one week";
    this.rewardName = "Conch Shell";
    this.scaleVal = 8;
    this.earned = stats[0] == "t";
    this.used = stats[1] == "t";
    if(this.used){
      this.position = new Vector3D(int(stats[2]), fieldY-center.y, int(stats[4]));
      this.absolutePosition = this.position.addVector(new Vector3D(center.x, center.y, center.z));
      this.orientation = float(stats[5]);
      this.dimensions = new Vector3D(this.scaleVal*11.2, this.scaleVal*5.6, this.scaleVal*5.7);
    }
    else{
      this.position = new Vector3D(0, 0, 0);
      this.absolutePosition = new Vector3D(0, 0, 0);
      this.orientation = 0;
      this.dimensions = new Vector3D(this.scaleVal*11.2, this.scaleVal*5.6, this.scaleVal*5.7);
    }
  }
  
  public boolean checkFulfilled(){
    if(this.earned){
      return true;
    }
    else{
      long now = new Date().getTime();
      for(int i = 0; i < tank.fish.size(); i++){
        Fish f = (Fish) tank.fish.get(i);
        if(f.happySince != 0 && now - f.happySince > 604800000){
          this.earned = true;
          return true;
        }
      }
    }
    return false;
  }
  
  public HashMap tankEffects(){
    HashMap effects = new HashMap();
    effects.put("hardness", .001);
    return effects;
  }
}