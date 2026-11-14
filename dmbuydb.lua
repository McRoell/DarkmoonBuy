-- Version 0.1.7
-- Datenbank ist vielleicht etwas hoch gegriffen, aber irgendwie ist das hier doch eine. :)

local _, ns = ...

--
-- Die Einkaufsregeln für die verschiedenen Berufe. Also wie viel von was für jeden Beruf.
--
ns.RULES = {
-- item = Item-ID
-- count = Bedarf für diesen Beruf
-- benötigen mehrere Berufe dasselbe Item, wird der Bedarf addiert.

    { profession = 171, items = {                        -- Alchemie
        { item = 1645,  count = 5 },                     -- Mondbeerensaft
    }},
    { profession = 185, items = {                        -- Kochen
        { item = 30817, count = 5 },                     -- Herkömmliches Mehl
    }},
    { profession = 165, items = {                        -- Lederverarbeitung
        { item = 6260,  count = 5 },                     -- Blauer Farbstoff
        { item = 6529,  count = 10 },                    -- Glänzendes Schmuckstück
        { item = 2320,  count = 5 },                     -- Grober Faden
    }},
    { profession = 197, items = {                        -- Schneiderei
        { item = 6260,  count = 1 },                     -- Blauer Farbstoff
        { item = 2320,  count = 1 },                     -- Grober Faden
        { item = 2604,  count = 1 },                     -- Roter Farbstoff
    }},
    { profession = 773, items = {                        -- Inschriftenkunde
        { item = 39354, count = 5 },                     -- Leichtes Pergament
    }},
    { profession = 794, items = {
        { item = 87535, count = 3 },                     -- Kiste mit fossilen Archäologiefragmenten
    }}
}
--
-- Die Berufsquests auf dem Dunkelmondjahrmarkt, für die Materialien benötigt werden.
-- Nur diese Quests werden als abgeschlossen gespeichert.
--
ns.QUESTS = {
    29506,    -- Alchemie; Eine prickelnde Mischung
    29515,    -- Inschriftenkunde; Ein Blick in die Zukunft
    29509,    -- Kochen; Wie der Frosch knusprig wird
    29517,    -- Lederverarbeitung; Begehrte Preise
    29520,    -- Schneiderei; Banner, überall Banner!
    29507,    -- Archäologie; Spaß für die Kleinen!
}
