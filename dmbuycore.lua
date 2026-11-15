-- Version 1.0

local _, ns = ...

ns.CRAFTQUESTS = {}
for _, quest in ipairs(ns.QUESTS) do
    ns.CRAFTQUESTS[quest.id] = true
end

local function Usage()
    print(HELPTITLE)
    print(HELPBUY)
    print(HELPCAL)
    print(HELPISDM)
    print(HELPQDATE)
    print(HELPPROFS)
    print(HELPBUTTON)
end

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
    buy    = function() ns.Buy() end,
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

    local handler = handlers[cmd]
    if handler then
        handler(rest)
    else
        Usage()
    end
end
