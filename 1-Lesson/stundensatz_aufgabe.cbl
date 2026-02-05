       *> ================================================================
       *> SKELETON: Bitte ergänzen Sie die mit TODO markierten Bereiche.
       *> Ziel: Datei einlesen, Umsatz pro Mitarbeitenden berechnen, Gesamtsumme ausgeben.
       *> ================================================================
       
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
       
       *> Formatierte Ausgabe je Mitarbeiter
       01 FORMAT-UMSATZ-PRO-MITARBEITER.
           05 PRINT-MITARBEITER-NAME   PIC X(20).
           05 FILLER                   PIC X.
       
       01 EOF-FLAG PIC X VALUE "N".
       
       *> ---------------------------
       *> TODO: Achtung hier fehlen noch Variablen
       *> MITARBEITER-NACHNAME, ANZAHL-STUNDEN, GESAMT-UMSATZ
       *> FIRMA-STUNDENSATZ, GESAMT-UMSATZ, GESAMT-SUMME
       *> PRINT-ANZAHL-STUNDEN, PRINT-MENGE-UMSATZ
       *> ---------------------------
       
       
       *> ================================================================
       *> #4 PROCEDURE DIVISION – Was soll das Programm tun?
       *> ================================================================
       PROCEDURE DIVISION.
       
       BEGIN.
           PERFORM INITIALIZE-PROGRAM.
       
           *> -----------------------
           *> Einlesen bis EOF
           *> -----------------------
           *> TODO: Lese Datensätze aus BUCHUNGEN bis Dateiende (EOF)
           *>   - READ BUCHUNGEN
           *>   - AT END EOF-FLAG setzen
           *>   - sonst PROCESS-LINE ausführen
           *> Hinweis: Die konkrete READ/IF-Logik soll von den Teilnehmenden ergänzt werden.
       
           *> PERFORM UNTIL EOF-FLAG = "Y"
           *>     ...
           *> END-PERFORM
       
           PERFORM CLEAN-UP.
           STOP RUN.
       
       
       *> ================================================================
       *> #4.1 Datei öffnen
       *> ================================================================
       INITIALIZE-PROGRAM.
           OPEN INPUT BUCHUNGEN.
           *> TODO: Gib eine Tabellenüberschrift aus (z.B. Name | Std | Umsatz)
           *> TODO: Gib eine Trennlinie aus
       
       
       *> ================================================================
       *> #4.2 Verarbeitung einer Zeile
       *> ================================================================
       PROCESS-LINE.
           *> TODO: Zerlege BUCHUNG-LINE in Vorname, Nachname und Stunden
           *>   - Vorname aus den ersten 10 Zeichen
           *>   - Nachname aus den nächsten 10 Zeichen
           *>   - Stunden aus den nächsten 3 Zeichen
       
           *> TODO: Berechne den Umsatz für den Datensatz
           *> PERFORM BERECHNE-GESAMTUMSATZ
       
           *> TODO: Gib die formatierte Zeile aus
           *> PERFORM PRINT-UMSATZ-PRO-MITARBEITER
       
           *> TODO: Addiere den Umsatz zur Gesamtsumme
       
       
       *> ================================================================
       *> #4.2.1 Umsatz berechnen
       *> ================================================================
       BERECHNE-GESAMTUMSATZ.
           *> TODO: Berechne GESAMT-UMSATZ aus ANZAHL-STUNDEN und FIRMA-STUNDENSATZ
       
       
       *> ================================================================
       *> #4.2.2 Ausgabe formatieren
       *> ================================================================
       PRINT-UMSATZ-PRO-MITARBEITER.
           *> TODO: Fülle PRINT-MITARBEITER-NAME (Vorname + Nachname)
           *> TODO: Setze PRINT-ANZAHL-STUNDEN
           *> TODO: Setze PRINT-MENGE-UMSATZ
       
           *> TODO: Gib die formatierte Zeile aus (Name, Stunden, Umsatz)
       
       
       *> ================================================================
       *> #4.5 Aufräumen und Gesamtsumme ausgeben
       *> ================================================================
       CLEAN-UP.
           CLOSE BUCHUNGEN.
           *> TODO: Gib eine Trennlinie aus
           *> TODO: Gib die Gesamtsumme formatiert aus (z.B. "Gesamtumsatz: ...")
           *> TODO: Erfolgsnachricht ausgeben (DISPLAY "JOB SUCCESSFULLY COMPLETED".)                            