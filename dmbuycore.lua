-- Version 0.1.7

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
--   /dmbuy button [mode] Anzeigemodus des Buttons (always|instock|inneed)
--

local function SetButtonMode(msg)
    local mode = strtrim(msg or ""):lower()
    if mode == "" then
        print(BUTTONMODE .. ns.GetButtonMode())
        return
    end
    if ns.SetButtonMode(mode) then
        print(BUTTONMODE .. mode)
    else
        print(BUTTONMODEUNKNOWN .. mode)
    end
end

local handlers = {
    cal    = function() ns.InitializeCalendar() end,
    isdm   = function() ns.PrintIsDarkmoonFaire() end,
    qdate  = function(msg) ns.PrintQuestDates(msg) end,
    profs  = function() ns.PrintMyProfessions() end,
    button = SetButtonMode,
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
