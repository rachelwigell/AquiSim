public class ClamShell extends Achievement{
  public ClamShell(){
    this.rewardModel = loadShape("clamshell");
    this.rewardSprite = "graphics/clamshell.png";
    this.rewardDescription = "A pretty clam shell for your tank!";
    this.condition = "a fish alive for one week";
    this.rewardName = "Clam Shell";
    this.earned = true;
    this.used = true;
  }
}