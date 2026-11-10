-- Version 0.1.6

local _, ns = ...

ns.CRAFTQUESTS = {}
for _, id in ipairs(ns.QUESTS) do
    ns.CRAFTQUESTS[id] = true
end

--
-- Slash-Befehle. Ein Befehl, mehrere Argumente.
--
--   /dmbuy              Einkauf beim Händler (wie bisher)
--   /dmbuy cal          Kalender initialisieren
--   /dmbuy isdm         Prüfen, ob der Jahrmarkt stattfindet
--   /dmbuy qdate [id]   Abschlussdatum einer Quest (ohne id: alle)
--   /dmbuy profs        Berufe des Charakters ausgeben
--

local function PrintIsDarkmoonFaire()
    if ns.IsDarkmoonFaireActive() then
        print(DMACTIVE)
    else
        print(DMINACTIVE)
    end
end

local function PrintQuestDates(msg)
    local questID = tonumber(msg)
    if questID then
        print(ns.FormatEntry(questID))
        return
    end

    -- Ohne gefundene Daten (Addon neu, Beruf gewechselt) einmal NODATAYET ausgeben.
    local done = DarkmoonBuyData.questDone
    local found = false
    for _, id in ipairs(ns.QUESTS) do
        if done[id] then
            print(ns.FormatEntry(id))
            found = true
        end
    end

    if not found then
        print(NODATAYET)
    end
end

local handlers = {
    cal   = function() ns.InitializeCalendar() end,
    isdm  = PrintIsDarkmoonFaire,
    qdate = PrintQuestDates,
    profs = function() ns.PrintMyProfessions() end,
}

SLASH_DMBUY1 = "/dmbuy"
SlashCmdList["DMBUY"] = function(msg)
    msg = strtrim(msg or "")
    local cmd, rest = msg:match("^(%S*)%s*(.*)$")
    cmd = cmd:lower()

    local handler = cmd ~= "" and handlers[cmd]
    if handler then
        handler(rest)
    else
        ns.Buy()
    end
end
