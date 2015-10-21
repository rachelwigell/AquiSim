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
    this.position = this.position.addVector(velocity);
    this.absolutePosition = this.absolutePosition.addVector(velocity);
  }

  public void removeFromTank(Tank t) {}
  
  public void updateVelocity(){}
}

