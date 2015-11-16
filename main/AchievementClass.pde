public abstract class Achievement {
  public PShape rewardModel;
  public String rewardSprite;
  public String rewardDescription;
  public String condition;
  public String rewardName;
  public boolean earned;
  public boolean used;
  public Vector3D position;
  public float orientation;
  public int scaleVal;
  
  public boolean checkFulfilled(){}
}