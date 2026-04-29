# Arcade-UI
The main interface for the arcade cabinet. The system to choose the game to play and view its leaderboards

# Dependencies
1. [processing4](https://processing.org)
2. [jinput](https://jinput.github.io/jinput/) installation instructions: Pace the librarie jar at `%SketchBook%/libraries/jinput/library/jinput.jar` extract the files from the natives jar and place them at `%SketchBook%/libraries/jinput/library/`

# Configuring games
1. Edit `data/games.csv`
2. Add a new line for your game
3. The first value(before the first coma) is the display name of the game
4. The second value is the file path to the game icon
5. The third value is the path to the game launch script / game executable
6. The fourth value id the leaderboard mode: 0 for simple mode, 1 for complex mode. More on the leaderboards below
7. The fifth and final value is the path the the game's leaderboard csv file  

All together an example line in the game file might look like this:
```csv
Example game,/path/to/game/icon.png,/path/to/launch/script.sh,0,/path/to/leaderboard.csv
```

# Leaderboard System
The big feature of this arcade UI system if the custom leaderboard  system.  
2 types of leaderboard are supported: Simple and Complex  
All leaderboards are stored in csv files

### Simple leaderboard (mode 0)
This leaderboard type is based on a single list of names and scores  
Each line of the leaderbord file contains a sigle value. This value will consist of the name and score of the player. The first 10 scores in the file will be displayed.  
Example simple Leaderbaord file:
```csv
Bob --- 1000
Joe --- 900
Jef --- 800
Bil --- 700
Jak --- 600
CIA --- 500
Sup --- 400
Kid --- 300
Fil --- 200
Rik --- 0
```

Note: it is up to the game to order the scores correctly

### Complex loaderboard (mode 1)
This mode is also known as the multiple levels mode. This mode allows for multiple levels / catagories to have unique score boards on a single game.  
Each line of the leaderboard files represens a diffrent level. The first value on the line is the name of the level. After that come the names and scores in value pairs, up to 10 scores. Games can have as many level as they want.
Example complex leaderboard file:
```csv
level 1 name,name 1,1:36,name 2,2:22,name 3,2:58,name 4,4:02,name 5,4:10,name 6,5:34,name 7,5:30,name 8,6:59,name 9,7:57,name 10,1685:55
level 2 name,name 1,1:36,name 2,2:22,name 3,2:58,name 4,4:02,name 5,4:10,name 6,5:34,name 7,5:30,name 8,6:59,name 9,7:57,name 10,1685:55
```

Note: it is up to the game to order the scores correctly