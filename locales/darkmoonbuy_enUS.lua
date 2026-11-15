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
  DMINACTIVE  = "The Darkmoon Faire is |cffff0000NOT|r taking place";
    
  -- Texte für dmbybutton
  BUYBUTTONTXT = "Buy Darkmoon\nFaire materials";

    -- Texte für /dmbuy button
  BUTTONMODE        = "Button display mode: ";
  BUTTONMODEUNKNOWN = "Unknown mode: ";

    -- Texte für die Befehlsübersicht (/dmbuy ohne Argument)
  HELPTITLE  = "Darkmoon Buy - Commands:";
  HELPBUY    = "  |cffb960fe/dmbuy buy|r - Buy beeded crafting materials from the vendor";
  HELPCAL    = "  |cffb960fe/dmbuy cal|r - Initialize the calendar (development option)";
  HELPISDM   = "  |cffb960fe/dmbuy isdm|r - Check whether the Faire is taking place";
  HELPQDATE  = "  |cffb960fe/dmbuy qdate [id]|r - Completion date of the Faire professions quest (without id all are shown)";
  HELPPROFS  = "  |cffb960fe/dmbuy profs|r - Print the character's professions";
  HELPBUTTON = "  |cffb960fe/dmbuy button [mode]|r - Button display mode (off | always | instock | inneed)";
end;
