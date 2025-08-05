local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("bReadyCheck", true)


local L = AceLocale:NewLocale("bReadyCheck", "enUS", true)
if L then
    L["READY_CHECK"] = "Ready Check"
	L["SECONDS"] = " (%s sec.)" 
	L["Enable"] = "Enable"
	L["General Settings"] = "General"
	L["EnableDesc"] = "Enable/disable bReadyCheck"
	L["OnlyRL"] = "Only for raid leader"
	L["OnlyRLDesc"] = "Show info only to raid leader or assistants"
	L["FrameScale"] = "Scale"
	L["MinFlaskExp"] = "Show expiring flasks"
	L["MinFlaskExpDesc"] = "Set how many minutes before flask expiration to display a warning"
	L["MinFlaskExpNo"] = "no"
	L["MinFlaskExpMin"] = "min."
	L["TimerTooltip"] = "Disappearance time after the ready check (in seconds)"
	L["Fonts"] = "Font"
	L["FontsDesc"] = "Select the text font" 
	L["SortByClass"] = "Sort by class"
	L["SortByClassDesc"] = "Players will be sorted by class"
	L["NeedGroupOrRaid"] = "You have to be in a party or raid"
	L["FontSize"] = "Font size"
	L["FontSettings"] = "Font"
	L["BuffSettings"] = "Buffs"
	
	L["ShowSourceName"] = "Display who applied the buff"
	L["ShowSourceNameDesc"] = "Show the name of the buff's source in the tooltip"

	
end
--[[
L = AceLocale:NewLocale("bReadyCheck", "ruRU")
if L then
    L["READY_CHECK"] = "Проверка готовности"
end
]]
