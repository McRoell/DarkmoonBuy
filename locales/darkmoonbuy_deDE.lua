-- Darkmoon Buy v 0.1 --
if (GetLocale() == "deDE") then
	print("Darkmoon Buy geladen");
	ClientLanguage = "set";

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
end;