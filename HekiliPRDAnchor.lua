-- Create a new addon frame
local addonName, addonTable = ...
local HekiliPRDAnchor = CreateFrame("Frame", addonName)

-- Function to get the Personal Resource Display frame
local function GetPersonalResourceFrame()
    local nameplate = C_NamePlate.GetNamePlateForUnit("player")
    if nameplate then
        return nameplate.UnitFrame -- The UnitFrame contains the Personal Resource Display
    end
    return nil
end

-- Event handler to reposition Hekili buttons
local function RepositionHekili()
    local button1 = _G["Hekili_Primary_B1"] -- Hekili Button 1
    local button2 = _G["Hekili_Primary_B2"] -- Hekili Button 2
    local personalResourceFrame = GetPersonalResourceFrame()

    if button1 and button2 and personalResourceFrame then
        -- Position Button 1 relative to the Personal Resource Display
        button1:ClearAllPoints()
        button1:SetPoint("TOP", personalResourceFrame, "BOTTOM", 0, -15)

        -- Position Button 2 relative to Button 1
        button2:ClearAllPoints()
        button2:SetPoint("LEFT", button1, "RIGHT", 5, 0)
    end
end

-- Delayed function to ensure frames exist
local function DelayedReposition()
    C_Timer.After(1, RepositionHekili) -- Wait 1 second before trying to reposition
end

-- Register events for when UI elements are available
HekiliPRDAnchor:RegisterEvent("PLAYER_ENTERING_WORLD")
HekiliPRDAnchor:RegisterEvent("NAME_PLATE_UNIT_ADDED") -- To handle dynamic nameplates
HekiliPRDAnchor:RegisterEvent("PLAYER_REGEN_ENABLED") -- Adjust after combat

HekiliPRDAnchor:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        DelayedReposition()
    else
        RepositionHekili()
    end
end)
