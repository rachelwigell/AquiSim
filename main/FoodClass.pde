public class Food extends Waste{
  
  public void removeFromTank(Tank t){
    t.food.remove(this);
  }
}