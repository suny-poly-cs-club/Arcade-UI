import net.java.games.input.*;//theese imports are nessary to get processing to include the library in the export
import net.java.games.util.plugins.*;
import net.java.games.util.*;

//first* funtion called from this program by processing
void setup(){
  //start in fullscreen mode with the 3D OpenGL rederer
  fullScreen(P3D);
  
  //size(1280,1024,P3D);//manauly set window size for testing
  
  
  
  //initilize the UI Frame with a base resoltion of 12080 x 1024 (the resolution of the arcade screen)
  //this class does all the calculations nessary to make a well scaled and adapted UI for any resolution
  //while allowing the programer to wright the UI code as if the screen is just gaing to be the base resolution
  //it must be initilized here becasue this is the earliest place where the actual screen resolution is known
  ui=new UiFrame(this,1280,1024);
  
  textSize(100*ui.scale());//generate the text texture at default size 50
  //in processing all text is renderd from a pre computed texture of all the letters
  //this text is renderd when textSize is called for the first time
  //while this has a major seed benifit it causes test that is sized farm the the initial size to have noticable scale ing artifacts
  
  Game.initClass(this,(int)(600*ui.scale()));
  
  //initilize text and buttons that require the UI Frame
  initilizeText();
  initilizeButtons();
  
  
  loading=true;
  //load all the game info on a seperate thread incase the drive is slow
  thread("loadGames");
}

UiFrame ui;

ArrayList<Game> games = new ArrayList<>();

int currentLeaderBoardLevel =0;

int currentGameIndex =0,prevousGameIndex=0;

String gameConfigFile = "data/games.csv";

boolean loading = true, controllerError=false;
boolean animationRight = false, animationLeft= false;
boolean gameStarted = false,launched=false;

Process runningGame;

GamePadWrapper controller = new GamePadWrapper();

int controlerErrorTimeStamp=0,lastControllUseTime=0,errorTimeStamp=0,animationStartTimestamp;

float defCameraFOV = 60 * DEG_TO_RAD; // at least for now
float defCameraX = width / 2.0f;
float defCameraY = height / 2.0f;
float defCameraZ = defCameraY / ((float) Math.tan(defCameraFOV / 2.0f));


// 0=prevGame 1=prevLreaderBoard 2=nextLeaderBoard 3=play 4=nextGame
int selectedButton =3;

