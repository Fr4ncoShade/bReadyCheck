local addonName, addonTable = ...
local bReadyCheck = addonTable.bReadyCheck
local L = LibStub("AceLocale-3.0"):GetLocale("bReadyCheck")


--еда
bReadyCheck.tableFood = {
	[57367]=true,	-- Blackened Dragonfin (agility)
	[57327]=true,	-- Tender Shoveltusk Steak / Firecracker Salmon (spd)
	[57139]=true,	-- Shoveltusk Steak (spd)
	[57097]=true,	--спд
	[57356]=true,	-- экспертиза
	[57334]=true,	--стамина	
	[57107]=true,	--стамина
	[57329]=true,	--крит
	[57286]=true,	--крит
	[57100]=true,	--крит
	[57332]=true,	--хаст	
	[57102]=true,	--хаст	
	[57288]=true,	--хаст
	[57365]=true,	--дух
	[53284]=true,	--Steaming Chicken Soup (spirit +25)
	[57325]=true,	--ап	
	[57079]=true,	--ап	
	[57111]=true,	--ап
	[57371]=true,	--сила
	[57360]=true,	--хит
	[57291]=true,	-- Rhino Dogs (mp5)	
	[57358]=true,	--рпб
	[57399]=true,	-- Fish Feast
	[53563]=true,	--тест
}

--фласки
bReadyCheck.tableFlask = {
	[53760]=true,	[53755]=true,	[67019]=true,	[53758]=true,	[54212]=true,	[62380]=true,	[53752]=true,	[53760]=true,	
	[53755]=true,	[53758]=true,	[54212]=true,	[28497]=true,	[33721]=true,	[60347]=true,	[53749]=true,	[60346]=true,
	[53746]=true,	[60345]=true,	[53764]=true,	[53748]=true,	[60344]=true,	[60341]=true,	[53763]=true,	[53751]=true,
	[60340]=true,	[53747]=true,	[60343]=true,	[63729]=true,
	--[168]=true,	--тест
	[673]=true,
}

--бафы
bReadyCheck.classicBuffs = {
	{"druid","Druid",136078,{[48470]=9,[26991]=8,[21850]=7,[21849]=6,[1126]=1,[5232]=2,[5234]=4,[6756]=3,[8907]=5,[9884]=6,[9885]=7,[26990]=8,[48469]=9,[69381]=9}},	--Gift of the Wild
	{"int","Int",135932,{[43002]=7,[27126]=6,[10157]=5,[10156]=4,[1461]=3,[1460]=2,[1459]=1,[23028]=5,[27127]=6,[42995]=7,[61316]=3,[61024]=7}},	--Arcane Intellect
	{"stamina","Stamina",135987,{[1243]=1,[21562]=5,[21564]=6,[25392]=7,[48162]=8,[1244]=2,[1245]=3,[2791]=4,[10937]=5,[10938]=6,[25389]=7,[48161]=8}},	--Power Word: Fortitude
	{"spirit","Spirit",135946,{[27681]=4,[32999]=5,[48074]=6,[14752]=1,[14818]=2,[14819]=3,[27841]=4,[25312]=5,[48073]=6}},	--Prayer of Spirit
	{"shadow","Shadow",136121,{[48170]=5,[25433]=4,[10958]=3,[976]=1,[10957]=2,[27683]=3,[39374]=4,[48169]=5}},	--Shadow Protection	
	{"bom", "BoM", 135908, {[19740]=1,[19834]=2,[19835]=3,[19836]=4,[19837]=5,[19838]=6,[25291]=7,[27140]=8,[48931]=9,[48932]=10,[25782]=6,[25916]=7,[27141]=8,[48933]=9,[48934]=10}},
	{"bow", "BoW", 135970, {[19742]=1,[19850]=2,[19852]=3,[19853]=4,[19854]=5,[25290]=6,[27142]=7,[48935]=8,[48936]=9,[25894]=5,[25918]=6,[27143]=7,[48937]=8,[48938]=9}},
	{"bok", "BoK", 135993, {[20217]=1,[25898]=1,[69378]=1}},
	{"bos", "BoS", 135911, {[25899]=1,[20911]=1}},
}

bReadyCheck.classicBuffsBySpellID = {}

local bReadyCheck_IconPaths = {
  [136078] = "Interface\\Icons\\spell_nature_giftofthewild",
  [135932] = "Interface\\Icons\\spell_holy_arcaneintellect",
  [135987] = "Interface\\Icons\\spell_holy_wordfortitude",
  [135946] = "Interface\\Icons\\spell_holy_prayerofspirit",
  [136121] = "Interface\\Icons\\spell_shadow_antishadow",
  [135908] = "Interface\\Icons\\spell_holy_greaterblessingofkings", -- кулак
  [135970] = "Interface\\Icons\\spell_holy_greaterblessingofwisdom", --мп5 
  [135993] = "Interface\\Icons\\spell_magic_greaterblessingofkings",  -- каска
  [135911] = "Interface\\Icons\\spell_holy_greaterblessingofsanctuary", -- прото
}

function bReadyCheck:GetIconPath(iconID)
  return bReadyCheck_IconPaths[iconID] or "Interface\\Icons\\INV_Misc_QuestionMark"
end

for i, entry in ipairs(bReadyCheck.classicBuffs) do
  local key = entry[1]
  local iconID = entry[3]
  local iconPath = bReadyCheck:GetIconPath(iconID)
  local spells = entry[4]
  for spellID, val in pairs(spells) do
    bReadyCheck.classicBuffsBySpellID[spellID] = {
      key = key,
      icon = iconPath,
      val = val,
    }
  end
end

	--============================
--[[
for i, entry in ipairs(bReadyCheck.classicBuffs) do
	local key = entry[1]
	local icon = entry[3]
	local spells = entry[4]
	for spellID, val in pairs(spells) do
		bReadyCheck.classicBuffsBySpellID[spellID] = {
			key = key,
			icon = icon,
			val = val,
		}
	end
end
]]

local _GetRaidRosterInfo = GetRaidRosterInfo

local function GetRaidRosterInfoCompat(raidUnitID)
	local numRaidMembers = GetNumRaidMembers()

	if numRaidMembers > 0 then
		local name, rank, subgroup, level, class, classFileName = _GetRaidRosterInfo(raidUnitID)
		return name, rank, subgroup, level, class, classFileName
	elseif raidUnitID <= 5 then
		local unit
		if raidUnitID <= 4 then
			unit = "party" .. raidUnitID
		else
			unit = "player"
		end

		local name = UnitName(unit)
		local classFileName = select(2, UnitClass(unit))
		return name, nil, 1, nil, nil, classFileName
	else
		--print("|cffff0000[RC DEBUG]|r INVALID raidUnitID: "..tostring(raidUnitID))
		return nil
	end
