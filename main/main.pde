Tank tank;
public final static int fieldX = window.screen.availWidth-200;
public final static int fieldY = window.screen.availHeight-200;
public final static int fieldZ = (800-fieldX*.2-fieldY*.2);
public final static float zoomPercentage = .85;

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
    box((zoomPercentage*.8*fieldX), (zoomPercentage*fieldY), 1); //back
    translate((zoomPercentage*.4*fieldX), 0, (zoomPercentage*.25*fieldZ));
    box(1, (zoomPercentage*fieldY), (zoomPercentage*.5*fieldZ)); //right
    translate((-zoomPercentage*.8*fieldX), 0, 0);
    box(1, (zoomPercentage*fieldY), (zoomPercentage*.5*fieldZ)); //left
    translate((zoomPercentage*.4*fieldX), (zoomPercentage*.5*fieldY), 1);
    fill(color(200));
    box((zoomPercentage*.8*fieldX), 1, (zoomPercentage*.5*fieldZ)); //bottom
    fill(color(0, 0, 255, 20));
    translate(0, (-zoomPercentage*.5*fieldY) + (zoomPercentage*fieldY*.5*(1-tank.waterLevel)), 0);
    hint(DISABLE_DEPTH_TEST);
    box((zoomPercentage*.8*fieldX), (zoomPercentage*fieldY*tank.waterLevel), (zoomPercentage*.5*fieldZ)); //water
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