//main render function 
//automcaticaly called by the render theread once every frame
void draw(){
  camera();//reset the camera
  if(controllerError){
    background(200);
    textSize(100);
    fill(0);
    textAlign(CENTER,CENTER);
    text("Controller Error!\n Restarting momnetrarily",width/2,height/2);
    if(controlerErrorTimeStamp+5000 < millis()){
     println("Exiting");
     //exec("restartUi.sh");//run a script that re launches this program
     //for some reason this controller library is incable of refreshing the list of controllers
     //so if no controller is found we need to resetart this program to fetch the controllers again
     exit();
    }
    return;
  }
  background(0);//set the background color to black clearing anything currently on screen
  noStroke();//stroke with the 3D render can be kinda anoying
  
  //if loading do not display the normal UI instead display loading unill the load has completed
  if(loading){
    //I know this is not the most scaleable thing but it should be fine
    fill(255);
    textSize(100);
    text("Loading ...",width/2,height/2);
  }else{
    //hilight the currently selected button
    // 0=prevGame 1=prevLreaderBoard 2=nextLeaderBoard 3=play 4=nextGame
    switch(selectedButton){
      case 0:
        prevGameButton.setColor(#503B00, #ffc02e);
        nextGameButton.setColor(0, 200);
        prevLeaderBoard.setColor(0, 200);
        nextLeaderBoard.setColor(0, 200);
        playButton.setColor(#137600, #25E500);
        break;
      case 1:
        prevGameButton.setColor(0, 200);
        nextGameButton.setColor(0, 200);
        prevLeaderBoard.setColor(#503B00, #ffc02e);
        nextLeaderBoard.setColor(0, 200);
        playButton.setColor(#137600, #25E500);
        break;
      case 2:
        prevGameButton.setColor(0, 200);
        nextGameButton.setColor(0, 200);
        prevLeaderBoard.setColor(0, 200);
        nextLeaderBoard.setColor(#503B00, #ffc02e);
        playButton.setColor(#137600, #25E500);
        break;
      case 3:
        prevGameButton.setColor(0, 200);
        nextGameButton.setColor(0, 200);
        prevLeaderBoard.setColor(0, 200);
        nextLeaderBoard.setColor(0, 200);
        playButton.setColor(#137600, #00DED1);
        break;
      case 4:
        prevGameButton.setColor(0, 200);
        nextGameButton.setColor(#503B00, #ffc02e);
        prevLeaderBoard.setColor(0, 200);
        nextLeaderBoard.setColor(0, 200);
        playButton.setColor(#137600, #25E500);
        break;
      default:
        prevGameButton.setColor(0, 200);
        nextGameButton.setColor(0, 200);
        prevLeaderBoard.setColor(0, 200);
        nextLeaderBoard.setColor(0, 200);
        playButton.setColor(#137600, #25E500);
    }
    
    if((runningGame!=null && runningGame.isAlive()) || gameStarted){
      playButton.setColor(#13B2BF, #00DED1);
    }
    
    //title bar
    fill(#002C73);
    uiRect(20,20,1240,130);
    fill(255);
    titleText.draw();
    
    if(animationRight){
      float animationPercent = (millis()-animationStartTimestamp)/3000.0;
      float xoffset = 3000*animationPercent*animationPercent , zoffset = -1000*animationPercent*(animationPercent-1);
      camera(defCameraX+xoffset, defCameraY, defCameraZ+zoffset, defCameraX+xoffset, defCameraY, zoffset, 0,1,0);
      renderGameSelection(prevousGameIndex);
      translate(3000,0,0);
      renderGameSelection(currentGameIndex);
      translate(-6000,0,0);
      if(animationPercent>=1){
        animationRight=false;
      }
    }else if(animationLeft){
      float animationPercent = (millis()-animationStartTimestamp)/3000.0;
      float xoffset = -3000*animationPercent*animationPercent , zoffset = -1000*animationPercent*(animationPercent-1);
      camera(defCameraX+xoffset, defCameraY, defCameraZ+zoffset, defCameraX+xoffset, defCameraY, zoffset, 0,1,0);
      renderGameSelection(prevousGameIndex);
      translate(-3000,0,0);
      renderGameSelection(currentGameIndex);
      translate(3000,0,0);
      if(animationPercent>=1){
        animationLeft=false;
      }
    }else if(gameStarted){
      float animationPercent = (millis()-animationStartTimestamp)/5000.0;
      if(animationPercent<1){
      float zoffset = 800*animationPercent*(animationPercent-2),xoffset = -200*animationPercent;
      camera(defCameraX+xoffset, defCameraY, defCameraZ+zoffset, defCameraX+xoffset, defCameraY, zoffset, sin(animationPercent*PI/2),cos(animationPercent*PI/2),0);
      
      renderGameSelection(currentGameIndex);
      
      if(animationPercent >=0.65 && !launched){
        try{
          println("launching game");
          runningGame = exec(games.get(currentGameIndex).getExe());
        }catch (Exception e){
          errorTimeStamp = millis();
        }
        launched=true;
      }
      }else{
        camera(defCameraX-200, defCameraY, defCameraZ-800, defCameraX-200, defCameraY, -800, 1,0,0);
      }
      if(animationPercent>=2){
        gameStarted=false;
        launched=false;
      }
    }else {
    
      //draw the main pannel with the game info
      renderGameSelection(currentGameIndex);
      if(errorTimeStamp+5000>millis() && millis()>5000){
        fill(255,0,0);
        errorText.draw();
      }
    }
  }
  
  
}

/**draws the main part of the selection UI 
*/
void renderGameSelection(int gameId){
  //next and last gamen buttons
  prevGameButton.draw();
  nextGameButton.draw();
  
  Game currentGame = games.get(gameId);
  
  //game image
  image(currentGame.getImg(),ui.topX()+600*ui.scale(),ui.topY()+250*ui.scale());
  
  //game name 
  currentGame.getName(gameName);
  fill(color(255,190));
  gameName.draw();
  
  //leaderBoard
  fill(#002C73);
  uiRect(80,160,400,60);
  fill(255);
  leaderBoardTitle.draw();
  if(currentGame.leaderBoardPresent()){
    if(currentGame.hasAdvancedLeaderBoard()){
      //check if multiple leaderBoards
      currentGame.getLevelName(leaderBoardName,currentLeaderBoardLevel);
      leaderBoardName.draw();
      prevLeaderBoard.draw();
      nextLeaderBoard.draw();
    }
    fill(255);
    currentGame.populateScores(leaderBoardContent,currentLeaderBoardLevel);
    //populate leaderBoard Info
    for(int i=0; i< leaderBoardContent.length;i++){
      leaderBoardContent[i].draw();
    }
  
  }
  //play button
  playButton.draw();
}

void mousePressed(){
  if(!loading){
    Game currentGame = games.get(currentGameIndex);
    if(currentGame.leaderBoardPresent()&&currentGame.hasAdvancedLeaderBoard()){
        if(nextLeaderBoard.isMouseOver()){
          currentLeaderBoardLevel = currentGame.nextLeaderBoard(currentLeaderBoardLevel);
        }
        if(prevLeaderBoard.isMouseOver()){
          currentLeaderBoardLevel = currentGame.prevLeaderBoard(currentLeaderBoardLevel);
        }
    }
    
    if(prevGameButton.isMouseOver()){
      currentLeaderBoardLevel=0;
      prevousGameIndex = currentGameIndex;
      if(currentGameIndex >0){
        currentGameIndex--;
      }else{
        currentGameIndex = games.size()-1;
      }
      animationLeft=true;
      animationStartTimestamp = millis();
    }
    if(nextGameButton.isMouseOver()){
      currentLeaderBoardLevel=0;
      prevousGameIndex = currentGameIndex;
      if(currentGameIndex <games.size()-1){
        currentGameIndex++;
      }else{
        currentGameIndex = 0;
      }
      animationRight=true;
      animationStartTimestamp = millis();
    }
    
    if(playButton.isMouseOver()){
      gameStarted=true;
      animationStartTimestamp = millis();
    }
    
  }
}

void loadGames(){
  //initilize the controller
  ReadController.read(controller,this);
  //if an error occors then stop loading farther
  if(controllerError){
    
    return;
  }
  //read the game info file
  String[] rawGameinfo = loadStrings(gameConfigFile);
  //pargse the contetnce into useable objects
  for(String gameInfo: rawGameinfo){
    try{
      games.add(new Game(gameInfo.split(",")));
    }catch (Exception e){
      e.printStackTrace();
    }
  }
  
  //start the controller handler
  thread("handleController");
  loading=false;
}

void handleController(){
  while(true){
    //while the UI is the focused program
    if(focused){
      //read in the any updates that have come from the controller
      ReadController.read(controller,this);
      //enfores a 250ms delay between processed inputs
      if(lastControllUseTime+250 < millis()){
        Game currentGame = games.get(currentGameIndex);
        //if the left stick is pushed right
        if(controller.leftStickX() > 0.3 && selectedButton!=4){
          lastControllUseTime=millis();
          //if on prev game and the current leaderBoard is not advanced
          if(!currentGame.hasAdvancedLeaderBoard() && selectedButton==0){
            selectedButton=3;
          }else{
            selectedButton++;
          }
        }
        //if the left stick is pushed left
        else if(controller.leftStickX() < -0.3 && selectedButton!=0){
          lastControllUseTime=millis();
          if(!currentGame.hasAdvancedLeaderBoard() && selectedButton==3){
            selectedButton=0;
          }else{
            selectedButton--;
          }
        }
        
        if(controller.a()){
          lastControllUseTime=millis();

          switch(selectedButton){
            case 0:
              mouseX = (int)(prevGameButton.x + prevGameButton.lengthX/2);
              mouseY = (int)(prevGameButton.y + prevGameButton.lengthY/2);
              break;
            case 1:
              mouseX = (int)(prevLeaderBoard.x + prevLeaderBoard.lengthX/2);
              mouseY = (int)(prevLeaderBoard.y + prevLeaderBoard.lengthY/2);
              break;
            case 2:
              mouseX = (int)(nextLeaderBoard.x + nextLeaderBoard.lengthX/2);
              mouseY = (int)(nextLeaderBoard.y + nextLeaderBoard.lengthY/2);
              break;
            case 3:
              mouseX = (int)(playButton.x + playButton.lengthX/2);
              mouseY = (int)(playButton.y + playButton.lengthY/2);
              break;
            case 4:
              mouseX = (int)(nextGameButton.x + nextGameButton.lengthX/2);
              mouseY = (int)(nextGameButton.y + nextGameButton.lengthY/2);
              break;
            default:
              
          }
          mousePressed();
        }
      }
    }else{
      controller.reset();
    }
  }
}

//if the window is resized
void windowResized() {
  //tell the UI Frame to recalculate
  ui.reScale();
  //get the game images to resize 
  Game.sRescale(ui.scale());
  for(int i=0;i<games.size();i++){
    games.get(i).rescale(ui.scale());
  }
  
  defCameraX = width / 2.0f;
  defCameraY = height / 2.0f;
  defCameraZ = defCameraY / ((float) Math.tan(defCameraFOV / 2.0f));
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