end

local function GetRaidDiffMaxGroup()
	if GetNumRaidMembers() == 0 then
		return 1
	end

	local difficulty = GetRaidDifficulty()
	if difficulty == 1 or difficulty == 3 then
		return 2  -- 10N или 10H
	elseif difficulty == 2 or difficulty == 4 then
		return 5  -- 25N или 25H
	else
		return 8
	end
end

local function GetFood()
	local f = {[0]={}}  -- игроки без еды
	local gMax = GetRaidDiffMaxGroup()

	for j = 1, 40 do
		local name, _, subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i = 1, 40 do
				local _, _, _, _, _, _, _, _, _, spellId = UnitAura(name, i, "HELPFUL")
				if not spellId then break end

				local foodType = bReadyCheck.tableFood[spellId]
				if foodType then
					f[1] = f[1] or {}  -- есть баф
					f[1][ #f[1]+1 ] = name
					isAnyBuff = true
				end
			end
			if not isAnyBuff then
				f[0][ #f[0]+1 ] = name  -- нет еды
			end
		end
	end

	return f
end

local function GetFlask()
	local f = {[0] = {}}  -- без фласки
	local gMax = GetRaidDiffMaxGroup()
	local _time = GetTime()

	for j = 1, 40 do
		local name, _, subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i = 1, 40 do
				local _, _, _, _, _, expires, _, _, _, spellId = UnitAura(name, i, "HELPFUL")
				if not spellId then
					break
				end

				if bReadyCheck.tableFlask[spellId] then
					local lost = (expires or 0) - _time
					if expires == 0 or lost < 0 then
						lost = 901
					end

					f[1] = f[1] or {}
					f[1][#f[1]+1] = {name, lost}
					isAnyBuff = true
				end
			end

			if not isAnyBuff then
				f[0][#f[0]+1] = {name, 901}
			end
		end
	end

	for _, typeData in pairs(f) do
		table.sort(typeData, function(a, b) return a[2] < b[2] end)
	end
	
	--local showExpFlasks_seconds = VMRT.RaidCheck.FlaskExp == 1 and 300 or VMRT.RaidCheck.FlaskExp == 2 and 600 or -1
	local flaskOption = bReadyCheck.db.profile.flaskExpireOption or 0
	local showExpFlasks_seconds = flaskOption > 0 and flaskOption * 60 or -1

	
	return f
end

local function GetRaidBuffs()
	local buffsList, buffsListLen = bReadyCheck.classicBuffs, #bReadyCheck.classicBuffs

	local classicBuffsList = {}
	for k = 1, buffsListLen do
		for s in pairs(buffsList[k][4]) do
			classicBuffsList[s] = k
		end
	end

	local f = {}
	for k = 1, buffsListLen * 2 do
		f[k] = 0
	end

	local gMax = GetRaidDiffMaxGroup()
	local isAnyBuff = {}

	for j = 1, 40 do
		local name, _, subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			for k = 1, buffsListLen * 2 do
				isAnyBuff[k] = false
			end

			for i = 1, 40 do
				local _, _, _, _, _, _, _, _, _, auraSpellID = UnitAura(name, i, "HELPFUL")
				if not auraSpellID then break end

				local k = classicBuffsList[auraSpellID]
				if k then
					isAnyBuff[k] = true
					isAnyBuff[buffsListLen + k] = true
				end
			end

			for k = 1, buffsListLen do
				if not isAnyBuff[k] then
					f[k] = f[k] + 1
				end
				if not isAnyBuff[buffsListLen + k] then
					f[buffsListLen + k] = f[buffsListLen + k] + 1
				end
			end
		end
	end

	return f
end

local RCW_iconsList = {'food','flask', 'druid', 'int', 'spirit', 'stamina', 'shadow', 'bom', 'bow', 'bok', 'bos'} -- ключ

local RCW_iconsListHeaders = { --заголовок
    "Food", "Flask", "GotW", "Intellect", "Spirit", "Stamina", "Shadow", "BoM", "BoW", "BoK", "BoS" 
}

local RCW_iconsListDebugIcons = {
    "Interface\\Icons\\spell_misc_food",				-- food
    "Interface\\Icons\\INV_Potion_119",					-- flask
    "Interface\\Icons\\spell_holy_magicalsentry",		-- int
    "Interface\\Icons\\Spell_Holy_WordFortitude",		-- stam
}

--===================
function bReadyCheck:SaveFramePosition(frame)
	local left = frame:GetLeft()
	local top = frame:GetTop()
	local scale = frame:GetScale()
	local uiScale = UIParent:GetScale()

	if left and top and scale then
		local absLeft = left * scale / uiScale
		local absTop = top * scale / uiScale
		self.db.profile.framePos = { left = absLeft, top = absTop }
	end
end

function bReadyCheck:RestoreFramePosition(frame, scale)
	local pos = self.db.profile.framePos
	local uiScale = UIParent:GetScale()

	if pos and pos.left and pos.top then
		local scaledLeft = pos.left * uiScale / scale
		local scaledTop = pos.top * uiScale / scale
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", scaledLeft, scaledTop)
	else
		frame:SetPoint("CENTER")
	end
end

function bReadyCheck:ApplyScaleAndPosition(frame, newScale)
	local oldScale = frame:GetScale()
	local uiScale = UIParent:GetScale()
	local left = frame:GetLeft()
	local top = frame:GetTop()

	if left and top and oldScale then
		local absLeft = left * oldScale / uiScale
		local absTop = top * oldScale / uiScale

		frame:SetScale(newScale)
		self.db.profile.scale = newScale

		local newLeft = absLeft * uiScale / newScale
		local newTop = absTop * uiScale / newScale

		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", newLeft, newTop)

		self.db.profile.framePos = { left = absLeft, top = absTop }
	end
end

function bReadyCheck:CreateMainFrame()
    if self.buffFrame then
		return
	end

    local frame = CreateFrame("Frame", "bReadyCheckFrame", UIParent)
    self.buffFrame = frame
	
	local scale = self.db.profile.scale or 1
	frame:SetScale(scale)
    frame:SetSize(700, 400)
	
	self:RestoreFramePosition(frame, scale)
--[[
	local pos = self.db.profile.framePos
	if pos and pos.left and pos.top then
		local uiScale = UIParent:GetScale()
		local scaledLeft = pos.left * uiScale / scale
		local scaledTop = pos.top * uiScale / scale
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", scaledLeft, scaledTop)
	else
		frame:SetPoint("CENTER")
	end
]]
	frame:SetFrameStrata("DIALOG")
	frame:SetClampedToScreen(true) -- ограничение, чтобы фрейм не выходил за пределы экрана
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
--[[
	frame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)

	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()

		local left = self:GetLeft()
		local top = self:GetTop()
		local scale = self:GetScale()
		local uiScale = UIParent:GetScale()

		if left and top and scale then
			local absLeft = left * scale / uiScale
			local absTop = top * scale / uiScale
			bReadyCheck.db.profile.framePos = {
				left = absLeft,
				top = absTop,
			}
		end
	end)
	]]
	---------------------
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		bReadyCheck:SaveFramePosition(self)
	end)
	
-------------------------
	frame:SetScript("OnMouseDown", function(self,button) 
		if button == "RightButton" then
			self:Hide()
		end
	end)

	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		--tile = true, tileSize = 32, edgeSize = 1,
		edgeSize = 1.5,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	 })	
	frame:SetBackdropColor(0, 0, 0, 0.5)
	--frame:SetBackdropColor(0.05, 0.05, 0.07, 0.98)
	--frame:SetBackdropBorderColor(0, 0.0, 0.0, 0.9)
	frame:SetBackdropBorderColor(0, 0.0, 0.0, 0.45)

	local shadowSize = 20
	local shadowEdgeSize = 28

	local shadow = CreateFrame("Frame", nil, frame)
	shadow:SetPoint("LEFT", -shadowSize, 0)
	shadow:SetPoint("RIGHT", shadowSize, 0)
	shadow:SetPoint("TOP", 0, shadowSize)
	shadow:SetPoint("BOTTOM", 0, -shadowSize)
	shadow:SetBackdrop({
		edgeFile = "Interface\\AddOns\\bReadyCheck\\media\\border\\shadow",
		edgeSize = shadowEdgeSize,
		insets = {
			left = shadowSize,
			right = shadowSize,
			top = shadowSize,
			bottom = shadowSize
		}
	})
	shadow:SetBackdropBorderColor(0, 0, 0, 0.45)
	--shadow:SetBackdropBorderColor(0.58, 0.51, 0.79, 0.45)
	frame.shadow = shadow
	
	self.buffFrame.headText = self.buffFrame:CreateFontString(nil, "OVERLAY")
	self.buffFrame.headText:SetPoint("TOP", 0, -3)
	self.buffFrame.headText:SetTextColor(1,0.66,0,1)
	self.buffFrame.headText:SetFont("Interface\\AddOns\\bReadyCheck\\media\\fonts\\default.ttf", 16, "OUTLINE")
	--self.buffFrame.headText:SetText("Проверка готовности")
	self.buffFrame.headText:SetText(L["READY_CHECK"])
	
	do
		local closeButton = CreateFrame("Button", nil, frame)
		closeButton:SetSize(18, 18)
		closeButton:SetPoint("TOPRIGHT", -1, 0) -- например

		closeButton.TC = {
		  --cross = {0.0625, 0.125, 0, 0.125},
		  cross = {0.5, 0.5625, 0.5, 0.6250},
		}

		-- нормальное состояние
		closeButton.NormalTexture = closeButton:CreateTexture(nil, "ARTWORK")
		closeButton.NormalTexture:SetTexture("Interface\\AddOns\\bReadyCheck\\media\\DiesalGUIcons16x256x128")
		closeButton.NormalTexture:SetAllPoints()
		closeButton.NormalTexture:SetVertexColor(1,1,1,0.7)
		closeButton.NormalTexture:SetTexCoord(unpack(closeButton.TC.cross))
		closeButton:SetNormalTexture(closeButton.NormalTexture)

		-- при наведении
		closeButton.HighlightTexture = closeButton:CreateTexture(nil, "ARTWORK")
		closeButton.HighlightTexture:SetTexture("Interface\\AddOns\\bReadyCheck\\media\\DiesalGUIcons16x256x128")
		closeButton.HighlightTexture:SetAllPoints()
		closeButton.HighlightTexture:SetVertexColor(1, 0, 0, 1) -- слегка красный
		closeButton.HighlightTexture:SetTexCoord(unpack(closeButton.TC.cross))
		closeButton:SetHighlightTexture(closeButton.HighlightTexture)

		-- при нажатии
		closeButton.PushedTexture = closeButton:CreateTexture(nil, "ARTWORK")
		closeButton.PushedTexture:SetTexture("Interface\\AddOns\\bReadyCheck\\media\\DiesalGUIcons16x256x128")
		closeButton.PushedTexture:SetAllPoints()
		closeButton.PushedTexture:SetVertexColor(1, 0.3, 0.3, 1) -- насыщенно-красный
		closeButton.PushedTexture:SetTexCoord(unpack(closeButton.TC.cross))
		closeButton:SetPushedTexture(closeButton.PushedTexture)

		closeButton:SetScript("OnClick", function() frame:Hide() end)
	end		

	-- resize handle
	local resizeHandle = CreateFrame("Button", nil, frame)
	resizeHandle:SetSize(18, 18)
	resizeHandle:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
	resizeHandle:EnableMouse(true)
	resizeHandle:SetFrameLevel(frame:GetFrameLevel() + 10)

	resizeHandle.texture = resizeHandle:CreateTexture(nil, "OVERLAY")
	resizeHandle.texture:SetAllPoints()

	resizeHandle:SetNormalTexture("Interface\\AddOns\\bReadyCheck\\media\\resize")
	resizeHandle:GetNormalTexture():SetVertexColor(0.7, 0.7, 0.7, 0.1)

	resizeHandle:SetHighlightTexture("Interface\\AddOns\\bReadyCheck\\media\\resize")
	resizeHandle:GetHighlightTexture():SetVertexColor(0.7, 0.7, 0.7, 0.7)

	resizeHandle:SetPushedTexture("Interface\\AddOns\\bReadyCheck\\media\\resize")
	resizeHandle:GetPushedTexture():SetVertexColor(1, 1, 1, 1) 

	resizeHandle:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			self.startX = GetCursorPosition()
			self.startScale = frame:GetScale()
		end
	end)

	resizeHandle:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			self.startX = nil
		end
	end)

	resizeHandle:SetScript("OnUpdate", function(self)
		if self.startX then
			local x = GetCursorPosition()
			local delta = (x - self.startX) / 300
			local newScale = math.max(0.1, math.min(2, self.startScale + delta))
			bReadyCheck:ApplyScaleAndPosition(frame, newScale)
		end
	end)

	self:CreateFadeOutAnimation(frame)
	frame:Hide()
