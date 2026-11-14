-- Version 0.1.8

local addonName, ns = ...

--
-- Abfrage welche Berufe der Char hat/kann (s. /dmbuy profs)
-- Die fünf Slots werden der Reihe nach durchgegangen und deren Name ausgegeben.
--
function ns.PrintMyProfessions()
    local profs = { GetProfessions() }
    for slot = 1, 5 do
        local index = profs[slot]
        if index then
            local name = GetProfessionInfo(index)
            print(name)
        end
    end
end

-- Vergleicht den 7. Rückgabewert (skillLineID, im Grunde die ID des Berufs) 
-- von GetProfessionInfo mit dem Übergebenen Wert (skillLine)
local function HasProfession(skillLine)
    for _, index in pairs({ GetProfessions() }) do
        if select(7, GetProfessionInfo(index)) == skillLine then
            return true
        end
    end
    return false
end

-- Bedarf aller gelernten Berufe je Item aufaddieren und mit dem Bestand abgleichen.
-- Die Tabelle order enthält die Reihenfolge der Item-IDs, wie sie in den Regeln auftauchen.
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

-- Funktion, die das Einkaufen beim Händler übernimmt (s. /dmbuy)
function ns.Buy()
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
            local itemName = C_Item.GetItemNameByID(itemID) or itemID
            print(itemName .. NOITEM)
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

-- Prüft, ob der Dunkelmond-Jahrmarkt gerade stattfindet (s. /dmbuy isdm)
-- TODO: Vor dem Release den Dev-Modus entfernen, damit der Kalenderwert gilt.
function ns.IsDarkmoonFaireActive()
    local today = C_DateAndTime.GetCurrentCalendarTime().monthDay
    for i = 1, C_Calendar.GetNumDayEvents(0, today) do
        local event = C_Calendar.GetDayEvent(0, today, i)
        if event and event.eventID == 479 then
            return true
        end
    end
    -- return false
    return true -- DEV-MODUS: immer aktiv
end

-- Wandelt die QuestID der Berufsquests in eine lesbare Ausgabe um,
-- inklusive Datum und Tage seit Abschluss (s. /dmbuy qdate)
function ns.FormateQuestDate(questID)
    local title = C_QuestLog.GetTitleForQuestID(questID) or "?"
    local t = DarkmoonBuyData.questDone[questID]
    if t then
        local days = math.floor((time() - t) / 86400)
        return ("Quest: \"%s (%d)\"" .. FINISHED .. DAYAGO):format(title, questID, date("%Y-%m-%d %H:%M", t), days)
    end
    return ("%s (%d): " .. NODATE):format(title, questID)
end

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

-- Button am Händlerfenster
local button

--
-- Anzeigemodus des Buttons (s. /dmbuy button)
--
--   "off"     Button wird nie angezeigt, Einkauf nur über /dmbuy buy
--   "always"  Button erscheint immer, sobald die Grundbedingung erfüllt ist
--   "instock" Button zusätzlich nur, wenn der Händler ein Regel-Item führt
--   "inneed"  wie "instock", zusätzlich muss bei einem Item Bedarf bestehen
--
local BUTTON_MODES = { off = true, always = true, instock = true, inneed = true }
local DEFAULT_BUTTON_MODE = "inneed"

function ns.GetButtonMode()
    local mode = DarkmoonBuyData and DarkmoonBuyData.buttonMode
    if BUTTON_MODES[mode] then
        return mode
    end
    return DEFAULT_BUTTON_MODE
end

function ns.SetButtonMode(mode)
    if not BUTTON_MODES[mode] then
        return false
    end
    DarkmoonBuyData.buttonMode = mode
    return true
end

-- Prüft, ob der Händler mindestens ein Regel-Item führt und ob darauf Bedarf besteht.
-- Liefert drei Werte: hatItem, hatBedarf, gelesen.
-- "gelesen" ist false, wenn das Sortiment noch nicht auswertbar war.
local function CheckStock()
    local targets, order = BuildTargets()
    if #order == 0 then
        return false, false, false
    end

    local slots = BuildMerchantIndex()
    if not next(slots) then
        return false, false, false
    end

    local hasItem, hasNeed = false, false
    for _, itemID in ipairs(order) do
        if slots[itemID] then
            hasItem = true
            if targets[itemID] - C_Item.GetItemCount(itemID) > 0 then
                hasNeed = true
            end
        end
    end
    return hasItem, hasNeed, true
end

local function ShouldShow()
    -- Grundbedingung: Jahrmarkt aktiv und letzte Abgabe länger als 6 Tage her.
    if not ns.IsDarkmoonFaireActive() then
        return false
    end
    local days = DarkmoonQuestsLastDone()
    if not (days == nil or days > 6) then
        return false
    end

    local mode = ns.GetButtonMode()
    if mode == "off" then
        return false
    end
    if mode == "always" then
        return true
    end

    local hasItem, hasNeed, read = CheckStock()
    if not read then
        -- Sortiment noch nicht auswertbar: Button nicht verstecken.
        return true
    end
    if mode == "instock" then
        return hasItem
    end
    return hasItem and hasNeed
end

local function CreateButton()
    button = CreateFrame("Button", "DMBuyButton", MerchantFrame, "UIPanelButtonTemplate")
    button:SetSize(140, 40)
    button:SetPoint("TOPLEFT", MerchantFrame, "BOTTOMRIGHT", -140, 5)
    button:SetText(BUYBUTTONTXT)
    button:SetScript("OnClick", function()
        ns.Buy()
    end)
end

-- Kalender-Tweak: öffnet den Kalender einmalig, um die Eventdaten zu laden (s. /dmbuy cal)
function ns.InitializeCalendar()
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST")
    frame:SetScript("OnEvent", function(self, event, ...)
        if event == "CALENDAR_UPDATE_EVENT_LIST" then
            print(DMINITCAL)
            self:UnregisterEvent("CALENDAR_UPDATE_EVENT_LIST")
        end
    end)
    C_Calendar.OpenCalendar()
end

-- Die Print-Funktionen der Slash-Befehle (s. /dmbuy isdm, /dmbuy qdate)

function ns.PrintIsDarkmoonFaire()
    if ns.IsDarkmoonFaireActive() then
        print(DMACTIVE)
    else
        print(DMINACTIVE)
    end
end

function ns.PrintQuestDates(msg)
    local questID = tonumber(msg)
    if questID then
        print(ns.FormateQuestDate(questID))
        return
    end

    -- Ohne gefundene Daten (Addon neu, Beruf gewechselt) einmal NODATAYET ausgeben.
    local done = DarkmoonBuyData.questDone
    local found = false
    for _, id in ipairs(ns.QUESTS) do
        if done[id] then
            print(ns.FormateQuestDate(id))
            found = true
        end
    end

    if not found then
        print(NODATAYET)
    end
end

-- Initialisierung des Addons beim Laden
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("QUEST_TURNED_IN")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript(
    "OnEvent",
    function(self, event, arg1)
        if event == "ADDON_LOADED" and arg1 == addonName then
            DarkmoonBuyData = DarkmoonBuyData or {}
            DarkmoonBuyData.questDone = DarkmoonBuyData.questDone or {}
            print(DMLOADED)
            ns.InitializeCalendar()  -- Kalenderdaten im Hintergrund laden
        elseif event == "QUEST_TURNED_IN" and ns.CRAFTQUESTS[arg1] then
            DarkmoonBuyData.questDone[arg1] = time()               -- arg1 = questID
        elseif event == "MERCHANT_SHOW" then
            if not button then
                CreateButton()
            end
            button:SetShown(ShouldShow())
        end
    end
)
