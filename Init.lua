-- Auction House Pro Tools - Basic Init Script
local addonName, addonTable = ...

local function OnAddonLoaded(event, addon)
    if addon == addonName then
        print(addonName .. " loaded!")
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", OnAddonLoaded)