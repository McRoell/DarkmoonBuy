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

SLASH_DMISDM1 = "/dmisdm"
SlashCmdList["DMISDM"] = function(msg)
    if IsDarkmoonFaireActive() then
        print("The Darkmoon Faire is currently active.");
    else
        print("The Darkmoon Faire is not active.");
    end
end