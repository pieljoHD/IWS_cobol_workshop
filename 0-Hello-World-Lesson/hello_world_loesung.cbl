               >>SOURCE FORMAT FREE
               
               *> ================================================================
               *> #1 IDENTIFICATION DIVISION – Wer bin ich?
               *> ================================================================
               IDENTIFICATION DIVISION.
               PROGRAM-ID. HELLO-COBOL.
               AUTHOR. Workshop-Team.
               DATE-WRITTEN. 2025-NOV-01.
               
               
               *> ================================================================
               *> #2 ENVIRONMENT DIVISION
               *> ================================================================
               ENVIRONMENT DIVISION.
               INPUT-OUTPUT SECTION.
               
               
               *> ================================================================
               *> #3 DATA DIVISION – Was speichere ich?
               *> ================================================================
               DATA DIVISION.               
               
               *> ---------------------------
               *> #3.1 WORKING-STORAGE
               *> ---------------------------
               WORKING-STORAGE SECTION.
               
               01 VORNAME  PIC X(10).
               01 NACHNAME PIC X(10).
               01 STUNDEN  PIC 9(3).
               
               
               *> ================================================================
               *> #4 PROCEDURE DIVISION – Was soll das Programm tun?
               *> ================================================================
               PROCEDURE DIVISION.
               
               BEGIN.
                   *> ------------------------------------------------------------
                   *> #4.1 Aufgabe 0.1 – Hello World
                   *> ------------------------------------------------------------
                   DISPLAY "Hello COBOL World!".
                   DISPLAY "-------------------".
               
               
                   *> ------------------------------------------------------------
                   *> #4.2 Aufgabe 0.2 – Hello World mit Variablen
                   *> ------------------------------------------------------------
                   MOVE "Anna"     TO VORNAME
                   MOVE "Schmidt"  TO NACHNAME
                   MOVE 40         TO STUNDEN
               
                   DISPLAY "Mitarbeiter: " VORNAME " " NACHNAME
                   DISPLAY "Stunden: " STUNDEN
               
                   STOP RUN.
               
               
