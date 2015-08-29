Tank tank;
public final static int fieldX = window.screen.availWidth-200;
public final static int fieldY = window.screen.availHeight-200;
public final static int fieldZ = (fieldX*.1+fieldY*.1);

tank_stats =  {
  pH: 8,
  temperature: 24,
  hardness: 6,
  ammonia: 0,
  nitrite: 0,
  nitrate: 0,
  o2: 11,
  co2: 11,
  nitrosomonas: .01,
  nitrobacter: .01,
  food: 0,
  waste: 0
};

  void setup(){
    size(fieldX, fieldY, P3D);
    tank = new Tank();
    camera();
    fill(color(0));
  }
  
  void draw(){
    Vector3D bcolor = backgroundColor();
    background(bcolor.x, bcolor.y, bcolor.z);
    int spotColor = spotlightColor();
    spotLight(spotColor, spotColor, spotColor, fieldX/2, 0, 1500, 0, 0, -1, PI/4, 0);
    drawTank();
    updateTankStats();
  }
  
  public void drawTank(){
    noStroke();
    pushMatrix();
    translate((.5*fieldX), (.8*fieldY), -fieldZ);
    translate(0, (.5*fieldY), -1);
    fill(color(200, 180, 100));
    box(2*fieldX, fieldY, 1);
    translate(0, (-.8*fieldY), 1);
    fill(color(255));
    box((.8*fieldX), (fieldY), 1); //back
    translate((.4*fieldX), 0, (.25*fieldZ));
    box(1, (fieldY), (.5*fieldZ)); //right
    translate((-.8*fieldX), 0, 0);
    box(1, (fieldY), (.5*fieldZ)); //left
    translate((.4*fieldX), (.5*fieldY), 1);
    fill(color(200));
    box((.8*fieldX), 1, (.5*fieldZ)); //bottom
    fill(color(0, 0, 255, 20));
    translate(0, (-.5*fieldY) + (fieldY*.5*(1-tank.waterLevel)), 0);
    hint(DISABLE_DEPTH_TEST);
    box((.8*fieldX), (fieldY*tank.waterLevel), (.5*fieldZ)); //water
    popMatrix();
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
    tank_stats.pH = tank.pH;
    tank_stats.temperature = tank.temp + ' degrees Celsius';
    tank_stats.hardness = tank.hardness + ' dH';
    tank_stats.ammonia = tank.ammonia + ' ppm';
    tank_stats.nitrite = tank.nitrite + ' ppm';
    tank_stats.nitrate = tank.nitrate + ' ppm';
    tank_stats.o2 = tank.o2 + ' ppm';
    tank_stats.co2 = tank.co2 + ' ppm';
    tank_stats.nitrosomonas = tank.nitrosomonas + ' bacteria';
    tank_stats.nitrobacter = tank.nitrobacter + ' bacteria';
    tank_stats.food = (tank.food).size() + ' noms';
    tank_stats.waste = tank.waste + ' poops';
  }
