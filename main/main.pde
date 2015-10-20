/**************************************************
 * INITIALIZE *
 **************************************************/

public final static int fieldX = window.screen.availWidth-100;
public final static int fieldY = window.screen.availHeight-100;
public final static int fieldZ = (fieldX*.1+fieldY*.1);

public Tank tank;
public ArrayList speciesList = new ArrayList();
public Selection_in_P3D_OPENGL_A3D picker;
public int backMinX = null;
public int backMaxX = null;
public int backMaxY = null;
public int leftMinX = null;
public int rightMaxX = null;
public int sidesMaxY = null;
public int updateCount = 0;

tank_stats =  {};
fish_stats = {};
species_stats = {};

public void populateSpeciesList(){
  speciesList.add(new Guppy("Swimmy"));
}

void setup(){
  size(fieldX, fieldY, P3D);
  frameRate(30); //causes draw() to be called 30 times per second
  picker = new Selection_in_P3D_OPENGL_A3D();
  
  tank = new Tank();
  populateSpeciesList();
  populateSpeciesStats();
  
  determineBounds();
  
  addFishToTank("Guppy", "Swimmy");
}

void draw(){
  Vector3D bcolor = backgroundColor();
  background(bcolor.x, bcolor.y, bcolor.z);
  int spotColor = spotlightColor();
  ambientLight(spotColor, spotColor, spotColor);
  drawTank();
  drawAllFish();
  drawAllWaste();
  if(updateCount > 150){ //operations to happen every 5 seconds
      tank.progress();
      updateTankStats();
      updateFishStats();
      updateCount = 0;
    }
  updateCount++;
}

/**************************************************
 * DRAW *
 **************************************************/

public void drawTank(){
  noStroke();
  pushMatrix();
  translate((.5*fieldX), (.8*fieldY), -1.5*fieldZ);
  translate(0, (.5*fieldY), -1);
  fill(color(200, 180, 100));
  box(2*fieldX, fieldY, 1); //table
  translate(0, (-.8*fieldY), 1);
  fill(color(200));
  box((.95*fieldX), (fieldY), 1); //back
  fill(color(255));
  translate((.475*fieldX), 0, (.5*fieldZ));
  box(1, (fieldY), (fieldZ)); //right
  translate((-.95*fieldX), 0, 0);
  box(1, (fieldY), (fieldZ)); //left
  translate((.475*fieldX), (.5*fieldY), 0);
  fill(color(180));
  box((.95*fieldX), 1, (fieldZ)); //bottom
  fill(color(0, 0, 255, 20));
  translate(0, (-.5*fieldY) + (fieldY*.5*(1-tank.waterLevel)), 0);
  hint(DISABLE_DEPTH_TEST);
  box((.95*fieldX), (fieldY*tank.waterLevel), (fieldZ)); //water
  fill(50, 50, 50, 20);
  translate(0, -.5*fieldY*tank.waterLevel, 0);
  box((.95*fieldX), 1, fieldZ);
  popMatrix();
}

