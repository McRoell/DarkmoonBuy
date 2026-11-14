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
  DMINACTIVE  = "Der Dunkelmond-Jahrmarkt findet derzeit NICHT statt";

    -- Texte für dmbybutton
  BUYBUTTONTXT = "Dunkelmond–\nMats Kaufen";

    -- Texte für /dmbuy button
  BUTTONMODE        = "Anzeigemodus des Buttons: ";
  BUTTONMODEUNKNOWN = "Unbekannter Modus: ";

    -- Texte für die Befehlsübersicht (/dmbuy ohne Argument)
  HELPTITLE  = "Darkmoon Buy - Befehle:";
  HELPBUY    = "  /dmbuy buy           Materialien beim Händler einkaufen";
  HELPCAL    = "  /dmbuy cal           Kalender initialisieren";
  HELPISDM   = "  /dmbuy isdm          Prüfen, ob der Jahrmarkt stattfindet";
  HELPQDATE  = "  /dmbuy qdate [id]    Abschlussdatum einer Quest (ohne id: alle)";
  HELPPROFS  = "  /dmbuy profs         Berufe des Charakters ausgeben";
  HELPBUTTON = "  /dmbuy button [mode] Anzeigemodus des Buttons (always|instock|inneed)";
end