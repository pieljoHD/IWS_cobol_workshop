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
    SELECT BUCHUNGEN
        ASSIGN TO "BUCHUNGEN.DAT"
        ORGANIZATION IS LINE SEQUENTIAL.


*> ================================================================
*> #3 DATA DIVISION – Was speichere ich?
*> ================================================================
DATA DIVISION.

*> ---------------------------
*> #3.1 FILE SECTION
*> ---------------------------
FILE SECTION.
FD BUCHUNGEN.
01 BUCHUNG-LINE PIC X(80).

*> ---------------------------
*> #3.2 WORKING-STORAGE
*> ---------------------------
WORKING-STORAGE SECTION.

01 MITARBEITER-VORNAME  PIC X(10).
01 MITARBEITER-NACHNAME PIC X(10).
01 ANZAHL-STUNDEN       PIC 9(3).

01 FIRMA-STUNDENSATZ PIC 9(3) VALUE 150.
01 GESAMT-UMSATZ     PIC 9(6)V99.
01 GESAMT-SUMME      PIC 9(7)V99 VALUE 0.

*> Formatierte Ausgabe je Mitarbeiter
01 FORMAT-UMSATZ-PRO-MITARBEITER.
    02 PRINT-MITARBEITER-NAME   PIC X(20).
    02 FILLER                   PIC X.
    02 PRINT-ANZAHL-STUNDEN     PIC 9(3).
    02 FILLER                   PIC X.
    02 PRINT-MENGE-UMSATZ       PIC $***,***.99.

01 EOF-FLAG PIC X VALUE "N".


*> ================================================================
*> #4 PROCEDURE DIVISION – Was soll das Programm tun?
*> ================================================================
PROCEDURE DIVISION.

BEGIN.
    PERFORM INITIALIZE-PROGRAM.

    *> -----------------------
    *> Einlesen bis EOF
    *> -----------------------
    PERFORM UNTIL EOF-FLAG = "Y"
        READ BUCHUNGEN
            AT END MOVE "Y" TO EOF-FLAG
        END-READ

        IF EOF-FLAG NOT = "Y"
            PERFORM PROCESS-LINE
        END-IF
    END-PERFORM

    PERFORM CLEAN-UP.
    STOP RUN.


*> ================================================================
*> #4.1 Datei öffnen
*> ================================================================
INITIALIZE-PROGRAM.
    OPEN INPUT BUCHUNGEN.
    DISPLAY "Name                  Std   Umsatz".
    DISPLAY "--------------------------------------------".


*> ================================================================
*> #4.2 Verarbeitung einer Zeile
*> ================================================================
PROCESS-LINE.
    MOVE BUCHUNG-LINE(1:10)  TO MITARBEITER-VORNAME
    MOVE BUCHUNG-LINE(11:10) TO MITARBEITER-NACHNAME
    MOVE BUCHUNG-LINE(21:3)  TO ANZAHL-STUNDEN

    PERFORM BERECHNE-GESAMTUMSATZ
    PERFORM PRINT-UMSATZ-PRO-MITARBEITER

    ADD GESAMT-UMSATZ TO GESAMT-SUMME.


*> ================================================================
*> #4.2.1 Umsatz berechnen
*> ================================================================
BERECHNE-GESAMTUMSATZ.
    COMPUTE GESAMT-UMSATZ = ANZAHL-STUNDEN * FIRMA-STUNDENSATZ.


*> ================================================================
*> #4.2.2 Ausgabe formatieren
*> ================================================================
PRINT-UMSATZ-PRO-MITARBEITER.
    MOVE MITARBEITER-VORNAME  TO PRINT-MITARBEITER-NAME(1:10)
    MOVE MITARBEITER-NACHNAME TO PRINT-MITARBEITER-NAME(11:10)
    MOVE ANZAHL-STUNDEN       TO PRINT-ANZAHL-STUNDEN
    MOVE GESAMT-UMSATZ        TO PRINT-MENGE-UMSATZ

    DISPLAY PRINT-MITARBEITER-NAME " "
            PRINT-ANZAHL-STUNDEN  " "
            PRINT-MENGE-UMSATZ.


*> ================================================================
*> #4.5 Aufräumen und Gesamtsumme ausgeben
*> ================================================================
CLEAN-UP.
    CLOSE BUCHUNGEN.
    DISPLAY "--------------------------------------------".
    MOVE GESAMT-SUMME TO PRINT-MENGE-UMSATZ.
    DISPLAY "Gesamtumsatz:          " PRINT-MENGE-UMSATZ.
    DISPLAY "JOB SUCCESSFULLY COMPLETED".
