local addonName, addonTable = ...

local bReadyCheck = LibStub("AceAddon-3.0"):NewAddon("bReadyCheck", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("bReadyCheck")

addonTable.bReadyCheck = bReadyCheck


local defaults = {
	profile = {
		enabled = true,
		onlyForRL = false,
		scale = 1,
		flaskExpireOption = 0,
		ReadyCheckFadeDelay = 10,
		
		fontKey = "default", 
		fontPath = "Interface\\AddOns\\bReadyCheck\\media\\fonts\\default.ttf", 
		fontSize = 12,
		sortByClass = false,	
	}
}

function bReadyCheck:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("bReadyCheckDB", defaults, true)
	
	if self.RegisterOptions then
		self:RegisterOptions()
	end
	
	self:RegisterChatCommand("brc", "SlashCommand")
	self:RegisterChatCommand("breadycheck", "SlashCommand")
	self:RegisterChatCommand("brch", "SlashCommand")
end

function bReadyCheck:SlashCommand(input)
	input = input and input:trim():lower()

	local inRaid = GetNumRaidMembers() > 0
	local inParty = GetNumPartyMembers() > 0

	if not inRaid and not inParty then
		--self:Print("Вы должны быть в группе или рейде, чтобы использовать эту команду.")
		self:Print(L["NeedGroupOrRaid"])
		return
	end

	if not input or input == "" then
		self:CreateMainFrame()
		local frame = self.buffFrame

		self:CleanupMainFrame()

		frame.isManual = true
		frame.isManualOpen = true

		frame:SetAlpha(1)
		frame:Show()

		-- скрытие таймера
		self:ClearHeadTextTimer()
--[[
		if frame.headText then
			local text = frame.headText:GetText()
			if text then
				text = text:gsub("%s*%b()", ""):gsub("%s+$", "")
				frame.headText:SetText(text)
			end
		end
]]
		self.buffFrame:Show()
		self:CreateLines()
		self:CreateIconHeaders()
		self:UpdateLinesSize(true)
		self:UpdateRoster(true)
		self:UpdateData()

		frame:RegisterEvent("UNIT_AURA")
		frame:SetScript("OnEvent", function(self, event, unit)
			if event == "UNIT_AURA" and unit then
				local line = bReadyCheck.RCW_UnitToLine and bReadyCheck.RCW_UnitToLine[unit]
				if line then
					bReadyCheck:UpdateData(line)
				end
			end
		end)
	else
		self:Print("bReadyCheck: Введите /brc help для справки.")
	end
end

function bReadyCheck:OnEnable()
	if self.db.profile.enabled then
		self:RegisterEvent("READY_CHECK", "OnReadyCheck")
		self:RegisterEvent("READY_CHECK_FINISHED", "OnReadyCheckFinished")
		self:RegisterEvent("READY_CHECK_CONFIRM", "OnReadyCheckConfirm")
		self:RegisterEvent("ADDON_LOADED")
	end
end
--[[
function bReadyCheck:OnReadyCheck()
print("[bReadyCheck] OnReadyCheck: start")
	self:CreateMainFrame()
	self.buffFrame.isManualOpen = false
	self.buffFrame:Show()
	

	self:CreateFadeOutAnimation()
	self:CreateLines()
	self:CreateIconHeaders()
	self:UpdateLinesSize(true)

	if self.buffFrame and self.buffFrame.timeLeftLine and self.buffFrame.timeLeftLine.Start then
		self.buffFrame.timeLeftLine:Start(30)
	end

	self:UpdateRoster(false)
	self:UpdateData()
	self:OnBuffFrameEvent()

	self.db.profile.RaidCheckReadyCheckTime = GetTime() + 30
	self.db.profile.ReadyCheckEnded = false
	
	self.buffFrame:SetAlpha(1)

end
]]

--[[
function bReadyCheck:OnReadyCheckFinished()
	self:Print("Готовность завершена!")
	self:PrepToHide()
end
]]
