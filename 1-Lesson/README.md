## I. Für die Lektion 1 relevante Dateien sind:
1) stundensatz_aufgabe.cbl: Hier wird die Aufgabe bearbeitet - die Hauptdatei, in der der COBOL-Code geschrieben wird.
2) stundensatz_loesung: Die Lösung zur ersten Aufgabe. Wir empfehlen jedoch, die Aufgabe selbstständig zu lösen, bevor ein Blick in die Lösung geworfen wird.
3) BUCHUNGEN.DAT: Beispieldatei mit aufgebrachten Stunden je Mitarbeiter. Wird vom Programm eingelesen und verarbeitet.

## II. Was sind die anderen Dateien im Ordner? 
4) compile-and-run.sh: Shell-Skript zum Compilen und Ausführen des COBOL-Programms.
5) stundensatz_aufgabe: Unix-Datei, die der Compiler erzeugt hat, da die .cbl-Dateien nicht wie Skripte direkt gestartet werden können, sondern immer zuerst zu einer ausführbaren Unix-Datei übersetzt werden. 
6) Readme.md: Diese Datei mit Anweisungen zur Aufgabe.

## III. Ausführung am eigenen BWLehrpool-Rechner
Am BWLehrpool-Rechner:
1.⁠ ⁠⁠Schritt: Führe mithilfe der Shell-Datei ausführen ( einfach jedesmal “./compile-and-run.sh“ fürs compilen).

Am eigenen Rechner (Windows):
...

Am eigenen Rechner (Mac):
1.⁠ ⁠⁠Schritt: Lade die Erweiterung in VS Code herunter fürs Highlighting (https://marketplace.visualstudio.com/items?itemName=bitlang.cobol)
2.⁠ ⁠⁠Schritt: Lade die GnuCOBOL-Erweiterung herunter (bei Mac: brew install gnu-cobol und checken, ob es funktioniert hat mit cobc -v).
3.⁠ ⁠⁠Schritt: Führe mithilfe der Shell-Datei/ manuell aus (bei Mac: Shell-Script ausführbar machen mit “chmod +x compile-and-run.sh“, danach einfach jedesmal “./compile-and-run.sh“ fürs compilen).

Hinweis: Wir empfehlen die Ausführung am BWLehrpool-Rechner, da dort alle nötigen Programme bereits installiert sind und die Umgebung vorkonfiguriert ist.