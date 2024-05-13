import java.util.ArrayList;
class LeaderBoard{
  public LeaderBoard(boolean advacned, String[] fileContent){
    if(advacned){
      content = new String[fileContent.length][10];
      boardNames = new String[fileContent.length];
      for(int i=0;i<fileContent.length;i++){
        String[] levelContent = fileContent[i].split(",");
        boardNames[i] = levelContent[0];
        for(int j =0;j<10 && (j*2)+1 < levelContent.length; j++){
          content[i][j] = 
          levelContent[(j*2)+1] +" -- "+
          levelContent[(j*2)+2];
        }
      }
    }else{
      content = new String[1][];
      content[0] = fileContent;
    }
  }
  
  private String[] boardNames;
  private String[][] content;
  
  public String getBoardName(int i){
    return boardNames[i];
  }
  
  public String getPosition(int level,int pos){
    return content[level][pos];
  }
  
  public int getNumLevels(){
    return boardNames.length;
  }
}
