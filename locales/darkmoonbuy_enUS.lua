-- Darkmoon Buy v 0.1.8 --
if not (DMBClientLanguage == "set") then
	print("Darkmoon Buy loaded");

    -- Text for initialization
  DMLOADED    = "Darkmoon Buy loaded";
  DMINITCAL   = "Calendar initialized";

    -- Texte für dmbuy
  NOVENDOR    = "Vendor window not open.";
  NOITEM      = " is not available from this vendor!";
  NONEED      = "Nothing was restocked";

    -- Texte für dmquestdate
  FINISHED    = " finished on %s";
  DAYAGO      = " (%d days ago)";
  NODATE      = "No record available!";
  NODATAYET   = "No data available (yet).";

    -- Texte für dmisdm
  DMACTIVE    = "The Darkmoon Faire IS currently taking place";
  DMINACTIVE  = "The Darkmoon Faire is NOT taking place";
    
  -- Texte für dmbybutton
  BUYBUTTONTXT = "Buy Darkmoon\nFaire materials";

    -- Texte für /dmbuy button
  BUTTONMODE        = "Button display mode: ";
  BUTTONMODEUNKNOWN = "Unknown mode: ";

    -- Texte für die Befehlsübersicht (/dmbuy ohne Argument)
  HELPTITLE  = "Darkmoon Buy - Commands:";
  HELPBUY    = "  /dmbuy buy           Buy materials from the vendor";
  HELPCAL    = "  /dmbuy cal           Initialize the calendar";
  HELPISDM   = "  /dmbuy isdm          Check whether the Faire is taking place";
  HELPQDATE  = "  /dmbuy qdate [id]    Completion date of a quest (without id: all)";
  HELPPROFS  = "  /dmbuy profs         Print the character's professions";
  HELPBUTTON = "  /dmbuy button [mode] Button display mode (always|instock|inneed)";
end;