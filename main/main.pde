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

String clickMode = "DEFAULT";
Plant previewPlant = null;
Vector3D zero = null;
Vector3D center = null;

void setup(){
  size(fieldX, fieldY, P3D);
  frameRate(30); //causes draw() to be called 30 times per second
  picker = new Selection_in_P3D_OPENGL_A3D();
  
  tank = new Tank();
  populateSpeciesList();
  populateSpeciesStats();
  zero = new Vector3D(fieldX/2, fieldY*(1-.5*tank.waterLevel), -fieldZ);
  center = new Vector3D(fieldX/2, fieldY/2, -fieldZ);
  
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
  tank.allEat();
  drawAllPlants();
  if(updateCount > 150){ //operations to happen every 5 seconds
      tank.progress();
      updateCount = 0;
    }
  updateCount++;
}

public void populateSpeciesList(){
  speciesList.add(new Guppy("Swimmy"));
}

public void determineBounds(){
  backMinX = int(screenX(.025*fieldX, .5*fieldY, -1.5*fieldZ));
  backMaxX = fieldX -  backMinX;
  backMaxY = int(screenY(.5*fieldX, fieldY, -1.5*fieldZ));
  leftMinX = int(screenX(.025*fieldX, fieldY/2, -.5*fieldZ));
  rightMaxX = fieldX - leftMinX;
  sidesMaxY = int(screenY(0.25*fieldX, fieldY, -.5*fieldZ));
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
    f.drawFish();
    f.updatePosition();
  }
}
  
