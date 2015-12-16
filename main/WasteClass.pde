public abstract class Waste {
  public Vector3D position;
  public Vector3D absolutePosition;
  public Vector3D RGBcolor;
  public Vector3D velocity;
  public Vector3D dimensions;
  public Vector3D restingPosition;
  public Vector3D speedChangeLocation;

  public void updatePosition() {
    this.updateVelocity();
    if(this.position.y < fieldY*(.5-waterLevel) && this.velocity.y > 0){
      this.position = this.position.addVector(this.velocity);
    }
    else{
      this.position = new Vector3D(new Vector3D(-.475*fieldX, this.position.x + this.velocity.x, .475*fieldX).centermost(),
                                   new Vector3D(fieldY*(.5-waterLevel), this.position.y + this.velocity.y, .5*fieldY).centermost(),
                                   new Vector3D(-.5*fieldZ, this.position.z + this.velocity.z, .5*fieldZ).centermost());
    }
    this.absolutePosition = this.position.addVector(center);
  }

  public void removeFromTank(Tank t) {}
  
  public void updateVelocity(){}
  
  public void drawWaste(){}
}