void drawAllFish(){
  hint(ENABLE_DEPTH_TEST);
  for(int i=0; i < tank.fish.size(); i++){
    Fish f = (Fish) tank.fish.get(i);
    noStroke();
    pushMatrix();
    translate(fieldX/2, fieldY/2, -fieldZ);
    translate(f.position.x, f.position.y, f.position.z);
    rotateX(f.orientation.x);
    rotateY(f.orientation.y);
    rotateZ(f.orientation.z);
    Vector3D currentColor = (Vector3D) f.model.get(0); //side
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, -6, 7.5);
    vertex(20, -6, 7.5);
    vertex(20, 6, 7.5);
    vertex(-20, 6, 7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(1); //back trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(40, -1.5, 2.5);
    vertex(20, -6, 7.5);
    vertex(20, 6, 7.5);
    vertex(40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(2); //top trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, -6, 7.5);
    vertex(-4, -18, 2.5);
    vertex(4, -18, 2.5);
    vertex(20, -6, 7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(3); //top (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, -18, 2.5);
    vertex(-4, -18, -2.5);
    vertex(4, -18, -2.5);
    vertex(4, -18, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(4); //top back triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, -18, 2.5);
    vertex(20, -6, 7.5);
    vertex(40, -1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(5); //top of top back triangle (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, -18, -2.5);
    vertex(4, -18, 2.5);
    vertex(40, -1.5, 2.5);
    vertex(40, -1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(6); //bottom trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, 6, 7.5);
    vertex(-4, 18, 2.5);
    vertex(4, 18, 2.5);
    vertex(20, 6, 7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(7); //bottom back triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, 18, 2.5);
    vertex(20, 6, 7.5);
    vertex(40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(8); //bottom of bottom trapezoid (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, 18, -2.5);
    vertex(4, 18, 2.5);
    vertex(-4, 18, 2.5);
    vertex(-4, 18, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(9); //bottom of bottom back triangle (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, 18, 2.5);
    vertex(4, 18, -2.5);
    vertex(40, 1.5, -2.5);
    vertex(40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(10); //front trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-40, -1.5, 2.5);
    vertex(-20, -6, 7.5);
    vertex(-20, 6, 7.5);
    vertex(-40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(11); //top front triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, -18, 2.5);
    vertex(-20, -6, 7.5);
    vertex(-40, -1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(12); //top of top front triangle (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, -18, -2.5);
    vertex(-4, -18, 2.5);
    vertex(-40, -1.5, 2.5);
    vertex(-40, -1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(13); //bottom front triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, 18, 2.5);
    vertex(-20, 6, 7.5);
    vertex(-40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(14); //bottom of bottom front triangle (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, 18, -2.5);
    vertex(-4, 18, 2.5);
    vertex(-40, 1.5, 2.5);
    vertex(-40, 1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(15); //front (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-40, 1.5, -2.5);
    vertex(-40, 1.5, 2.5);
    vertex(-40, -1.5, 2.5);
    vertex(-40, -1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(16); //side tail
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(40, -1.5, 2.5);
    vertex(58, -20, 2.5);
    vertex(58, -15, 2.5);
    vertex(52, 0, 2.5);
    vertex(58, 15, 2.5);
    vertex(58, 20, 2.5);
    vertex(40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(17); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(40, -1.5, 2.5);
    vertex(40, -1.5, -2.5);
    vertex(58, -20, -2.5);
    vertex(58, -20, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(18); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(58, -20, -2.5);
    vertex(58, -20, 2.5);
    vertex(58, -15, 2.5);
    vertex(58, -15, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(19); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(58, -15, 2.5);
    vertex(58, -15, -2.5);
    vertex(52, 0, -2.5);
    vertex(52, 0, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(20); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(52, 0, 2.5);
    vertex(52, 0, -2.5);
    vertex(58, 15, -2.5);
    vertex(58, 15, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(21); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(58, 15, 2.5);
    vertex(58, 15, -2.5);
    vertex(58, 20, -2.5);
    vertex(58, 20, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(22); //tail sides (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(58, 20, 2.5);
    vertex(58, 20, -2.5);
    vertex(40, 1.5, -2.5);
    vertex(40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(0); //side
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, -6, -7.5);
    vertex(20, -6, -7.5);
    vertex(20, 6, -7.5);
    vertex(-20, 6, -7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(1); //back trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(40, -1.5, -2.5);
    vertex(20, -6, -7.5);
    vertex(20, 6, -7.5);
    vertex(40, 1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(2); //top trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, -6, -7.5);
    vertex(-4, -18, -2.5);
    vertex(4, -18, -2.5);
    vertex(20, -6, -7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(4); //top back triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, -18, -2.5);
    vertex(20, -6, -7.5);
    vertex(40, -1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(6); //bottom trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, 6, -7.5);
    vertex(-4, 18, -2.5);
    vertex(4, 18, -2.5);
    vertex(20, 6, -7.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(7); //bottom back triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, 18, -2.5);
    vertex(20, 6, -7.5);
    vertex(40, 1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(10); //front trapezoid
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-40, -1.5, -2.5);
    vertex(-20, -6, -7.5);
    vertex(-20, 6, -7.5);
    vertex(-40, 1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(11); //top front triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, -18, -2.5);
    vertex(-20, -6, -7.5);
    vertex(-40, -1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(13); //bottom front triangle
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-4, 18, 2.5);
    vertex(-20, 6, 7.5);
    vertex(-40, 1.5, 2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(16); //side tail
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(40, -1.5, -2.5);
    vertex(58, -20, -2.5);
    vertex(58, -15, -2.5);
    vertex(52, 0, -2.5);
    vertex(58, 15, -2.5);
    vertex(58, 20, -2.5);
    vertex(40, 1.5, -2.5);
    endShape(CLOSE);
    popMatrix();
    updatePosition(f);
  }
}
  
public void drawAllWaste(){
//    for(int i = 0; i < this.tank.poops.length; i++){
//      Poop p = (Poop) this.tank.poops.get(i);
//      drawWaste(p);
//      updatePosition(p);
//    }
  for(int i = 0; i < tank.food.size(); i++){
    Food f = (Food) tank.food.get(i);
    drawWaste(f);
    f.updatePosition();
  }
//    for(int i = 0; i < this.tank.deadFish.length; i++){
//      DeadFish d = (DeadFish) this.tank.deadFish.get(i);
//      drawDeadFish(d);
//      updatePosition(d);
//    }
}
  
public void drawWaste(Waste s){
  noStroke();
  pushMatrix();
  translate(fieldX/2, fieldY/2, -fieldZ);
  translate(s.position.x, s.position.y, s.position.z);
  fill(s.RGBcolor.x, s.RGBcolor.y, s.RGBcolor.z);
  sphere(s.dimensions.x);
  popMatrix();    
}

public void mouseReleased(){
    picker.captureViewMatrix(fieldX, fieldY);
    picker.calculatePickPoints(mouseX,height-mouseY);
    Vector3D start = new Vector3D(picker.ptStartPos.x, fieldY-picker.ptStartPos.y, picker.ptStartPos.z);
    Vector3D end = new Vector3D(picker.ptEndPos.x, fieldY-picker.ptEndPos.y, picker.ptEndPos.z);
    // first check whether waste was clicked on; if so, remove it
    Waste w = removeWaste(start, end);
    if(w != null){
      w.removeFromTank(tank);
    }
    // clicked back of tank - place food
    else if(mouseX >= backMinX && mouseX <= backMaxX && mouseY <= backMaxY){
      Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
      float percent = random(0, 1);
      float z = (float) (-fieldZ + 30 + percent*(.5*fieldZ)-30);
      float factor = (z-start.z)/normal.z;
      Vector3D absolutePosition = start.addVector(normal.multiplyScalar(factor));
      tank.addFood(new Food(absolutePosition));
    }
    // clicked side of tank - place food
    else if((side = onSide(mouseX, mouseY)) != "No"){
      Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
      float x;
      if(side == "left") x = .025*fieldX;
      else x = .975*fieldX;
      float factor = (x-start.x)/normal.x;
      Vector3D absolutePosition = start.addVector(normal.multiplyScalar(factor));
      tank.addFood(new Food(absolutePosition));
    }
    // clicked bottom of tank - place food
    else if(onBottom(mouseX, mouseY)){
      Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
      float y = fieldY;
      float factor = (y-start.y)/normal.y;
      Vector3D absolutePosition = start.addVector(normal.multiplyScalar(factor));
      tank.addFood(new Food(absolutePosition));
    }
}

/**************************************************
 * TALK TO JAVASCRIPT *
 **************************************************/

public void populateSpeciesStats(){
  for(int i = 0; i < speciesList.size(); i++){
    Fish f = (Fish) speciesList.get(i);
    species_stats[f.species] = {
      "image url": f.sprite,
      "Species:": f.species,
      "Ease of care:": f.ease + "/5",
      "Ammonia levels tolerated:": "0-" + f.ammonia + ' ppm',
      "Nitrite levels tolerated:": "0-" + f.nitrite + ' ppm',
      "Nitrate levels tolerated:": "0-" + f.nitrate + ' ppm',
      "pH levels tolerated:": f.minPH + "-" + f.maxPH,
      "Temperatures tolerated:": f.minTemp + "-" + f.maxTemp + ' °C',
      "Hardness levels tolerated:": f.minHard + "-" + f.maxHard + ' dH'
    };
  }
}

public void updateTankStats(){
  tank_stats.pH = roundFloat(tank.pH);
  tank_stats.temperature = roundFloat(tank.temp) + ' °C';
  tank_stats.hardness = roundFloat(tank.hardness) + ' dH';
  tank_stats.ammonia = roundFloat(tank.ammonia) + ' ppm';
  tank_stats.nitrite = roundFloat(tank.nitrite) + ' ppm';
  tank_stats.nitrate = roundFloat(tank.nitrate) + ' ppm';
  tank_stats.o2 = roundFloat(tank.o2) + ' ppm';
  tank_stats.co2 = roundFloat(tank.co2) + ' ppm';
  tank_stats.nitrosomonas = roundFloat(tank.nitrosomonas) + ' bacteria';
  tank_stats.nitrobacter = roundFloat(tank.nitrobacter) + ' bacteria';
  tank_stats.food = (tank.food).size() + ' noms';
  tank_stats.waste = tank.waste + ' poops';
}

public void updateFishStats(){
  for(int i = 0; i < tank.fish.size(); i++){
    Fish f = (Fish) (tank.fish.get(i));
    fish_stats[f.name] = {
      "Name:": f.name,
      "Ammonia levels tolerated:": "0-" + f.ammonia + ' ppm',
      "Species:": f.species,
      "Nitrite levels tolerated:": "0-" + f.nitrite + ' ppm',
      "image url": f.sprite,
      "Nitrate levels tolerated:": "0-" + f.nitrate + ' ppm',
      "Status:": f.status,
      "pH levels tolerated:": f.minPH + "-" + f.maxPH,
      "fullness": f.fullness,
      "Temperatures tolerated:": f.minTemp + "-" + f.maxTemp + ' °C',
      "health": f.health,
      "Hardness levels tolerated:": f.minHard + "-" + f.maxHard + ' dH',
      "max health": f.maxHealth,
      "max fullness": f.maxFullness
    };
  }
}

public void waterChange(float percent){
  tank.waterChange(percent);
}

/**************************************************
 * HELPERS *
 **************************************************/

public String roundFloat(float toRound){
  return str(toRound).substring(0, 4);
}

public Vector3D backgroundColor(){
  int time = tank.time;
  return new Vector3D( ((160.0/1020.0)*(720-abs(720-time) + 300)),  ((180.0/1020.0)*(720-abs(720-time) + 300)),  ((200.0/1020.0)*(720-abs(720-time) + 300)));
}

public int spotlightColor(){
  int time = tank.time;
  return  ((200.0/1320.0)*(720-abs(720-time) + 600));
}

public Fish addFishToTank(String speciesName, String nickname){
  Fish toAdd = null;
  if(speciesName == "Guppy"){
    toAdd = new Guppy(nickname);
  }
  if(toAdd != null){
    tank.addFish(toAdd);
  }
  return toAdd;
}

public void determineBounds(){
  backMinX = int(screenX(.025*fieldX, .5*fieldY, -1.5*fieldZ));
  backMaxX = fieldX -  backMinX;
  backMaxY = int(screenY(.5*fieldX, fieldY, -1.5*fieldZ));
  leftMinX = int(screenX(.025*fieldX, fieldY/2, -.5*fieldZ));
  rightMaxX = fieldX - leftMinX;
  sidesMaxY = int(screenY(0.25*fieldX, fieldY, -.5*fieldZ));
}

public void updatePosition(Fish fish){
  fish.position.x = new Vector3D((-.475*fieldX+fish.dimensions.x/2.0), fish.position.x+fish.velocity.x, (.475*fieldX-fish.dimensions.x/2.0)).centermost();
  fish.position.y = new Vector3D((fieldY/2-fish.dimensions.y/2.0), fish.position.y+fish.velocity.y, (fieldY*(.5-tank.waterLevel)+fish.dimensions.y/2.0)).centermost();
  fish.position.z = new Vector3D((-.5*fieldZ+fish.dimensions.x/2.0), fish.position.z+fish.velocity.z, (.5*fieldZ-fish.dimensions.x/2.0)).centermost();
  updateVelocity(fish);
}

public void updateAcceleration(Fish fish){
  fish.acceleration.x += random(-.25, .25);
  fish.acceleration.y += random(-.125, .125);
  fish.acceleration.z += random(-.25, .25);
}

public void updateVelocity(Fish fish){
  fish.velocity.x = new Vector3D(-2, fish.velocity.x + fish.acceleration.x, 2).centermost();
  fish.velocity.y = new Vector3D(-2, fish.velocity.y + fish.acceleration.y, 2).centermost();
  fish.velocity.z = new Vector3D(-2, fish.velocity.z + fish.acceleration.z, 2).centermost();
//  fish.velocity = fish.velocity.addVector(hungerContribution(tank));
  updateOrientationRelativeToVelocity(fish);
  updateAcceleration(fish);
}

public void updateOrientationRelativeToVelocity(Fish fish){
  Vector3D velocity = fish.velocity;  
  double angle = Math.asin(Math.abs(velocity.z)/velocity.magnitude());
  if(velocity.x < 0 && velocity.z > 0) fish.orientation.y = angle;
  else if(velocity.x > 0 && velocity.z > 0) fish.orientation.y = (PI - angle);
  else if(velocity.x > 0 && velocity.z < 0) fish.orientation.y = (PI + angle);
  else if(velocity.x < 0 && velocity.z < 0) fish.orientation.y = -angle;
  else if(velocity.z == 0 && velocity.x < 0) fish.orientation.y = 0;
  else if(velocity.x == 0 && velocity.z > 0) fish.orientation.y = (PI/2.0);
  else if(velocity.z == 0 && velocity.x > 0) fish.orientation.y = PI;
  else if(velocity.x == 0 && velocity.z < 0) fish.orientation.y = (3*PI/2.0);
  fish.orientation.z = new Vector3D(-1, -velocity.y, 1).centermost() * PI/6;
}

public float triangleArea(Vector3D point1, Vector3D point2, Vector3D point3){
  return (float) Math.abs(((point1.x*(point2.y-point3.y)) + point2.x*(point3.y-point1.y) + point3.x*(point1.y-point2.y))/2.0);
}

public String onSide(float x, float y){
  Vector3D point = new Vector3D(x, y, 0);
  
    Vector3D leftBottomLeft = new Vector3D(leftMinX, sidesMaxY, 0);
    Vector3D leftBottomRight = new Vector3D(backMinX, backMaxY, 0);
    Vector3D leftTopRight = new Vector3D(backMinX, 0, 0);
    Vector3D leftTopLeft = new Vector3D(leftMinX, 0, 0);
    float area = triangleArea(leftBottomLeft, leftBottomRight, leftTopLeft) + triangleArea(leftBottomRight, leftTopRight, leftTopLeft);
    float pointArea  = triangleArea(leftBottomLeft, point, leftBottomRight) + triangleArea(leftBottomRight, point, leftTopRight) +
        triangleArea(leftTopRight, point, leftTopLeft) + triangleArea(leftTopLeft, point, leftBottomLeft);
        
    if(pointArea <= area){
      return "left";
    }

    Vector3D rightBottomLeft = new Vector3D(backMaxX, backMaxY, 0);
    Vector3D rightBottomRight = new Vector3D(rightMaxX, sidesMaxY, 0);
    Vector3D rightTopRight = new Vector3D(rightMaxX, 0, 0);
    Vector3D rightTopLeft = new Vector3D(backMaxX, 0, 0);
    float area = triangleArea(rightBottomLeft, rightBottomRight, rightTopLeft) + triangleArea(rightBottomRight, rightTopRight, rightTopLeft);
    float pointArea  = triangleArea(rightBottomLeft, point, rightBottomRight) + triangleArea(rightBottomRight, point, rightTopRight) +
        triangleArea(rightTopRight, point, rightTopLeft) + triangleArea(rightTopLeft, point, rightBottomLeft);

    if(pointArea <= area){
      return "right";
    }
    
    return "No";
}

public boolean onBottom(float x, float y){
  Vector3D point = new Vector3D(x, y, 0);
  
  Vector3D bottomLeft = new Vector3D(leftMinX, sidesMaxY, 0);
  Vector3D bottomRight = new Vector3D(rightMaxX, sidesMaxY, 0);
  Vector3D topRight = new Vector3D(backMaxX, backMaxY, 0);
  Vector3D topLeft = new Vector3D(backMinX, backMaxY, 0);
  
  float area = triangleArea(bottomLeft, bottomRight, topLeft) + triangleArea(bottomRight, topRight, topLeft);
  float pointArea  = triangleArea(bottomLeft, point, bottomRight) + triangleArea(bottomRight, point, topRight) +
      triangleArea(topRight, point, topLeft) + triangleArea(topLeft, point, bottomLeft);
  
  return pointArea <= area;
}

public Waste removeWaste(Vector3D start, Vector3D end){
  Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
  Waste closest = null;
  float z = -100000;
//  for(Poop p: tank.poops){
//    if(raySphereIntersect(start, normal, p.absolutePosition, p.dimensions.x*2)){
//      if(p.absolutePosition.z > z){
//        z = p.absolutePosition.z;
//        closest = p;
//      } 
//    }
//  }
  for(int i = 0; i < tank.food.size(); i++){
    Food f = (Food) tank.food.get(i);
    if(raySphereIntersect(start, normal, f.absolutePosition, f.dimensions.x*2)){
      if(f.absolutePosition.z > z){
        z = f.absolutePosition.z;
        closest = f;
      }
    }
  }
//  for(DeadFish d: tank.deadFish){
//    if(clickedDeadFish(d, start, normal)){
//      if(d.absolutePosition.z > z){
//        z = d.absolutePosition.z;
//        closest = d;
//      }        
//    }
//  }
  return closest;
}

public boolean raySphereIntersect(Vector3D rayOrigin, Vector3D rayNormal, Vector3D sphereCenter, float sphereRadius){
  double determinant = Math.pow(rayNormal.dotProduct(rayOrigin.addVector(sphereCenter.multiplyScalar(-1))), 2) - Math.pow(rayOrigin.addVector(sphereCenter.multiplyScalar(-1)).magnitude(), 2) + Math.pow(sphereRadius, 2);
  return determinant >= 0;
}
