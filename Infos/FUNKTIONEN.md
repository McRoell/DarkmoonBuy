# Darkmoon Buy 0.1.6 — Funktionsreferenz

Dokumentation des Ist-Stands. Beschrieben sind alle Funktionen der drei Lua-Dateien sowie die beiden anonymen Ereignis-Funktionen. Wo eine Funktion eine andere aufruft, ist jeweils nur das Ergebnis dieses Aufrufs genannt.

## Dateiübersicht

| Datei | Inhalt |
|---|---|
| `locales\Locales.xml` | Lädt `darkmoonbuy_deDE.lua`, danach `darkmoonbuy_enUS.lua` |
| `dmbuyfunctions.lua` | Alle Fachfunktionen, der Händlerbutton und die Ereignisschleife |
| `dmbuydb.lua` | Daten: Einkaufsregeln (`ns.RULES`) und Questliste (`ns.QUESTS`) |
| `dmbuycore.lua` | Slash-Befehl `/dmbuy` mit Argumentverteilung |

Ladereihenfolge laut `DarkmoonBuy.toc`: `locales\Locales.xml`, dann `dmbuyfunctions.lua`, dann `dmbuydb.lua`, dann `dmbuycore.lua`.

## PrintMyProfessions

Die Funktion ermittelt die Berufe des aktuellen Charakters und gibt deren Namen im Chatfenster aus. Sie liegt als `ns.PrintMyProfessions` in der Addon-Tabelle, damit der Slash-Befehl sie aus einer anderen Datei erreichen kann. Eingelesen wird das Ergebnis des Aufrufs `GetProfessions()`, das sie in eine Tabelle umwandelt, um die fünf Berufs-Slots der Reihe nach zu durchlaufen. Für jeden belegten Slot holt sie mit `GetProfessionInfo(index)` den Namen und gibt ihn aus. Leere Slots werden übersprungen, sodass nur tatsächlich gelernte Berufe erscheinen. Die Funktion hat keinen Rückgabewert und ändert keine Daten.

## HasProfession

Die Funktion beantwortet die Frage, ob der Charakter einen bestimmten Beruf beherrscht. Sie erhält dafür eine Berufs-ID als Argument, etwa `171` für Alchemie. In einer Schleife liest sie alle gelernten Berufe ein und vergleicht für jeden den siebten Rückgabewert von `GetProfessionInfo`, der die Berufszeile (`skillLine`) enthält. Stimmt einer dieser Werte mit der übergebenen ID überein, liefert sie sofort `true` zurück und bricht die Suche ab. Wird kein Treffer gefunden, ist das Ergebnis `false`. Sie ist lokal und wird nur innerhalb von `dmbuyfunctions.lua` von `BuildTargets` verwendet.

## BuildTargets

Die Funktion berechnet, welche Materialien in welcher Menge für die Berufe des Charakters benötigt werden. Sie durchläuft dazu alle Einträge in `ns.RULES`, der Einkaufsregel-Tabelle. Für jede Regel prüft sie über `HasProfession`, ob der Charakter den jeweiligen Beruf beherrscht, und übergeht Regeln für nicht gelernte Berufe. Bei einem Treffer addiert sie den Bedarf jedes zugehörigen Items auf den bisherigen Wert. Benötigen mehrere Berufe dasselbe Item, summiert sich der Wert entsprechend. Neben den Bedarfsmengen liefert sie eine zweite Tabelle `order` zurück, die die Items in der Reihenfolge ihres ersten Auftretens enthält — diese zweite Tabelle dient `ns.Buy` als Durchlaufliste.

## BuildMerchantIndex

Die Funktion erstellt eine Zuordnung von Item-ID zur Verkaufs-Slot-Nummer beim aktuell geöffneten Händler. Dafür ermittelt sie über `GetMerchantNumItems()` die Anzahl der Verkaufsplätze und geht sie der Reihe nach durch. Für jeden Platz liest sie mit `GetMerchantItemLink` den Item-Link aus und gewinnt daraus mit einem Musterabgleich auf `item:(%d+)` die Item-ID. Diese ID wird in einer Tabelle mit dem jeweiligen Platz als Wert hinterlegt. Ist eine Item-ID mehrfach vorhanden, bleibt der erste gefundene Platz erhalten; damit hängt das Ergebnis vom Händlerfenster ab, das beim Aufruf offen ist.

## ns.Buy

Die Funktion führt den eigentlichen Einkauf beim Händler durch und ist der Standardaufruf von `/dmbuy` ohne Argument. Zuerst prüft sie, ob das Händlerfenster überhaupt offen ist; ist es geschlossen, gibt sie `NOVENDOR` aus und beendet sich ohne weitere Aktion. Andernfalls holt sie über `BuildTargets` die benötigten Mengen und über `BuildMerchantIndex` die Slot-Zuordnung des aktuellen Händlers. Dann geht sie die Item-Liste der Reihe nach durch: Fehlt ein Item im Sortiment, wird sein Name zusammen mit `NOITEM` ausgegeben; ist es vorhanden, vergleicht sie den Bedarf mit dem Ergebnis von `C_Item.GetItemCount` und kauft nur die Differenz. Gekauft wird mit `BuyMerchantItem(slot, missing)`. Wurde am Ende nichts beschafft, gibt die Funktion `NONEED` aus; sie hat keinen Rückgabewert.