end

function bReadyCheck:ClearHeadTextTimer()
	if self.buffFrame and self.buffFrame.headText then
		local text = self.buffFrame.headText:GetText()
		if text then
			text = text:gsub("%s*%b()", ""):gsub("%s+$", "")
			self.buffFrame.headText:SetText(text)
		end
	end
end

function bReadyCheck:CleanupMainFrame()
	local frame = self.buffFrame
	if not frame then return end

	frame:UnregisterAllEvents()

	if frame.anim and frame.anim:IsPlaying() then
		frame.anim:Stop()
	end

	-- остановка таймера
	if self.timerTicker then
		self:CancelTimer(self.timerTicker)
		self.timerTicker = nil
	end

	if frame.timeLeftLine and frame.timeLeftLine.Stop then
		frame.timeLeftLine:Stop()
		frame.timeLeftLine:Hide()
	end

	frame._hideTimestamp = nil
	frame.isManual = nil
	frame.isManualOpen = nil
end

function bReadyCheck:CreateFadeOutAnimation()
	local frame = self.buffFrame
	if not frame then return end

	if frame.anim then return end

	frame.animFrame = CreateFrame("Frame", nil, frame)
	frame.animFrame:SetPoint("TOPLEFT")
	frame.animFrame:SetSize(1, 1)

	frame.anim = frame.animFrame:CreateAnimationGroup()
	frame.timer = frame.anim:CreateAnimation()
	frame.timer:SetDuration(2)

	-- изменение прзрачности
	frame.timer:SetScript("OnUpdate", function(self)
		local progress = self:GetProgress()
		frame:SetAlpha(1 - progress)
	end)

	-- скрыть фрейм
	frame.timer:SetScript("OnFinished", function()
		frame.anim:Stop()
		frame:Hide()
	end)

	frame:SetScript("OnHide", function()
		bReadyCheck:CleanupMainFrame()
	end)
