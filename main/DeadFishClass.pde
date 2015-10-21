public class DeadFish extends Waste{
  Fish sprite;
  
  public DeadFish(Fish origin){
    this.sprite = origin;
    origin.orientation = new Vector3D(PI, origin.orientation.y, 0);
    this.dimensions = origin.dimensions;
    this.restingPosition = new Vector3D(0, fieldY*(.5-tank.waterLevel), 0);
    this.velocity = new Vector3D(0, -1, 0);
    this.position = origin.position;
    this.absolutePosition = origin.position.addVector(new Vector3D(fieldX/2, fieldY/2, -fieldZ));   
  }
  
  public void removeFromTank(Tank t){
    t.deadFish.remove(this);
  }
  
  public void updatePosition() {
    this.updateVelocity();
    this.position = this.position.addVector(velocity);
    this.sprite.position = this.position;
    this.absolutePosition = this.absolutePosition.addVector(velocity);
  }
  
  public void updateVelocity(){
    if(this.position.y <= this.restingPosition.y && this.velocity.y < 0){
      this.velocity.y = 0;
    }
  }
}
