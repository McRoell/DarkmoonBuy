-- Version 0.1.5

local _, ns = ...

-- item = Item-ID, count = Bedarf für diesen Beruf (Zielbestände mehrerer Berufe werden addiert)
ns.RULES = {
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
}

-- Getrackte Quests (Reihenfolge = Reihenfolge der Ausgabe)
ns.QUESTS = {
    29506,    -- Alchemie; Eine prickelnde Mischung
    29515,    -- Inschriftenkunde; Ein Blick in die Zukunft
    29509,    -- Kochen; Wie der Frosch knusprig wird
    29517,    -- Lederverarbeitung; Begehrte Preise
    29520,    -- Schneiderei; Banner, überall Banner!
-- Diese Dunkelmondquest stehen hier nur der Vollständigkeit halber.
    29513,    -- Angeln; Leckerer Fisch im Schlafrock
    29518,    -- Bergbau; Wiederbewaffnung, Wiederver...
    29511,    -- Ingenieurskunst; Panzerreparatur
    29516,    -- Juwelenschleifen; Jahrmarkt der Eitelkeiten
    29514,    -- Kräuterkunde; Heilkräuter
    29519,    -- Kürschnerei; Gerbt meine Häute
    29508,    -- Schmiedekunst; Baby braucht zwei Paar Schuhe
    29510,    -- Verzauberkunst; Auch Abfall kann nützlich sein
}

ns.TRACKED = {}
for _, id in ipairs(ns.QUESTS) do
    ns.TRACKED[id] = true
end

SLASH_DMISDM1 = "/dmisdm"
SlashCmdList["DMISDM"] = function()
    if ns.IsDarkmoonFaireActive() then
        print(DMACTIVE)
    else
        print(DMINACTIVE)
    end
end

SLASH_MYPROFS1 = "/myprofs"
SlashCmdList["MYPROFS"] = ns.PrintMyProfessions

SLASH_DMBUY1 = "/dmbuy"
SlashCmdList["DMBUY"] = ns.Buy

SLASH_DMQUESTDATE1 = "/dmquestdate"
SlashCmdList["DMQUESTDATE"] = function(msg)
    local questID = tonumber(msg)
    if questID then
        print(ns.FormatEntry(questID))
    else
        local found = false
        for _, id in ipairs(ns.QUESTS) do
            if DarkmoonBuyData.questDone[id] then
                print(ns.FormatEntry(id))
                found = true
            end
        end
        if not found then
            print(NODATAYET)
        end
    end
end

-- testerrei die dazu dienen soll den Kalender zu initialisieren - FUNKTIONIERT!
SLASH_DMCAL1 = "/dmcal"
SlashCmdList["DMCAL"] = function()
local frame = CreateFrame("Frame")
frame:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "CALENDAR_UPDATE_EVENT_LIST" then
        print("Kalenderdaten erfolgreich im Hintergrund geladen!")
        -- Hier kannst du jetzt mit C_Calendar.GetMonthInfo() o.ä. arbeiten
        
        -- Event optional wieder abmelden, wenn es nur einmalig gebraucht wurde
        self:UnregisterEvent("CALENDAR_UPDATE_EVENT_LIST")
    end
end)
C_Calendar.OpenCalendar()
end


