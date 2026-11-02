# Darkmoon Buy – Beta (oder doch Alpha)
Hilft die für die Berufsquests des Dunkelmond–Jahrmarkt benötigten Mats zu kaufen. 

Aktuell noch nicht wirklich lokalisiert, sollte aber sinnvoll mit allen Sprachversionen des Clients laufen. 
## Was kann es, macht es
Es prüft welche Berufe ein Char aktuell gelernt hat und ergänzt das Inventar um die benötigten Mats für die jeweiligen Berufe. 
Sollte der Händler etwas nicht haben, gibt es eine entsprechende Fehlermeldung im Chat. 
## Wie funktioniert es
Einfach das Händlerfenster öffnen und `/dmbuy` in den Chat schreiben. Alternativ geht natürlich auch das Ganze in ein Makro zu packen. 
## Was kann es (noch) nicht
Es prüft nicht ob überhaupt Dunkelmond ist oder ob man die Quests nicht bereits vorgestern erledigt hat. Die Items werden auf die benötigte Menge eingekauft. 
## und sonst AKA Developer Tools
Im Moment noch implementiert
* `/myprofs` gibt die aktiven Berufe des Chars aus
* Aktuell werden die Daten (UNIX Zeit Format) gespeichert, wann die Berufsquests zuletzt abgeschlossen wurden. vielleicht kann man das nutzen um zusammen mit der Info dass Dunkelmond ist, beim Händlerbesuch einen Button erscheinen zu lassen, mit dem man dann einkauft.
  jedenfalls gibt `/dmquestdate` die entsprechenden Daten aus. Voraussetzung ist allerdings, dass die Quests überhaupt einmal mit aktiviertem Addon einmal abgeschlossen wurden. 



