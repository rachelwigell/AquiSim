public class Substrate extends Achievement{
  ArrayList pieces;
  Vector3D RGBcolor;
  
  public Substrate(){
    this.rewardSprite = "graphics/substrate.png";
    this.rewardDescription = "Gravel for the bottom of your tank!";
    this.condition = "playing AquiSim for 30 days";
    this.rewardName = "Substrate";
    this.scaleVal = 0;
    this.position = null;
    this.absolutePosition = null;
    this.orientation = 0;
    this.earned = false;
    this.used = false;
    this.dimensions = null;
    this.RGBcolor = new Vector3D(80, 100, 120);
    this.pieces = new ArrayList();
  }
  
  public Substrate(String[] stats){
    this.rewardSprite = "graphics/substrate.png";
    this.rewardDescription = "Gravel or sand for the bottom of your tank!";
    this.condition = "playing AquiSim for 30 days";
    this.rewardName = "Substrate";
    this.earned = stats[0] == "t";
    this.used = stats[1] == "t";
    if(this.used){
      this.RGBcolor = new Vector3D(int(stats[2]), int(stats[3]), int(stats[4]));
      this.pieces = new ArrayList();
      initialize();
    }
    else{
      this.RGBcolor = new Vector3D(80, 100, 120);
      this.pieces = new ArrayList();
    }
  }
  
  public void initialize(){
    for(int i = 0; i < 15; i++){
      for(int j = 0; j < 15; j++){
        int x = int(.05*fieldX + (i+.5) * (.95*fieldX-.05*fieldX)/15.0 + random(-25, 25));
        int z = int(-1.5*fieldZ + j * (-.5*fieldZ+1.5*fieldZ)/15.0 + random(-10, 10));
        size = int(random(24, 36));
        pieces.add({size,
          int(random(this.RGBcolor.x-25, this.RGBcolor.x+25)),
          int(random(this.RGBcolor.y-25, this.RGBcolor.y+25)),
          int(random(this.RGBcolor.z-25, this.RGBcolor.z+25)),
          int(x),
          int(fieldY-size/3.0),
          int(z)
        });
      }
    }
  }
  
  public boolean checkFulfilled(){
    if(this.earned){
      return true;
    }
    else{
    long now = new Date().getTime();
      if(now - tank.createdAt > 2592000000){
        this.earned = true;
        return true;
      }
    }
    return false;
  }
  
  public HashMap tankEffects(){
    HashMap effects = new HashMap();
    effects.put("hardness", .001);
    return effects;
  }
  
  void drawAchievement() {
    if(this.earned && this.used){
      noStroke();
      sphereDetail(4);
      for(int i = 0; i < this.pieces.size(); i++){
        int[] stats = (int[]) this.pieces.get(i);
        pushMatrix();
        translate(stats[4], stats[5], stats[6]);
        fill(stats[1], stats[2], stats[3]);
        rotateY(stats[0]);
        scale(1, .2, 1);
        sphere(stats[0]);
        popMatrix();
      }
    }
  }
  
  void drawPreview(){
    noStroke();
    sphereDetail(4);
    for(int i = 0; i < this.pieces.size(); i++){
      int[] stats = (int[]) this.pieces.get(i);
      pushMatrix();
      translate(stats[4], stats[5], stats[6]);
      fill(stats[1], stats[2], stats[3]);
      rotateY(stats[0]);
      scale(1, .2, 1);
      sphere(stats[0]);
      popMatrix();
    }
  }
}