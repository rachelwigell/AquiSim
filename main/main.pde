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
public float waterLevel = .8;
public int maxFish = 20;
public int maxPlants = 6;

tank_stats =  {};
fish_stats = {};
species_stats = {};

String clickMode = "DEFAULT";
Plant previewPlant = null;
Vector3D zero = null;
Vector3D center = null;
boolean floatingFood = false;

void setup(){
  if(fieldY > fieldX){
    int temp = fieldY;
    fieldY = fieldX;
    fieldX = temp;
  }
  size(fieldX, fieldY, P3D);
  frameRate(30); //causes draw() to be called 30 times per second
  picker = new Selection_in_P3D_OPENGL_A3D();
  zero = new Vector3D(fieldX/2, fieldY*(1-.5*waterLevel), -fieldZ);
  center = new Vector3D(fieldX/2, fieldY/2, -fieldZ);
  
  String cookie = get_cookie("t");
  if(cookie == ""){
    tank = new Tank();
    accordion_defaults(true);
  }
  else{
    tank = new Tank(cookie);
    accordion_defaults(false);
    cookie = LZString.decompressFromUTF16(cookie);
    String[] stats = splitTokens(cookie, "+");
    var now = new Date();
    var lastSave = new Date(int(stats[13])+2000, int(stats[14]), int(stats[15]), int(stats[16]), int(stats[17]), 0, 0);
    int elapsedMinutes = int((now.getTime() - lastSave.getTime())/60000);
    tank.skipAhead(elapsedMinutes);
  }
  
  populateSpeciesList();
  populateSpeciesStats();
  update_tank_stats();
  update_fish_dropdown();
  update_fish_stats();
  update_species_dropdown();
  update_species_stats();
  handle_add_plant();
  handle_move_plant();
  handle_delete_plant();
  floatingFood = !$('#food_type').is(":checked");
  
  determineBounds();
}

void draw(){
  Vector3D bcolor = backgroundColor();
  background(bcolor.x, bcolor.y, bcolor.z);
  int spotColor = spotlightColor();
  ambientLight(spotColor, spotColor, spotColor);
  spotLight(spotColor/3, spotColor/3, spotColor/3, fieldX/4, 0, fieldZ, 0, 0, -1, PI/2, 0);
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
  speciesList.add(new NeonTetra("Swimmy"));
  speciesList.add(new CherryBarb("Swimmy"));
  speciesList.add(new WhiteCloudMountainMinnow("Swimmy"));
  speciesList.add(new CherryShrimp("Swimmy"));
  speciesList.add(new MysterySnail("Swimmy"));
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
  translate(0, (-.5*fieldY) + (fieldY*.5*(1-waterLevel)), 0);
  hint(DISABLE_DEPTH_TEST);
  box((.95*fieldX), (fieldY*waterLevel), (fieldZ)); //water
  fill(50, 50, 50, 20);
  translate(0, -.5*fieldY*waterLevel, 0);
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
    p.drawWaste();
    p.updatePosition();
  }
  for(int i = 0; i < tank.food.size(); i++){
    Food f = (Food) tank.food.get(i);
    f.drawWaste();
    f.updatePosition();
  }
  for(int i = 0; i < tank.deadFish.size(); i++){
    DeadFish d = (DeadFish) tank.deadFish.get(i);
    d.sprite.drawFish();
    d.updatePosition();
  }
}

public void drawStack(Plant plant){
  strokeWeight(5-plant.level);
  line(plant.path.start.x, plant.path.start.y, plant.path.start.z,
    plant.path.end.x, plant.path.end.y, plant.path.end.z);
  if(plant.level < 3){
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
    if(clickMode == "DELETE"){
      pushMatrix();
      noStroke();
      scale(1, .1, 1);
      fill(100, 100, 100);
      sphere(30);
      popMatrix();
      stroke(230, 10, 20);
      strokeWeight(5);
      line(-20, -2, 20, 20, -2, -20);
      line(20, -2, 20, -20, -2, -20);
    }
    else if(clickMode == "MOVE"){
      pushMatrix();
      noStroke();
      scale(1, .1, 1);
      fill(100, 100, 100);
      sphere(30);
      stroke(230, 10, 20);
      popMatrix();
      line(-30, -1, 0, -50, -1, 0);
      line(-50, -1, 0, -40, -1, 10);
      line(-50, -1, 0, -40, -1, -10);
      line(30, -1, 0, 50, -1, 0);
      line(50, -1, 0, 40, -1, 10);
      line(50, -1, 0, 40, -1, -10);
      line(0, -1, 30, 0, -1, 50);
      line(0, -1, 50, 10, -1, 40);
      line(0, -1, 50, -10, -1, 40);
      line(0, -1, -30, 0, -1, -50);
      line(0, -1, -50, 10, -1, -40);
      line(0, -1, -50, -10, -1, -40);
    }
    popMatrix();
  }
}

