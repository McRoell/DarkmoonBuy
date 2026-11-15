-- Darkmoon Buy v 1.0
if not (DMBClientLanguage == "set") then
	print("Darkmoon Buy loaded");

    -- Initialization
  DMLOADED    = "Darkmoon Buy loaded";
  DMINITCAL   = "Calendar initialized";

  -- dmbuy buy
  NOVENDOR    = "Vendor window not open.";
  NOITEM      = " is not available from this vendor!";
  NONEED      = "Nothing was restocked";
  NOBAGSPACE  = " – no space in bags, purchase aborted!";
  NOPROFESSION = "No suitable professions learned - there is nothing to buy.";

    -- dmbuy qdate
  FINISHED    = " finished on %s";
  DAYAGO      = " (%d days ago)";
  NODATE      = "No record available!";
  NODATAYET   = "No data available (yet).";

    -- dmbuy isdm
  DMACTIVE    = "The Darkmoon Faire IS currently taking place";
  DMINACTIVE  = "The Darkmoon Faire is NOT taking place";
    
	-- Button text
  BUYBUTTONTXT = "Buy Darkmoon\nFaire materials";

    -- dmbuy button
  BUTTONMODE        = "Button display mode: ";
  BUTTONMODEUNKNOWN = "Unknown mode: ";

    -- Usage output
  HELPTITLE  = "Darkmoon Buy - Commands:";
  HELPBUY    = "  |cffb960fe/dmbuy buy|r - Buy needed crafting materials from the vendor";
  HELPCAL    = "  |cffb960fe/dmbuy cal|r - Initialize the calendar (development option)";
  HELPISDM   = "  |cffb960fe/dmbuy isdm|r - Check whether the Faire is taking place";
  HELPQDATE  = "  |cffb960fe/dmbuy qdate [id]|r - Completion date of the Faire professions quest (without id all are shown)";
  HELPPROFS  = "  |cffb960fe/dmbuy profs|r - Print the character's professions";
  HELPBUTTON = "  |cffb960fe/dmbuy button [mode]|r - Button display mode (off | always | instock | inneed)";

    -- Quest titles of the profession quests (used in dmbuydb.lua)
  ALCTITLE      = "A Fizzy Fusion";
  INSCRIBTITLE  = "Writing the Future";
  COOKTITLE     = "Putting the Crunch in the Frog";
  LEATHERTITLE  = "Eyes on the Prizes";
  TAILORTITLE   = "Banners, Banners Everywhere!";
  ARCHTITLE     = "Fun for the Little Ones";

    -- Output for unknown quest IDs
  UNKNOWNQUEST  = "Unknown quest";
end;
