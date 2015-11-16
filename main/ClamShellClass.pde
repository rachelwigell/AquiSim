public class ClamShell extends Achievement{
  public ClamShell(){
    this.rewardModel = loadShape("clamshell");
    this.rewardSprite = "graphics/clamshell.png";
    this.rewardDescription = "A pretty clam shell for your tank!";
    this.condition = "keeping a fish alive for one week";
    this.rewardName = "Clam Shell";
    this.scaleVal = 8;
    this.position = new Vector3D(0, 0, 0);
    this.orientation = 0;
    this.earned = false;
    this.used = false;
  }
  
  public ClamShell(String[] stats){
    this.rewardModel = loadShape("clamshell");
    this.rewardSprite = "graphics/clamshell.png";
    this.rewardDescription = "A pretty clam shell for your tank!";
    this.condition = "keeping a fish alive for one week";
    this.rewardName = "Clam Shell";
    this.scaleVal = 8;
    this.earned = stats[0] == "t";
    this.used = stats[1] == "t";
    if(this.used){
      this.position = new Vector3D(int(stats[2]), int(stats[3]), int(stats[4]));
      this.orientation = float(stats[5]);
    }
    else{
      this.position = new Vector3D(0, 0, 0);
      this.orientation = 0;
    }
  }
}