## ns.IsDarkmoonFaireActive

Die Funktion beantwortet die Frage, ob der Dunkelmond-Jahrmarkt gerade stattfindet. Sie ermittelt den heutigen Kalendertag über `C_DateAndTime.GetCurrentCalendarTime().monthDay` und zählt dann mit `C_Calendar.GetNumDayEvents` die an diesem Tag eingetragenen Kalenderereignisse. In einer Schleife liest sie jedes Ereignis über `C_Calendar.GetDayEvent` und vergleicht dessen `eventID` mit dem Wert `479`, der für den Jahrmarkt steht. Bei einem Treffer liefert sie `true` zurück und beendet die Suche vorzeitig. Aktuell ist die Rückgabe `false` am Ende der Funktion auskommentiert, stattdessen wird immer `true` zurückgegeben; ein `TODO`-Kommentar weist darauf hin, dass dies der Dev-Modus ist und vor dem Release entfernt werden muss. Damit meldet die Funktion unabhängig vom Kalender derzeit stets „Jahrmarkt aktiv".

## ns.FormatEntry

Die Funktion wandelt eine Quest-ID in eine lesbare Ausgabezeile um, die den Questtitel, das Abschlussdatum und die Zahl der Tage seit dem Abschluss enthält. Zuerst holt sie den Titel über `C_QuestLog.GetTitleForQuestID` und setzt ersatzweise ein Fragezeichen, falls kein Titel ermittelbar ist. Dann liest sie den gespeicherten Abschlusszeitpunkt aus `DarkmoonBuyData.questDone[questID]`. Ist ein Zeitpunkt vorhanden, berechnet sie die vergangenen Tage als ganzzahlige Division der Sekundendifferenz durch `86400` und formatiert das Datum mit `date`. Existiert kein Eintrag, liefert sie den Questtitel zusammen mit `NODATE` zurück. Die Funktion gibt nichts selbst aus, sondern liefert den fertigen String an den Aufrufer zurück.

## DarkmoonQuestsLastDone

Die Funktion ermittelt, wie viele Tage seit dem zuletzt gespeicherten Abschluss einer der fünf Berufsquests vergangen sind. Sie greift auf `DarkmoonBuyData.questDone` zu und gibt `nil` zurück, wenn diese Tabelle nicht existiert. Ansonsten durchläuft sie alle Quest-IDs aus `ns.QUESTS` und sucht den jüngsten gespeicherten Zeitstempel. Findet sie keinen einzigen Eintrag, ist das Ergebnis ebenfalls `nil`. Andernfalls teilt sie die Sekundendifferenz zur aktuellen Zeit durch `86400` und rundet ab, sodass die Anzahl vollständiger Tage entsteht. Der `nil`-Rückgabewert ist bedeutungstragend und wird von `ShouldShow` als „keine Daten vorhanden" gewertet.

## ShouldShow

Die Funktion entscheidet, ob der Einkaufsbutton am Händlerfenster sichtbar sein soll. Als Erstes prüft sie über `ns.IsDarkmoonFaireActive()`, ob der Jahrmarkt stattfindet, und liefert bei `false` sofort `false` zurück. Danach holt sie über `DarkmoonQuestsLastDone()` die Zahl der Tage seit dem letzten Questabschluss. Sie gibt dann `true` zurück, wenn dieser Wert `nil` ist — also noch gar keine Daten vorliegen — oder wenn er größer als `6` ist. Die Grenze von sechs Tagen bedeutet, dass der Button erst wieder erscheint, wenn die letzte Abgabe mehr als eine Woche zurückliegt. Die Funktion ist lokal und wird ausschließlich vom `MERCHANT_SHOW`-Ereignis aufgerufen.

## CreateButton

Die Funktion erzeugt den Einkaufsbutton am Händlerfenster und legt ihn einmalig als `DMBuyButton` an. Als Vorlage dient `UIPanelButtonTemplate`, als Elternfenster `MerchantFrame`. Sie setzt die Größe auf 140 × 40 Pixel und positioniert den Button unten rechts am Händlerfenster. Beschriftet wird er mit dem globalen Text `BUYBUTTONTXT`, der aus der jeweiligen Lokalisierungsdatei stammt. Beim Anklicken ruft sie `ns.Buy()` auf, sodass ein Klick denselben Ablauf startet wie der Slash-Befehl ohne Argument. Die erzeugte Schaltfläche wird in der dateilokalen Variablen `button` gespeichert, damit spätere Ereignisse sie ein- und ausblenden können.

## ns.InitializeCalendar