public void drawAllPlants(){
  for(int i = 0; i < tank.plants.size(); i++){
    Plant plant = (Plant) tank.plants.get(i);
    drawPlant(plant);
  }
  if(previewPlant != null && mouseY > 2*fieldY/3){
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
      if(mouseY > 2*fieldY/3){
        previewPlant.encoding = previewPlant.encode();
        tank.plants.add(previewPlant);
        $('#cancel_plant_add').click();
      }
      else{
        $('#cancel_plant_add').click();
      }
    }
    else if(clickMode == "DELETE"){
      handlePlantDeleteClick(x, y, start, end);
      $('#cancel_plant_delete').click();
      clickMode = "DEFAULT";
    }
    else if(clickMode == "MOVE"){
      if(handlePlantMoveClick(x, y, start, end)){
         clickMode = "PLANT";
      }
      else{
        clickMode = "DEFAULT";
      }
      $('#cancel_plant_move').click();
    }
    if(mouseButton == RIGHT){
      console.log("skipping ahead 1 hour");
      tank.skipAhead(60);
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
  tank_stats.pH = tank.pH.toFixed(2);
  tank_stats.temperature = tank.temp.toFixed(1) + ' °C';
  tank_stats.hardness = tank.hardness.toFixed(2) + ' dH';
  tank_stats.ammonia = tank.ammonia.toFixed(2) + ' ppm';
  tank_stats.nitrite = tank.nitrite.toFixed(2) + ' ppm';
  tank_stats.nitrate = tank.nitrate.toFixed(2) + ' ppm';
  tank_stats["O₂ "] = tank.o2.toFixed(1) + ' ppm';
  tank_stats["CO₂ "] = tank.co2.toFixed(1) + ' ppm';
  tank_stats.nitrosomonas = tank.nitrosomonas.toFixed(2) + 'M bacteria';
  tank_stats.nitrobacter = tank.nitrobacter.toFixed(2) + 'M bacteria';
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
  else if(speciesName == "Neon Tetra"){
    toAdd = new NeonTetra(nickname);
  }
  else if(speciesName == "Cherry Barb"){
    toAdd = new CherryBarb(nickname);
  }
  else if(speciesName == "White Cloud Mountain Minnow"){
    toAdd = new WhiteCloudMountainMinnow(nickname);
  }
  else if(speciesName == "Cherry Shrimp"){
    toAdd = new CherryShrimp(nickname);
  }
  else if(speciesName == "Mystery Snail"){
    toAdd = new MysterySnail(nickname);
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
  for(int i = 0; i < tank.sinkingFood.size(); i++){
    SinkingFood f = (SinkingFood) tank.sinkingFood.get(i);
    if(raySphereIntersect(start, normal, f.absolutePosition, f.dimensions.x*2)){
      if(f.absolutePosition.z > z){
        z = f.absolutePosition.z;
        closest = f;
      }
    }
  }
  for(int i = 0; i < tank.floatingFood.size(); i++){
    FloatingFood f = (FloatingFood) tank.floatingFood.get(i);
    if(rayTriangleIntersect(start, normal, f)){
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

public boolean rayTriangleIntersect(Vector3D rayOrigin, Vector3D rayNormal, FloatingFood f){
  Vector3D v0 = (Vector3D) f.points.get(0).addVector(f.absolutePosition);
  Vector3D v1 = (Vector3D) f.points.get(1).addVector(f.absolutePosition);
  Vector3D v2 = (Vector3D) f.points.get(2).addVector(f.absolutePosition);
  Vector3D e1 = v1.addVector(v0.multiplyScalar(-1));
  Vector3D e2 = v2.addVector(v0.multiplyScalar(-1));
  Vector3D h = rayNormal.crossProduct(e2);
  float a = e1.dotProduct(h);

  if (a > -0.00001 && a < 0.00001)
    return(false);

  float f = 1/a;
  Vector3D s = rayOrigin.addVector(v0.multiplyScalar(-1));
  float u = f * s.dotProduct(h);
  
  if (u < -0.2 || u > 1.2)
    return(false);

  Vector3D q = s.crossProduct(e1);
  float v = f * rayNormal.dotProduct(q);

  if (v < -0.2 || u + v > 1.2)
    return(false);
  t = f * e2.dotProduct(q);

  if (t > -.2) // ray intersection
    return(true);
  else // this means that there is a line intersection but not a ray intersection
     return (false);
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
  previewPlant = new Plant();
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
    if(floatingFood){
      tank.addFood(new FloatingFood(absolutePosition));
    }
    else{
      tank.addFood(new SinkingFood(absolutePosition));
    }
  }
  // clicked side of tank - place food
  else if((side = onSide(xCoord, yCoord)) != "No"){
    Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
    float x;
    if(side == "left") x = .025*fieldX+30;
    else x = .975*fieldX-30;
    float factor = (x-start.x)/normal.x;
    Vector3D absolutePosition = start.addVector(normal.multiplyScalar(factor));
    if(floatingFood){
      tank.addFood(new FloatingFood(absolutePosition));
    }
    else{
      tank.addFood(new SinkingFood(absolutePosition));
    }
  }
  // clicked bottom of tank - place food
  else if(onBottom(xCoord, yCoord)){
    Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
    float y = fieldY;
    float factor = (y-start.y)/normal.y;
    Vector3D absolutePosition = start.addVector(normal.multiplyScalar(factor));
    if(floatingFood){
      tank.addFood(new FloatingFood(absolutePosition));
    }
    else{
      tank.addFood(new SinkingFood(absolutePosition));
    }
  }
}

public boolean handlePlantDeleteClick(int x, int y, Vector3D start, Vector3D end){
  Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
  float y = fieldY;
  float factor = (y-start.y)/normal.y;
  Vector3D absolutePosition = start.addVector(normal.multiplyScalar(factor));
  for(int i = 0; i < tank.plants.size(); i++){
    Plant p = (Plant) tank.plants.get(i);
    if(absolutePosition.distance(p.absolutePosition) < 40){
      tank.plants.remove(p);
      return true;
    }
  }
  return false;
}

public boolean handlePlantMoveClick(int x, int y, Vector3D start, Vector3D end){
  Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
  float y = fieldY;
  float factor = (y-start.y)/normal.y;
  Vector3D absolutePosition = start.addVector(normal.multiplyScalar(factor));
  for(int i = 0; i < tank.plants.size(); i++){
    Plant p = (Plant) tank.plants.get(i);
    if(absolutePosition.distance(p.absolutePosition) < 40){
       previewPlant = p;
       tank.plants.remove(p);
       return true;
     }
   }
 return false;
}

public void deleteMode(){
  clickMode = "DELETE";
}

public void moveMode(){
  clickMode = "MOVE";
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

public ArrayList cookieInfo(){
  cookieInfo = new ArrayList();
  String tankStringPrefix = "t=";
  String tankString = "";
  tankString += tank.pH.toFixed(2) + "+";
  tankString += tank.temp.toFixed(2) + "+";
  tankString += tank.hardness.toFixed(2) + "+";
  tankString += tank.ammonia.toFixed(2) + "+";
  tankString += tank.nitrite.toFixed(2) + "+";
  tankString += tank.nitrate.toFixed(2) + "+";
  tankString += tank.o2.toFixed(2) + "+";
  tankString += tank.co2.toFixed(2) + "+";
  tankString += tank.nitrosomonas.toFixed(2) + "+";
  tankString += tank.nitrobacter.toFixed(2) + "+";
  tankString += min(tank.sinkingFood.size(), 99) + "+";
  tankString += min(tank.floatingFood.size(), 99) + "+";
  tankString += min(tank.poops.size(), 99) + "+";
  var date = new Date();
  tankString += date.getFullYear()-2000 + "+";
  tankString += date.getMonth() + "+";
  tankString += date.getDate() + "+";
  tankString += date.getHours() + "+";
  tankString += date.getMinutes();
  tankString = LZString.compressToUTF16(tankString) + ";";
  cookieInfo.add(tankStringPrefix + tankString);
  for(int i = 0; i < min(tank.fish.size(), maxFish); i++){
   Fish f = (Fish) tank.fish.get(i);
   String fishStringPrefix = "f" + i + "=";
   String fishString = "";
   fishString += f.species + "+";
   fishString += f.name + "+";
   fishString += f.health + "+";
   fishString += f.fullness + "+";
   fishString += f.minTemp.toFixed(2) + "+";
   fishString += f.maxTemp.toFixed(2) + "+";
   fishString += f.minHard.toFixed(2) + "+";
   fishString += f.maxHard.toFixed(2) + "+";
   fishString += f.minPH.toFixed(2) + "+";
   fishString += f.maxPH.toFixed(2);
   fishString = LZString.compressToUTF16(fishString) + ";";
   cookieInfo.add(fishStringPrefix + fishString);
  }
  for(int i = min(tank.fish.size(), maxFish); i < maxFish; i++){
    cookieInfo.add("f" + i + "=;");
  }
  for(int i = 0; i < min(tank.deadFish.size(), maxFish); i++){
   DeadFish f = (DeadFish) tank.deadFish.get(i);
   String fishStringPrefix = "d" + i + "=";
   String fishString = f.sprite.species;
   fishString = LZString.compressToUTF16(fishString) + ";";
   cookieInfo.add(fishStringPrefix + fishString);
  }
  for(int i = min(tank.deadFish.size(), maxFish); i < maxFish; i++){
    cookieInfo.add("d" + i + "=;");
  }
  for(int i = 0; i < min(tank.plants.size(), maxPlants); i++){
    Plant p = (Plant) tank.plants.get(i);
    String plantStringPrefix = "p" + i + "=";
    String plantString = p.encode();
    cookieInfo.add(plantStringPrefix + plantString + ";");
  }
  for(int i = min(tank.plants.size(), maxPlants); i < maxPlants; i++){
    cookieInfo.add("p" + i + "=;");
  }
  return cookieInfo;
}

public boolean hasMaxFish(){
  return tank.fish.size() >= maxFish;
}

public boolean hasMaxPlants(){
  return tank.plants.size() >= maxPlants;
}

public boolean setFloatingFood(boolean floating){
  floatingFood = floating;
  return floatingFood;
}