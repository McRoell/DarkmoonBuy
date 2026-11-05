# Darkmoon Buy – Alpha (v0.1.5)

Hilft die für die Berufsquests des Dunkelmond–Jahrmarkt benötigten Mats zu kaufen. 

Aktuell noch nicht wirklich lokalisiert, sollte aber sinnvoll mit allen Sprachversionen des Clients laufen. 
## Was kann es, macht es
Es prüft welche Berufe ein Char aktuell gelernt hat und ergänzt das Inventar um die benötigten Mats für die jeweiligen Berufe. 
Sollte der Händler etwas nicht haben, gibt es eine entsprechende Fehlermeldung im Chat. 
## Wie funktioniert es
Einfach das Händlerfenster öffnen und `/dmbuy` in den Chat schreiben. Alternativ geht natürlich auch das Ganze in ein Makro zu packen. 
## Was kann es (noch) nicht
Es prüft nicht ob überhaupt Dunkelmond ist oder ob man die Quests nicht bereits vorgestern erledigt hat. Die Items werden auf die benötigte Menge eingekauft. 
## und sonst so (AKA Developer Tools)
Im Moment noch implementiert
* `/myprofs` gibt die aktiven Berufe des Chars aus
* Das Addon speichert den Zeitpunkt wenn einer der Berufsquest abgegeben wurde im Unix Zeitformat – natürlich nur dann, wenn das Addon aktiv ist. Diese Info wird genutzt um, zusammen mit der Info dass Dunkelmond ist, beim Händlerbesuch einen Button erscheinen zu lassen, mit dem man dann einkauft, oder halt eben nicht.  
Jedenfalls gibt `/dmquestdate` die entsprechenden Daten aus. Voraussetzung ist allerdings, dass die Quests überhaupt einmal mit aktiviertem Addon abgeschlossen wurden. 
`/dmisdm` gibt aus ob überhaupt Dunkelmond ist. Aktuell gibt es aber noch einen Bug, dass die Info erst gesichert bereit steht, wenn frt Kalender einmal geöffnet wurde. `/dmcal` soll das beheben. AKtuell als eigener Slashbefehl, zuknftig als Teil des normalen Ablaufs.
## Ausblick, wo hakt es noch
- Der Code ist ein einziger Wirrwarr und muss noch aufgeräumt werden.
- Im Moment wird noch die ItemID und nicht der Itemname ausgegeben, wenn versucht wird etwas zu kaufen, was der Händler nicht hat.
- Wenn ein Händler keine Mats hat, die ich für meine Berufsquest benötige, muss der Button ebenfalls gar nicht erst angezeigt werden.
- "Ich brauch einen Button für das TomTom Command zum nächsten Händler" – nicht vor 2027 😊