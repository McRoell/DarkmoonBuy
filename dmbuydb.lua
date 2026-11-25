-- Version 1.0
-- "Database" might be a bit of a stretch, but somehow this is one after all. :)

local _, ns = ...

--
-- The purchase rules for the different professions, i.e. how much of what each profession needs.
--
ns.RULES = {
-- item  = item ID
-- count = quantity needed for this profession
-- if several professions need the same item, the quantities are added together.

    { profession = 171, items = {                        -- Alchemy
        { item = 1645,  count = 5 },                     -- Moonberry Juice
    }},
    { profession = 185, items = {                        -- Cooking
        { item = 30817, count = 5 },                     -- Simple Flour
    }},
    { profession = 165, items = {                        -- Letherworking
        { item = 6260,  count = 5 },                     -- Blue Dye
        { item = 6529,  count = 10 },                    -- Shiny Bauble
        { item = 2320,  count = 5 },                     -- Coarse Thread
    }},
    { profession = 197, items = {                        -- Tailoring
        { item = 6260,  count = 1 },                     -- Blue Dye
        { item = 2320,  count = 1 },                     -- Shiny Bauble
        { item = 2604,  count = 1 },                     -- Red Dye
    }},
    { profession = 773, items = {                        -- Inscription
        { item = 39354, count = 5 },                     -- Light Parchment
    }},
    { profession = 794, items = {                        -- Archeology
        { item = 87535, count = 3 },                     -- Crate of Fossil Archaeology Fragments
    }}
}
--
-- The profession quests at the Darkmoon Faire that require materials.
-- Only these quests are saved as completed.
--
ns.QUESTS = {
    { id = 29506, title = ALCTITLE },          -- Alchemy
    { id = 29515, title = INSCRIBTITLE },      -- Inscription
    { id = 29509, title = COOKTITLE },         -- Cooking
    { id = 29517, title = LEATHERTITLE },      -- Letherworking
    { id = 29520, title = TAILORTITLE },       -- Tailoring
    { id = 29507, title = ARCHTITLE },         -- Archeology
}