end

function bReadyCheck:StartReadyCheckTimer(duration)

    if not self.buffFrame then
        return
    end
--[[
    -- отменяем старый таймер
    if self.timerTicker then
        self:CancelTimer(self.timerTicker)
        self.timerTicker = nil
    end
]]
    self.timerRemaining = duration

    if self.timerRemaining > 0 then
        --local h = " (" .. tostring(self.timerRemaining) .. " сек.)"
		local h = format(L["SECONDS"], tostring(self.timerRemaining))
		self.buffFrame.headText:SetText(L["READY_CHECK"] .. h)

        self.timerTicker = self:ScheduleRepeatingTimer(function()
            self.timerRemaining = self.timerRemaining - 1

            if self.buffFrame and self.buffFrame.headText and self.timerRemaining > 0 then
                --local h = " (" .. tostring(self.timerRemaining) .. " сек.)"
				local h = format(L["SECONDS"], tostring(self.timerRemaining))

                --self.buffFrame.headText:SetText("Проверка готовности" .. h)
				self.buffFrame.headText:SetText(L["READY_CHECK"] .. h)

            else
                self.buffFrame.headText:SetText(L["READY_CHECK"])
                self:CancelTimer(self.timerTicker)
                self.timerTicker = nil
            end
        end, 1)
    else
        self.buffFrame.headText:SetText(L["READY_CHECK"])
    end
end

	-- подсветка при наведении
local function BRD_LineOnUpdate(self)
	if self:IsMouseOver() and not self.hoverShow then
		self.hover:SetAlpha(0.15)
		self.hoverShow = true
	elseif not self:IsMouseOver() and self.hoverShow then
		self.hover:SetAlpha(0)
		self.hoverShow = false
	end
end

local function BRD_LineOnEnter(self)
	if self.tooltip then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		if type(self.tooltip) == "string" then
			GameTooltip:SetHyperlink(self.tooltip)
		else
			GameTooltip:SetText(tostring(self.tooltip))
		end
		GameTooltip:Show()
	end
end

local function BRD_LineOnLeave(self)
	if self.tooltip then
		GameTooltip_Hide()
	end
end
--=============
local function AddSourceNameToTooltip(tooltip, unit, index, filter)  --sourceName
	if not bReadyCheck.db.profile.showSourceName then
        return
    end
	
	local srcUnit = select(8, UnitAura(unit, index, filter))
	if not srcUnit then return end

	if srcUnit == "pet" or srcUnit == "vehicle"
		or srcUnit:match("^partypet%d+$")
		or srcUnit:match("^raidpet%d+$")
	then
		return
	end

	tooltip:AddLine(" ")
	local src = GetUnitName(srcUnit)
	tooltip:AddLine("" .. src)
	tooltip:Show()
end
--------------


--============
	--иконка
function CreateFullIcon(parent, texturePath, size)
	local icon = CreateFrame("Frame", nil, parent)
	icon:SetSize(size, size)
	icon:EnableMouse(true)

	icon.texture = icon:CreateTexture(nil, "BACKGROUND")
	icon.texture:SetAllPoints()
	icon.texture:SetTexture(texturePath or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
	icon.texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	-- tooltip
	icon:SetScript("OnEnter", function(self)
		if self.tooltip then
			local unit = self:GetParent().unit ----------------------------------------
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			if type(self.tooltip) == "string" and self.tooltip:find("^spell:") then
			--print("SetHyperlink")
				GameTooltip:SetHyperlink(self.tooltip)
			else
			--print("SetUnitAura")
				GameTooltip:SetUnitAura(self:GetParent().unit, self.tooltip, "HELPFUL")
				AddSourceNameToTooltip(GameTooltip, unit, self.tooltip, "HELPFUL")
			end
			GameTooltip:Show()
		end
	end)

	icon:SetScript("OnLeave", BRD_LineOnLeave)
	
	icon:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			local parent = self
			while parent and parent.GetParent do
				if parent:GetName() == "bReadyCheckFrame" then
					parent:Hide()
					break
				end
				parent = parent:GetParent()
			end
		end
	end)
	
	-- текст в правом нижнем углу (уровень заклинания)
	icon.text = icon:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	icon.text:SetPoint("BOTTOMRIGHT", 4, 0)
	icon.text:SetText("100")
	icon.text:SetTextColor(0, 1, 0) -- зеленый
	icon.text:SetJustifyH("RIGHT")

	-- текст в центре
	icon.bigText = icon:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	icon.bigText:SetPoint("CENTER")
	icon.bigText:SetText("") -- пока пустой
	icon.bigText:SetTextColor(1, 1, 1)
	icon.bigText:SetJustifyH("CENTER")

	-- напоминание обновить баф
	icon.subIcon = icon:CreateTexture(nil, "BORDER")
	icon.subIcon:SetPoint("CENTER", icon, "TOPRIGHT", -2, -2)
	icon.subIcon:SetSize(10, 10)
	icon.subIcon:SetTexture("Interface\\AddOns\\bReadyCheck\\media\\DiesalGUIcons16x256x128")
	icon.subIcon:SetTexCoord(0.125, 0.1875, 0.5, 0.625)
	icon.subIcon:SetVertexColor(1, 0, 0)
	icon.subIcon:Hide()

	return icon
	
