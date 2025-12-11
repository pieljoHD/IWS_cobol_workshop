       *> ================================================================
       *> #1 IDENTIFICATION DIVISION – Wer bin ich?                       
       *> ================================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. UMSATZ-RECHNER.
       AUTHOR. Workshop-Team.
       DATE-WRITTEN. 2025-NOV-01.


       *> ================================================================
       *> #2 ENVIRONMENT DIVISION – Welche Dateien benutze ich?
       *> ================================================================
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       *> define your file input here


       *> ================================================================
       *> #3 DATA DIVISION – Was speichere ich?
       *> ================================================================
       DATA DIVISION.
       
       *> ---------------------------
       *> #3.1 FILE SECTION
       *> ---------------------------
       FILE SECTION.
              *> define how and where do you store your files data?
       
       *> ---------------------------
       *> #3.2 WORKING-STORAGE
       *> ---------------------------
       WORKING-STORAGE SECTION.
       
       *> define variables for saving file data

       *> define variables for temporary storage
           
       *> define variables for outputting the formatted data
       *> HINT: remember what * are used in cobol

       *> HINT: you will need this when reading in the file
       01 EOF-FLAG PIC X VALUE "N".
        
       *> ================================================================
       *> #4 PROCEDURE DIVISION – Was soll das Programm tun?
       *> ================================================================
       PROCEDURE DIVISION.
       BEGIN.
       
           *> -----------------------
           *> #4.1 Main Loop
           *> -----------------------
   
           STOP RUN.
       
       
       *> ================================================================
       *> #5 Datei öffnen
       *> ================================================================
             
       *> ================================================================
       *> #6 Verarbeitung einer Zeile
       *> ================================================================

            
       *> ================================================================
       *> #7 Umsatz berechnen
       *> ================================================================
       
       *> ================================================================
       *> #8 Ausgabe formatieren
       *> ================================================================
         
       *> ================================================================
       *> #9 Aufräumen und Gesamtsumme ausgeben
       *> ================================================================

       
        END PROGRAM UMSATZ-RECHNER.