public void drawAllWaste(){
  for(int i = 0; i < tank.poops.size(); i++){
    Poop p = (Poop) tank.poops.get(i);
    drawWaste(p);
    p.updatePosition();
  }
  for(int i = 0; i < tank.food.size(); i++){
    Food f = (Food) tank.food.get(i);
    drawWaste(f);
    f.updatePosition();
  }
  for(int i = 0; i < tank.deadFish.size(); i++){
    DeadFish d = (DeadFish) tank.deadFish.get(i);
    d.sprite.drawFish();
    d.updatePosition();
  }
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

public void drawStack(Plant plant){
  strokeWeight(5-plant.level);
  line(plant.path.start.x, plant.path.start.y, plant.path.start.z,
    plant.path.end.x, plant.path.end.y, plant.path.end.z);
  if(plant.level < plant.endLevel){
    for(int i = 0; i < plant.numBranches; i++){
      Plant b = (Plant) plant.branches[i];
      drawStack(b);
    }
  }
}

public void drawPlant(Plant plant){
  for(int j = 0; j < 3; j++){
    stroke(plant.RGBcolor.x, plant.RGBcolor.y, plant.RGBcolor.z);
    pushMatrix();
    translate(center.x, center.y, center.z);
    translate(plant.position.x, plant.position.y, plant.position.z);
    drawStack(plant.stack[j]);
    popMatrix();
  }
}

public void drawAllPlants(){
  for(int i = 0; i < tank.plants.size(); i++){
    Plant plant = (Plant) tank.plants.get(i);
    drawPlant(plant);
  }
  if(previewPlant != null && onBottom(mouseX, mouseY)){
    picker.captureViewMatrix(fieldX, fieldY);
    picker.calculatePickPoints(mouseX,height-mouseY);
    Vector3D start = new Vector3D(picker.ptStartPos.x, fieldY-picker.ptStartPos.y, picker.ptStartPos.z);
    Vector3D end = new Vector3D(picker.ptEndPos.x, fieldY-picker.ptEndPos.y, picker.ptEndPos.z);
    previewPlant.changePosition(start, end);
    drawPlant(previewPlant);
  }
}

public void mouseReleased(){
    int x = mouseX;
    int y = mouseY;
    picker.captureViewMatrix(fieldX, fieldY);
    picker.calculatePickPoints(x,height-y);
    Vector3D start = new Vector3D(picker.ptStartPos.x, fieldY-picker.ptStartPos.y, picker.ptStartPos.z);
    Vector3D end = new Vector3D(picker.ptEndPos.x, fieldY-picker.ptEndPos.y, picker.ptEndPos.z);
    if(clickMode == "DEFAULT"){
      // first check whether waste was clicked on; if so, remove it
      wasteRemoved = handleWasteClick(start, end);
      if(!wasteRemoved){
        handleFoodClick(x, y, start, end);
      }
    }
    else if(clickMode == "PLANT"){
      if(onBottom(x, y)){
          tank.plants.add(previewPlant);
          $('#cancel_plant_add').click();
      }
      else{
        $('#cancel_plant_add').click();
      }
    }
    else if(clickMode == "DELETE"){
      if(handlePlantDeleteClick(x, y)){
         $('#cancel_plant_add').click();
      }
    }
    //if(mouseButton == RIGHT){
    //  console.log("skipping ahead 1 hour");
    //  skipAhead(60);
    //}
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
  tank_stats.pH = tank.pH.toFixed(2);
  tank_stats.temperature = tank.temp.toFixed(1) + ' °C';
  tank_stats.hardness = tank.hardness.toFixed(2) + ' dH';
  tank_stats.ammonia = tank.ammonia.toFixed(2) + ' ppm';
  tank_stats.nitrite = tank.nitrite.toFixed(2) + ' ppm';
  tank_stats.nitrate = tank.nitrate.toFixed(2) + ' ppm';
  tank_stats.o2 = tank.o2.toFixed(1) + ' ppm';
  tank_stats.co2 = tank.co2.toFixed(1) + ' ppm';
  tank_stats.nitrosomonas = tank.nitrosomonas.toFixed(0) + ' bacteria';
  tank_stats.nitrobacter = tank.nitrobacter.toFixed(0) + ' bacteria';
  tank_stats.food = tank.food.size() + ' noms';
  tank_stats.waste = tank.waste + ' poops';
}

public void updateFishStats(){
  fish_stats = {};
  for(int i = 0; i < tank.fish.size(); i++){
    Fish f = (Fish) (tank.fish.get(i));
    fish_stats[f.name] = {
      "Name:": f.name,
      "Ammonia levels tolerated:": "0-" + f.ammonia.toFixed(1) + ' ppm',
      "Species:": f.species,
      "Nitrite levels tolerated:": "0-" + f.nitrite.toFixed(1) + ' ppm',
      "image url": f.sprite,
      "Nitrate levels tolerated:": "0-" + f.nitrate.toFixed(1) + ' ppm',
      "Status:": f.status,
      "pH levels tolerated:": f.minPH.toFixed(1) + "-" + f.maxPH.toFixed(1),
      "fullness": f.fullness,
      "Temperatures tolerated:": f.minTemp.toFixed(1) + "-" + f.maxTemp.toFixed(1) + ' °C',
      "health": f.health,
      "Hardness levels tolerated:": f.minHard.toFixed(1) + "-" + f.maxHard.toFixed(1) + ' dH',
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
    updateFishStats();
  }
  return toAdd;
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
  float z = MIN_FLOAT;
  for(int i = 0; i < tank.poops.size(); i++){
    Poop p = (Poop) tank.poops.get(i);
    if(raySphereIntersect(start, normal, p.absolutePosition, p.dimensions.x*2)){
      if(p.absolutePosition.z > z){
        z = p.absolutePosition.z;
        closest = p;
      } 
    }
  }
  for(int i = 0; i < tank.food.size(); i++){
    Food f = (Food) tank.food.get(i);
    if(raySphereIntersect(start, normal, f.absolutePosition, f.dimensions.x*2)){
      if(f.absolutePosition.z > z){
        z = f.absolutePosition.z;
        closest = f;
      }
    }
  }
  for(int i = 0; i < tank.deadFish.size(); i++){
    DeadFish d = (DeadFish) tank.deadFish.get(i);
    if(clickedDeadFish(d, start, normal)){
      if(d.absolutePosition.z > z){
        z = d.absolutePosition.z;
        closest = d;
      }        
    }
  }
  return closest;
}

public boolean raySphereIntersect(Vector3D rayOrigin, Vector3D rayNormal, Vector3D sphereCenter, float sphereRadius){
  double determinant = Math.pow(rayNormal.dotProduct(rayOrigin.addVector(sphereCenter.multiplyScalar(-1))), 2) - Math.pow(rayOrigin.addVector(sphereCenter.multiplyScalar(-1)).magnitude(), 2) + Math.pow(sphereRadius, 2);
  return determinant >= 0;
}

public void skipAhead(int minutes){
  for(int i = 0; i < minutes*12; i++){
    tank.progress();
//    moveAllFish(visual);
//    allRandomizedEat();
  }
}

public boolean clickedDeadFish(DeadFish d, Vector3D rayOrigin, Vector3D rayNormal){
  float width = abs((cos(d.sprite.orientation.y)*d.dimensions.x) + abs(sin(d.sprite.orientation.y)*d.dimensions.z));
  float height = d.dimensions.y;
  float dist = (d.absolutePosition.z-rayOrigin.z)/rayNormal.z;
  Vector3D pointAt = rayOrigin.addVector(rayNormal.multiplyScalar(dist));
  return pointAt.x < (d.absolutePosition.x + width/2.0) && pointAt.x > (d.absolutePosition.x - width/2.0)
      && pointAt.y < (d.absolutePosition.y + height/2.0) && pointAt.y > (d.absolutePosition.y - height/2.0);
}

public void createPlantPreview(){
  clickMode = "PLANT";
  previewPlant = new Plant(0, 0, 7, 3);
}

public void cancelPlant(){
  clickMode = "DEFAULT";
  previewPlant = null;
}

public boolean handleWasteClick(Vector3D start, Vector3D end){
  Waste w = removeWaste(start, end);
  if(w != null){
    w.removeFromTank(tank);
    return true;
  }
  return false;
}
  
public void handleFoodClick(int xCoord, int yCoord, Vector3D start, Vector3D end){
  // clicked back of tank - place food
  if(xCoord >= backMinX && xCoord <= backMaxX && yCoord <= backMaxY){
    Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
    float percent = random(0, 1);
    float z = new Vector3D(-1.5*fieldZ+30, -1.5*fieldZ + percent*fieldZ, -.5*fieldZ-30).centermost();
    float factor = (z-start.z)/normal.z;
    Vector3D absolutePosition = start.addVector(normal.multiplyScalar(factor));
    tank.addFood(new Food(absolutePosition));
  }
  // clicked side of tank - place food
  else if((side = onSide(xCoord, yCoord)) != "No"){
    Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
    float x;
    if(side == "left") x = .025*fieldX+30;
    else x = .975*fieldX-30;
    float factor = (x-start.x)/normal.x;
    Vector3D absolutePosition = start.addVector(normal.multiplyScalar(factor));
    tank.addFood(new Food(absolutePosition));
  }
  // clicked bottom of tank - place food
  else if(onBottom(xCoord, yCoord)){
    Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
    float y = fieldY;
    float factor = (y-start.y)/normal.y;
    Vector3D absolutePosition = start.addVector(normal.multiplyScalar(factor));
    tank.addFood(new Food(absolutePosition));
  }
}

public boolean handlePlantDeleteClick(int x, int y){
 clickedColor = get(x, fieldY-y);
 Vector3D clickedRGB = new Vector3D(red(clickedColor), green(clickedColor), blue(clickedColor));
 for(int i = 0; i < tank.plants.size(); i++){
   Plant p = (Plant) tank.plants.get(i);
   if(p.RGBcolor.isEqual(clickedRGB)){
     tank.plants.remove(p);
     handle_delete_plant();
     return true;
   }
 }
 return false;
}

public void deleteMode(){
  clickMode = "DELETE";
}

public boolean haveFishWithName(String name){
  for(int i = 0; i < tank.fish.size(); i++){
    Fish f = (Fish) tank.fish.get(i);
    if(f.name == name){
      return true;
    }
  }
  return false;
}

public boolean hasPlants(){
  return tank.plants.size() > 0;
}