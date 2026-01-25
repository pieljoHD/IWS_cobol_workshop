# Bildschirm leeren, damit die Ausgabe übersichtlich ist
clear && printf "\033c"

# COBOL-Datei übersetzen (kompilieren): 
# -x = ausführbares Programm erzeugen,
# -free = Free-Format akzeptieren (Code nicht an feste spalten gebunden), 
# -o = Name des erzeugten Programms ("stundensatz")
cobc -x -free -o stundensatz_aufgabe stundensatz_aufgabe.cbl

# Das frisch erstellte COBOL-Programm starten
./stundensatz_aufgabe