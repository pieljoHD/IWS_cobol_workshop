
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BUCHUNGEN-VALIDIERER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BUCHUNGEN ASSIGN TO "BUCHUNGEN.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS FSIN.
           SELECT FEHLER-LOG ASSIGN TO "buchungen-fehler.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS FSERR.

       DATA DIVISION.
       FILE SECTION.
       FD BUCHUNGEN.
       01 BUCHUNG-LINE                PIC X(256).
       FD FEHLER-LOG.
       01 FEHLER-RECORD               PIC X(600).

       WORKING-STORAGE SECTION.
       77 FSIN                        PIC XX VALUE SPACES.
       77 FSERR                       PIC XX VALUE SPACES.
       77 EOF-FLAG                    PIC X  VALUE "N".
       77 ZEILEN-NR                   PIC 9(6) VALUE 0.

       01 LINE-TRIM                   PIC X(256).

       *> Eingabefelder: Vorname Nachname Stunden Gehalt Geburtsdatum (Leerzeichen-getrennt)
       01 WS-VORNAME                  PIC X(40).
       01 WS-NACHNAME                 PIC X(40).
       01 WS-STUNDEN-RAW              PIC X(30).
       01 WS-GEHALT-RAW               PIC X(30).
       01 WS-GEBURT-RAW               PIC X(20).

       01 WS-NAME-ZUS                 PIC X(90).

       *> Hilfsvariablen
       01 WS-I                        PIC 9(4) VALUE 0.
       01 WS-J                        PIC 9(4) VALUE 1.
       01 WS-CNT                      PIC 9(4) VALUE 0.
       01 WS-ERR-FLAG                 PIC X VALUE "N".

       01 WS-TAG                      PIC 99    VALUE 0.
       01 WS-MONAT                    PIC 99    VALUE 0.
       01 WS-JAHR                     PIC 9(4)  VALUE 0.
       01 WS-TAG-MAX                  PIC 99    VALUE 0.
       01 WS-LEN                      PIC 9(4)  VALUE 0.

       01 CNT-OK                      PIC 9(6) VALUE 0.
       01 CNT-ERROR                   PIC 9(6) VALUE 0.

       *> Erlaubte Zeichen für Namen (Buchstaben + Leerzeichen + Bindestrich)
       01 ALLOWED-NAME-CHARS          PIC X(200)
          VALUE "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ÄÖÜäöüß-".

       *> Argumente für LOG-ERROR
       01 ARG-FELD                    PIC X(30).
       01 ARG-MSG                     PIC X(200).

       PROCEDURE DIVISION.
       MAIN.
           OPEN INPUT BUCHUNGEN
                OUTPUT FEHLER-LOG

           IF FSIN NOT = "00"
               DISPLAY "Fehler beim Oeffnen BUCHUNGEN.DAT, Status=" FSIN
               GOBACK
           END-IF
           IF FSERR NOT = "00"
               DISPLAY "Fehler beim Oeffnen FEHLER-LOG, Status=" FSERR
               GOBACK
           END-IF
           DISPLAY "Starte Validierung der Buchungen...".

           PERFORM UNTIL EOF-FLAG = "Y"
               READ BUCHUNGEN
                   AT END MOVE "Y" TO EOF-FLAG
               END-READ
               IF EOF-FLAG NOT = "Y"
                   ADD 1 TO ZEILEN-NR
                   MOVE FUNCTION TRIM(BUCHUNG-LINE) TO LINE-TRIM
                   *> Tabs in Spaces wandeln (nur zur Sicherheit)
                   INSPECT LINE-TRIM REPLACING ALL X"09" BY " "
                   *> Leere Zeilen komplett überspringen
                   IF LINE-TRIM = SPACES
                   OR FUNCTION LENGTH(FUNCTION TRIM(LINE-TRIM)) = 0
                       CONTINUE
                   ELSE
                       *> --- Felder per Leerzeichen splitten ---
                       MOVE SPACES TO WS-VORNAME WS-NACHNAME
                                      WS-STUNDEN-RAW WS-GEHALT-RAW WS-GEBURT-RAW
                       UNSTRING LINE-TRIM
                           DELIMITED BY ALL SPACE
                           INTO WS-VORNAME
                                WS-NACHNAME
                                WS-STUNDEN-RAW
                                WS-GEHALT-RAW
                                WS-GEBURT-RAW
                       END-UNSTRING

                       *> Namen zusammenbauen (für Ausgabe)
                       MOVE FUNCTION TRIM(WS-VORNAME) TO WS-NAME-ZUS
                       MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-NAME-ZUS))
                            TO WS-J
                       ADD 1 TO WS-J
                       STRING
                           " " DELIMITED BY SIZE
                           FUNCTION TRIM(WS-NACHNAME) DELIMITED BY SIZE
                           INTO WS-NAME-ZUS
                           WITH POINTER WS-J
                       END-STRING

                       MOVE "N" TO WS-ERR-FLAG

                       *> ==== VALIDIERUNGEN ====
                       PERFORM PRUEFE-NAME
                       PERFORM PRUEFE-STUNDEN
                       PERFORM PRUEFE-GEHALT
                       PERFORM PRUEFE-GEBURTSDATUM

                       IF WS-ERR-FLAG = "N"
                           DISPLAY "OK: " FUNCTION TRIM(WS-NAME-ZUS)
                                   " | Stunden=" FUNCTION TRIM(WS-STUNDEN-RAW)
                                   " | Gehalt=" FUNCTION TRIM(WS-GEHALT-RAW)
                                   " | Geburtsdatum=" FUNCTION TRIM(WS-GEBURT-RAW)
                           ADD 1 TO CNT-OK
                       END-IF
                   END-IF
               END-IF
           END-PERFORM

           CLOSE BUCHUNGEN FEHLER-LOG
           DISPLAY "--------------------------------------------"
           DISPLAY "OK: " CNT-OK "  Fehler: " CNT-ERROR
           DISPLAY "Validierung abgeschlossen."
           GOBACK.

       *>--------------------------------------------------------------
       *> PRUEFE-NAME
       *>--------------------------------------------------------------
       PRUEFE-NAME.
           MOVE FUNCTION TRIM(WS-NAME-ZUS) TO WS-NAME-ZUS
           MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-NAME-ZUS)) TO WS-LEN
           MOVE 1 TO WS-I
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-LEN
               MOVE 0 TO WS-CNT
               INSPECT ALLOWED-NAME-CHARS
                   TALLYING WS-CNT FOR ALL WS-NAME-ZUS(WS-I:1)
               IF WS-CNT = 0
                   MOVE "Name" TO ARG-FELD
                   MOVE SPACES TO ARG-MSG
                   STRING "Sonderzeichen gefunden: '"
                          WS-NAME-ZUS(WS-I:1) "'"
                          INTO ARG-MSG
                   END-STRING
                   PERFORM LOG-ERROR
                   MOVE "Y" TO WS-ERR-FLAG
                   EXIT PERFORM
               END-IF
           END-PERFORM
           EXIT PARAGRAPH.

       *>--------------------------------------------------------------
       *> PRUEFE-STUNDEN
       *>--------------------------------------------------------------
       PRUEFE-STUNDEN.
           MOVE FUNCTION TRIM(WS-STUNDEN-RAW) TO WS-STUNDEN-RAW
           IF WS-STUNDEN-RAW = SPACES
               MOVE "Stundenanzahl" TO ARG-FELD
               MOVE "leer/fehlend"  TO ARG-MSG
               PERFORM LOG-ERROR
               MOVE "Y" TO WS-ERR-FLAG
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-STUNDEN-RAW)) TO WS-LEN

           *> Buchstaben? (per Schleife)
           PERFORM VARYING WS-I FROM 1 BY 1
                   UNTIL WS-I > WS-LEN OR WS-ERR-FLAG = "Y"
               IF WS-STUNDEN-RAW(WS-I:1) ALPHABETIC
                   MOVE "Stundenanzahl" TO ARG-FELD
                   MOVE "alphanumerisch (Buchstaben enthalten)" TO ARG-MSG
                   PERFORM LOG-ERROR
                   MOVE "Y" TO WS-ERR-FLAG
               END-IF
           END-PERFORM

           *> Minus unzulässig
           IF WS-ERR-FLAG = "N"
              AND WS-STUNDEN-RAW(1:1) = "-"
               MOVE "Stundenanzahl" TO ARG-FELD
               MOVE "negativ nicht erlaubt" TO ARG-MSG
               PERFORM LOG-ERROR
               MOVE "Y" TO WS-ERR-FLAG
           END-IF

           *> Mehr als ein '.' ?
           IF WS-ERR-FLAG = "N"
               MOVE 0 TO WS-CNT
               INSPECT WS-STUNDEN-RAW TALLYING WS-CNT FOR ALL "."
               IF WS-CNT > 1
                   MOVE "Stundenanzahl" TO ARG-FELD
                   MOVE "mehrere '.' gefunden" TO ARG-MSG
                   PERFORM LOG-ERROR
                   MOVE "Y" TO WS-ERR-FLAG
               END-IF
           END-IF

           *> Mehr als ein ',' ?
           IF WS-ERR-FLAG = "N"
               MOVE 0 TO WS-CNT
               INSPECT WS-STUNDEN-RAW TALLYING WS-CNT FOR ALL ","
               IF WS-CNT > 1
                   MOVE "Stundenanzahl" TO ARG-FELD
                   MOVE "mehrere ',' gefunden" TO ARG-MSG
                   PERFORM LOG-ERROR
                   MOVE "Y" TO WS-ERR-FLAG
               END-IF
           END-IF
           EXIT PARAGRAPH.

       *>--------------------------------------------------------------
       *> PRUEFE-GEHALT
       *>--------------------------------------------------------------
       PRUEFE-GEHALT.
           MOVE FUNCTION TRIM(WS-GEHALT-RAW) TO WS-GEHALT-RAW
           IF WS-GEHALT-RAW = SPACES
               MOVE "Monatsgehalt" TO ARG-FELD
               MOVE "leer/fehlend" TO ARG-MSG
               PERFORM LOG-ERROR
               MOVE "Y" TO WS-ERR-FLAG
               EXIT PARAGRAPH
           END-IF

           *> Negativ?
           IF WS-GEHALT-RAW(1:1) = "-"
               MOVE "Monatsgehalt" TO ARG-FELD
               MOVE "negativ" TO ARG-MSG
               PERFORM LOG-ERROR
               MOVE "Y" TO WS-ERR-FLAG
           END-IF

           *> Buchstaben? (per Schleife)
           MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-GEHALT-RAW)) TO WS-LEN
           PERFORM VARYING WS-I FROM 1 BY 1
                   UNTIL WS-I > WS-LEN OR WS-ERR-FLAG = "Y"
               IF WS-GEHALT-RAW(WS-I:1) ALPHABETIC
                   MOVE "Monatsgehalt" TO ARG-FELD
                   MOVE "alphanumerisch (Buchstaben enthalten)" TO ARG-MSG
                   PERFORM LOG-ERROR
                   MOVE "Y" TO WS-ERR-FLAG
               END-IF
           END-PERFORM

           *> Mehr als ein '.' ?
           IF WS-ERR-FLAG = "N"
               MOVE 0 TO WS-CNT
               INSPECT WS-GEHALT-RAW TALLYING WS-CNT FOR ALL "."
               IF WS-CNT > 1
                   MOVE "Monatsgehalt" TO ARG-FELD
                   MOVE "mehrere '.' gefunden" TO ARG-MSG
                   PERFORM LOG-ERROR
                   MOVE "Y" TO WS-ERR-FLAG
               END-IF
           END-IF

           *> Mehr als ein ',' ?
           IF WS-ERR-FLAG = "N"
               MOVE 0 TO WS-CNT
               INSPECT WS-GEHALT-RAW TALLYING WS-CNT FOR ALL ","
               IF WS-CNT > 1
                   MOVE "Monatsgehalt" TO ARG-FELD
                   MOVE "mehrere ',' gefunden" TO ARG-MSG
                   PERFORM LOG-ERROR
                   MOVE "Y" TO WS-ERR-FLAG
               END-IF
           END-IF
           EXIT PARAGRAPH.

       *>--------------------------------------------------------------
       *> PRUEFE-GEBURTSDATUM
       *>--------------------------------------------------------------
       PRUEFE-GEBURTSDATUM.
           MOVE FUNCTION TRIM(WS-GEBURT-RAW) TO WS-GEBURT-RAW
           MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-GEBURT-RAW)) TO WS-LEN

           IF WS-LEN NOT = 10
               MOVE "Geburtsdatum" TO ARG-FELD
               MOVE "falsches Format (erwartet DD.MM.YYYY)" TO ARG-MSG
               PERFORM LOG-ERROR
               MOVE "Y" TO WS-ERR-FLAG
               EXIT PARAGRAPH
           END-IF

           IF WS-GEBURT-RAW(3:1) NOT = "." OR WS-GEBURT-RAW(6:1) NOT = "."
               MOVE "Geburtsdatum" TO ARG-FELD
               MOVE "falsches Format (Trenner '.' fehlt)" TO ARG-MSG
               PERFORM LOG-ERROR
               MOVE "Y" TO WS-ERR-FLAG
               EXIT PARAGRAPH
           END-IF

           IF WS-GEBURT-RAW(1:2) NUMERIC
               MOVE WS-GEBURT-RAW(1:2) TO WS-TAG
           ELSE
               MOVE "Geburtsdatum" TO ARG-FELD
               MOVE "Tag nicht numerisch" TO ARG-MSG
               PERFORM LOG-ERROR
               MOVE "Y" TO WS-ERR-FLAG
           END-IF

           IF WS-GEBURT-RAW(4:2) NUMERIC
               MOVE WS-GEBURT-RAW(4:2) TO WS-MONAT
           ELSE
               MOVE "Geburtsdatum" TO ARG-FELD
               MOVE "Monat nicht numerisch" TO ARG-MSG
               PERFORM LOG-ERROR
               MOVE "Y" TO WS-ERR-FLAG
           END-IF

           IF WS-GEBURT-RAW(7:4) NUMERIC
               MOVE WS-GEBURT-RAW(7:4) TO WS-JAHR
           ELSE
               MOVE "Geburtsdatum" TO ARG-FELD
               MOVE "Jahr nicht numerisch" TO ARG-MSG
               PERFORM LOG-ERROR
               MOVE "Y" TO WS-ERR-FLAG
           END-IF

           IF WS-ERR-FLAG = "Y"
               EXIT PARAGRAPH
           END-IF

           *> Monat 1..12
           IF WS-MONAT < 1 OR WS-MONAT > 12
               MOVE "Geburtsdatum" TO ARG-FELD
               MOVE "Monat ausserhalb 1..12" TO ARG-MSG
               PERFORM LOG-ERROR
               MOVE "Y" TO WS-ERR-FLAG
               EXIT PARAGRAPH
           END-IF

           *> Max. Tage je Monat inkl. Schaltjahrregel
           EVALUATE WS-MONAT
               WHEN 1  MOVE 31 TO WS-TAG-MAX
               WHEN 2
                   IF ( FUNCTION MOD(WS-JAHR, 400) = 0 )
                      OR ( FUNCTION MOD(WS-JAHR, 4) = 0
                           AND FUNCTION MOD(WS-JAHR, 100) NOT = 0 )
                       MOVE 29 TO WS-TAG-MAX
                   ELSE
                       MOVE 28 TO WS-TAG-MAX
                   END-IF
               WHEN 3  MOVE 31 TO WS-TAG-MAX
               WHEN 4  MOVE 30 TO WS-TAG-MAX
               WHEN 5  MOVE 31 TO WS-TAG-MAX
               WHEN 6  MOVE 30 TO WS-TAG-MAX
               WHEN 7  MOVE 31 TO WS-TAG-MAX
               WHEN 8  MOVE 31 TO WS-TAG-MAX
               WHEN 9  MOVE 30 TO WS-TAG-MAX
               WHEN 10 MOVE 31 TO WS-TAG-MAX
               WHEN 11 MOVE 30 TO WS-TAG-MAX
               WHEN 12 MOVE 31 TO WS-TAG-MAX
           END-EVALUATE

           IF WS-TAG < 1 OR WS-TAG > WS-TAG-MAX
               MOVE "Geburtsdatum" TO ARG-FELD
               MOVE "unmoegliches Datum (z. B. 31.02.)" TO ARG-MSG
               PERFORM LOG-ERROR
               MOVE "Y" TO WS-ERR-FLAG
           END-IF
           EXIT PARAGRAPH.

       *>--------------------------------------------------------------
       *> LOG-ERROR
       *>--------------------------------------------------------------
       LOG-ERROR.
           MOVE SPACES TO FEHLER-RECORD
           STRING
               FUNCTION TRIM(LINE-TRIM)
               " ; "
               "Fehler: " FUNCTION TRIM(ARG-FELD)
               " - "      FUNCTION TRIM(ARG-MSG)
               INTO FEHLER-RECORD
           END-STRING
           WRITE FEHLER-RECORD
           DISPLAY FEHLER-RECORD
           ADD 1 TO CNT-ERROR
           EXIT PARAGRAPH.