end
	
local function CreateCol(line, key, i)
   local pointer = CreateFrame("Frame", nil, line)
   pointer:SetSize(30, 14)
   line[key.."pointer"] = pointer

    if i == 1 then
       pointer:SetPoint("LEFT", line, "LEFT", 155, 0)  -- начало колонок
    else
       local prevKey = RCW_iconsList[i - 1]
       pointer:SetPoint("CENTER", line[prevKey.."pointer"], "CENTER", 50, 0)  -- расстояние между колонками
    end

    local icon = CreateFullIcon(line, RCW_iconsListDebugIcons[i], 14)
    icon:SetPoint("CENTER", pointer, "CENTER", 0, 0)
    icon.tooltip = "spell:" .. (RCW_iconsListSpellIDs and RCW_iconsListSpellIDs[i] or "")
    line[key] = icon
end

local function CreateIcon(parent, texturePath, size)
	local icon = CreateFrame("Frame", nil, parent)
	icon:SetSize(size, size)
		
	icon.texture = icon:CreateTexture(nil, "BACKGROUND")
	icon.texture:SetAllPoints()
	icon.texture:SetTexture(texturePath or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
				
	return icon
end
	
function bReadyCheck:CreateLines()
	local frame = self.buffFrame
	if not self.buffFrame then 
		return 
	end

	if frame.lines and #frame.lines > 0 then
		for _, line in ipairs(frame.lines) do
			line:Show()
		end
		self:UpdateFont()
		return
	end

	frame.lines = {}

	for i = 1, 40 do
		local line = CreateFrame("Frame", nil, frame)
		frame.lines[i] = line
		line.pos = i

		if i == 1 then
			line:SetPoint("TOPLEFT", 5, -50)
		else
			line:SetPoint("TOPLEFT", frame.lines[i - 1], "BOTTOMLEFT", 0, 0)
		end
			
		line:SetSize(700, 14)
		
		--никнейм
		line.name = line:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		line.name:SetText("raid" .. i)
		line.name:SetSize(130, 12)
		line.name:SetPoint("LEFT", 20, 0)
		line.name:SetFont("Fonts\\FRIZQT__.TTF", 12)
		line.name:SetTextColor(1, 1, 1, 1)
		line.name:SetShadowOffset(1, -1)
		line.name:SetJustifyH("LEFT")

		line.icon = CreateIcon(line, "Interface\\RaidFrame\\ReadyCheck-Waiting", 14)
		line.icon:SetPoint("LEFT", 0, 0)
		
		for i, key in pairs(RCW_iconsList) do
			CreateCol(line, key, i)
		end
			
		if i%2 == 0 then
			--line.back = line:CreateTexture(nil,"BACKGROUND")
			line.back = line:CreateTexture(nil, "BACKGROUND", nil, 0)
			line.back:SetPoint("TOPLEFT",-5,0)
			line.back:SetPoint("BOTTOMRIGHT",-5,0)
			line.back:SetTexture(1,1,1,.05)
		end
			
		line.hover = line:CreateTexture(nil, "BACKGROUND")
		--line.hover:SetAllPoints()
		line.hover:SetPoint("TOPLEFT",-5,0)
		line.hover:SetPoint("BOTTOMRIGHT",-5,0)
		line.hover:SetTexture(1, 1, 1, 1)
		line.hover:SetAlpha(0)

		line:SetScript("OnEnter", BRD_LineOnEnter)
		line:SetScript("OnLeave", BRD_LineOnLeave)
		line:SetScript("OnUpdate", BRD_LineOnUpdate)

		--line.classLeft = line:CreateTexture(nil,"BACKGROUND",nil,5)
		line.classLeft = line:CreateTexture(nil,"BACKGROUND",nil,1)
		line.classLeft:SetPoint("TOPLEFT",-5,0)
		line.classLeft:SetPoint("BOTTOMLEFT",-5,0)
		
		line.classLeft:SetPoint("RIGHT",-5,0)
		line.classLeft:SetTexture(1,1,1,1)
		line.classLeft:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)
		--line.classLeft:SetGradientAlpha("VERTICAL", 1, 0, 0, 1, 0, 0, 1, 1) -- от красного к синему
	end
	self:UpdateFont()
end

	--замена шрифта
function bReadyCheck:UpdateFont()
	local frame = self.buffFrame
	if not frame or not frame.lines then
		return
	end

	local fontKey = self.db.profile.fontKey or "default"
	--local fontPath = self.db.profile.fontPath or "Fonts\\FRIZQT__.TTF"
	local fontPath = self.db.profile.fontPath or "Interface\\AddOns\\bReadyCheck\\media\\fonts\\default.ttf"
	local fontSize = self.db.profile.fontSize or 12

	for i = 1, 40 do
		local line = frame.lines[i]
		if line and line.name then
			line.name:SetFont(fontPath, fontSize)
		end

		for j, key in ipairs(RCW_iconsList) do
			local icon = line[key]
			if icon and icon.bigText then
				icon.bigText:SetFont(fontPath, fontSize - 2)
			end
		end
	end
	if frame.headText then
		--frame.headText:SetFont(fontPath, 16, "OUTLINE")
		frame.headText:SetFont(fontPath, fontSize + 4, "OUTLINE")
	end
end

	--полоса с обратным отсчетом
