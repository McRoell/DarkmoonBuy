local _, ns = ...

local button

local function ShouldShow()
    if not ns.IsDarkmoonFaireActive or not ns.DarkmoonQuestsLastDone then
    -- if not ns.IsDarkmoonFaireActive then
        return false
    end
    local days = ns.DarkmoonQuestsLastDone()
    return ns.IsDarkmoonFaireActive() and (days == nil or days > 6)
end

local function CreateButton()
    button = CreateFrame("Button", "DMBuyButton", MerchantFrame, "UIPanelButtonTemplate")
    button:SetSize(140, 22)
    button:SetPoint("TOPLEFT", MerchantFrame, "TOPRIGHT", 4, -60)
    button:SetText(BUYBUTTONTXT)
    button:SetScript("OnClick", function()
        ns.Buy()
    end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", function()
    if not button then
        CreateButton()
    end
    button:SetShown(ShouldShow())
end)