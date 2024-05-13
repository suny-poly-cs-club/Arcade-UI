UiText titleText;
UiText gameName;
void initilizeText(){
  titleText = new UiText(ui,"SUNY Poly Arcade",640,55,130,CENTER,CENTER);
  gameName = new UiText(ui,"GAME NAME", 900, 175, 80, CENTER, CENTER);
}


Button prevGameButton, nextGameButton;
void initilizeButtons(){
  prevGameButton = new UiButton(ui, 10, 362, 40, 300, "<", #72dfa00e, #72ffc02e).setTextColor(color(255,190));
  nextGameButton = new UiButton(ui, 1230 , 362, 40, 300, ">", #72dfa00e, #72ffc02e).setTextColor(color(255,190));
}
