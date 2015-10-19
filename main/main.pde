/**************************************************
 * INITIALIZE *
 **************************************************/

public final static int fieldX = window.screen.availWidth-100;
public final static int fieldY = window.screen.availHeight-100;
public final static int fieldZ = (fieldX*.1+fieldY*.1);

public Tank tank;
public ArrayList speciesList = new ArrayList();
public Selection_in_P3D_OPENGL_A3D picker;
public int backMinX = 99999;
public int backMaxX = -1;
public int backMaxY = -1;
public int leftMinX = 99999;
public int rightMaxX = -1;
public int sidesMaxY = -1;
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
  
  //determineBounds();
  
  addFishToTank("Guppy", "Swimmy");
}

void draw(){
  Vector3D bcolor = backgroundColor();
  background(bcolor.x, bcolor.y, bcolor.z);
//  lights();
  int spotColor = spotlightColor();
  ambientLight(spotColor, spotColor, spotColor);
//  spotLight(spotColor, spotColor, spotColor, fieldX/4, 0, 400, 0, 0, -1, PI/2, 0);
  drawTank();
  drawAllFish();
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
  popMatrix();
}

void drawAllFish(){
  hint(ENABLE_DEPTH_TEST);
  for(int i=0; i<tank.fish.size(); i++){
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
    currentColor = (Vector3D) f.model.get(8); //bottom of bottom back triangle (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(4, 18, -2.5);
    vertex(4, 18, 2.5);
    vertex(40, 1.5, 2.5);
    vertex(40, 1.5, -2.5);
    endShape(CLOSE);
    currentColor = (Vector3D) f.model.get(9); //bottom of bottom trapezoid (not repeat)
    fill(currentColor.x, currentColor.y, currentColor.z);
    beginShape();
    vertex(-20, 6, 7.5);
    vertex(-4, 18, 2.5);
    vertex(4, 18, 2.5);
    vertex(20, 6, 7.5);
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

public void mouseReleased(){
    picker.captureViewMatrix(fieldX, fieldY);
    picker.calculatePickPoints(mouseX,height-mouseY);
    PVector start = picker.ptStartPos;
    PVector end = picker.ptEndPos;
//    console.log(start);
//    console.log(end);
//    if(mouseX >= backMinX && mouseX <= backMaxX && mouseY <= backMaxY){
//      tank.addFood(new Food(this, new Vector3D(start.x, start.y, start.z), new Vector3D(end.x, end.y, end.z)));
//    }
//    else if(onLeftSide(mouseX, mouseY)){
//      tank.addFood(new Food(this, new Vector3D(start.x, start.y, start.z), new Vector3D(end.x, end.y, end.z), true));
//    }
//    else if(onRightSide(mouseX, mouseY)){
//      tank.addFood(new Food(this, new Vector3D(start.x, start.y, start.z), new Vector3D(end.x, end.y, end.z), false));
//    }
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
  for(int i=0; i<speciesList.size(); i++){
    Fish f = (Fish) speciesList.get(i);
    if(f.species.equals(speciesName)){
      toAdd = f.createFromNickname(nickname);
      tank.addFish(toAdd);
    }
  }
  return toAdd;
}

public void drawDummyBox(){
    noLights();
    noStroke();
    fill(255, 0, 0);
    pushMatrix();
    translate((.5*fieldX), (.5*fieldY), (-1.5*fieldZ));
    box((.95*fieldX), (fieldY), 1); //back
    fill(255, 255, 0);
    translate((.475*fieldX), 0, (.5*fieldZ));
    box(1, (fieldY), (fieldZ)); //right
    translate((-.95*fieldX), 0, 0);
    box(1, (fieldY), (fieldZ)); //left
    popMatrix();
}

public void determineBounds(){
    drawDummyBox();
    loadPixels();
    draw();
    int x = 0;
    int y = 0;
    for(int i: pixels){
      if(i == -65536){
        if(x < backMinX) backMinX = x;
        else if(x > backMaxX) backMaxX = x;
        if(y > backMaxY) backMaxY = y;
      }
      else if (i == -256){
        if( x < leftMinX) leftMinX = x;
        else if(x > rightMaxX) rightMaxX = x;
        if(y > sidesMaxY) sidesMaxY = y;
      }
      x++;
      if(x >= fieldX){
        x = 0;
        y++;
      }
    }
  }

public void addFoodToTank(Vector3D start, Vector3D end){
  Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
  float factor = 0;
}

public void updatePosition(Fish fish){
  fish.position.x = new Vector3D((-.475*fieldX+fish.dimensions.x/2.0), fish.position.x+fish.velocity.x, (.475*fieldX-fish.dimensions.x/2.0)).centermost();
  fish.position.y = new Vector3D((fieldY/2-fish.dimensions.y/2.0), fish.position.y+fish.velocity.y, (fieldY*(.5-tank.waterLevel)+fish.dimensions.y/2.0)).centermost();
  fish.position.z = new Vector3D((-.5*fieldZ+fish.dimensions.x/2.0), fish.position.z+fish.velocity.z, (.5*fieldZ-fish.dimensions.x/2.0)).centermost();
  updateVelocity(fish);
}

public void updateAcceleration(Fish fish){
  fish.acceleration.x += random()*.25-.125;
  fish.acceleration.y += random()*.25-.125;
  fish.acceleration.z += random()*.25-.125;
}

public void updateVelocity(Fish fish){
  fish.velocity.x = new Vector3D(-1, fish.velocity.x + fish.acceleration.x, 1).centermost();
  fish.velocity.y = new Vector3D(-1, fish.velocity.y + fish.acceleration.y, 1).centermost();
  fish.velocity.z = new Vector3D(-1, fish.velocity.z + fish.acceleration.z, 1).centermost();
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
