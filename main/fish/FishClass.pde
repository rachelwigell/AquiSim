public abstract class Fish {
  public String species;
  public String name;
  public String status;
  public float fullness;
  public float maxFullness;
  public float maxHealth;
  public float health;
  public int ease;
  public float size;
  public HashMap parameterTolerances;
  public PShape model;
  public String sprite;
  public int scaleVal;
  public int activity;
  public boolean swimming;
  public Vector3D rotate;
  public Vector3D position;
  public Vector3D absolutePosition;
  public Vector3D orientation;
  public Vector3D dimensions;
  public Vector3D velocity;
  public Vector3D acceleration;
  public Vector3D eyePosition;
  public Vector3D offset;
  public HashMap dangerRatings;
  public float region;
  public long aliveSince;
  public long happySince;
  public float schoolingCoefficient;

  /*
  Store the fish's tolerance to various water parameters such as pH in a hashmap.
  This gets initialized with unique values for each different type of species.
  */
  public void initializeTolerances(float ammonia, float nitrite, float nitrate, float minPH, float maxPH,
    float minTemp, float maxTemp, float minHard, float maxHard){
    this.parameterTolerances = new HashMap();
    this.parameterTolerances.put("max Ammonia", ammonia);
    this.parameterTolerances.put("max Nitrite", nitrite);
    this.parameterTolerances.put("max Nitrate", nitrate);
    this.parameterTolerances.put("min pH", minPH);
    this.parameterTolerances.put("min Hardness", minHard);
    this.parameterTolerances.put("min Temperature", minTemp);
    this.parameterTolerances.put("max pH", maxPH);
    this.parameterTolerances.put("max Hardness", maxHard);
    this.parameterTolerances.put("max Temperature", maxTemp);
  }

  /*
  assign a 1-3 value to each parameter of the water chemistry indicating how dangerous
  (3 being most dangerous) it is when that parameter gets out of range
  this ends up affecting how much fish health is subtracted when the water is unhealthy
  */
  public void setDangerRatings() {
    this.dangerRatings = new HashMap();
    this.dangerRatings.put("Ammonia", 3);
    this.dangerRatings.put("Nitrite", 2);
    this.dangerRatings.put("Nitrate", 1);
    this.dangerRatings.put("pH", 2);
    this.dangerRatings.put("Hardness", 1);
    this.dangerRatings.put("Temperature", 1);
  }

  /*
  Update the fish's health based on its status. Add health if it's happy,
  remove health if there's some kind of problem. Health reduction is proportionate
  to how bad that problem is.
  */
  public double setHealth() {
    int timeScaleConstant = 100;
    if (this.status == "Happy.") {
      this.health = min(this.maxHealth, this.health+(tank.timeScale*timeScaleConstant));
    }
    else if (this.status == "Hungry!") {
      int hungerDangerRating = 2;
      this.health = max(0, this.health-(tank.timeScale*timeScaleConstant*hungerDangerRating));
    }
    else if(playMode != "casual_mode"){
     String problemElement = this.problemElementFromStatus();
     String parameter = this.problemDirectionFromStatus() + " " + problemElement;
     float dist = 0;
     dist = abs(tank.getParameter(problemElement) - this.parameterTolerances.get(parameter));
     float reduction = max(1, dist*this.dangerRatings.get(problemElement));
     this.health = max(0, this.health-(tank.timeScale*timeScaleConstant*reduction));
    }
    return this.health;
  }

  /*
  Helper function to determine which parameter is off (e.g. "pH")
  from a fish's status string (e.g. "pH too high")
  */
  public String problemElementFromStatus(){
     Iterator i = this.dangerRatings.entrySet().iterator();
     while (i.hasNext()) {
      Map.Entry danger = (Map.Entry) i.next();
      String dangerKey = (String) danger.getKey();
      if (this.status.contains(dangerKey)) {
        return dangerKey;
      }
     }
     return null;
   }

   /*
   Helper function to determine the direction of the problem
   (e.g. too high or too low) from a fish's status string (e.g. pH too high)
   */
   public String problemDirectionFromStatus(){
    if(this.status.contains('too high')) return "max";
    else return "min";
   }

   /*
   Creates the equivalent of "+=" for an appropriate hashmap
   */
   public void plusEqualsHashMap(HashMap mapping, String aKey, float add){
    float value = (float) mapping.get(aKey);
    mapping.put(aKey, value+add);
   }
  
  /*
  Fish slowly adapt to tank parameters (e.g. a fish that prefers low pH slowly starts to
  accept higher pHs if it's forced to live in a high pH tank for a long time).
  That logic is handled here.
  */
  public void adapt(){
    float adaptationConstant = .01;
    float adaptCoeff = adaptationConstant*tank.timeScale;
    String param = this.problemElementFromStatus();
    String fishParam = this.problemDirectionFromStatus() + " " + param;
    float tankParam = tank.getParameter(param);
    if(param == "pH" || param == "Hardness" || param == "Temperature"){
      float dist = tankParam - this.parameterTolerances.get(fishParam);
      plusEqualsHashMap(this.parameterTolerances, "min " + param, adaptCoeff*dist);
      plusEqualsHashMap(this.parameterTolerances, "max " + param, adaptCoeff*dist);
    }
  }

  public long changeHunger() {
    float timeScaleConstant = 100;
    int hunger = (int) (tank.timeScale*timeScaleConstant*this.size); //hunger changes relative to fish size
    this.fullness = Math.max(this.fullness - hunger, 0);
    return hunger;
  }
  
  public String setFishHappiness(){
    if(this.fullness <= 0){
      this.status = "Hungry!";
      this.happySince = 0;
      return;
    }
    Iterator i = this.dangerRatings.entrySet().iterator();
    while (i.hasNext()) {
      Map.Entry danger = (Map.Entry) i.next();
      String dangerKey = (String) danger.getKey();
      if(tank.getParameter(dangerKey) > this.parameterTolerances.get("max " + dangerKey) && playMode != "casual_mode"){
        this.status = dangerKey + " too high.";
        this.happySince = 0;
        return this.status;
      }
      else if(tank.getParameter(dangerKey) < this.parameterTolerances.get("min " + dangerKey) && playMode != "casual_mode"){
        ths.status = dangerKey + " too low.";
        this.happySince = 0;
        return this.status;
      }
    }
   //if it hasn't returned by now, then  it's happy
    this.status = "Happy.";
    if(this.happySince == 0){
      this.happySince = new Date().getTime();
    }
    return this.status;
  }

  public void updatePosition() {
    float tankXBound = .475;
    float tankYBound = .5;
    float tankZBound = .5;
    int buffer = 30;
    // give this fish a new x, y, z position bound by the walls of the tank and based on its current position and velocity
    this.position.x = new Vector3D((-tankXBound*fieldX+this.dimensions.x/2.0), this.position.x+buffer/rate*this.velocity.x, (tankXBound*fieldX-this.dimensions.x/2.0)).centermost();
    this.position.y = new Vector3D((-tankYBound*fieldY*waterLevel+this.dimensions.y/2.0), this.position.y+buffer/rate*this.velocity.y, (tankYBound*fieldY*waterLevel-this.dimensions.y/2.0)).centermost();
    this.position.z = new Vector3D((-tankZBound*fieldZ+this.dimensions.x/2.0), this.position.z+buffer/rate*this.velocity.z, (tankZBound*fieldZ-this.dimensions.x/2.0)).centermost();
    this.absolutePosition = this.position.addVector(new Vector3D(zero.x, zero.y, zero.z));
    this.updateVelocity();
  }

  public void updateAcceleration() {
    int activityCoefficient = 20;
    int maxActivity = 100;
    // some logic here to allow a fish to actually stop swimming, based on how "active" this species is
    if(swimming){
      if(random(0, activityCoefficient*this.activity) < 1){
        swimming = false;
      }
    }
    // resume swimming
    else{
      if(random(0, maxActivity-activityCoefficient*this.activity) < 1){
        swimming = true;
      }
    }
    float maxAcceleration = .8;
    float maxJerk = .2;
    if(swimming){
      // give this fish a new acceleration bound by a max and min
      this.acceleration.x = new Vector3D(-maxAcceleration, this.acceleration.x+random(-maxJerk, maxJerk), maxAcceleration).centermost();
      this.acceleration.y = new Vector3D(-maxAcceleration, this.acceleration.y+random(-maxJerk, maxJerk), maxAcceleration).centermost();
      this.acceleration.z = new Vector3D(-maxAcceleration, this.acceleration.z+random(-maxJerk, maxJerk), maxAcceleration).centermost();
      this.regionPull();
    }
    else{
      // if the fish is not swimming, decelerate it until stopped.
      float decelerationCoefficient = -.1;
      this.acceleration.x = new Vector3D(-maxAcceleration, -decelerationCoefficient*this.velocity.x, maxAcceleration).centermost();
      this.acceleration.y = new Vector3D(-maxAcceleration, -decelerationCoefficient*this.velocity.y, maxAcceleration).centermost();
      this.acceleration.z = new Vector3D(-maxAcceleration, -decelerationCoefficient*this.velocity.z, maxAcceleration).centermost();
    }
  }
  
  /*
  Some species prefer the top area of the tank while others prefer the bottom. This preference is set in each
  species' "region" class attribute. Here we use region to influence the y component of the acceleration
  to cause the fish to tend towards their preferred region.
  */
  public void regionPull() {
    float pullCoefficient;
    float variability = random(0, 10);
    float pull = pullCoefficient*variability*abs(this.region) * (fieldY*waterLevel*this.region - this.position.y);
    this.acceleration.y += pull;
  }

  public void updateVelocity() {
    float tankXBound = .475;
    float tankYBound = .5;
    float tankZBound = .5;
    // if you hit the left or right wall, turn around by reversing acceleration
    if(this.position.x <= (-tankXBound*fieldX+this.dimensions.x/2.0)){
      this.acceleration.x = 1;
    }
    else if(this.position.x >= (tankXBound*fieldX-this.dimensions.x/2.0)){
      this.acceleration.x = -1;
    }
    int buffer = 1;
    float activityCoefficient = .2;
    this.velocity.x = new Vector3D(-buffer-activityCoefficient*this.activity, this.velocity.x + this.acceleration.x, buffer+activityCoefficient*this.activity).centermost();
    //but let them hit the floor, in case they're going towards food that's there.
    this.velocity.y = new Vector3D(-buffer-activityCoefficient*this.activity, this.velocity.y + this.acceleration.y, buffer+activityCoefficient*this.activity).centermost();
    // if you hit the front or back wall, turn around by reversing accleration
    if(this.position.z == (-tankZBound*fieldZ+this.dimensions.x/2.0)){
     this.acceleration.z = 1;
    }
    else if(this.position.z == (tankZBound*fieldZ-this.dimensions.x/2.0)){
     this.acceleration.z = -1;
    }
    this.velocity.z = new Vector3D(-buffer-activityCoefficient*this.activity, this.velocity.z + this.acceleration.z, buffer+activityCoefficient*this.activity).centermost();
    pullTowardsSchool();
    this.velocity = this.velocity.addVector(this.hungerContribution());
    this.updateOrientationRelativeToVelocity();
    this.updateAcceleration();
  }

  /*
  If fish are hungry, we want them to swim towards the nearest food. This function
  returns a vector pointing towards the nearest food that will be added to the fish's
  velocity vector to achieve this.
  */
  public Vector3D hungerContribution() {
    float fullEnough = .8;
    if(this.fullness > fullEnough*this.maxFullness){
      //for performance, if this fish is not very hungry (>80%), skip this function
      return new Vector3D(0, 0, 0);
    }
    int fullnessCoefficient = 6;
    Vector3D nearestFood = tank.nearFood(this.absolutePosition);
    if (nearestFood == null) return new Vector3D(0, 0, 0);
    nearestFood = nearestFood.addVector(new Vector3D(-zero.x, -zero.y, -zero.z));
    //fish should swim faster towards the food the hungrier they are
    float percent = max((fullEnough-(max(this.fullness, 0)/((double) this.maxFullness)))*fullnessCoefficient, 0);
    Vector3D normal = nearestFood.addVector(this.position.multiplyScalar(-1)).normalize();
    return normal.multiplyScalar(percent);
  }
  
  /*
  Make sure the fish is always pointing forward while it's swimming.
  */
  public void updateOrientationRelativeToVelocity() {
    Vector3D velocity = this.velocity;  
    double angle = asin(abs(velocity.z)/velocity.magnitude());
    if (velocity.x < 0 && velocity.z > 0) this.orientation.y = angle;
    else if (velocity.x > 0 && velocity.z > 0) this.orientation.y = (PI - angle);
    else if (velocity.x > 0 && velocity.z < 0) this.orientation.y = (PI + angle);
    else if (velocity.x < 0 && velocity.z < 0) this.orientation.y = -angle;
    else if (velocity.z == 0 && velocity.x < 0) this.orientation.y = 0;
    else if (velocity.x == 0 && velocity.z > 0) this.orientation.y = (PI/2.0);
    else if (velocity.z == 0 && velocity.x > 0) this.orientation.y = PI;
    else if (velocity.x == 0 && velocity.z < 0) this.orientation.y = (3*PI/2.0);
    this.orientation.z = new Vector3D(-1, -velocity.y, 1).centermost() * PI/6;
  }

  void drawFish() {
    noStroke();
    pushMatrix();
    translate(this.absolutePosition.x, this.absolutePosition.y, this.absolutePosition.z);
    rotateX(this.orientation.x);
    rotateY(this.orientation.y);
    rotateZ(this.orientation.z);
    rotateX(this.rotate.x);
    rotateY(this.rotate.y);
    rotateZ(this.rotate.z);
    translate(this.offset.x, this.offset.y, this.offset.z);
    scale(this.scaleVal, this.scaleVal, this.scaleVal);
    shape(this.model);
    //draw eyes
    float eyeSize = 2.5;
    int eyeDetail = 8;
    fill(0);
    sphereDetail(eyeDetail);
    scale(1/this.scaleVal, 1/this.scaleVal, 1/this.scaleVal);
    translate(-this.offset.x, -this.offset.y, -this.offset.z);
    translate(this.dimensions.x*this.eyePosition.x, this.dimensions.y*this.eyePosition.y, this.dimensions.z*this.eyePosition.z);
    sphere(eyeSize);
    translate(0, 0, -2*this.dimensions.z*this.eyePosition.z);
    sphere(eyeSize);
    popMatrix();
  }
  
  /*
  Schooling algorithm. Establish a "leader" fish (the first fish of this species occurring in the tank.fish list).
  The leader fish swims normally, but all other fish of its species will be drawn towards it. This is achieved by
  adding a vector towards the leader fish's position to other fish's velocities.
  Effect: No effect if this fish is the leader fish. Otherwise, make a change to this fish's velocity.
  */
  public void pullTowardsSchool(){
    //iterate to find the leader fish
    for(int i = 0; i < tank.fish.size(); i++){
      Fish f = (Fish) tank.fish.get(i);
      if(f.name == this.name){
        //if leader fish is this fish (determined by fish's nicknames - nicknames are unique,
        //so name comparison is a safe and efficient way to determine equality), no effect.
        return;
      }
      else if(f.species == this.species){
        Vector3D pullToward = f.position;
        //BUT, we don't want to move toward the leader fish's exact position.
        //instead we pull toward a point that's near him, offset by some pseudorandom amount
        //we base this offset on the fish's name so that it is consistent
        //so one fish will consistently tend to be above the leader, another behind, etc
        //this helps prevent the fish from just piling up on top the leader
        int offset = int(name.toCharArray())[0];
        pullToward = pullToward.addVector(new Vector3D(offset, offset, offset));
        //convert to a vector pointing from the current position to the desired position and normalize
        pullToward = pullToward.addVector(this.position.multiplyScalar(-1)).normalize();
        //schoolingCoefficient is the "strength" of the pull, different for each species
        //(since some real fish species school more tightly than others)
        this.velocity = this.velocity.addVector(pullToward.multiplyScalar(this.schoolingCoefficient));
        return;
      }
    }
  }
}
