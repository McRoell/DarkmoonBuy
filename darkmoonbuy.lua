-- Darkmoon Buy v0.1 --
--[[ First blood ]]

--[[Offene Punkte
Ich weiß wann ich den Quest abgeschlossen habe (dmquestdate).
Wenn das länger als eine woche her ist UND der Händler die Items
hat, könnte ich fragen ob sie gekauft werden sollen

Bis dahin passiert gar nichts, so lange keine /dmbuy eingibt
]]

print("Darkmoon Buy – Items geladen.");

-- Abfrage welche Berufe der Char hat/kann
-- Separate funktion (s. /myprofs)
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

-- Gibt den 7. Wert des SkillLine Arrays und damit die BerufsID aus.
local function HasProfession(skillLine)
    for _, index in pairs({ GetProfessions() }) do
        if select(7, GetProfessionInfo(index)) == skillLine then
            return true
        end
    end
    return false
end

-- item = Item-ID, count = Bedarf für diesen Beruf (Zielbestände mehrerer Berufe werden addiert)
local RULES = {
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

-- Bedarf aller gelernten Berufe je Item aufaddieren
local function BuildTargets()
    local targets, order = {}, {}
    for _, rule in ipairs(RULES) do
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

SLASH_DMBUY1 = "/dmbuy"
SlashCmdList["DMBUY"] = function()
    if not MerchantFrame:IsShown() then
        print("Kein Händlerfenster geöffnet.")
        return
    end

    local targets, order = BuildTargets()
    local slots = BuildMerchantIndex()
    local bought = false

    for _, itemID in ipairs(order) do
        local slot = slots[itemID]
        if not slot then
            print(itemID .. " ist bei diesem Händler nicht verfügbar!")
        else
            local missing = targets[itemID] - C_Item.GetItemCount(itemID)
            if missing > 0 then
                BuyMerchantItem(slot, missing)
                bought = true
            end
        end
    end

    if not bought then
        print("Es gibt nichts was aufgefüllt werden müsste.")
    end
end

SLASH_MYPROFS1 = "/myprofs"
SlashCmdList["MYPROFS"] = PrintMyProfessions