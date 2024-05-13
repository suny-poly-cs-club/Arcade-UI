import processing.core.*;

class Game{
  private PImage img;
  
  static PApplet dataSource;
  private static PImage defaultImage;
  
  private String name = "GAME NAME HERE";
  
  
  static void initClass(PApplet source){
    dataSource=source;
    defaultImage = dataSource.loadImage("data/defaultGameImage.png");
  }
  
  public PImage getImg(){
    return (img!=null)? img : defaultImage;
  }
  
  public void getName(UiText text){
    text.setText(name);
  }
}
