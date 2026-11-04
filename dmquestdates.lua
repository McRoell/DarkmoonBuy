-- Darkmoon Buy v0.1 --
--[[ Closed Beta ]]
local addonName, ns = ...

-- Getrackte Quests (Reihenfolge = Reihenfolge der Ausgabe)
local QUESTS = {
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

local TRACKED = {}
for _, id in ipairs(QUESTS) do
    TRACKED[id] = true
end

local function FormatEntry(questID)
    local title = C_QuestLog.GetTitleForQuestID(questID) or "?"
    local t = DarkmoonBuyData.questDone[questID]
    if t then
        local days = math.floor((time() - t) / 86400)
--        return ("%s (%d): %s (vor %d Tagen)"):format(title, questID, date("%Y-%m-%d %H:%M", t), days)
        return ("Quest: \"%s (%d)\"" .. FINISHED .. DAYAGO):format(title, questID, date("%Y-%m-%d %H:%M", t), days)
    end
    return ("%s (%d): " .. NODATE):format(title, questID)
end

-- Tage seit dem letzten gespeicherten Abschluss, nil = keine Daten
local function DarkmoonQuestsLastDone()
    local done = DarkmoonBuyData and DarkmoonBuyData.questDone
    if not done then return nil end

    local newest
    for _, id in ipairs(QUESTS) do
        local t = done[id]
        if t and (not newest or t > newest) then
            newest = t
        end
    end
    if not newest then return nil end
    return math.floor((time() - newest) / 86400)
end

ns.DarkmoonQuestsLastDone = DarkmoonQuestsLastDone

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("QUEST_TURNED_IN")
f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        DarkmoonBuyData = DarkmoonBuyData or {}
        DarkmoonBuyData.questDone = DarkmoonBuyData.questDone or {}
    elseif event == "QUEST_TURNED_IN" and TRACKED[arg1] then
        DarkmoonBuyData.questDone[arg1] = time()               -- arg1 = questID
    end
end)

SLASH_DMQUESTDATE1 = "/dmquestdate"
SlashCmdList["DMQUESTDATE"] = function(msg)
    local questID = tonumber(msg)
    if questID then
        print(FormatEntry(questID))
    else
        local found = false
        for _, id in ipairs(QUESTS) do
            if DarkmoonBuyData.questDone[id] then
                print(FormatEntry(id))
                found = true
            end
        end
        if not found then
            print(NODATAYET)
        end
    end
end