function bReadyCheck:CreateTimeLine()

	if self.buffFrame.timeLeftLine then
        if self.buffFrame.timeLeftLine.Stop then
            self.buffFrame.timeLeftLine:Stop(true) -- мгновенная остановка
        end
        self.buffFrame.timeLeftLine:SetScript("OnUpdate", nil)
        self.buffFrame.timeLeftLine:Hide()
        self.buffFrame.timeLeftLine = nil
    end

	local line = CreateFrame("Frame", nil, self.buffFrame)
	self.buffFrame.timeLeftLine = line

	local cR1, cG1, cB1 = 1, .2, .2     -- красный
	local cR3, cG3, cB3 = .6, .6, .2    -- желтый
	local cR2, cG2, cB2 = .2, .7, .2    -- зеленый когда все подтвердили

	local WIDTH,WIDTH2 = 700,18
	line:SetSize(WIDTH,18)
	line:SetPoint("TOPLEFT", self.buffFrame, "TOPLEFT", 0, 0)

	line.back = line:CreateTexture(nil, "BACKGROUND")
	line.back:SetSize(110, 18)
	line.back:SetPoint("LEFT")
	line.back:SetTexture(cR1,cG1,cB1)

	-- размытие
	line.back2 = line:CreateTexture(nil, "BACKGROUND")
	line.back2:SetSize(WIDTH2,18)
	line.back2:SetPoint("LEFT", line.back, "RIGHT")
	line.back2:SetTexture(1, 1, 1)	
	line.back2:SetGradientAlpha("HORIZONTAL",cR1,cG1,cB1,1,cR1,cG1,cB1,0)

	-- количество подтвердивших
	line.readyCount = line:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	line.readyCount:SetPoint("TOPLEFT", line, "TOPLEFT", 5, -34)
	line.readyCount:SetFont("Fonts\\FRIZQT__.TTF", 12)
	line.readyCount:SetText("40")
	line.readyCount:SetTextColor(1, 1, 1)
	line.readyCount:SetShadowOffset(1, -1)
	line.readyCount:Hide()

	local currR,currG,currB = 1,.2,.2

	local stop = nil
	local end_time,duration = 0,30
	line:SetScript("OnUpdate",function(self)
		if stop then
			return
		end
		local t = end_time - GetTime()
		if t < 0 then
			self:Stop()
			return
		end
		local width = t / duration * (WIDTH - WIDTH2)
		if width <= 1 then
			width = 1
		end
		line.back:SetWidth(width)
	end)

	line.Stop = function(self)
		stop = true
		if line:GetAlpha() > 0 then
			line.anim_alpha:Play()
		end
		line.back:SetTexture(cR2, cG2, cB2)
	end
		
		line.Start = function(self,timer)
		self:Stop(true)
		end_time = GetTime() + timer
		duration = timer

		line.readyCount:SetText("")
		line.back:SetTexture(cR1,cG1,cB1)
		line.back2:SetGradientAlpha("HORIZONTAL",cR1,cG1,cB1,1,cR1,cG1,cB1,0)
		line.back:SetWidth(WIDTH - WIDTH2)

		currR,currG,currB = cR1,cG1,cB1

		line.anim_alpha:Stop()
		line:SetAlpha(1)
		line.readyCount:SetAlpha(1)
		stop = nil
		self:Show()
		self.readyCount:Show()
	end
		
	line:SetScript("OnHide",function(self)
		line.readyCount:Hide()
	end)
		
	line.anim_alpha = line:CreateAnimationGroup()
	line.anim_alpha.color = line.anim_alpha:CreateAnimation()
	line.anim_alpha.color:SetDuration(1)
	line.anim_alpha.color:SetScript("OnUpdate", function(self,elapsed) 
		line:SetAlpha(1 - self:GetProgress())
		line.readyCount:SetAlpha(1 - self:GetProgress())
	end)
		
	line.anim_alpha.color:SetScript("OnFinished", function()
		line.anim_alpha:Stop() 
	end)

	local cfR,cfG,cfB = 1,1,1
	local ctR,ctG,ctB = 1,1,1

	line.anim = line:CreateAnimationGroup()
	line.anim.color = line.anim:CreateAnimation()
	line.anim.color:SetDuration(1)
	line.anim.color:SetScript("OnUpdate", function(self,elapsed) 
		local r,g,b = cfR - (cfR - ctR) * self:GetProgress(),cfG - (cfG - ctG) * self:GetProgress(),cfB - (cfB - ctB) * self:GetProgress()

		line.back:SetTexture(r,g,b)
		line.back2:SetGradientAlpha("HORIZONTAL",r,g,b,1,r,g,b,0)
		
		currR,currG,currB = r,g,b
	end)
		
	line.Color = function(self,r,g,b)
		if self.anim:IsPlaying() then
			line.anim:Stop()
		end
		cfR,cfG,cfB = currR,currG,currB
		ctR,ctG,ctB = r,g,b
		line.anim:Play()
	end

	line.SetProgress = function(self,total,totalResponced)
		local progress = totalResponced / max(total,1)
		if progress == 0 then
			self.readyCount:SetText(totalResponced.."/"..total)
			return
		end
		local fR,fG,fB
		local tR,tG,tB
		if progress >= .66 then
			fR,fG,fB = cR3,cG3,cB3
			tR,tG,tB = cR2,cG2,cB2
			progress = (progress - 0.66) / (1 - 0.66)
		else
			fR,fG,fB = cR1,cG1,cB1
			tR,tG,tB = cR3,cG3,cB3
			progress = progress * (1 / 0.66)
		end
		--self.time:SetText(progress < 1 and totalResponced.."/"..total or "")
		self.readyCount:SetText(totalResponced.."/"..total)

		local r,g,b = fR - (fR - tR) * progress,fG - (fG - tG) * progress,fB - (fB - tB) * progress
		self:Color(r,g,b)
	end
		-----------------------------

	local titleLayer = CreateFrame("Frame", nil, self.buffFrame)
	titleLayer:SetPoint("TOP", self.buffFrame, "TOP")
	titleLayer:SetSize(1, 1)

	self.buffFrame.headText:SetParent(titleLayer)
end
	--заголовки
	--[[
	function bReadyCheck:CreateIconHeaders()
		if self.buffFrame.iconHeaders then return end

		local headers = CreateFrame("Frame", nil, self.buffFrame)
		self.buffFrame.iconHeaders = headers

		headers.labels = {}

		for i, text in ipairs(RCW_iconsListHeaders) do
			local label = headers:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			label:SetText(text)
			label:SetTextColor(1, 1, 1)

			if i == 1 then
				label:SetPoint("BOTTOMLEFT", self.buffFrame, "TOPLEFT", 155, -48)
			else
				local prev = headers.labels[i - 1]
				label:SetPoint("BOTTOMLEFT", prev, "BOTTOMLEFT", 70, 0) -- фиксированный отступ между заголовками
			end

			headers.labels[i] = label
		end
	end
	]]
	------------------------------------
function bReadyCheck:CreateIconHeaders()
	if self.buffFrame.iconHeaders then
		return
	end
	
	if not self.buffFrame.lines or not self.buffFrame.lines[1] then
		return
	end

	local headers = CreateFrame("Frame", nil, self.buffFrame)
	self.buffFrame.iconHeaders = headers
	headers.labels = {}

	local firstLine = self.buffFrame.lines[1]

	for i, text in ipairs(RCW_iconsListHeaders) do
		local label = headers:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		label:SetText(text)
		label:SetTextColor(1, 1, 1)
		label:SetJustifyH("CENTER")

		local key = RCW_iconsList[i]
		local pointer = firstLine[key.."pointer"]

		if pointer then
			label:SetPoint("BOTTOM", pointer, "TOP", 0, 4)
		else
			label:SetPoint("BOTTOMLEFT", self.buffFrame, "TOPLEFT", 155 + (i-1)*50, -48)
		end

		headers.labels[i] = label
	end
end

