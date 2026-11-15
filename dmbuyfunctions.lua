-- Version 1.0

local addonName, ns = ...

--
-- Query which professions the character has/knows (see /dmbuy profs)
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

-- Compares the 7th return value (skillLineID, basically the ID of the profession)
-- of GetProfessionInfo with the passed value (skillLine)
local function HasProfession(skillLine)
    for _, index in pairs({ GetProfessions() }) do
        if select(7, GetProfessionInfo(index)) == skillLine then
            return true
        end
    end
    return false
end

-- In case no professions has been learned
local noProfessionReported = false

local function CheckAnyProfession()
    if next({ GetProfessions() }) == nil then
        if not noProfessionReported then
            print(NOPROFESSION)
            noProfessionReported = true
        end
        return false
    end
    return true
end

-- Add up the needs of all learned professions per item and compare them with the current stock.
local function BuildTargets()
    if not CheckAnyProfession() then
        return {}, {}
    end

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

-- Returns the quest table for a given ID (or nil).
local function FindQuest(questID)
    for _, quest in ipairs(ns.QUESTS) do
        if quest.id == questID then
            return quest
        end
    end
    return nil
end

-- Slot# per ItemID at vendor
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

-- let's buy (s. /dmbuy)
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
                -- BuyMerchantItem does not report success. Therefore the
                -- stock is compared before and after the purchase: if it stays the same,
                -- the bag was full (or the vendor's inventory has changed).
                local before = C_Item.GetItemCount(itemID)
                BuyMerchantItem(slot, missing)
                local after = C_Item.GetItemCount(itemID)

                if after <= before then
                    local itemName = C_Item.GetItemNameByID(itemID) or itemID
                    print(itemName .. NOBAGSPACE)
                    break
                end
                bought = true
            end
        end
    end

    if not bought then
        print(NONEED)
    end
end

-- Checks if Darkmoon Faire is taking place (s. /dmbuy isdm)
function ns.IsDarkmoonFaireActive()
    local today = C_DateAndTime.GetCurrentCalendarTime().monthDay
    for i = 1, C_Calendar.GetNumDayEvents(0, today) do
        local event = C_Calendar.GetDayEvent(0, today, i)
        if event and event.eventID == 479 then
            return true
        end
    end
    return false
    -- return true -- Dev mode, permanent faire
end

-- Converts the QuestID of the profession quests into a readable output,
-- including the date and days since completion (see /dmbuy qdate)
function ns.FormateQuestDate(questID)
    local quest = FindQuest(questID)
    local title = quest and quest.title or UNKNOWNQUEST
    local t = DarkmoonBuyData.questDone[questID]
    if t then
        local days = math.floor((time() - t) / 86400)
        return ("Quest: \"%s (%d)\"" .. FINISHED .. DAYAGO):format(title, questID, date("%Y-%m-%d %H:%M", t), days)
    end
    return ("%s (%d): " .. NODATE):format(title, questID)
end

-- Days since the quest has last tunend in. nil = no data
local function DarkmoonQuestsLastDone()
    local done = DarkmoonBuyData and DarkmoonBuyData.questDone
    if not done then return nil end

    local newest
    for _, quest in ipairs(ns.QUESTS) do
        local t = done[quest.id]
        if t and (not newest or t > newest) then
            newest = t
        end
    end
    if not newest then return nil end
    return math.floor((time() - newest) / 86400)
end

-- The Button on the vendor frame
local button

--
-- Display Mode of the Button (s. /dmbuy button)
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
    for _, quest in ipairs(ns.QUESTS) do
        if done[quest.id] then
            print(ns.FormateQuestDate(quest.id))
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
