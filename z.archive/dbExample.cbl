       IDENTIFICATION DIVISION.
       PROGRAM-ID. ShowTables.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  CMD-LINE        PIC X(512)
           VALUE 'sqlite3 praxis.db "UPDATE Buchungen SET Stunden=45' &
           ' WHERE Vorname=''Max''"'.
       01  TABLES-LINE     PIC X(256).

       PROCEDURE DIVISION.
           DISPLAY "Reading tables from praxis.db...".
           CALL "SYSTEM" USING CMD-LINE.
           STOP RUN.
