# Darkmoon Buy – Alpha (v0.1.7)

Hilft die für die Berufsquests des Dunkelmond–Jahrmarkt benötigten Mats zu kaufen. 

Aktuell noch nicht wirklich lokalisiert, sollte aber sinnvoll mit allen Sprachversionen des Clients laufen. 
## Was kann es, macht es
Es prüft welche Berufe ein Char aktuell gelernt hat und ergänzt das Inventar um die benötigten Mats für die jeweiligen Berufe. 
Sollte der Händler etwas nicht haben, gibt es eine entsprechende Fehlermeldung im Chat. 
## Wie funktioniert es
Darkmoon Buy prüft ob der Dunkelmondjahrmarkt gerade stattfindet. Ist das der Fall, wird am Händlerfenster ein Button angezeigt, mit dem man die füür die Berufe-Quests benötigten Materialien kaufen kann. Dabei wird geprüft, welche Berufe der Char ausübt und was sich noch im Inventar befindet. Es wird also nur das gekauft, was noch fehlt.
Damit der Button nicht ständig rumnervt, wird er nicht angezeigt, wenn die Berufsquests während des aktuellen Jahrmarkts bereits abgeschlossen wurden – vorausgesetzt das Addon war bereits aktiv.
## Einstellungen und optionale Funktionen.
/dmbuy isdm gibt an, ob der Jahrmarkt aktuell stattfindet.
/dmbuy qdate gibt an, wann die Berufsquests zuletzt abgeschlossen worden sind.
/dmbuy profs gibt die aktuellen Berufe aus
/dmbuy Button (always | instock | inneed) ermöglicht es weitere Parameter zu definieren, wann der Button angezeigt werden soll.
        "always"  Button erscheint immer, sobald die Grundbedingung erfüllt ist
        "instock" Button zusätzlich nur, wenn der Händler ein Regel-Item führt
        "inneed"  wie "instock", zusätzlich muss bei einem Item aber Bedarf bestehen
## und sonst so (AKA Developer Tools)
Im Moment noch nicht implementiert
* Übergabe des nächsten Händlers an TomTom.
* Usage Ausgabe wenn /dmbuy ohen Parameter aufgerufen wird. Im Moment wird versucht Dinge zu kaufen. Stammt noch aus der Zeit ohne Button.