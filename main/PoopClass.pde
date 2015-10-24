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
    this.speedChangeLocation = null
  }
  
  public void removeFromTank(Tank t){
    t.poops.remove(this);
    t.waste--;
  }
  
  public void updateVelocity(){
    if(this.position.y >= this.restingPosition.y && this.velocity.y > 0){
      this.velocity.y = 0;
    }
  }
}