function bReadyCheck:PrepToHide()
	if not self.buffFrame then return end
	if not self.buffFrame:IsShown() or self.buffFrame.isManualOpen then
		return
	end

	self:CreateFadeOutAnimation()
	local delay = tonumber(self.db.profile.ReadyCheckFadeDelay) or 10

	if not self.buffFrame._hideTimestamp then
		self.buffFrame._hideTimestamp = GetTime() + delay
	end

	if not self.buffFrame._prepHideOnUpdateSet then
		self.buffFrame._prepHideOnUpdateSet = true
		self.buffFrame:SetScript("OnUpdate", function(frame, elapsed)
			if frame._hideTimestamp and GetTime() >= frame._hideTimestamp then
				frame._hideTimestamp = nil

				if frame.timeLeftLine and frame.timeLeftLine.Stop then
					frame.timeLeftLine:Stop()
				end

				if frame.anim then
					frame.anim:Play()
				else
					frame:Hide()
				end
			end
		end)
	end
end

local RCW_UnitToLine = {}

local RCW_RCStatusToIcon = {
	[1] = "Interface\\RaidFrame\\ReadyCheck-Waiting",
	[2] = "Interface\\RaidFrame\\ReadyCheck-Ready",
	[3] = "Interface\\RaidFrame\\ReadyCheck-NotReady",
}

function bReadyCheck:UpdateLinesSize(large)
	if not self.buffFrame then 
		return 
	end
	local frame = self.buffFrame
	
	local size1 = large and 20 or 14
	local size2 = large and 18 or 14
	local size3 = large and 8 or 6
	local size4 = large and 10 or 8
		
		for i = 1, #frame.lines do
		local line = frame.lines[i]

			line:SetHeight(size1)

		for j = 1, 2 do
			local icon = line["icon"..j]
			if icon then
				icon:SetSize(size2, size2)
				icon.size = size2

				if icon.text then
					icon.text:SetFont(icon.text:GetFont(), size3, "OUTLINE")
				end
				if icon.bigText then
					icon.bigText:SetFont(icon.bigText:GetFont(), size4, "OUTLINE")
				end
				if icon.subIcon then
					icon.subIcon:SetSize(size4, size4)
				end
			end
		end
	end
end

function bReadyCheck:UpdateRoster(isManual)
	if not self.buffFrame then 
		return 
	end
	if not self.buffFrame.lines then
		return
	end

	local frame = self.buffFrame

	wipe(self.RCW_UnitToLine or {})
	self.RCW_UnitToLine = {}

	local gMax = GetRaidDiffMaxGroup()
	--local inGroup = GetNumRaidMembers() > 0 or GetNumPartyMembers() > 0
	local inRaid = GetNumRaidMembers() > 0

	local count = 0
	local classColorsTable = type(CUSTOM_CLASS_COLORS) == "table" and CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
	local result = {}
	
	for i = 1, 40 do
		local name, subgroup, class, unit

		if not inRaid and i <= 5 then
			unit = i == 1 and "player" or "party"..(i - 1)
			name = UnitName(unit)
			subgroup = 1
			class = select(2, UnitClass(unit))
		else
			name, _, subgroup, _, _, class = GetRaidRosterInfoCompat(i)
			unit = "raid"..i
		end

		if name and subgroup and subgroup <= gMax then
			local shortName = name:match("^[^-]+") or name
			table.insert(result, {
				name = shortName,
				unit = unit,
				class = class,
			})
		end
	end

	--сортировка по классу
	if self.db.profile.sortByClass then
		table.sort(result, function(a, b)
			if a.class == b.class then
				return a.name < b.name
			else
				return a.class < b.class
			end
		end)
	end

	for i = 1, #result do
		count = count + 1
		local line = frame.lines[i]
		if line then
			local data = result[i]

			line.name:SetText(data.name)
			line.unit = data.unit
			line.unit_name = data.name
			line.name:SetTextColor(1, 1, 1, 1)

			local classColor = classColorsTable[data.class]
			local r = (classColor and classColor.r) or 0.7
			local g = (classColor and classColor.g) or 0.7
			local b = (classColor and classColor.b) or 0.7
			
			if line.classLeft and line.classLeft.SetGradientAlpha then
				line.classLeft:SetGradientAlpha("HORIZONTAL", r, g, b, 0.4, r, g, b, 0)  -- увеличить яркость
			end

			line:Show()

			if isManual or (not UnitIsPartyLeader("player") and not UnitIsRaidOfficer("player")) then
				line.rc_status = 4
			else
				line.rc_status = 1
			end

			self.RCW_UnitToLine[data.name] = line
			self.RCW_UnitToLine[data.unit] = line
		end
	end

	for i = count + 1, #frame.lines do
		local line = frame.lines[i]
		line.unit = nil
		line:Hide()
	end

	local large = count <= 20
	self:UpdateLinesSize(large)

	local lineHeight = large and 20 or 14
	frame:SetHeight(55 + lineHeight * count)
end

function bReadyCheck:UpdateData(onlyLine)
	if not self.buffFrame then 
		return 
	end
	local frame = self.buffFrame
	
	local total, totalResponced = 0, 0
	local currTime,currTime2 = time(),GetTime()
	for i = 1, #self.buffFrame.lines do
		local line = self.buffFrame.lines[i]
		if line.unit then
			total = total + 1
			
			if line.rc_status == 2 or line.rc_status == 3 then
				totalResponced = totalResponced + 1
			end
	
			if not onlyLine or line == onlyLine then
				local buffCount = 0
				local flaskCount = 1
				
				line.icon.texture:SetTexture(RCW_RCStatusToIcon[line.rc_status] or "")

				for i,key in pairs(RCW_iconsList) do
					line[key].texture:SetTexture("")
					line[key].texture:SetAlpha(1)
					line[key].text:SetText("")
					line[key].bigText:SetText("")
					line[key].tooltip = nil
					line[key].subIcon:Hide()
					line[key]:SetPoint("CENTER", line[key.."pointer"], "CENTER", 0, 0)
				end

				for i = 1, 60 do
					local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(line.unit, i, "HELPFUL")

					if not spellId then
						break
					
					-- еда
					elseif bReadyCheck.tableFood and bReadyCheck.tableFood[spellId] then
						line.food.texture:SetTexture("Interface\\Icons\\spell_misc_food")
						line.food.text:SetText("")
						line.food.text:SetTextColor(0, 1, 0)
						line.food.tooltip = i

						if expirationTime and expirationTime - currTime2 < 600 and expirationTime ~= 0 then
							line.food.subIcon:Show()
							line.food.texture:SetAlpha(0.6)
						end

						buffCount = buffCount + 1

					-- фласка
					elseif bReadyCheck.tableFlask and bReadyCheck.tableFlask[spellId] then
						local val = bReadyCheck.tableFlask[spellId]
						local frame = line.flask

						frame.texture:SetTexture(icon)
						frame.text:SetTextColor(0, 1, 0)
						frame.text:SetText(val or "")
						frame.tooltip = i

						--if expirationTime and expirationTime - currTime2 < 600 and expirationTime ~= 0 then
						--if expirationTime and expirationTime - currTime2 < self.db.profile.flaskExpireOption and expirationTime ~= 0 then
						if expirationTime and expirationTime - currTime2 < (self.db.profile.flaskExpireOption * 60) and expirationTime ~= 0 then
							frame.subIcon:Show()
							frame.texture:SetAlpha(0.6)
						end

						frame:Show()
						buffCount = buffCount + 1

					--бафы
					elseif bReadyCheck.classicBuffsBySpellID and bReadyCheck.classicBuffsBySpellID[spellId] then
						local data = bReadyCheck.classicBuffsBySpellID[spellId]
						local key = data.key
						local val = data.val
						local icon = icon or data.icon
						--local icon = data.icon

						line[key].texture:SetTexture(icon)
						line[key].text:SetText(val or "")
						--line[key].tooltip = "spell:"..spellId
						line[key].tooltip = i 
						--line[key].auraIndex = i  
