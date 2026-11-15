-- Darkmoon Buy v 0.1.8 --
if (GetLocale() == "deDE") then
	DMBClientLanguage = "set";

  -- Text bei der Initialisierung
  DMLOADED    = "Darkmoon Buy geladen";
  DMINITCAL   = "Kalender initialisiert";

  -- Texte für dmbuy
  NOVENDOR    = "Kein Händlerfenster geöffnet";
  NOITEM      = " ist bei diesem Händler nicht verfügbar!";
  NONEED      = "Es wurde nichts aufgefüllt.";

    -- Texte für dmquestdate
  FINISHED    = " abgeschlossen am %s";
  DAYAGO      = " (vor %d Tagen)";
  NODATE      = "Kein Eintrag vorhanden";
  NODATAYET   = "(Noch) keine Daten vorhanden.";

    -- Texte für dmisdm
  DMACTIVE    = "Der Dunkelmond-Jahrmarkt findet derzeit statt";
  DMINACTIVE  = "Der Dunkelmond-Jahrmarkt findet derzeit |cffff0000NICHT|rstatt";

    -- Texte für dmbybutton
  BUYBUTTONTXT = "Dunkelmond–\nMats Kaufen";

    -- Texte für /dmbuy button
  BUTTONMODE        = "Anzeigemodus des Buttons: ";
  BUTTONMODEUNKNOWN = "Unbekannter Modus: ";

    -- Texte für die Befehlsübersicht (/dmbuy ohne Argument)
  HELPTITLE  = "Darkmoon Buy - Befehle:";
  HELPBUY    = "  |cffb960fe/dmbuy buy|r - Benötigte Materialien für die Quests beim Händler kaufen";
  HELPCAL    = "  |cffb960fe/dmbuy cal|r - Kalender initialisieren (Entwickleroption)";
  HELPISDM   = "  |cffb960fe/dmbuy isdm|r - Prüfen, ob der Jahrmarkt stattfindet";
  HELPQDATE  = "  |cffb960fe/dmbuy qdate [id]|r - Abgabedatum der Jahrmarkt-Berufsquest anzeigen (ohne id werden alle angezeigt)";
  HELPPROFS  = "  |cffb960fe/dmbuy profs|r - Berufe des Charakters ausgeben";
  HELPBUTTON = "  |cffb960fe/dmbuy button [mode]|r - Anzeigemodus des Buttons (off | always | instock | inneed)";
end
