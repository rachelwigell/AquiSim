public class Bubbler extends Achievement{
  ArrayList bubbles;
  
  public Bubbler(){
    this.rewardModel = loadShape("bubbler.obj");
    this.rewardSprite = "graphics/bubbler.png";
    this.rewardDescription = "A tube that runs bubbles through your tank!";
    this.condition = "cycling your tank (getting both populations of bacteria up above 500M)";
    this.rewardName = "Bubbler";
    this.scaleVal = 12;
    this.position = new Vector3D(0, 0, 0);
    this.absolutePosition = new Vector3D(0, 0, 0);
    this.orientation = 0;
    this.earned = false;
    this.used = false;
    this.dimensions = new Vector3D(this.scaleVal*4, this.scaleVal*2.5, this.scaleVal*4);
    this.bubbles = new ArrayList();
  }
  
  public Bubbler(String[] stats){
    this.rewardModel = loadShape("bubbler.obj");
    this.rewardSprite = "graphics/bubbler.png";
    this.rewardDescription = "A tube that runs bubbles through your tank!";
    this.condition = "cycling your tank (getting both populations of bacteria up above 500M)";
    this.rewardName = "Bubbler";
    this.scaleVal = 12;
    this.earned = stats[0] == "t";
    this.used = stats[1] == "t";
    if(this.used){
      this.position = new Vector3D(int(stats[2]), fieldY-center.y, int(stats[4]));
      this.absolutePosition = this.position.addVector(new Vector3D(center.x, center.y, center.z));
      this.orientation = float(stats[5]);
      this.dimensions = new Vector3D(this.scaleVal*4, this.scaleVal*2.5, this.scaleVal*4);
      this.bubbles = new ArrayList();
    }
    else{
      this.position = new Vector3D(0, 0, 0);
      this.absolutePosition = new Vector3D(0, 0, 0);
      this.orientation = 0;
      this.dimensions = new Vector3D(this.scaleVal*4, this.scaleVal*2.5, this.scaleVal*4);
      this.bubbles = new ArrayList();
    }
  }
  
  public boolean checkFulfilled(){
    if(this.earned){
      return true;
    }
    else if(tank.nitrobacter >= 500 && tank.nitrosomonas >= 500){
      this.earned = true;
      return true;
    }
    return false;
  }
  
  public HashMap tankEffects(){
    HashMap effects = new HashMap();
    effects.put("o2", .001);
    return effects;
  }
  
  void drawAchievement() {
    if(this.earned && this.used){
      noStroke();
      pushMatrix();
      translate(center.x, center.y, center.z);
      translate(this.position.x, this.position.y, this.position.z);
      rotateY(this.orientation);
      scale(this.scaleVal, this.scaleVal, this.scaleVal);
      shape(this.rewardModel);
      rotateY(-this.orientation);
      scale(1/this.scaleVal, 1/this.scaleVal, 1/this.scaleVal);
      fill(255, 255, 255, 20);
      int chance = random(0, 5);
      if(chance <= 2){
        this.bubbles.add(new Vector3D(random(-this.scaleVal, this.scaleVal), 0, random(-this.scaleVal, this.scaleVal)));
      }
      for(int i = 0; i < this.bubbles.size(); i++){
        Vector3D bubble = (Vector3D) this.bubbles.get(i);
        pushMatrix();
        translate(bubble.x, bubble.y, bubble.z);
        sphere(3);
        popMatrix();
        bubble.y -= 10;
        if(bubble.y <= (-fieldY*waterLevel)){
          this.bubbles.remove(bubble);
        }
      }
      if(clickMode == "DELETEACHIEVEMENT"){
        pushMatrix();
        translate(0, 0, this.dimensions.x/2+20);
        fill(100, 100, 100);
        stroke(230, 10, 20);
        strokeWeight(2);
        translate(0, -1, 0);
        rotateX(PI/2);
        ellipse(0, 0, 60, 60);
        rotateX(-PI/2);
        line(-20, 0, 20, 20, 0, -20);
        line(20, 0, 20, -20, 0, -20);
        popMatrix();
      }
      else if(clickMode == "MOVEACHIEVEMENT"){
        pushMatrix();
        translate(0, 0, this.dimensions.x/2+20);
        fill(100, 100, 100);
        stroke(230, 10, 20);
        strokeWeight(2);
        translate(0, -1, 0);
        rotateX(PI/2);
        ellipse(0, 0, 60, 60);
        rotateX(-PI/2);
        line(-30, 0, 0, -50, 0, 0);
        line(-50, 0, 0, -40, 0, 10);
        line(-50, 0, 0, -40, 0, -10);
        line(30, 0, 0, 50, 0, 0);
        line(50, 0, 0, 40, 0, 10);
        line(50, 0, 0, 40, 0, -10);
        line(0, 0, 30, 0, 0, 50);
        line(0, 0, 50, 10, 0, 40);
        line(0, 0, 50, -10, 0, 40);
        line(0, 0, -30, 0, 0, -50);
        line(0, 0, -50, 10, 0, -40);
        line(0, 0, -50, -10, 0, -40);
        popMatrix();
      }
      else if(clickMode == "ROTATEACHIEVEMENT"){
        pushMatrix();
        translate(0, 0, this.dimensions.x/2+20);
        fill(100, 100, 100);
        stroke(230, 10, 20);
        strokeWeight(2);
        translate(0, -1, 0);
        rotateX(PI/2);
        ellipse(0, 0, 60, 60);
        rotateX(-PI/2);
        line(-30, 0, 0, -40, 0, -10);
        line(-30, 0, 0, -20, 0, -10);
        line(30, 0, 0, 20, 0, 10);
        line(30, 0, 0, 40, 0, 10);
        line(0, 0, -30, 10, 0, -40);
        line(0, 0, -30, 10, 0, -20);
        line(0, 0, 30, -10, 0, 40);
        line(0, 0, 30, -10, 0, 20);
        popMatrix();
      }
      popMatrix();
    }
  }
}