//first* funtion called from this program by processing
void setup(){
  //start in fullscreen mode with the 3D OpenGL rederer
  //fullScreen(P3D);
  
  size(1280,1024,P3D);//manauly set window size for testing
  
  
  
  //initilize the UI Frame with a base resoltion of 12080 x 1024 (the resolution of the arcade screen)
  //this class does all the calculations nessary to make a well scaled and adapted UI for any resolution
  //while allowing the programer to wright the UI code as if the screen is just gaing to be the base resolution
  //it must be initilized here becasue this is the earliest place where the actual screen resolution is known
  ui=new UiFrame(this,1280,1024);
  
  textSize(100*ui.scale());//generate the text texture at default size 50
  //in processing all text is renderd from a pre computed texture of all the letters
  //this text is renderd when textSize is called for the first time
  //while this has a major seed benifit it causes test that is sized farm the the initial size to have noticable scale ing artifacts
  
  //initilize text and buttons that require the UI Frame
  initilizeText();
  initilizeButtons();
}

UiFrame ui;

//main render function 
//automcaticaly called by the render theread once every frame
void draw(){
  background(0);//set the background color to black clearing anything currently on screen
  noStroke();//stroke with the 3D render can be kinda anoying
  
  //title bar
  fill(#002C73);
  uiRect(20,20,1240,130);
  fill(255);
  titleText.draw();
  
  renderGameSelection(0);
}

/**draws the main part of the selection UI 
*/
void renderGameSelection(int gameId){
  
}

//if the window is resized
void windowResized() {
  //tell the UI Frame to recalculate
  ui.reScale();
}


//this methos is not currently incorperated into any class but is very usefull
/** same as the normal rect but autocaling with the Ui Frame
  @param x the unscaled x coord to draw the rect at
  @param y the unscaled y coord to draw the rect at
  @param width the unscaled with of the rect
  @param height the unscaled height of the rect
*/
void uiRect(float x,float y,float width,float height){
  rect(ui.topX()+x*ui.scale(),ui.topY()+y*ui.scale(),width*ui.scale(),height*ui.scale());
}
