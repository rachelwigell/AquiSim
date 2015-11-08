public class FloatingFood extends Food{
  
  public FloatingFood(Vector3D absolutePosition){
    this.absolutePosition = absolutePosition;
    this.position = absolutePosition.addVector(new Vector3D(-center.x, -center.y, -center.z));
    this.speedChangeLocation = new Vector3D(0, fieldY*(.5-waterLevel), 0);
    if(this.position.y < speedChangeLocation.y){
      this.velocity = new Vector3D(0, 8, 0);
    }
    else{
      this.velocity = new Vector3D(0, -1, 0);
    }
    this.dimensions = new Vector3D(5, 5, 5);
    this.RGBcolor = new Vector3D(200, 200, 0);
    this.restingPosition = new Vector3D(0, fieldY*(.5-waterLevel), 0);
  }
  
  //randomizes positions for save/load
  public FloatingFood(){
    this.absolutePosition = new Vector3D(0, 0, 0);
    this.absolutePosition.z = random(-1.5*fieldZ+30, -.5*fieldZ-30);
    this.absolutePosition.y = fieldY*(.5-waterLevel)+center.y;
    this.absolutePosition.x = random(.025*fieldX+30, .975*fieldX-30);
    this.position = absolutePosition.addVector(new Vector3D(-center.x, -center.y, -center.z));
    this.speedChangeLocation = new Vector3D(0, fieldY*(.5-waterLevel), 0);
    if(this.position.y < speedChangeLocation.y){
      this.velocity = new Vector3D(0, 8, 0);
    }
    else{
      this.velocity = new Vector3D(0, -1, 0);
    }
    this.dimensions = new Vector3D(5, 5, 5);
    this.RGBcolor = new Vector3D(200, 200, 0);
    this.restingPosition = new Vector3D(0, fieldY*(.5-waterLevel), 0);
  }
  
  public void updateVelocity(){
    if(this.position.y >= this.speedChangeLocation.y && this.velocity.y == 8){
      this.velocity.y = -1;
    }
    if(this.position.y <= this.restingPosition.y && this.velocity.y == -1){
      this.velocity.y = 0;
    }
  }
  
  public void addToAppropriateList(tank t){
    t.floatingFood.add(this);
  }
  
  public void removeFromAppropriateList(tank t){
    t.floatingFood.remove(this);
  }
}