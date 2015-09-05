public Tank tank;
public final static int fieldX = window.screen.availWidth-100;
public final static int fieldY = window.screen.availHeight-100;
public final static int fieldZ = (fieldX*.1+fieldY*.1);

public ArrayList speciesList = new ArrayList();

//debug_string = "Default debug string";

tank_stats =  {};

fish_stats = {};

species_stats = {};

  void setup(){
    size(fieldX, fieldY, P3D);
    tank = new Tank();
    camera();
    fill(color(0));
    populateSpeciesList();
    populateSpeciesStats();
    tank.progress();
  }
  
  void draw(){
    Vector3D bcolor = backgroundColor();
    background(bcolor.x, bcolor.y, bcolor.z);
    int spotColor = spotlightColor();
    spotLight(spotColor, spotColor, spotColor, fieldX/2, 0, 1500, 0, 0, -1, PI/4, 0);
    drawTank();
    updateTankStats();
    updateFishStats();
    tank.progress();
  }
  
  public void drawTank(){
    noStroke();
    pushMatrix();
    translate((.5*fieldX), (.8*fieldY), -fieldZ);
    translate(0, (.5*fieldY), -1);
    fill(color(200, 180, 100));
    box(2*fieldX, fieldY, 1); //table
    translate(0, (-.8*fieldY), 1);
    fill(color(255));
    box((.95*fieldX), (fieldY), 1); //back
    translate((.475*fieldX), 0, (.25*fieldZ));
    box(1, (fieldY), (.5*fieldZ)); //right
    translate((-.95*fieldX), 0, 0);
    box(1, (fieldY), (.5*fieldZ)); //left
    translate((.475*fieldX), (.5*fieldY), 1);
    fill(color(200));
    box((.95*fieldX), 1, (.5*fieldZ)); //bottom
    fill(color(0, 0, 255, 20));
    translate(0, (-.5*fieldY) + (fieldY*.5*(1-tank.waterLevel)), 0);
    hint(DISABLE_DEPTH_TEST);
    box((.95*fieldX), (fieldY*tank.waterLevel), (.5*fieldZ)); //water
    popMatrix();
  }
  
  public void populateSpeciesList(){
    speciesList.add(new Guppy("Swimmy"));
  }
  
  public void populateSpeciesStats(){
    for(int i = 0; i < speciesList.size(); i++){
      Fish f = (Fish) speciesList.get(i);
      species_stats[f.species] = {
        "Species": f.species,
        "Ease of care": f.ease + "/5",
        "Maximum ammonia level tolerated": f.ammonia + ' ppm',
        "Maximum nitrite level tolerated": f.nitrite + ' ppm',
        "Maximum nitrate level tolerated": f.nitrate + ' ppm',
        "Minimum pH level tolerated": f.minPH,
        "Maximum pH level tolerated": f.maxPH,
        "Minimum temperature tolerated": f.minTemp + ' degrees Celsius',
        "Maximum temperature tolerated": f.maxTemp + ' degrees Celsius',
        "Minimum hardness tolerated": f.minHard + ' dH',
        "Maximum hardness tolerated": f.maxHard + ' dh',
      };
    }
  }
  
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
  
  public void updateTankStats(){
    tank_stats.pH = roundFloat(tank.pH);
    tank_stats.temperature = roundFloat(tank.temp) + ' degrees Celsius';
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
        "Name": f.name,
        "Species": f.species,
        "Status": f.status.stringify(),
        "Maximum ammonia level tolerated": f.ammonia + ' ppm',
        "Maximum nitrite level tolerated": f.nitrite + ' ppm',
        "Maximum nitrate level tolerated": f.nitrate + ' ppm',
        "Minimum pH level tolerated": f.minPH,
        "Maximum pH level tolerated": f.maxPH,
        "Minimum temperature tolerated": f.minTemp + ' degrees Celsius',
        "Maximum temperature tolerated": f.maxTemp + ' degrees Celsius',
        "Minimum hardness tolerated": f.minHard + ' dH',
        "Maximum hardness tolerated": f.maxHard + ' dh',
        "fullness": f.fullness,
        "health": f.health
      };
    }
  }
  
  public void waterChange(float percent){
    tank.waterChange(percent);
  }
