public class Food extends Waste{
  
  public Food(Vector3D absolutePosition){
    this.absolutePosition = absolutePosition;
    this.position = absolutePosition.addVector(new Vector3D(-fieldX/2, -fieldY/2, fieldZ));
    this.speedChangeLocation = new Vector3D(0, fieldY*(.5-tank.waterLevel), 0);
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
  
  public void removeFromTank(Tank t){
    t.food.remove(this);
  }
}
