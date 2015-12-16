public class FloatingFood extends Food{
  ArrayList points;
  
  public FloatingFood(Vector3D absolutePosition){
    this.absolutePosition = absolutePosition;
    this.absolutePosition.y = min(this.absolutePosition.y, fieldY/2+center.y-2);
    this.position = absolutePosition.addVector(new Vector3D(-center.x, -center.y, -center.z));
    this.speedChangeLocation = new Vector3D(0, fieldY*(.5-waterLevel), 0);
    if(this.position.y <= speedChangeLocation.y){
      this.velocity = new Vector3D(0, 8, 0);
    }
    else{
      this.velocity = new Vector3D(0, 1, 0);
    }
    this.points = new ArrayList();
    Vector3D first = new Vector3D(0, 0, 0);
    Vector3D normal = new Vector3D(random(-1, 1), 0, random(-1, 1));
    Vector3D second = first.addVector(normal.multiplyScalar(40));
    Vector3D midpoint = first.addVector(normal.multiplyScalar(20));
    Vector3D perpNormal = new Vector3D(normal.z, 0, -normal.x);
    Vector3D third = midpoint.addVector(perpNormal.multiplyScalar(random(30, 50)));
    points.add(first);
    points.add(second);
    points.add(third);
    this.RGBcolor = new Vector3D(200, 120, 0);
    this.restingPosition = new Vector3D(0, fieldY/2-2, 0);
  }
  
  //randomizes positions for save/load
  public FloatingFood(){
    this.absolutePosition = new Vector3D(0, 0, 0);
    this.absolutePosition.z = random(-1.5*fieldZ+30, -.5*fieldZ-30);
    this.absolutePosition.y = fieldY*(.5-waterLevel)+center.y;
    this.absolutePosition.x = random(.025*fieldX+30, .975*fieldX-30);
    this.position = absolutePosition.addVector(new Vector3D(-center.x, -center.y, -center.z));
    this.speedChangeLocation = new Vector3D(0, fieldY*(.5-waterLevel), 0);
    if(this.position.y <= speedChangeLocation.y){
      this.velocity = new Vector3D(0, 8, 0);
    }
    else{
      this.velocity = new Vector3D(0, 1, 0);
    }
    this.points = new ArrayList();
    Vector3D first = new Vector3D(0, 0, 0);
    Vector3D normal = new Vector3D(random(-1, 1), 0, random(-1, 1));
    Vector3D second = first.addVector(normal.multiplyScalar(40));
    Vector3D midpoint = first.addVector(normal.multiplyScalar(20));
    Vector3D perpNormal = new Vector3D(normal.z, 0, -normal.x);
    Vector3D third = midpoint.addVector(perpNormal.multiplyScalar(random(30, 50)));
    points.add(first);
    points.add(second);
    points.add(third);
    this.RGBcolor = new Vector3D(200, 120, 0);
    this.restingPosition = new Vector3D(0, fieldY/2-2, 0);
  }
  
  public void updateVelocity(){
    if(this.position.y >= this.speedChangeLocation.y && (this.velocity.y == 8 || this.velocity.y == -.5)){
      this.velocity.y = -.5;
    }
    else if(this.position.y <= this.speedChangeLocation.y && this.velocity.y <= 0){
      this.velocity.y = 0;
    }
    else if(this.position.y >= this.restingPosition.y && this.velocity.y >= 0){
      this.position.y = this.restingPosition.y;
      this.velocity.y = 0;
    }
    else if(this.position.y > this.speedChangeLocation.y){
      this.velocity = new Vector3D(0, 1, 0);
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
      else if(this.position.y > this.speedChangeLocation.y+8){
        this.velocity = new Vector3D(0, 1, 0);
      }
      else{
        this.velocity = new Vector3D(0, 0, 0);
      }
    }
  }
  
  public void addToAppropriateList(tank t){
    t.floatingFood.add(this);
  }
  
  public void removeFromAppropriateList(tank t){
    t.floatingFood.remove(this);
  }
  
  public void drawWaste(){
    noStroke();
    pushMatrix();
    translate(fieldX/2, fieldY/2, -fieldZ);
    translate(this.position.x, this.position.y, this.position.z);
    fill(this.RGBcolor.x, this.RGBcolor.y, this.RGBcolor.z);
    beginShape();
    for(int i = 0; i < this.points.size(); i ++){
      Vector3D point = (Vector3D) points.get(i);
      vertex(point.x, point.y, point.z);
    }
    endShape(CLOSE);
    popMatrix();    
  }
}