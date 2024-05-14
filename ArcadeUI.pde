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

int currentGameIndex =0;

String gameConfigFile = "data/games.csv";

boolean loading = true;

Process runningGame;

//main render function 
//automcaticaly called by the render theread once every frame
void draw(){
  background(0);//set the background color to black clearing anything currently on screen
  noStroke();//stroke with the 3D render can be kinda anoying
  
  //if loading do not display the normal UI instead display loading unill the load has completed
  if(loading){
    //I know this is not the most scl;eable thing but it should be fine
    fill(255);
    textSize(100);
    text("Loading ...",width/2,height/2);
  }else{
    //title bar
    fill(#002C73);
    uiRect(20,20,1240,130);
    fill(255);
    titleText.draw();
    
    //draw the main pannel with the game info
    renderGameSelection(currentGameIndex);
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
      if(currentGameIndex >0){
        currentGameIndex--;
      }else{
        currentGameIndex = games.size()-1;
      }
    }
    if(nextGameButton.isMouseOver()){
      currentLeaderBoardLevel=0;
      if(currentGameIndex <games.size()-1){
        currentGameIndex++;
      }else{
        currentGameIndex = 0;
      }
    }
    
    if(playButton.isMouseOver()){
      println("launching game");
      runningGame = exec(currentGame.getExe());
    }
    
  }
}

void loadGames(){
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
  loading=false;
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