--================================================				прозрачность, иконки если время действия бафа меньше 10 минут	
						if expirationTime then
							local timeLeft = expirationTime - GetTime()
							if timeLeft < 600 then -- 600 секунд = 10 минут
								line[key].texture:SetAlpha(0.6)
								line[key].text:SetAlpha(0.6)
							else
								line[key].texture:SetAlpha(1)
								line[key].text:SetAlpha(1)
							end
						else
							-- если неизвестно, тогда полностью непрозрачно
							line[key].texture:SetAlpha(1)
							line[key].text:SetAlpha(1)
						end
						
--================================================
						buffCount = buffCount + 1
					end
				end

				if line.rc_status == 3 then
					line.name:SetTextColor(1,.5,.5)
					line.name:SetAlpha(1)
				elseif line.rc_status == 2 and (buffCount >= 6) then
					line.name:SetTextColor(1,1,1)
					line.name:SetAlpha(.3)
				elseif line.rc_status == 2 then
					line.name:SetTextColor(1,1,.5)
					line.name:SetAlpha(.9)
				else
					line.name:SetTextColor(1,1,1)
					line.name:SetAlpha(1)
				end
			end
		end
	end
	
	if total == totalResponced then
		self:PrepToHide()
	end
	
	if self.buffFrame.timeLeftLine and self.buffFrame.timeLeftLine.SetProgress then
		self.buffFrame.timeLeftLine:SetProgress(total, totalResponced)
	end	
end

function bReadyCheck:OnBuffFrameEvent(event, unit)
	if not self.buffFrame or not self.buffFrame:IsVisible() then
		self.buffFrame:UnregisterAllEvents()
		return
	end

	local line = self.RCW_UnitToLine and self.RCW_UnitToLine[unit]
	if unit and line then
		self:UpdateData(RCW_UnitToLine[unit])
	end
end

function bReadyCheck:ReadyCheckWindow(starter, manual)
    local frame = self.buffFrame
    if not frame then
        return
    end
	
	self:CleanupMainFrame()
	self:CreateTimeLine()
	self:CreateLines()
    self.RaidCheckReadyCheckTime = nil
    frame.isManual = manual
	frame.isManualOpen = manual and true or false
-- ================= Manual == false =================
	if not manual then
		if frame.timeLeftLine and frame.timeLeftLine.Stop then
			frame.timeLeftLine:Stop()
		end
		frame._hideTimestamp = nil
	end
-- ================= Manual == true =================
    if manual then
		for i = 1, #frame.lines do
			frame.lines[i].rc_status = 4
		end

		if frame.timeLeftLine and frame.timeLeftLine.Stop then
			frame.timeLeftLine:Stop()
		end
	
		frame._hideTimestamp = nil

		frame:SetScript("OnUpdate", nil)
		--frame.headText:SetText("Проверка готовности")
		frame.headText:SetText(L["READY_CHECK"])
	end
--================================================
	self:UpdateRoster()
	self:CreateIconHeaders()
	self:UpdateData()
    frame.timeLeftLine:Hide()

    frame:SetAlpha(1)
    frame:Show()

	if not manual then
		self:StartReadyCheckTimer(30) -- указать нужную длительность
	end

--================================================
--[[
    frame:RegisterEvent("UNIT_AURA")
	frame:SetScript("OnEvent", function(self, event, unit)
		if event == "UNIT_AURA" and unit then
			local line = bReadyCheck.RCW_UnitToLine and bReadyCheck.RCW_UnitToLine[unit]
			if line then
				bReadyCheck:UpdateData(line)
			end
		end
	end)
	]]
	frame:RegisterEvent("UNIT_AURA")
	frame:SetScript("OnEvent", function(_, event, unit)
		bReadyCheck:OnBuffFrameEvent(event, unit)
	end)

end

do	
	local function ScheduledReadyCheckFinish()
		bReadyCheck:OnReadyCheckFinished()
	end
	
	function bReadyCheck:OnReadyCheck(event, starter, timer)
		if self.db.profile.enabled and (not self.db.profile.onlyForRL or
		IsRaidLeader() or
		IsPartyLeader() or
		IsRaidOfficer()
		) then

			if self.timerHandle then
				self:CancelTimer(self.timerHandle)
				self.timerHandle = nil
			end

			local delay = timer or 35

			self.timerHandle = self:ScheduleTimer(function()
				self:OnReadyCheckFinished()
			end, delay)

			if not self.buffFrame then
				self:CreateMainFrame()
			end

			self:ReadyCheckWindow(starter)
			self.db.RaidCheckReadyCheckTime = GetTime() + delay

			if self.buffFrame and self.buffFrame.timeLeftLine and self.buffFrame.timeLeftLine.Start then
				self.buffFrame.timeLeftLine:Start(delay)
			end

			if (IsRaidLeader() or IsRaidOfficer() or IsPartyLeader()) then
				self:OnReadyCheckConfirm("READY_CHECK_CONFIRM", starter, true)
			end
		end
	end
end

function bReadyCheck:OnReadyCheckFinished()
	self:PrepToHide()
end

function bReadyCheck:OnReadyCheckConfirm(event, unit, response)
    if not unit or not UnitExists(unit) then
        return
    end

    local name = UnitName(unit)
    if not name then
        return
    end
	
    if self.RCW_UnitToLine and self.RCW_UnitToLine[name] then
        local line = self.RCW_UnitToLine[name]
        line.rc_status = response == true and 2 or 3

        self:UpdateData(line)
    else
        for k in pairs(self.RCW_UnitToLine or {}) do
            --print(" -", k)
        end
    end
end