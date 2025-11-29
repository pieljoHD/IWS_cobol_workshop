       IDENTIFICATION DIVISION.
       PROGRAM-ID. UMSATZ-RECHNER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           *> define your file input here

       DATA DIVISION.
       FILE SECTION.
           *> define how and where do you store your files data?

       WORKING-STORAGE SECTION.
           *> define variables for saving file data


           *> define variables for temporary storage
           

           *> define variables for outputting the formatted data
           *> HINT: remember what * are used in cobol


           *> HINT: you will need this when reading in the file
           01 EOF-FLAG PIC X VALUE "N".
       PROCEDURE DIVISION.
       BEGIN.
           *> define your main loop here

           STOP RUN.


       *>  define costume functions you might need here
       *>  HINT: important function might be:
       *>        - Open and close a file
       *>        - processing one line
       *>        - printing values


       END PROGRAM UMSATZ-RECHNER.
