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
*> Eingabe- und Fehlerdatei deklarieren.


*> ================================================================
*> #3 DATA DIVISION
*> ================================================================
DATA DIVISION.

*> ---------------------------
*> #3.1 FILE SECTION
*> ---------------------------
FILE SECTION.
*> Puffer für Eingabe- und Fehlerzeilen.

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
*> Hauptablauf: öffnen, lesen, prüfen, loggen, schließen.


*> ================================================================
*> #5 Datei-Handling
*> ================================================================
OPEN-FILES.
*> Dateien öffnen.

CLOSE-FILES.
*> Dateien schließen.

READ-NEXT.
*> Zeile lesen.


*> ================================================================
*> #6 Zeilenverarbeitung
*> ================================================================
PREPARE-LINE.
*> Zeile bereinigen.

PARSE-FIELDS.
*> Felder extrahieren.

BUILD-NAME-DISPLAY.
*> Anzeige-Name bilden.

HANDLE-OK.
*> OK-Fall zählen/anzeigen.


*> ================================================================
*> #7 Validierungen
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
*> #8 Logging / Fehlerausgabe
*> ================================================================
LOG-ERROR.
*> Fehler in Datei schreiben.