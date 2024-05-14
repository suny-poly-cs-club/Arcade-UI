//class to represent the stars in the background of the menu
class Star{
  PVector pos;
  Star(){
    pos = new PVector(-3000,random(-100,1230),random(-1000,-5));
  }
  
  void draw(){
    translate(0,0,pos.z);
    fill(255);
    uiRect(pos.x,pos.y,2,2);
    translate(0,0,-pos.z);
  }
  
  boolean update(int slefIndex){
    pos.x+=2.5;
    if(pos.x > 7000){
      stars.remove(slefIndex);
      return true;
    }
    return false;
  }
}