Die Funktion stößt das Laden der Kalenderdaten an und bestätigt es im Chatfenster. Sie erzeugt dafür einen eigenen, unsichtbaren Rahmen und registriert ihn auf das Ereignis `CALENDAR_UPDATE_EVENT_LIST`. Tritt dieses Ereignis ein, gibt sie `DMINITCAL` aus und meldet den Rahmen sofort wieder ab, sodass die Meldung nur einmal erscheint. Anschließend öffnet sie den Kalender über `C_Calendar.OpenCalendar()`, wodurch die Ereignisdaten geladen werden. Aufgerufen wird sie beim Laden des Addons sowie über den Slash-Befehl `/dmbuy cal`. Sie hat keinen Rückgabewert und beeinflusst nur den geladenen Kalenderzustand.

## PrintIsDarkmoonFaire

Die Funktion gibt im Chatfenster aus, ob der Jahrmarkt stattfindet. Sie ruft dazu `ns.IsDarkmoonFaireActive()` auf und wertet dessen Ergebnis aus. Bei `true` erscheint der Text `DMACTIVE`, andernfalls `DMINACTIVE`. Sie liefert selbst nichts zurück und ist an den Slash-Befehl `/dmbuy isdm` gebunden. Da der Aufruf derzeit im Dev-Modus stets `true` ergibt, meldet der Befehl aktuell immer „aktiv".

## PrintQuestDates

Die Funktion gibt die Abschlussdaten der Berufsquests aus und verarbeitet das Argument des Slash-Befehls `/dmbuy qdate`. Wird eine Zahl übergeben, deutet sie diese als Quest-ID, holt über `ns.FormatEntry` die Ausgabezeile und gibt nur diese aus. Ohne Argument durchläuft sie stattdessen alle fünf Quest-IDs aus `ns.QUESTS`. Für jede Quest, zu der in `DarkmoonBuyData.questDone` ein Datum hinterlegt ist, gibt sie über `ns.FormatEntry` eine Zeile aus. Wird dabei kein einziger Eintrag gefunden — etwa weil das Addon neu ist oder der Beruf gewechselt wurde —, gibt sie einmalig `NODATAYET` aus. Sie hat keinen Rückgabewert.

## Die Argumentverteilung in dmbuycore.lua

Der anonyme Funktionsausdruck hinter `SlashCmdList["DMBUY"]` nimmt die gesamte Eingabezeile entgegen und verteilt sie auf die zuständigen Funktionen. Zuerst entfernt er über `strtrim` führende und nachfolgende Leerzeichen und zerlegt die Zeile dann mit einem Musterabgleich in Befehlsname und Rest. Der Befehlsname wird in Kleinbuchstaben umgewandelt, sodass `/dmbuy CAL` genauso wirkt wie `/dmbuy cal`. Anschließend sucht er den Namen in der Tabelle `handlers`, die die vier Argumente `cal`, `isdm`, `qdate` und `profs` auf ihre Funktionen abbildet. Wird ein Eintrag gefunden, ruft er die zugehörige Funktion auf und übergibt ihr den Rest der Eingabe; `qdate` erhält auf diesem Weg seine optionale Quest-ID. Ist der Befehlsname leer oder unbekannt, ruft er `ns.Buy()` auf — damit verhält sich `/dmbuy` ohne Argument wie bisher, und auch eine versehentliche Fehleingabe löst den Einkauf aus.

## Die Ereignisfunktion in dmbuyfunctions.lua

Der anonyme Funktionsausdruck hinter `f:SetScript("OnEvent", ...)` steuert den gesamten Ablauf des Addons und unterscheidet drei Fälle. Beim Ereignis `ADDON_LOADED` prüft er zuerst, ob das geladene Addon das eigene ist; trifft das zu, legt er die gespeicherten Daten `DarkmoonBuyData` samt der Tabelle `questDone` an, falls sie noch nicht existieren. Danach gibt er `DMLOADED` aus und ruft `ns.InitializeCalendar()` auf, wodurch die Kalenderdaten im Hintergrund geladen werden. Beim Ereignis `QUEST_TURNED_IN` prüft er, ob die abgegebene Quest in `ns.CRAFTQUESTS` steht, und speichert für diese fünf Quests den aktuellen Zeitpunkt als Abschlussdatum. Beim Ereignis `MERCHANT_SHOW` erzeugt er den Button, falls er noch fehlt, und blendet ihn über `ShouldShow()` ein oder aus — die Sichtbarkeit des Buttons hängt damit an genau diesen Bedingungen.

## Verhalten bei geändertem Berufsstand

Zwei Funktionen reagieren auf den Berufsstand des Charakters, tun das aber zu unterschiedlichen Zeitpunkten und mit unterschiedlicher Wirkung. `HasProfession` und `BuildTargets` werten den Berufsstand bei jedem Einkauf neu aus, sodass ein Berufswechsel sofort in die Einkaufsliste einfließt. Die Tabelle `DarkmoonBuyData.questDone` wird dagegen nicht bereinigt: Ein einmal gespeichertes Abschlussdatum bleibt erhalten, auch wenn der zugehörige Beruf später aufgegeben wird. `ns.FormatEntry` und `DarkmoonQuestsLastDone` lesen diese Einträge weiterhin aus, solange die Quest-ID in `ns.QUESTS` steht. Für `PrintQuestDates` kann daraus die Ausgabe `NODATAYET` folgen, wenn kein Datum zu den fünf aktuellen Quests gefunden wird.
