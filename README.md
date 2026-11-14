# Darkmoon Buy – Alpha (v0.1.8)

Helps you buy the materials needed for the Darkmoon Faire profession quests.

Not really localized yet, but it should work sensibly with all client languages.
## What it does
It checks which professions a character has currently learned and tops up the inventory with the materials needed for those professions.
If the vendor doesn't have something, an appropriate error message is shown in chat.
## How it works
Darkmoon Buy checks whether the Darkmoon Faire is currently running. If it is, a button is shown on the vendor window that lets you buy the materials needed for the profession quests. It checks which professions the character practices and what is already in the inventory, so only what is still missing gets bought.
To keep the button from getting in your way, it is not shown if the profession quests have already been completed during the current Faire – provided the addon was already active at that time.
## Settings and optional features
/dmbuy gives     an overview of all commands – basically the content of this chapter.  
/dmbuy buy      If you don't like buttons, you can also buy manually.  
/dmbuy isdm     shows whether the Faire is currently running.  
/dmbuy qdate    shows when the profession quests were last completed.  
/dmbuy profs    lists the current professions.  
/dmbuy Button   (off | always | instock | inneed) lets you define further conditions for when the button should be shown.  
* "off"     No button is shown on the vendor window. Purchases are made using /dmbuy buy.
* "always"  Button is always shown as soon as the basic condition is met
* "instock" Button is additionally shown only if the vendor carries a rule item
* "inneed"  like "instock", but there must also be a need for at least one item
## And everything else (AKA Developer Tools)
Not yet implemented:
* Passing the next vendor to TomTom.
