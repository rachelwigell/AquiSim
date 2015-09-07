/**************************************************
 * INITIALIZE *
 **************************************************/

public final static int fieldX = window.screen.availWidth-100;
public final static int fieldY = window.screen.availHeight-100;
public final static int fieldZ = (fieldX*.1+fieldY*.1);

public Tank tank;
public ArrayList speciesList = new ArrayList();

tank_stats =  {};
fish_stats = {};
species_stats = {};

public void populateSpeciesList(){
  speciesList.add(new Guppy("Swimmy"));
}

void setup(){
  size(fieldX, fieldY, P3D);
  tank = new Tank();
  fill(color(0));
  populateSpeciesList();
  addFishToTank("Guppy", "Swimmy");
  populateSpeciesStats();
  tank.progress();
}

void draw(){
  Vector3D bcolor = backgroundColor();
  background(bcolor.x, bcolor.y, bcolor.z);
  int spotColor = spotlightColor();
  spotLight(spotColor, spotColor, spotColor, fieldX/2, 0, 1500, 0, 0, -1, PI/4, 0);
  drawTank();
  drawAllFish();
  updateTankStats();
  updateFishStats();
  tank.progress();
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
  fill(color(255));
  box((.95*fieldX), (fieldY), 1); //back
  translate((.475*fieldX), 0, (.5*fieldZ));
  box(1, (fieldY), (fieldZ)); //right
  translate((-.95*fieldX), 0, 0);
  box(1, (fieldY), (fieldZ)); //left
  translate((.475*fieldX), (.5*fieldY), 0);
  fill(color(200));
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
    shape(f.model);
    popMatrix();
    //updatePosition(f);
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
  return  ((255.0/1020.0)*(720-abs(720-time) + 300));
}

public void addFishToTank(String speciesName, String nickname){
  Fish toAdd = null;
  for(int i=0; i<speciesList.size(); i++){
    Fish f = (Fish) speciesList.get(i);
    if(f.species.equals(speciesName)){
      toAdd = f.createFromNickname(nickname);
      tank.addFish(toAdd);
    }
  }
}
