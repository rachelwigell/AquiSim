public class SinkingFood extends Food{
  
  public SinkingFood(Vector3D absolutePosition){
    this.absolutePosition = absolutePosition;
    this.position = absolutePosition.addVector(new Vector3D(-center.x, -center.y, -center.z));
    this.speedChangeLocation = new Vector3D(0, fieldY*(.5-waterLevel), 0);
    if(this.position.y < speedChangeLocation.y){
      this.velocity = new Vector3D(0, 8, 0);
    }
    else{
      this.velocity = new Vector3D(0, 1, 0);
    }
    this.dimensions = new Vector3D(5, 5, 5);
    this.RGBcolor = new Vector3D(200, 200, 0);
    this.restingPosition = new Vector3D(0, fieldY/2, 0);
  }
  
  //randomizes positions for save/load
  public SinkingFood(){
    this.absolutePosition = new Vector3D(0, 0, 0);
    this.absolutePosition.z = random(-1.5*fieldZ+30, -.5*fieldZ-30);
    this.absolutePosition.y = fieldY;
    this.absolutePosition.x = random(.025*fieldX+30, .975*fieldX-30);
    this.position = absolutePosition.addVector(new Vector3D(-center.x, -center.y, -center.z));
    this.speedChangeLocation = new Vector3D(0, fieldY*(.5-waterLevel), 0);
    if(this.position.y < speedChangeLocation.y){
      this.velocity = new Vector3D(0, 8, 0);
    }
    else{
      this.velocity = new Vector3D(0, 1, 0);
    }
    this.dimensions = new Vector3D(5, 5, 5);
    this.RGBcolor = new Vector3D(200, 200, 0);
    this.restingPosition = new Vector3D(0, fieldY/2, 0);
  }
  
  public void updateVelocity(){
    if(this.position.y >= this.speedChangeLocation.y && this.velocity.y > 1){
      this.velocity.y = 1;
    }
    if(this.position.y >= this.restingPosition.y && this.velocity.y > 0){
      this.velocity.y = 0;
      this.position.y = this.restingPosition.y;
    }
    if(vacuum && this.position.y >= this.speedChangeLocation.y){
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
        float magnitude = 5000/distBetween;
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
  }
  
  public void addToAppropriateList(tank t){
    t.sinkingFood.add(this);
  }
  
  public void removeFromAppropriateList(tank t){
    t.sinkingFood.remove(this);
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