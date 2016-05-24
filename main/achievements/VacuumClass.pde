public class Vacuum extends Achievement{
  
  public Vacuum(){
    this.rewardSprite = "graphics/vacuum.png";
    this.rewardDescription = "A vacuum that sucks food and poops to your mouse cursor!";
    this.condition = "keeping a school of at least 3 Tiger Barbs alive for 3 days";
    this.rewardName = "Vacuum";
    this.position = null;
    this.absolutePosition = null;
    this.earned = false;
    this.used = false;
    this.dimensions = null;
  }
  
  public Vacuum(String[] stats){
    this.rewardSprite = "graphics/vacuum.png";
    this.rewardDescription = "A vacuum that sucks food and poops to your mouse cursor!";
    this.condition = "keeping a school of at least 3 Tiger Barbs alive for 3 days";
    this.rewardName = "Vacuum";
    this.earned = stats[0] == "t";
    this.used = stats[1] == "t";
  }
  
  public boolean checkFulfilled(){
    if(this.earned){
      return true;
    }
    else{
      long now = new Date().getTime();
      int barbCount = 0;
      for(int i = 0; i < tank.fish.size(); i++){
        Fish f = (Fish) tank.fish.get(i);
        if(f.species == "Tiger Barb" && now - f.aliveSince > 259200000){
          barbCount++;
        }
      }
      if(barbCount >= 3){
        this.earned = true;
        return true;
      }
    }
    return false;
  }
  
  public HashMap tankEffects(){
    HashMap effects = new HashMap();
    return effects;
  }
  
  void drawAchievement() {}
  
  void drawPreview(){}
}