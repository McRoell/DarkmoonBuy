-- Darkmoon Buy v0.1 --
--[[ First blood ]]

print("Darkmoon Buy – Quest Dates geladen.");

local addonName = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("QUEST_TURNED_IN")
f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        DarkmoonBuyData = DarkmoonBuyData or {}
        DarkmoonBuyData.questDone = DarkmoonBuyData.questDone or {}
    elseif event == "QUEST_TURNED_IN" then
        DarkmoonBuyData.questDone[arg1] = time()               -- arg1 = questID
    end
end)

SLASH_DMQUESTDATE1 = "/dmquestdate"
SlashCmdList["DMQUESTDATE"] = function(msg)
    local questID = tonumber(msg)
    local t = questID and DarkmoonBuyData.questDone[questID]
    if t then
        local days = math.floor((time() - t) / 86400)
        print(questID, date("%Y-%m-%d %H:%M", t), "(vor " .. days .. " Tagen)")
    else
        print("Kein Abschlussdatum gespeichert für", msg)
    end
end