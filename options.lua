local addonName, addonTable = ...
local bReadyCheck = addonTable.bReadyCheck


function bReadyCheck:ADDON_LOADED(addonName)
	if not self.LSM then
		local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
		if LSM then
			self.LSM = LSM
		end
	end
end

function bReadyCheck:RegisterOptions()
	local AceConfig = LibStub("AceConfig-3.0")
	local AceConfigDialog = LibStub("AceConfigDialog-3.0")
	local L = LibStub("AceLocale-3.0"):GetLocale("bReadyCheck")


	local function NormalizeKey(str)
		if not str then
			return ""
		end
	
		return str:gsub("%s+", ""):lower()
	end

	local predefinedFonts = {
		["FRIZQT"] = "Friz Quadrata",
		["ARIALN"] = "Arial Narrow",
		["MORPHEUS"] = "Morpheus",
		["SKURRI"] = "Skurri",
		["UbuntuMedium"] = "Ubuntu Medium",
		["TelluralAlt"] = "Tellural Alt",
		["TaurusNormal"] = "Taurus Normal",
		["FiraSansMedium"] = "Fira Sans Medium",
		["ariblk"] = "Arial Black",
		["alphapixels"] = "AlphaPixels",
		["default"] = "Default",
	}

	local function GenerateFontOptions()
		local fonts = {}
		local addedKeys = {}

		if bReadyCheck.LSM then
			for _, name in ipairs(bReadyCheck.LSM:List("font")) do
				local norm = NormalizeKey(name)
				fonts[name] = name
				addedKeys[norm] = true
			end
		end

		for key, displayName in pairs(predefinedFonts) do
			local norm = NormalizeKey(displayName)
			if not addedKeys[norm] then
				fonts[key] = displayName
				addedKeys[norm] = true
			end
		end

		return fonts
	end

	local fontSourcesCache = nil

	local function getFontPath(key)
		if key == "FRIZQT" then return "Fonts\\FRIZQT__.TTF"
		elseif key == "ARIALN" then return "Fonts\\ARIALN.TTF"
		elseif key == "MORPHEUS" then return "Fonts\\MORPHEUS.TTF"
		elseif key == "SKURRI" then return "Fonts\\SKURRI.TTF"
		elseif key == "UbuntuMedium" then return "Interface\\AddOns\\bReadyCheck\\media\\fonts\\UbuntuMedium.ttf"
		elseif key == "TelluralAlt" then return "Interface\\AddOns\\bReadyCheck\\media\\fonts\\TelluralAlt.ttf"
		elseif key == "TaurusNormal" then return "Interface\\AddOns\\bReadyCheck\\media\\fonts\\TaurusNormal.ttf"
		elseif key == "FiraSansMedium" then return "Interface\\AddOns\\bReadyCheck\\media\\fonts\\FiraSansMedium.ttf"
		elseif key == "ariblk" then return "Interface\\AddOns\\bReadyCheck\\media\\fonts\\ariblk.ttf"
		elseif key == "alphapixels" then return "Interface\\AddOns\\bReadyCheck\\media\\fonts\\alphapixels.ttf"
		elseif key == "default" then return "Interface\\AddOns\\bReadyCheck\\media\\fonts\\skurri.ttf"
	end

		if bReadyCheck.LSM then
			local success, fontPath = pcall(bReadyCheck.LSM.Fetch, bReadyCheck.LSM, "font", key)
			if success and fontPath then
				return fontPath
			end
		end

		return "Interface\\AddOns\\bReadyCheck\\media\\skurri.ttf"
	end

	local function GetEnabledText()
		local enabled = bReadyCheck.db.profile.enabled
		local color = enabled and "|cff00ff00" or "|cffff0000"
		return color .. L["Enable"] .. "|r"
		--return color .. "Включить" .. "|r"
	end
	
	local options = {
		type = "group",
		name = "bReadyCheck",
		args = {
			header = {
				type = "header",
				--name = "General Settings",
				name = L["General Settings"],
				order = 0,
			},

			enabled = {
				type = "toggle",
				name = GetEnabledText,
				--desc = "Включить/выключить функциональность аддона",
				desc = L["EnableDesc"],
				get = function()
					return bReadyCheck.db.profile.enabled
				end,
				set = function(_, val)
					bReadyCheck.db.profile.enabled = val

					if val then
						bReadyCheck:RegisterEvent("READY_CHECK", "OnReadyCheck")
						bReadyCheck:RegisterEvent("READY_CHECK_FINISHED", "OnReadyCheckFinished")
						bReadyCheck:RegisterEvent("READY_CHECK_CONFIRM", "OnReadyCheckConfirm")
					else

						bReadyCheck:UnregisterEvent("READY_CHECK")
						bReadyCheck:UnregisterEvent("READY_CHECK_FINISHED")
						bReadyCheck:UnregisterEvent("READY_CHECK_CONFIRM")

						if bReadyCheck.buffFrame then
							bReadyCheck.buffFrame:Hide()
						end
					end

					LibStub("AceConfigRegistry-3.0"):NotifyChange("bReadyCheck")
				end,
				order = 1,
				width = "full",
			},

			onlyForRL = {
				type = "toggle",
				--name = "Только для рейд-лидера",
				name = L["OnlyRL"],
				desc = L["OnlyRLDesc"],
				--desc = "Показывать информацию только рейд-лидеру иили ассистентам."
				get = function()
					return bReadyCheck.db.profile.onlyForRL
				end,
				set = function(_, val)
					bReadyCheck.db.profile.onlyForRL = val
				end,
				order = 2,
				width = "full",
			},
			
			sortByClass = {
				type = "toggle",
				--name = "Сортировка по классам",
				name = L["SortByClass"],
				desc = L["SortByClassDesc"],
				--desc = "При включении игроки будут отображаться отсортированными по классам",
				get = function()
					return bReadyCheck.db.profile.sortByClass
				end,
				set = function(_, val)
					bReadyCheck.db.profile.sortByClass = val
					--bReadyCheck:UpdateRoster(true)
				end,
				order = 3,
				width = "full",
			},			

			scale = {
				type = "range",
				name = L["FrameScale"],
				min = 0.1,
				max = 2,
				step = 0.05,
				get = function()
					return bReadyCheck.db.profile.scale
				end,
				set = function(_, val)
					bReadyCheck.db.profile.scale = val
					
					if bReadyCheck.buffFrame then
						local frame = bReadyCheck.buffFrame

						local oldScale = frame:GetScale()
						local left = frame:GetLeft()
						local top = frame:GetTop()
						if not (left and top and oldScale) then return end

						local uiScale = UIParent:GetScale()
						local absLeft = left * oldScale / uiScale
						local absTop = top * oldScale / uiScale

						frame:SetScale(val)

						local newLeft = absLeft * uiScale / val
						local newTop = absTop * uiScale / val

						frame:ClearAllPoints()
						frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", newLeft, newTop)
					end
				end,
				width = "full",
				order = 4,
			},
			
			flaskExpireOption = {
				type = "select",
				--name = "Показывать истекающие фласки",
				name = L["MinFlaskExp"],
				desc = L["MinFlaskExpDesc"],
				--desc = "Выберите, за сколько минут до окончания фласок показывать предупреждение",
				values = {
					[0] = L["MinFlaskExpNo"],
					[5] = "5 " .. L["MinFlaskExpMin"],
					[10] = "10 " .. L["MinFlaskExpMin"],
				},
				sorting = { 0, 5, 10 },
				get = function()
					return bReadyCheck.db.profile.flaskExpireOption or 0
				end,
				set = function(_, val)
					bReadyCheck.db.profile.flaskExpireOption = val
				end,
				style = "radio",
				width = "full",
				order = 5,
			},
			
			disappearDelay = {
				type = "range",
				--name = "Время в секундах, через которое окно исчезает после окончания проверки",
				name = L["TimerTooltip"],
				min = 0,
				max = 180,
				step = 1,
				bigStep = 5,
				get = function()
					return bReadyCheck.db.profile.ReadyCheckFadeDelay or 10
				end,
				set = function(_, val)
					bReadyCheck.db.profile.ReadyCheckFadeDelay = val
				end,
				width = "full",
				order = 6,
			},

			fontSelect = {
				type = "select",
				--name = "Выбор шрифта",
				name = L["Fonts"],
				desc = L["FontsDesc"],
				--desc = "Выберите шрифт для отображения текста",
				values = function()
					return GenerateFontOptions()
				end,
				get = function()
					return bReadyCheck.db.profile.fontKey or "default"
				end,
				set = function(_, val)
					bReadyCheck.db.profile.fontKey = val
					bReadyCheck.db.profile.fontPath = getFontPath(val)
					bReadyCheck:UpdateFont()
				end,
				width = "full",
				order = 7,
			},
        },
    }

    AceConfig:RegisterOptionsTable("bReadyCheck", options)
    AceConfigDialog:AddToBlizOptions("bReadyCheck", "bReadyCheck")
end





    

