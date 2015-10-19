public class Food extends Waste{
  
  public Food(Vector3D position){
    this.position = position;  
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
}
