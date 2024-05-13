import processing.core.*;

class Game{
  //name image execuable leaderBoardMode, leaderBoardFile
  public Game(String[] data){
    if(data.length >=3){
     name =  data[0];
     try{
       img = dataSource.loadImage(data[1]);
       img.resize(600,600);
     }catch (Exception e){
       System.err.println("error loading image for "+name);
       e.printStackTrace();
     }
     executable = data[2];
     
     if(data.length >=  5){
       leaderBoardPresent = true;
       if(Integer.parseInt(data[3]) == 1){
         advancedLeaderBaord = true;
       }else{
         advancedLeaderBaord = false;
       }
       //load leaderBoardHere
       leaderBoardFile = data[4];
       reloadLeaderBaord();
     }
    }else{
      throw new RuntimeException("invalid game input data");
    }
  }
  
  private PImage img;
  
  static PApplet dataSource;
  private static PImage defaultImage;
  
  private String name = "GAME NAME HERE", executable,leaderBoardFile;
  
  private boolean leaderBoardPresent = false, advancedLeaderBaord = false;
  
  private LeaderBoard leaderBoard;
  
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
  
  public String getExe(){
    return executable;
  }
  
  public boolean leaderBoardPresent(){
    return leaderBoardPresent;
  }
  
  public boolean hasAdvancedLeaderBoard(){
    return advancedLeaderBaord;
  }
  
  int nextLeaderBoard(int current){
    if(current+1 < leaderBoard.getNumLevels()){
      return current+1;
    }else{
      return 0;
    }
  }
  
  int prevLeaderBoard(int current){
    if(current >0){
      return current-1;
    }else{
      return leaderBoard.getNumLevels()-1;
    }
  }
  
  void getLevelName(UiText text,int level){
    text.setText(leaderBoard.getBoardName(level));
  }
  
  void populateScores(UiText[] text,int level){
    for(int i=0;i<text.length;i++){
      text[i].setText(leaderBoard.getPosition(level,i)+"");
    }
  }
  
  public void reloadLeaderBaord(){
    leaderBoard = new LeaderBoard(advancedLeaderBaord,dataSource.loadStrings(leaderBoardFile));
  }
}
