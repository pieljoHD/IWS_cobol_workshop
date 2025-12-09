
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BUCHUNGEN-VALIDIERER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BUCHUNGEN ASSIGN TO "BUCHUNGEN.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS FSIN.
           SELECT FEHLER-LOG ASSIGN TO "FEHLER.LOG"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS FSERR.

       DATA DIVISION.
       FILE SECTION.
       FD BUCHUNGEN.
       01 BUCHUNG-LINE                PIC X(80).
       FD FEHLER-LOG.
       01 FEHLER-RECORD               PIC X(200).

       WORKING-STORAGE SECTION.
       77 FSIN                        PIC XX VALUE SPACES.
       77 FSERR                       PIC XX VALUE SPACES.
       77 EOF-FLAG                    PIC X  VALUE "N".
       77 ZEILEN-NR                   PIC 9(6) VALUE 0.

       01 VORNAME                     PIC X(20).
       01 NACHNAME                    PIC X(20).
       01 BUCHUNGS-NR-RAW             PIC X(3).
       01 BUCHUNGS-NR                 PIC 9(3).
       01 LINE-TRIM                   PIC X(80).
       01 REST-OHNE-NR                PIC X(77).
       01 L                           PIC 9(3).

       01 CNT-OK                      PIC 9(6) VALUE 0.
       01 CNT-ERROR                   PIC 9(6) VALUE 0.

       PROCEDURE DIVISION.
       MAIN.
           OPEN INPUT BUCHUNGEN
                OUTPUT FEHLER-LOG.
           IF FSIN NOT = "00"
               DISPLAY "Fehler beim Oeffnen BUCHUNGEN.DAT, Status=" FSIN
               GOBACK
           END-IF.
           IF FSERR NOT = "00"
               DISPLAY "Fehler beim Oeffnen FEHLER.LOG, Status=" FSERR
               GOBACK
           END-IF.
           DISPLAY "Starte Validierung der Buchungen...".

           PERFORM UNTIL EOF-FLAG = "Y"
               READ BUCHUNGEN
                   AT END MOVE "Y" TO EOF-FLAG
               END-READ
               IF EOF-FLAG NOT = "Y"
                   ADD 1 TO ZEILEN-NR
                   MOVE FUNCTION TRIM(BUCHUNG-LINE) TO LINE-TRIM
                   COMPUTE L = LENGTH OF FUNCTION TRIM(LINE-TRIM)
                   IF L >= 3
                       MOVE LINE-TRIM(L - 2:3) TO BUCHUNGS-NR-RAW
                   ELSE
                       MOVE SPACES TO BUCHUNGS-NR-RAW
                   END-IF
                   IF L > 3
                       MOVE LINE-TRIM(1:L - 3) TO REST-OHNE-NR
                   ELSE
                       MOVE SPACES TO REST-OHNE-NR
                   END-IF
                   MOVE SPACES TO VORNAME NACHNAME
                   UNSTRING FUNCTION TRIM(REST-OHNE-NR)
                       DELIMITED BY ALL SPACE
                       INTO VORNAME
                            NACHNAME
                   END-UNSTRING
                   IF BUCHUNGS-NR-RAW NUMERIC
                       MOVE BUCHUNGS-NR-RAW TO BUCHUNGS-NR
                       DISPLAY "OK: " FUNCTION TRIM(VORNAME)
                               " " FUNCTION TRIM(NACHNAME)
                               " -> " BUCHUNGS-NR-RAW
                       ADD 1 TO CNT-OK
                   ELSE
                       STRING
                           "FEHLER in Zeile " ZEILEN-NR
                           ": Ungueltige Buchungsnummer '" BUCHUNGS-NR-RAW
                           "' fuer " FUNCTION TRIM(VORNAME) " " FUNCTION TRIM(NACHNAME)
                           INTO FEHLER-RECORD
                       END-STRING
                       WRITE FEHLER-RECORD
                       DISPLAY FEHLER-RECORD
                       ADD 1 TO CNT-ERROR
                   END-IF
               END-IF
           END-PERFORM.

           CLOSE BUCHUNGEN FEHLER-LOG.
           DISPLAY "--------------------------------------------".
           DISPLAY "OK: " CNT-OK "  Fehler: " CNT-ERROR.
           DISPLAY "Validierung abgeschlossen.".
           GOBACK.
