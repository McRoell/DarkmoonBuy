# lokale Funktionen
## PrintMyProfessions
## HasProfession
## BuildTargets
## BuildMerchantIndex
## ns.buy
das ns. irritiert mich. geht das ggf. für alle Funktionen?
## IsDarkmoonFaireActive
## FormateQuestDate
## DarkmoonQuestsLastDone
## ShouldShow
## CreateButton
## ns.InitializeCalendar

# aktuelle Slash Befehle
## dmbuy
Ruft die Funktion [ns.Buy](#nsbuy) auf, die den Einkaufsprozess startet.
## dmisdm
Developer Befehl.
Prüft mittels der Funktion [IsDarkmoonFaireActive](#isdarkmoonfaireactive) ob der DM gerade stattfindet und gibt das Ergebnis (Ja/Nein) aus. Der Slasbefehl kann weg, die Funktion wird auch von der Funktion [ShouldShow](#shouldshow) verwendet.
## myprofs
Gibt mit hilfe der Funktion [PrintMyProfessions](#printmyprofessions) die vom Char erlernten Berufe aus.
## dmquestdate ([QuestID](#questid))
Gibt mit Hilfe der Funktion [FormateQuestDate](#FormateQuestDate) das Datum aus, an dem die Quest das letzte mal abgegeben worden ist.
Wird keine QuestID übergeben, werden dei daten Aller berufsquests ausgegeben.
Bedingung: Das Addon muss beim (letzten) Abgeben eines Quests aktiv gewesen sein.
## dmcal
Developer Befehl
Ruft die Funktion [ns.InitializeCalendar](#nsinitializecalendar) auf, die den Kalender einmal im Hintergrund aktualisiert.
Befehl kann weg, das die Funktion jetzt bei der initialisierung des Addons mit aufgerufen wird.
# zukünftige Slash Befehle
Es wäre denkbar, das Ganze über Argumente für dmbuy zu realisieren.
dmbuy ohne Argument bleibt wie gehabt.
dmbuy qdate wäre das Äquivalent zu [dmquestdate](#dmquestdate-questid)
dmbuy cal könnte als undokumentierte AUfruf der Kalenderinitiierung [dmcal](#dmcal) bleiben
dmbuy profs als ersatz für [myprofs](#myprofs) – der Name ist eh doof!
dmbuy isdm letztlich als ersatz für [dmisdm](#dmisdm).

# Variablen
## WoW Intern
### QUESTID
Interne ID eines Quests
## selbst definierte