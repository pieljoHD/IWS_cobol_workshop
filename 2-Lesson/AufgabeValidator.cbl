
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
       01 BUCHUNG-LINE                PIC X(256).
       FD FEHLER-LOG.
       01 FEHLER-RECORD               PIC X(300).

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
           *> Dateien öffnen (Eingabe/Output) und File-Status prüfen
           *> - OPEN INPUT BUCHUNGEN, OUTPUT FEHLER-LOG
           *> - Bei FSIN/FSERR <> "00": Abbruch mit DISPLAY

           *> Startmeldung ausgeben

           *> Hauptschleife: bis EOF
           *> PERFORM UNTIL EOF-FLAG = "Y"
           *>   - READ BUCHUNGEN; bei AT END: EOF-FLAG = "Y"
           *>   - Sonst:
           *>       • Zeilenzähler erhöhen
           *>       • Zeile trimmen, Tabs in Spaces umwandeln
           *>       • Leere Zeilen überspringen (TRIM-Länge prüfen)
           *>       • Felder zerlegen:
           *>           UNSTRING LINE-TRIM DELIMITED BY ALL SPACE
           *>             INTO WS-VORNAME WS-NACHNAME WS-STUNDEN-RAW WS-GEHALT-RAW WS-GEBURT-RAW
           *>       • Anzeigenamen aufbauen (Vorname + Nachname)
           *>       • Fehler-Flag zurücksetzen ("N")
           *>       • Validierungen aufrufen:
           *>           PERFORM PRUEFE-NAME
           *>           PERFORM PRUEFE-STUNDEN
           *>           PERFORM PRUEFE-GEHALT
           *>           PERFORM PRUEFE-GEBURTSDATUM
           *>       • Wenn kein Fehler:
           *>           OK-Zähler erhöhen und kurze OK-Zeile anzeigen
           *> END-PERFORM

           *> Dateien schließen
           *> Abschluss-Strichlinie und Summen (OK/Fehler) anzeigen
           *> Programm beenden
           GOBACK.

       *>--------------------------------------------------------------
       *> PRUEFE-NAME
       *>  - Ziel: Prüfen, ob im zusammengesetzten Namen nur
       *>    erlaubte Zeichen vorkommen (Buchstaben/Leerz./Bindestrich).
       *>  - Vorgehen:
       *>     • TRIM auf Namen
       *>     • Länge bestimmen
       *>     • Für jedes Zeichen:
       *>         - prüfen, ob es in ALLOWED-NAME-CHARS enthalten ist
       *>         - falls nicht:
       *>             ARG-FELD="Name", ARG-MSG="Sonderzeichen gefunden: '<Z>'"
       *>             PERFORM LOG-ERROR, WS-ERR-FLAG="Y", aus der Schleife raus
       *>--------------------------------------------------------------
       PRUEFE-NAME.
           *> (Implementierung hier von Teilnehmer: Zeichenweise prüfen,
           *>  ggf. LOG-ERROR aufrufen und WS-ERR-FLAG setzen)
           EXIT PARAGRAPH.

       *>--------------------------------------------------------------
       *> PRUEFE-STUNDEN
       *>  - Ziel: Stundenanzahl validieren
       *>  - Regeln:
       *>     • leer/fehlend  -> Fehler
       *>     • enthält Buchstaben -> Fehler ("alphanumerisch")
       *>     • beginnt mit '-' -> Fehler ("negativ nicht erlaubt")
       *>     • mehr als ein '.' oder mehr als ein ',' -> Fehler
       *>  - Hinweise:
       *>     • Zeiche-weise prüfen (ALPHABETIC)
       *>     • Für jeden Fehler: ARG-FELD/ARG-MSG setzen, LOG-ERROR, WS-ERR-FLAG="Y"
       *>--------------------------------------------------------------
       PRUEFE-STUNDEN.
           *> (Implementierung hier von Teilnehmer)
           EXIT PARAGRAPH.

       *>--------------------------------------------------------------
       *> PRUEFE-GEHALT
       *>  - Ziel: Monatsgehalt validieren
       *>  - Regeln:
       *>     • leer/fehlend  -> Fehler
       *>     • negativ (erstes Zeichen '-') -> Fehler
       *>     • enthält Buchstaben -> Fehler ("alphanumerisch")
       *>     • mehr als ein '.' oder mehr als ein ',' -> Fehler
       *>--------------------------------------------------------------
       PRUEFE-GEHALT.
           *> (Implementierung hier von Teilnehmer)
           EXIT PARAGRAPH.

       *>--------------------------------------------------------------
       *> PRUEFE-GEBURTSDATUM
       *>  - Ziel: Datum auf Format und Plausibilität prüfen
       *>  - Regeln:
       *>     • Format exakt 'DD.MM.YYYY' (Länge=10, Punkte an Pos 3 und 6)
       *>     • Tag/Monat/Jahr numerisch
       *>     • Monat in 1..12
       *>     • Tag <= max. Tage des Monats (inkl. Schaltjahrregel)
       *>  - Schaltjahr:
       *>     • 29.02. erlaubt wenn:
       *>       (Jahr mod 400 = 0) oder (Jahr mod 4 = 0 und Jahr mod 100 <> 0)
       *>  - Bei Verstößen:
       *>     • passende ARG-FELD/ARG-MSG setzen, LOG-ERROR, WS-ERR-FLAG="Y"
       *>--------------------------------------------------------------
       PRUEFE-GEBURTSDATUM.
           *> (Implementierung hier von Teilnehmer)
           EXIT PARAGRAPH.

       *>--------------------------------------------------------------
       *> LOG-ERROR
       *>  - Ziel: Eine formatierte Fehlerzeile in FEHLER.LOG schreiben,
       *>           auf der Konsole anzeigen und CNT-ERROR erhöhen.
       *>  - Erwartet (vor Aufruf):
       *>     • ARG-FELD: Feldname (z. B. "Monatsgehalt")
       *>     • ARG-MSG:  Nachricht (z. B. "negativ")
       *>  - Inhalt:
       *>     • FEHLER-RECORD leeren
       *>     • STRING "FEHLER in Zeile " ZEILEN-NR ...
       *>     • WRITE FEHLER-RECORD
       *>     • DISPLAY FEHLER-RECORD
       *>     • ADD 1 TO CNT-ERROR
       *>--------------------------------------------------------------
       LOG-ERROR.
           *> (Implementierung hier von Teilnehmer: Record bauen, loggen)
           EXIT PARAGRAPH.
