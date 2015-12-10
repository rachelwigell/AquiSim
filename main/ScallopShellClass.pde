public class ScallopShell extends Achievement{
  public ScallopShell(){
    this.rewardModel = loadShape("scallopshell.obj");
    this.rewardSprite = "graphics/scallopshell.png";
    this.rewardDescription = "A pretty scallop shell for your tank!";
    this.condition = "keeping a fish alive for one week";
    this.rewardName = "Scallop Shell";
    this.scaleVal = 12;
    this.position = new Vector3D(0, 0, 0);
    this.absolutePosition = new Vector3D(0, 0, 0);
    this.orientation = 0;
    this.earned = false;
    this.used = false;
    this.dimensions = new Vector3D(this.scaleVal*7.6, this.scaleVal*1.2, this.scaleVal*6.5);
  }
  
  public ScallopShell(String[] stats){
    this.rewardModel = loadShape("scallopshell.obj");
    this.rewardSprite = "graphics/scallopshell.png";
    this.rewardDescription = "A pretty scallop shell for your tank!";
    this.condition = "keeping a fish alive for one week";
    this.rewardName = "Scallop Shell";
    this.scaleVal = 12;
    this.earned = stats[0] == "t";
    this.used = stats[1] == "t";
    if(this.used){
      this.position = new Vector3D(int(stats[2]), fieldY-center.y, int(stats[3]));
      this.absolutePosition = this.position.addVector(new Vector3D(center.x, center.y, center.z));
      this.orientation = float(stats[4]);
      this.dimensions = new Vector3D(this.scaleVal*7.6, this.scaleVal*1.2, this.scaleVal*6.5);
    }
    else{
      this.position = new Vector3D(0, 0, 0);
      this.absolutePosition = new Vector3D(0, 0, 0);
      this.orientation = 0;
      this.dimensions = new Vector3D(this.scaleVal*7.6, this.scaleVal*1.2, this.scaleVal*6.5);
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
        if(now - f.aliveSince > 604800000){
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