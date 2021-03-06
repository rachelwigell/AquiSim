public class Poop extends Waste{
  
  public Poop(Fish origin){
    this.absolutePosition = new Vector3D((origin.absolutePosition.x + cos(origin.orientation.y) * origin.dimensions.x/2.0),
        (origin.absolutePosition.y + sin(origin.orientation.z)*origin.dimensions.x/2.0),
        (origin.absolutePosition.z - sin(origin.orientation.y) * origin.dimensions.x/2.0));
    this.position = this.absolutePosition.addVector(new Vector3D(-center.x, -center.y, -center.z));
    this.velocity = new Vector3D(0, 1, 0);
    this.dimensions = new Vector3D(origin.size, origin.size, origin.size);
    this.RGBcolor = new Vector3D(150, 100, 0);
    this.restingPosition = new Vector3D(0, fieldY/2, 0);
    this.speedChangeLocation = null;
  }
  
  //randomizes positions for save/load
  public Poop(){
    this.absolutePosition = new Vector3D(0, 0, 0);
    this.absolutePosition.z = random(-1.5*fieldZ+30, -.5*fieldZ-30);
    this.absolutePosition.y = fieldY;
    this.absolutePosition.x = random(.025*fieldX+30, .975*fieldX-30);
    this.position = this.absolutePosition.addVector(new Vector3D(-center.x, -center.y, -center.z));
    this.velocity = new Vector3D(0, 1, 0);
    this.dimensions = new Vector3D(5, 5, 5);
    this.RGBcolor = new Vector3D(150, 100, 0);
    this.restingPosition = new Vector3D(0, fieldY/2, 0);
    this.speedChangeLocation = null;
  }
  
  public void removeFromTank(Tank t){
    t.poops.remove(this);
    t.waste--;
  }
  
  public void updateVelocity(){
    this.velocity = new Vector3D(0, 1, 0);
    if(vacuum){
      float z = -fieldZ;
      picker.captureViewMatrix(fieldX, fieldY);
      picker.calculatePickPoints(mouseX,height-mouseY);
      Vector3D start = new Vector3D(picker.ptStartPos.x, fieldY-picker.ptStartPos.y, picker.ptStartPos.z);
      Vector3D end = new Vector3D(picker.ptEndPos.x, fieldY-picker.ptEndPos.y, picker.ptEndPos.z);
      Vector3D normal = end.addVector(start.multiplyScalar(-1)).normalize();
      float factor = (z-start.z)/normal.z;
      Vector3D mousePos = start.addVector(normal.multiplyScalar(factor));
      if(mousePos.x > fieldX*.025 && mousePos.x < fieldX*.975 && mousePos.y < fieldY && mousePos.y > fieldY*(1-waterLevel)){
        float distBetween = mousePos.squareDistance(this.absolutePosition);
        float magnitude = 50000/distBetween;
        if(distBetween < 1000){
          this.removeFromTank(tank);
        }
        if(magnitude < .1){
          this.velocity = new Vector3D(0, 1, 0);
        }
        else{
          this.velocity = this.velocity.addVector(mousePos.addVector(this.absolutePosition.multiplyScalar(-1)).normalize().multiplyScalar(min(magnitude, 500)));
        }
      }
      else{
        this.velocity = new Vector3D(0, 1, 0);
      }
    }
    if(this.position.y >= this.restingPosition.y && this.velocity.y > 0){
      this.velocity.y = 0;
      this.position.y = this.restingPosition.y;
    }
  }
  
  public void drawWaste(){
    noStroke();
    pushMatrix();
    translate(fieldX/2, fieldY/2, -fieldZ);
    if(hasSubstrate()){
      translate(0, -16, 0);
    }
    translate(this.position.x, this.position.y, this.position.z);
    fill(this.RGBcolor.x, this.RGBcolor.y, this.RGBcolor.z);
    sphere(this.dimensions.x);
    popMatrix();    
  }
}