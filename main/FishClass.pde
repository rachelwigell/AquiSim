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
  public float minPH;
  public float maxPH;
  public float minTemp;
  public float maxTemp;
  public float minHard;
  public float maxHard;
  public float ammonia;
  public float nitrite;
  public float nitrate;
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

  public void setDangerRatings() {
    this.dangerRatings = new HashMap();
    this.dangerRatings.put("Ammonia", 3);
    this.dangerRatings.put("Nitrite", 2);
    this.dangerRatings.put("Nitrate", 1);
    this.dangerRatings.put("pH", 2);
    this.dangerRatings.put("Hardness", 1);
    this.dangerRatings.put("Temperature", 1);
  }
  
  public double getParameter(String parameter, boolean high){
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
      if(high){
        return this.maxPH;
      }
      else{
        return this.minPH;
      }
    }
    if(parameter == "Temperature"){
      if(high){
        return this.maxTemp;
      }
      else{
        return this.minTemp;
      }
    }
    if(parameter == "Hardness"){
      if(high){
        return this.maxHard;
      }
      else{
        return this.minHard;
      }
    }
  }

  public double setHealth() {
    if (this.status == "Happy.") {
      this.health = min(this.maxHealth, this.health+1);
    }
    else if (this.status == "Hungry!") {
      this.health = max(0, this.health-2);
    }
    else {
     String problemElement = "";
     Iterator i = this.dangerRatings.entrySet().iterator();
     while (i.hasNext()) {
      Map.Entry danger = (Map.Entry) i.next();
      String dangerKey = (String) danger.getKey();
      if (this.status.contains(dangerKey)) {
        problemElement = dangerKey;
        break;
      }
     }
     boolean problemDirection = status.contains("high");
     float dist = 0;
     dist = abs(tank.getParameter(problemElement) - this.getParameter(problemElement, problemDirection));
     float reduction = max(1, dist*this.dangerRatings.get(problemElement));
     this.health = max(0, this.health-reduction);
    }
    return this.health;
  }
  
  public void adapt(){
    float adaptCoeff = .005;
    if (this.status == "pH too high."){
       float dist = tank.pH - this.maxPH;
       this.minPH += adaptCoeff*dist;
       this.maxPH += adaptCoeff*dist;
    }
    else if (this.status == "pH too low."){
       float dist = this.minPH - tank.pH;
       this.minPH -= adaptCoeff*dist;
       this.maxPH -= adaptCoeff*dist;
    }
    else if (this.status == "Temperature too high."){
       float dist = tank.temp - this.maxTemp;
       this.minTemp += adaptCoeff*dist;
       this.maxTemp += adaptCoeff*dist;
    }
    else if (this.status == "Temperature too low."){
       float dist = this.minTemp - tank.temp;
       this.minTemp -= adaptCoeff*dist;
       this.maxTemp -= adaptCoeff*dist;
    }
    else if (this.status == "Hardness too high."){
       float dist = tank.hardness - this.maxHard;
       this.minHard += adaptCoeff*dist;
       this.maxHard += adaptCoeff*dist;
    }
    else if (this.status == "Hardness too low."){
       float dist = this.minHard - tank.hardness;
       this.minHard -= adaptCoeff*dist;
       this.maxHard -= adaptCoeff*dist;
    }
  }

  public long changeHunger() {
    int hunger = (int) (this.size); //hunger changes relative to fish size
    this.fullness = Math.max(this.fullness - hunger, 0);
    return hunger;
  }

  public void updatePosition() {
    this.position.x = new Vector3D((-.475*fieldX+this.dimensions.x/2.0), this.position.x+this.velocity.x, (.475*fieldX-this.dimensions.x/2.0)).centermost();
    this.position.y = new Vector3D((-.5*fieldY*waterLevel+this.dimensions.y/2.0), this.position.y+this.velocity.y, (.5*fieldY*waterLevel-this.dimensions.y/2.0)).centermost();
    this.position.z = new Vector3D((-.5*fieldZ+this.dimensions.x/2.0), this.position.z+this.velocity.z, (.5*fieldZ-this.dimensions.x/2.0)).centermost();
    this.absolutePosition = this.position.addVector(new Vector3D(zero.x, zero.y, zero.z));
    this.updateVelocity();
  }

  public void updateAcceleration() {
    if(swimming){
      if(random(0, this.activity*20) < 1){
        swimming = false;
      }
    }
    else{
      if(random(0, 100-this.activity*20) < 1){
        swimming = true;
      }
    }
    if(swimming){
      this.acceleration.x = new Vector3D(-.8, this.acceleration.x+random(-.2, .2), 1).centermost();
      this.acceleration.y = new Vector3D(-.8, this.acceleration.y+random(-.2, .2), 1).centermost();
      this.acceleration.z = new Vector3D(-.8, this.acceleration.z+random(-.2, .2), 1).centermost();
      this.regionPull();
    }
    else{
      this.acceleration.x = new Vector3D(-.8, -.1*this.velocity.x, .8).centermost();
      this.acceleration.y = new Vector3D(-.8, -.1*this.velocity.y, .8).centermost();
      this.acceleration.z = new Vector3D(-.8, -.1*this.velocity.z, .8).centermost();
    }
  }

  public void updateVelocity() {
    if(this.position.x <= (-.475*fieldX+this.dimensions.x/2.0)){
      this.acceleration.x = 1;
    }
    else if(this.position.x >= (.475*fieldX-this.dimensions.x/2.0)){
      this.acceleration.x = -1;
    }
    this.velocity.x = new Vector3D(-1-.2*this.activity, this.velocity.x + this.acceleration.x, 1+.2*this.activity).centermost();
    //let them hit the floor, in case they're going towards food that's there.
    this.velocity.y = new Vector3D(-1-.2*this.activity, this.velocity.y + this.acceleration.y, 1+.2*this.activity).centermost();
    if(this.position.z == (-.5*fieldZ+this.dimensions.x/2.0)){
     this.acceleration.z = 1;
    }
    else if(this.position.z == (.5*fieldZ-this.dimensions.x/2.0)){
     this.acceleration.z = -1;
    }
    this.velocity.z = new Vector3D(-1-.2*this.activity, this.velocity.z + this.acceleration.z, 1+.2*this.activity).centermost();
    pullTowardsSchool();
    this.velocity = this.velocity.addVector(this.hungerContribution());
    this.updateOrientationRelativeToVelocity();
    this.updateAcceleration();
  }

  public Vector3D hungerContribution() {
    Vector3D nearestFood = tank.nearestFood(this.absolutePosition);
    if (nearestFood == null) return new Vector3D(0, 0, 0);
    nearestFood = nearestFood.addVector(new Vector3D(-zero.x, -zero.y, -zero.z));
    float percent = max((.8-(max(this.fullness, 0)/((double) this.maxFullness)))*6, 0);
    Vector3D normal = nearestFood.addVector(this.position.multiplyScalar(-1)).normalize();
    return normal.multiplyScalar(percent);
  }

  public void regionPull() {
    float pull = .001*random(0, 10)*abs(this.region) * (fieldY*waterLevel*this.region - this.position.y);
    this.acceleration.y += pull;
  }

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
    translate(zero.x, zero.y, zero.z);
    translate(this.position.x, this.position.y, this.position.z);
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
    fill(0);
    scale(1/this.scaleVal, 1/this.scaleVal, 1/this.scaleVal);
    translate(-this.offset.x, -this.offset.y, -this.offset.z);
    translate(this.dimensions.x*this.eyePosition.x, this.dimensions.y*this.eyePosition.y, this.dimensions.z*this.eyePosition.z);
    sphere(2.5);
    translate(0, 0, -2*this.dimensions.z*this.eyePosition.z);
    sphere(2.5);
    popMatrix();
  }
  
  // pull toward the nearest fish that comes before you in the list
  public void pullTowardsSchool(){
    Vector3D nearest = null;
    float distance = MAX_FLOAT;
    for(int i = 0; i < tank.fish.size(); i++){
      Fish f = (Fish) tank.fish.get(i);
      if(f.species != this.species){
        continue;
      }
      float dist = this.position.squareDistance(f.position);
      if(dist < .001){
        break;
      }
      if(dist < distance){
        distance = dist;
        nearest = f.position;
      }
    }
    if(nearest != null){
      //we don't want to pull toward the nearest fish's exact position.
      //instead we pull towards the point halfway between your own position and his
      nearest = nearest.addVector(this.position.multiplyScalar(-.5));
      //normalize
      nearest = nearest.addVector(this.position.multiplyScalar(-1)).normalize();
      //schoolingCoefficient is the "strength" of the pull, different for each species
      //strength also affected by distance; when farther away, the pull is stronger
      this.velocity = this.velocity.addVector(nearest.multiplyScalar(.01 * sqrt(distance) * this.schoolingCoefficient));
    }
  }
}