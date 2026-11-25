-- Darkmoon Buy v 1.0
if (GetLocale() == "deDE") then
	DMBClientLanguage = "set";

  -- Initialization
  DMLOADED    = "Darkmoon Buy geladen";
  DMINITCAL   = "Kalender initialisiert";

  -- dmbuy buy
  NOVENDOR    = "Kein Händlerfenster geöffnet";
  NOITEM      = " ist bei diesem Händler nicht verfügbar!";
  NONEED      = "Es wurde nichts aufgefüllt.";
  NOBAGSPACE  = " – kein Platz in den Taschen, Kauf abgebrochen!";
  NOPROFESSION = "Keine passenden Berufe gelernt - es gibt nichts einzukaufen.";

    -- dmbuy qdate
  FINISHED    = " abgeschlossen am %s";
  DAYAGO      = " (vor %d Tagen)";
  NODATE      = "Kein Eintrag vorhanden";
  NODATAYET   = "(Noch) keine Daten vorhanden.";

    -- dmbuy isdm
  DMACTIVE    = "Der Dunkelmond-Jahrmarkt findet derzeit statt";
  DMINACTIVE  = "Der Dunkelmond-Jahrmarkt findet derzeit NICHT statt";

    -- Button text
  BUYBUTTONTXT = "Dunkelmond–\nMats Kaufen";

    -- dmbuy button
  BUTTONMODE        = "Anzeigemodus des Buttons: ";
  BUTTONMODEUNKNOWN = "Unbekannter Modus: ";

    -- Usage output
  HELPTITLE  = "Darkmoon Buy - Befehle:";
  HELPBUY    = "  |cffb960fe/dmbuy buy|r - Benötigte Materialien für die Quests beim Händler kaufen";
  HELPCAL    = "  |cffb960fe/dmbuy cal|r - Kalender initialisieren (Entwickleroption)";
  HELPISDM   = "  |cffb960fe/dmbuy isdm|r - Prüfen, ob der Jahrmarkt stattfindet";
  HELPQDATE  = "  |cffb960fe/dmbuy qdate [id]|r - Abgabedatum der Jahrmarkt-Berufsquest anzeigen (ohne id werden alle angezeigt)";
  HELPPROFS  = "  |cffb960fe/dmbuy profs|r - Berufe des Charakters ausgeben";
  HELPBUTTON = "  |cffb960fe/dmbuy button [mode]|r - Anzeigemodus des Buttons (off | always | instock | inneed)";

    -- Questnames (used by dmbuydb.lua)
  ALCTITLE      = "Eine prickelnde Mischung";
  INSCRIBTITLE  = "Ein Blick in die Zukunft";
  COOKTITLE     = "Wie der Frosch knusprig wird";
  LEATHERTITLE  = "Begehrte Preise";
  TAILORTITLE   = "Banner, überall Banner!";
  ARCHTITLE     = "Spaß für die Kleinen!";

    -- Unknown questID
  UNKNOWNQUEST  = "Unbekannte Quest";
end;
