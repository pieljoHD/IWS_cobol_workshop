       IDENTIFICATION DIVISION.
       PROGRAM-ID. TIC-TAC-TOE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  BOARD.
           05 CELL OCCURS 9 TIMES PIC X VALUE SPACE.

       01  PLAYER-MARK     PIC X.
       01  PLAYER-NUMBER   PIC 9.
       01  PLAYER-MOVE     PIC 9.
       01  MOVE-COUNT      PIC 9 VALUE 0.
       01  GAME-OVER       PIC X VALUE 'N'.
       01  WINNER          PIC X VALUE SPACE.
       01  VALID-MOVE      PIC X.

       01  I               PIC 99.

       01 TEMP PIC X.

       PROCEDURE DIVISION.
       MAIN.
           PERFORM SHOW-INSTRUCTIONS
           PERFORM INIT-BOARD
           DISPLAY "init board"
           MOVE 'X' TO PLAYER-MARK
           MOVE 1   TO PLAYER-NUMBER
           
           PERFORM UNTIL GAME-OVER = 'Y'
               PERFORM CLEAR-SCREEN
               PERFORM DISPLAY-BOARD
               PERFORM GET-MOVE
               PERFORM CHECK-WIN
               PERFORM CHECK-DRAW
               IF GAME-OVER = 'N'
                   PERFORM SWITCH-PLAYER
               END-IF
           END-PERFORM

           PERFORM DISPLAY-BOARD

           IF WINNER NOT = SPACE
               DISPLAY "Player " PLAYER-NUMBER " wins!"
           ELSE
               DISPLAY "It's a draw!"
           END-IF

           STOP RUN.
       
       SHOW-INSTRUCTIONS.
           PERFORM CLEAR-SCREEN
           DISPLAY "TIC-TAC-TOE"
           DISPLAY " "
           DISPLAY "Two players take turns playing."
           DISPLAY "Player 1 uses X"
           DISPLAY "Player 2 uses O"
           DISPLAY " "
           DISPLAY "Enter a number from 1 to 9 to place your mark:"
           DISPLAY " "
           DISPLAY " 1 | 2 | 3"
           DISPLAY "---+---+---"
           DISPLAY " 4 | 5 | 6"
           DISPLAY "---+---+---"
           DISPLAY " 7 | 8 | 9"
           DISPLAY " "
           DISPLAY "First player to get three in a row wins."
           DISPLAY "Press ENTER to start the game..."
           ACCEPT TEMP.


       INIT-BOARD.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 9
               MOVE SPACE TO CELL(I)
           END-PERFORM
           MOVE 0 TO MOVE-COUNT
           MOVE SPACE TO WINNER.

       DISPLAY-BOARD.
           DISPLAY " "
           DISPLAY " " CELL(1) " | " CELL(2) " | " CELL(3)
           DISPLAY "---+---+---"
           DISPLAY " " CELL(4) " | " CELL(5) " | " CELL(6)
           DISPLAY "---+---+---"
           DISPLAY " " CELL(7) " | " CELL(8) " | " CELL(9)
           DISPLAY " ".

       GET-MOVE.
           MOVE 'N' TO VALID-MOVE
           PERFORM UNTIL VALID-MOVE = 'Y'
               DISPLAY "Player " PLAYER-NUMBER
                       " (" PLAYER-MARK ") - enter move (1-9): "
               ACCEPT PLAYER-MOVE

               IF PLAYER-MOVE >= 1 AND PLAYER-MOVE <= 9
                   IF CELL(PLAYER-MOVE) = SPACE
                       MOVE PLAYER-MARK TO CELL(PLAYER-MOVE)
                       ADD 1 TO MOVE-COUNT
                       MOVE 'Y' TO VALID-MOVE
                   ELSE
                       DISPLAY "Cell already taken."
                   END-IF
               ELSE
                   DISPLAY "Invalid move."
               END-IF
           END-PERFORM.

       CHECK-WIN.
           IF (CELL(1) = PLAYER-MARK AND CELL(2) = PLAYER-MARK
               AND CELL(3) = PLAYER-MARK)
            OR (CELL(4) = PLAYER-MARK AND CELL(5) = PLAYER-MARK
               AND CELL(6) = PLAYER-MARK)
            OR (CELL(7) = PLAYER-MARK AND CELL(8) = PLAYER-MARK
               AND CELL(9) = PLAYER-MARK)
            OR (CELL(1) = PLAYER-MARK AND CELL(4) = PLAYER-MARK
               AND CELL(7) = PLAYER-MARK)
            OR (CELL(2) = PLAYER-MARK AND CELL(5) = PLAYER-MARK
               AND CELL(8) = PLAYER-MARK)
            OR (CELL(3) = PLAYER-MARK AND CELL(6) = PLAYER-MARK
               AND CELL(9) = PLAYER-MARK)
            OR (CELL(1) = PLAYER-MARK AND CELL(5) = PLAYER-MARK
               AND CELL(9) = PLAYER-MARK)
            OR (CELL(3) = PLAYER-MARK AND CELL(5) = PLAYER-MARK
               AND CELL(7) = PLAYER-MARK)
               MOVE PLAYER-MARK TO WINNER
               MOVE 'Y' TO GAME-OVER
           END-IF.

       CHECK-DRAW.
           IF MOVE-COUNT = 9 AND WINNER = SPACE
               MOVE 'Y' TO GAME-OVER
           END-IF.

       SWITCH-PLAYER.
           IF PLAYER-MARK = 'X'
               MOVE 'O' TO PLAYER-MARK
               MOVE 2   TO PLAYER-NUMBER
           ELSE
               MOVE 'X' TO PLAYER-MARK
               MOVE 1   TO PLAYER-NUMBER
           END-IF.

       CLEAR-SCREEN.
           CALL "SYSTEM" USING "cls".

