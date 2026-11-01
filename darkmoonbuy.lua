-- Darkmoon Buy v0.1 --
--[[ First blood ]]

--[[
Suchen nach den Items (via Item ID) und dann kaufen
vielleicht auch prüfen wie viele Teile ggf. noch im Inventar vorhanden sind.
Abfrage welche Berufe der Char hat und dann anhand diese Info die Items kaufen.
]]


-- Abfrage welche Berufe der Char kann
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

SLASH_MYPROFS1 = "/myprofs"
SlashCmdList["MYPROFS"] = PrintMyProfessions