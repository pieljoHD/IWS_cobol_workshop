*> ================================================================
*> #1 IDENTIFICATION DIVISION – Wer bin ich?
*> ================================================================
IDENTIFICATION DIVISION.
PROGRAM-ID. BUCHUNGEN-VALIDIERER.
AUTHOR. Workshop-Team.
DATE-WRITTEN. 2025-NOV-01.


*> ================================================================
*> #2 ENVIRONMENT DIVISION – Welche Dateien benutze ich?
*> ================================================================
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.

    *> Eingabedatei BUCHUNGEN.DAT definieren
    *> Fehlerdatei FEHLER.LOG definieren
    *> FILE STATUS Felder verwenden


*> ================================================================
*> #3 DATA DIVISION – Was speichere ich?
*> ================================================================
DATA DIVISION.

*> ---------------------------
*> #3.1 FILE SECTION
*> ---------------------------
FILE SECTION.

    *> FD für Eingabedatei
    *> Datensatz für eine Buchungszeile

    *> FD für Fehlerdatei
    *> Datensatz für Fehlertext


*> ---------------------------
*> #3.2 WORKING-STORAGE SECTION
*> ---------------------------
WORKING-STORAGE SECTION.

    *> File-Status-Felder
    *> EOF-Steuerung
    *> Zeilenzähler

    *> Felder für Vorname / Nachname
    *> Roh-Buchungsnummer (alphanumerisch)
    *> Buchungsnummer (numerisch)

    *> Hilfsfelder für String-Verarbeitung
    *> Länge der aktuellen Zeile

    *> Statistik:
    *> Anzahl gültiger Buchungen
    *> Anzahl fehlerhafter Buchungen


*> ================================================================
*> #4 PROCEDURE DIVISION – Hauptsteuerung
*> ================================================================
PROCEDURE DIVISION.

MAIN.
    *> Dateien öffnen
    *> Fehler beim Öffnen prüfen
    *> Startmeldung ausgeben

    *> Schleife: Datei bis EOF lesen
    *> Zeilennummer erhöhen
    *> Verarbeitung der Zeile aufrufen

    *> Dateien schließen
    *> Statistik ausgeben
    *> Programm beenden


*> ================================================================
*> #5 Verarbeitung einer Buchungszeile
*> ================================================================
PROCESS-LINE.

    *> Zeile trimmen
    *> Länge bestimmen

    *> Letzte 3 Zeichen als Buchungsnummer extrahieren
    *> Rest der Zeile ohne Nummer bestimmen

    *> Vor- und Nachnamen aus dem Rest extrahieren
    *> Buchungsnummer validieren


*> ================================================================
*> #6 Validierung der Buchungsnummer
*> ================================================================
VALIDATE-BUCHUNG.

    *> Prüfen, ob Buchungsnummer numerisch ist
    *> OK-Fall zählen und anzeigen
    *> Fehler-Fall protokollieren


*> ================================================================
*> #7 Fehler protokollieren
*> ================================================================
WRITE-FEHLER.

    *> Fehlertext zusammensetzen
    *> Fehler in Datei schreiben
    *> Fehler auf Konsole anzeigen
