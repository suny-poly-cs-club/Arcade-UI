//initialize stuf that I didnt want to be in the main file
UiText titleText;
UiText gameName;
UiText leaderBoardTitle;
UiText leaderBoardName;
UiText[] leaderBoardContent = new UiText[10];
UiText errorText;
void initilizeText(){
  //create the scalable text componenets
  titleText = new UiText(ui,"SUNY Poly Arcade",640,55,130,CENTER,CENTER);
  gameName = new UiText(ui,"GAME NAME", 900, 185, 80, CENTER, CENTER);
  leaderBoardTitle = new UiText(ui, "Leader Board", 280, 180 ,50, CENTER, CENTER);
  leaderBoardName = new UiText(ui, "Level example", 280, 250 ,30, CENTER, CENTER);
  for(int i=0;i<leaderBoardContent.length;i++){
    leaderBoardContent[i] = new  UiText(ui, (i+1)+") Name Name -- 69:69:69", 80, 300+50*i ,25, LEFT, CENTER);
  }
  errorText = new UiText(ui, "ERROR!",640,512,150,CENTER,CENTER);
}


Button prevGameButton, nextGameButton;
Button prevLeaderBoard, nextLeaderBoard;
Button playButton;
void initilizeButtons(){
  //create the buttons
  prevGameButton = new UiButton(ui, 10, 362, 40, 300, "<", 0, 200).setTextColor(#1FC100);
  nextGameButton = new UiButton(ui, 1230 , 362, 40, 300, ">", 0, 200).setTextColor(#1FC100);
  //80,160,400,60
  prevLeaderBoard = new  UiButton(ui, 80, 230, 40, 40, "<", 0, 200).setTextColor(#1FC100);
  nextLeaderBoard = new  UiButton(ui, 440, 230, 40, 40, ">", 0, 200).setTextColor(#1FC100);
  playButton = new UiButton(ui, 610, 890, 580, 80, "PLAY", #137600, #25E500).setTextColor(255).setStrokeWeight(10);
}
