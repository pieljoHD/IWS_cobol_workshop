*> ================================================================
*> #1 IDENTIFICATION DIVISION
*> ================================================================
IDENTIFICATION DIVISION.
*> Grundangaben zum Programm.

*> ================================================================
*> #2 ENVIRONMENT DIVISION
*> ================================================================
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
*> Nur Eingabedatei deklarieren.


*> ================================================================
*> #3 DATA DIVISION
*> ================================================================
DATA DIVISION.

*> ---------------------------
*> #3.1 FILE SECTION
*> ---------------------------
FILE SECTION.
*> Puffer für Eingabezeile.

*> ---------------------------
*> #3.2 WORKING-STORAGE SECTION
*> ---------------------------
WORKING-STORAGE SECTION.
*> Flags, Zähler, Felder, Hilfsvariablen.


*> ================================================================
*> #4 PROCEDURE DIVISION – Hauptprogramm
*> ================================================================
PROCEDURE DIVISION.

MAIN.
*> Hauptablauf: öffnen, lesen, prüfen, ausgeben, schließen.


*> ================================================================
*> #4.1 Datei-Handling
*> ================================================================
OPEN-FILES.
*> Datei öffnen.

CLOSE-FILES.
*> Datei schließen.

READ-NEXT.
*> Zeile lesen.


*> ================================================================
*> #4.2 Zeilenverarbeitung, 4.2.1 Lesen und Vorbereiten
*> ================================================================
PREPARE-LINE.
*> Zeile bereinigen.

PARSE-FIELDS.
*> Felder extrahieren.

BUILD-NAME-DISPLAY.
*> Anzeige-Name bilden.

HANDLE-OK.
*> OK auf Konsole ausgeben.


*> ================================================================
*> #4.2.2 Validierungen, 4.2.3 Fehlerbehandlung und Zähler
*> ================================================================
PRUEFE-NAME.
*> Namenscheck.

PRUEFE-STUNDEN.
*> Stundencheck.

PRUEFE-GEHALT.
*> Gehaltscheck.

PRUEFE-GEBURTSDATUM.
*> Datumscheck.


*> ================================================================
*> #4.3 Logging / Fehlerausgabe
*> ================================================================
LOG-ERROR.
*> Fehler auf Konsole anzeigen.