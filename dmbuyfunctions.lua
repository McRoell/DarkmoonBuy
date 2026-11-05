-- Version 0.1.5

local addonName, ns = ...

-- Abfrage welche Berufe der Char hat/kann (s. /myprofs)
local function PrintMyProfessions()
    local profs = { GetProfessions() }
    for slot = 1, 5 do
        local index = profs[slot]
        if index then
            local name = GetProfessionInfo(index)
            print(name)
        end
    end
end
ns.PrintMyProfessions = PrintMyProfessions

-- Vergleicht mit dem 7. Rückgabewert (skillLine) von GetProfessionInfo
local function HasProfession(skillLine)
    for _, index in pairs({ GetProfessions() }) do
        if select(7, GetProfessionInfo(index)) == skillLine then
            return true
        end
    end
    return false
end

-- Bedarf aller gelernten Berufe je Item aufaddieren
local function BuildTargets()
    local targets, order = {}, {}
    for _, rule in ipairs(ns.RULES) do
        if HasProfession(rule.profession) then
            for _, entry in ipairs(rule.items) do
                if not targets[entry.item] then
                    order[#order + 1] = entry.item
                    targets[entry.item] = 0
                end
                targets[entry.item] = targets[entry.item] + entry.count
            end
        end
    end
    return targets, order
end

-- Slot-Nummer je Item-ID beim aktuellen Händler
local function BuildMerchantIndex()
    local slots = {}
    for i = 1, GetMerchantNumItems() do
        local link = GetMerchantItemLink(i)
        local id = link and tonumber(link:match("item:(%d+)"))
        if id and not slots[id] then
            slots[id] = i
        end
    end
    return slots
end

-- Funktion, die das einkaufen beim Händler übernimmt
ns.Buy = function()
    if not MerchantFrame:IsShown() then
        print(NOVENDOR)
        return
    end

    local targets, order = BuildTargets()
    local slots = BuildMerchantIndex()
    local bought = false

    for _, itemID in ipairs(order) do
        local slot = slots[itemID]
        if not slot then
            local ItemName = C_Item.GetItemNameByID(itemID) or itemID
            print(ItemName .. NOITEM)
        else
            local missing = targets[itemID] - C_Item.GetItemCount(itemID)
            if missing > 0 then
                BuyMerchantItem(slot, missing)
                bought = true
            end
        end
    end

    if not bought then
        print(NONEED)
    end
end

-- Prüft ob der Dunkelmond Jahrmarkt gerade stattfindet
local function IsDarkmoonFaireActive()
    local today = C_DateAndTime.GetCurrentCalendarTime().monthDay
    for i = 1, C_Calendar.GetNumDayEvents(0, today) do
        local event = C_Calendar.GetDayEvent(0, today, i)
        if event and event.eventID == 479 then
            return true
        end
    end
    return false
end
ns.IsDarkmoonFaireActive = IsDarkmoonFaireActive

-- Wandelt die QuestID in eine lesbare Ausgabe um, inklusive Datum und Tage seit Abschluss
local function FormatEntry(questID)
    local title = C_QuestLog.GetTitleForQuestID(questID) or "?"
    local t = DarkmoonBuyData.questDone[questID]
    if t then
        local days = math.floor((time() - t) / 86400)
        return ("Quest: \"%s (%d)\"" .. FINISHED .. DAYAGO):format(title, questID, date("%Y-%m-%d %H:%M", t), days)
    end
    return ("%s (%d): " .. NODATE):format(title, questID)
end
ns.FormatEntry = FormatEntry

-- Tage seit dem letzten gespeicherten Abschluss, nil = keine Daten
local function DarkmoonQuestsLastDone()
    local done = DarkmoonBuyData and DarkmoonBuyData.questDone
    if not done then return nil end

    local newest
    for _, id in ipairs(ns.QUESTS) do
        local t = done[id]
        if t and (not newest or t > newest) then
            newest = t
        end
    end
    if not newest then return nil end
    return math.floor((time() - newest) / 86400)
end
ns.DarkmoonQuestsLastDone = DarkmoonQuestsLastDone

-- Button am Händlerfenster
local button

local function ShouldShow()
    if not ns.IsDarkmoonFaireActive or not ns.DarkmoonQuestsLastDone then
        return false
    end
    local days = ns.DarkmoonQuestsLastDone()
    return ns.IsDarkmoonFaireActive() and (days == nil or days > 6)
end

local function CreateButton()
    button = CreateFrame("Button", "DMBuyButton", MerchantFrame, "UIPanelButtonTemplate")
    button:SetSize(140, 40)
    button:SetPoint("TOPLEFT", MerchantFrame, "BOTTOMRIGHT", -140,   5)
    button:SetText(BUYBUTTONTXT)
    button:SetScript("OnClick", function()
        ns.Buy()
    end)
end

-- Ereignisse
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("QUEST_TURNED_IN")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        ns.InitializeCalendar()  -- Kalenderdaten im Hintergrund laden (hoffentlich)
        DarkmoonBuyData = DarkmoonBuyData or {}
        DarkmoonBuyData.questDone = DarkmoonBuyData.questDone or {}
    elseif event == "QUEST_TURNED_IN" and ns.TRACKED[arg1] then
        DarkmoonBuyData.questDone[arg1] = time()               -- arg1 = questID
    elseif event == "MERCHANT_SHOW" then
        if not button then
            CreateButton()
        end
        button:SetShown(ShouldShow())
    end
end)

-- Kalender Tweak als Funktion
local function InitializeCalendar()
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST")
    frame:SetScript("OnEvent", function(self, event, ...)
        if event == "CALENDAR_UPDATE_EVENT_LIST" then


--[[ LÖSCHEN VOR RELEASE
LÖSCHEN VOR RELEASE
LÖSCHEN VOR RELEASE]]
            print("Kalenderdaten erfolgreich im Hintergrund geladen!")
--[[ LÖSCHEN VOR RELEASE
LÖSCHEN VOR RELEASE
LÖSCHEN VOR RELEASE]]


            self:UnregisterEvent("CALENDAR_UPDATE_EVENT_LIST")
        end
    end)
    C_Calendar.OpenCalendar()
end
ns.InitializeCalendar = InitializeCalendar