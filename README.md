# Chess



https://github.com/adrian-perez121/Chess/assets/107430887/dd518456-b38b-41a5-8986-361355a4a9ce



## Background

Funny enough, I don't like playing chess. In fact I feel the experience of coding was more entertaining than playing the game. Anyway, this project took me longer than expected since I was primarily in school while I was working on it but I am happy with the outcome. I was able to implement the major chess rules and logic. To my knowledge the only things I didn't implement were timing, the repetition rules, and the 50-move rule. On a side note, I am immensely grateful to Nicholas Weaver. The value from his Data Structures and Algorithms class was so helpful as I was writing out this project. Enough with the sappiness and let's get into the actual game.

## Thought Process

I knew for certain there was going to have to be a board and pieces. I mean it's Chess! There was a superclass for all the pieces and every piece was able to view the board. An algorithm in the pieces would use the board to determine which moves were "possible". This doesn't mean the moves were valid. For the logic of chess, I created a separate class that would have a view of the board. Using this view the class could return booleans for questions like "Is the King in Check?" and "Is this a hypothetical move?". My method for judging if a move was a valid hypothetical move was the most powerful. In simple terms, it moves a piece and returns if the friendly king is in check after the move. The board would keep track of which pieces were in play and which were out of play using two sets. The pieces that were in play would have their moves updated while the pieces that were out of play were displayed for the player to see which pieces were captured. Lastly, came the menus which weren't all too bad to code, there were just many corner cases I had too look out for. Oh and let's not forget saving! So much serialization was happening with pieces and board but it all came together in the end. 

## The Game

### Starting Screen
Upon starting the program, you are greeted with a starting screen explaining the commands to play the game and the save files. To start a chess game select '**1**', '**2**', or '**3**' to select a save file to play in. You can also reset any saved files you would by typing in '**r**' and then selecting the file you would like to reset. 

### Play Screen

Once a chess game has started, you are taken to the playing screen where you are able to input the following commands:
- **forfeit** -> The player can choose to forfeit
- **end** -> The game will end but that doesn't mean it's over. After this option is selected, the user can decided to save the game to start again at a later date.
- **m** -> The player will be taken to a menu where they can select the piece they want to move and select the square they would like to move that piece. Note: Moving and selecting pieces is done in algebraic notation.
- **c** -> The player will be taken to the castling menu (if castling is possible) and they choose to castle kingside or queenside depending on which options are available.
- **s** -> The player can save the game

### Pawn Promotions

The pawn promotion screen will happen automatically once a pawn reaches the opposite side. The user must select a piece to promote the pawn before switching turns.

## Final Thoughts

Again, I am so happy I was able to complete this project. It seemed so daunting at first but added piece after piece (pun intended) the entire project was finally completed. This game was a really valuable learning experience. I know my testing could use more work but my gosh was the testing I did so helpful. Who knows how many bugs I would have gotten if I wasn't testing.  Welp, it seems like this is the end for this project. Onto the next!
