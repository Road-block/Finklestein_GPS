local addonName, addon = ...
_G[addonName] = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0", "AceConsole-3.0" )
local L = LibStub("AceLocale-3.0"):GetLocale(addonName,false)
local ACD = LibStub("AceConfigDialog-3.0")
local AC = LibStub("AceConfig-3.0")
local locale = GetLocale()

local HBD = LibStub("HereBeDragons-2.0")
local addonLabel = addonName:gsub("_"," ")
local options = {
  name = addonName,
  handler = addon,
  type = 'group',
  args = {
		Scale = {
			order = 1,
			name = L["Scale"],
			desc = L["Set the size the the window."],
			type = "range",
			min = 0.50, max= 1.5, step = .05,
			isPercent = true,
			set = 'SetScale',
			get = 'GetScale',
		},
		Alpha = {
			order = 2,
			name = L["Alpha"],
			desc = L["Controls the transparency of the window."],
			type = "range",
			min = 0, max = 1, step = 0.01,
			isPercent = true,
			set = 'SetAlpha',
			get = 'GetAlpha',
		},
		ResetPosition = {
			order = 3,
			type = "execute",
			name = L["Reset Window"],
			desc = L["Reload Default Window Position."],
			cmdHidden = true,
			func = 'ResetPositions',
		},
	  divider = {
	  	order = 4,
	  	name = _G.DESCRIPTION,
	  	type = "header",
	  	width = "full",
	  },
	  Commands = {
	  	order = 5,
	  	type = "description",
	  	name = L["|cff00ffff/fgps|r to position frame. Repeat the command to hide it."],
	  	fontSize = "medium",
	  	width = "full",
	  },
	  divider2 = {
	  	order = 6,
	  	name = "",
	  	type = "header",
	  	width = "full",
	  },
	  Directions = {
	  	order = 7,
	  	type = "description",
	  	name = L.HINTS,
	  	fontSize = "large",
	 	  image = "Interface\\AddOns\\"..addonName.."\\images\\shelves.tga",
	  	imageWidth = 256,
	  	imageHeight = 256,
	  	imageCoords = {0,1,0,1},
	  	width = "full",
	  },
	},
}

local defaults = {
  profile =  {
	OffsetX = -170,
	OffsetY = -30,
	Point = "CENTER",
	RelativePoint = "CENTER",
	Scale = 1,
	Alpha = 1,
  },
}

local tomtomOpt = {
	desc = L["Storage Room"],
	title = L["Next Ingredient"],
	from = addonName,
	persistent = false,
	minimap = true,
	world = false,
	crazy = true,
	cleardistance = 10,
	arrivaldistance = 5,
}

addon.visualinfo = {
	[L["Abomination Guts"]] = 203,
	[L["Amberseed"]] = 101,
	--[L["Ancient Ectoplasm"]] = 102, -- this and Burning Ice is never used
	[L["Blight Crystal"]] = 204,
	[L["Chilled Serpent Mucus"]] = 205,
	[L["Crushed Basilisk Crystals"]] = 206,
	[L["Crystallized Hogsnot"]] = 107,
	[L["Frozen Spider Ichor"]] = 208,
	[L["Ghoul Drool"]] = 109,
	[L["Hairy Herring Head"]] = 325,
	[L["Icecrown Bottled Water"]] = 310,
	[L["Knotroot"]] = 311,
	[L["Muddy Mire Maggot"]] = 324,
	[L["Pickled Eagle Egg"]] = 312,
	[L["Prismatic Mojo"]] = 213,
	[L["Pulverized Gargoyle Teeth"]] = 314,
	[L["Putrid Pirate Perspiration"]] = 315,
	[L["Raptor Claw"]] = 216,
	[L["Seasoned Slider Cider"]] = 323,
	[L["Shrunken Dragon's Claw"]] = 117,
	[L["Speckled Guano"]] = 318,
	[L["Spiky Spider Egg"]] = 319,
	[L["Trollbane"]] = 120,
	[L["Wasp's Wings"]] = 121,
	[L["Withered Batwing"]] = 322,
}
addon.textinfo = {
	--["Item name"] = (Left and 1 or 2)*1000 + (CaseNumber or 0)*100 + ShelfNumber*10 + ItemNumber
	--So "Speckled Guano" is 2241 which means Right side, Case 2 (from left), Shelf 4 (from top), Item 1 (from left)
	[L["Abomination Guts"]] = 1434,
	[L["Amberseed"]] = 2133,
	--[L["Ancient Ectoplasm"]] = 2132, -- this and Burning Ice is never used
	[L["Blight Crystal"]] = 1232,
	[L["Chilled Serpent Mucus"]] = 1133,
	[L["Crushed Basilisk Crystals"]] = 1242,
	[L["Crystallized Hogsnot"]] = 2134,
	[L["Frozen Spider Ichor"]] = 1332,
	[L["Ghoul Drool"]] = 2344,
	[L["Hairy Herring Head"]] = 2003,
	[L["Icecrown Bottled Water"]] = 2121,
	[L["Knotroot"]] = 2141,
	[L["Muddy Mire Maggot"]] = 2001,
	[L["Pickled Eagle Egg"]] = 2122,
	[L["Prismatic Mojo"]] = 1142,
	[L["Pulverized Gargoyle Teeth"]] = 2124,
	[L["Putrid Pirate Perspiration"]] = 2123,
	[L["Raptor Claw"]] = 1123,
	[L["Seasoned Slider Cider"]] = 2002,
	[L["Shrunken Dragon's Claw"]] = 2333,
	[L["Speckled Guano"]] = 2241,
	[L["Spiky Spider Egg"]] = 2434,
	[L["Trollbane"]] = 2431,
	[L["Wasp's Wings"]] = 2131,
	[L["Withered Batwing"]] = 2143,
}
addon.debuffinfo = {
	[(GetSpellInfo(53150))] = L["Abomination Guts"],
	[(GetSpellInfo(51087))] = L["Amberseed"],
	[(GetSpellInfo(53158))] = L["Blight Crystal"],
	[(GetSpellInfo(51093))] = L["Chilled Serpent Mucus"],
	[(GetSpellInfo(51097))] = L["Crushed Basilisk Crystals"],
	[(GetSpellInfo(51095))] = L["Crystallized Hogsnot"],
	[(GetSpellInfo(51102))] = L["Frozen Spider Ichor"],
	[(GetSpellInfo(53153))] = L["Ghoul Drool"],
	[(GetSpellInfo(51072))] = L["Hairy Herring Head"],
	[(GetSpellInfo(51079))] = L["Icecrown Bottled Water"],
	[(GetSpellInfo(51018))] = L["Knotroot"],
	[(GetSpellInfo(51067))] = L["Muddy Mire Maggot"],
	[(GetSpellInfo(51055))] = L["Pickled Eagle Egg"],
	[(GetSpellInfo(51083))] = L["Prismatic Mojo"],
	[(GetSpellInfo(51064))] = L["Pulverized Gargoyle Teeth"],
	[(GetSpellInfo(51077))] = L["Putrid Pirate Perspiration"],
	[(GetSpellInfo(51085))] = L["Raptor Claw"],
	[(GetSpellInfo(51062))] = L["Seasoned Slider Cider"],
	[(GetSpellInfo(51091))] = L["Shrunken Dragon's Claw"],
	[(GetSpellInfo(51057))] = L["Speckled Guano"],
	[(GetSpellInfo(51069))] = L["Spiky Spider Egg"],
	[(GetSpellInfo(51100))] = L["Trollbane"],
	[(GetSpellInfo(51081))] = L["Wasp's Wings"],
	[(GetSpellInfo(51059))] = L["Withered Batwing"],
}
addon.iteminfo = {
	[L["Abomination Guts"]] = 39668,
	[L["Amberseed"]] = 38340,
	[L["Blight Crystal"]] = 39670,
	[L["Chilled Serpent Mucus"]] = 38346,
	[L["Crushed Basilisk Crystals"]] = 38379,
	[L["Crystallized Hogsnot"]] = 38336,
	[L["Frozen Spider Ichor"]] = 38345,
	[L["Ghoul Drool"]] = 39669,
	[L["Hairy Herring Head"]] = 38396,
	[L["Icecrown Bottled Water"]] = 38398,
	[L["Knotroot"]] = 38338,
	[L["Muddy Mire Maggot"]] = 38386,
	[L["Pickled Eagle Egg"]] = 38341,
	[L["Prismatic Mojo"]] = 38343,
	[L["Pulverized Gargoyle Teeth"]] = 38384,
	[L["Putrid Pirate Perspiration"]] = 38397,
	[L["Raptor Claw"]] = 38370,
	[L["Seasoned Slider Cider"]] = 38381,
	[L["Shrunken Dragon's Claw"]] = 38344,
	[L["Speckled Guano"]] = 38337,
	[L["Spiky Spider Egg"]] = 38393,
	[L["Trollbane"]] = 38342,
	[L["Wasp's Wings"]] = 38369,
	[L["Withered Batwing"]] = 38339,
}
addon.itemloc = {
	[L["Abomination Guts"]] = {},
	[L["Amberseed"]] = {},
	[L["Blight Crystal"]] = {},
	[L["Chilled Serpent Mucus"]] = {},
	[L["Crushed Basilisk Crystals"]] = {},
	[L["Crystallized Hogsnot"]] = {},
	[L["Frozen Spider Ichor"]] = {},
	[L["Ghoul Drool"]] = {},
	[L["Hairy Herring Head"]] = {},
	[L["Icecrown Bottled Water"]] = {},
	[L["Knotroot"]] = {},
	[L["Muddy Mire Maggot"]] = {},
	[L["Pickled Eagle Egg"]] = {},
	[L["Prismatic Mojo"]] = {},
	[L["Pulverized Gargoyle Teeth"]] = {},
	[L["Putrid Pirate Perspiration"]] = {},
	[L["Raptor Claw"]] = {},
	[L["Seasoned Slider Cider"]] = {},
	[L["Shrunken Dragon's Claw"]] = {},
	[L["Speckled Guano"]] = {},
	[L["Spiky Spider Egg"]] = {},
	[L["Trollbane"]] = {},
	[L["Wasp's Wings"]] = {},
	[L["Withered Batwing"]] = {},
}

addon.waypointInfo = {
	left  = {121, 0.35089863305695, 0.53041753322754, tomtomOpt},
	south = {121, 0.35089863305695, 0.53041753322754, tomtomOpt},
	right = {121, 0.351259093398, 0.51401701930439, tomtomOpt},
	north = {121, 0.351259093398, 0.51401701930439, tomtomOpt},
}
local ANIMATION_TIME = 1.5

local CurrentItem, itemCount = ""

function addon:SetupFrames()
	-- Main addon frame
	if addon.GPS_Frame then return addon.GPS_Frame end
	addon.GPS_Frame = CreateFrame("Frame",nil,UIParent,BackdropTemplateMixin and "BackdropTemplate")

	addon.GPS_Frame:SetWidth(154)
	addon.GPS_Frame:SetHeight(88)

	addon.GPS_Frame:SetBackdrop({
	  bgFile="Interface/DialogFrame/UI-DialogBox-Background",
	  edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
	  tile=0, tileSize=64, edgeSize=10,
	  insets={left=3, right=3, top=3, bottom=3}
	})

	addon.GPS_Frame:SetPoint("CENTER", UIParent)
	addon.GPS_Frame.Image = CreateFrame("Frame",nil,addon.GPS_Frame,BackdropTemplateMixin and "BackdropTemplate")
	addon.GPS_Frame.Image:SetParent(addon.GPS_Frame)
	addon.GPS_Frame.Image:SetWidth(64)
	addon.GPS_Frame.Image:SetHeight(64)
	addon.GPS_Frame.Image:SetPoint("TOPLEFT", addon.GPS_Frame, "TOPLEFT", 4, -4)

	addon.GPS_Frame.Caption = addon.GPS_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	addon.GPS_Frame.Caption:SetPoint("BOTTOM", addon.GPS_Frame, "BOTTOM", 0, 6)

	addon.GPS_Frame.North = addon.GPS_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	addon.GPS_Frame.North:SetText(L["North"])
	addon.GPS_Frame.North:SetPoint("CENTER", addon.GPS_Frame, "RIGHT", -44, 18)
	addon.GPS_Frame.North:Hide()

	addon.GPS_Frame.South = addon.GPS_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	addon.GPS_Frame.South:SetText(L["South"])
	addon.GPS_Frame.South:SetPoint("CENTER", addon.GPS_Frame, "RIGHT", -44, -8)
	addon.GPS_Frame.South:Hide()

	addon.GPS_Frame:SetMovable(true)
	addon.GPS_Frame:EnableMouse(true)

	addon.GPS_Frame:SetScript("OnMouseDown", function()
		addon.GPS_Frame:StartMoving()
	end)
	addon.GPS_Frame:SetScript("OnMouseUp",function()
	  addon.GPS_Frame:StopMovingOrSizing()
	  addon.db.profile.Point,_,addon.db.profile.RelativePoint,addon.db.profile.OffsetX,addon.db.profile.OffsetY = addon.GPS_Frame:GetPoint()
	end)
	addon.GPS_Frame:SetScript("OnHide", function()
		addon.GPS_Frame:StopMovingOrSizing()
	end)

	addon._pingFrame = CreateFrame("Frame",nil, UIParent)
	addon._pingFrame:SetWidth(100)
	addon._pingFrame:SetHeight(100)
	addon._pingFrame:SetScale(1.0)
	addon._pingFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
	addon._pingFrame:EnableMouse(false)
	addon._pingFrame:SetFrameStrata("HIGH")
	addon._pingFrame.model = CreateFrame("PlayerModel", nil, addon._pingFrame)
	addon._pingFrame.model:SetModel("interface/buttons/talktomequestionmark.m2")
	addon._pingFrame.model:SetAllPoints(addon._pingFrame)
	addon._pingFrame.model:SetModelAlpha(1.0)
	addon._pingFrame.model:SetModelDrawLayer("OVERLAY")
	addon._pingFrame.animation = addon._pingFrame:CreateAnimationGroup()
	addon._pingFrame.alpha = addon._pingFrame.animation:CreateAnimation("ALPHA")
	addon._pingFrame.alpha:SetDuration(ANIMATION_TIME)
	addon._pingFrame.alpha:SetFromAlpha(1)
	addon._pingFrame.alpha:SetToAlpha(0.1)
	addon._pingFrame.grow = addon._pingFrame.animation:CreateAnimation("SCALE")
	addon._pingFrame.grow:SetScale(3,3)
	addon._pingFrame.grow:SetDuration(ANIMATION_TIME*(1/3))
	addon._pingFrame.grow:SetEndDelay(0)
	addon._pingFrame.grow:SetOrder(1)
	addon._pingFrame.shrink = addon._pingFrame.animation:CreateAnimation("SCALE")
	addon._pingFrame.shrink:SetScale(-3,-3)
	addon._pingFrame.shrink:SetDuration(ANIMATION_TIME*(2/3))
	addon._pingFrame.shrink:SetOrder(2)
	addon._pingFrame:Hide()
	addon._pingFrame.alpha:SetScript("OnFinished", function()
		addon._pingFrame:Hide()
	end)
	addon._pingFrame:SetScript("OnShow", function()
		addon._pingFrame.model:SetModel("interface/buttons/talktomequestionmark.m2")
		addon._pingFrame.animation:Restart()
	end)
	return addon.GPS_Frame
end


function addon:OnInitialize()
	-- frames
	addon:SetupFrames()

	-- Load Database
	self.db = LibStub("AceDB-3.0"):New("FinklesteinGPSDB", defaults, "Default")
	
	-- Add to Ace and Bliz Options
  AC:RegisterOptionsTable(addonName, options)
  self.optionsFrame = ACD:AddToBlizOptions(addonName, addonLabel)
	
	-- Register Chat Commands
	self:RegisterChatCommand(L["finklesteingps"], "ChatCommand")
	self:RegisterChatCommand(L["finklegps"], "ChatCommand")
  self:RegisterChatCommand(L["fgps"], "ChatCommand")
	
	--Hook Events
	addon:RegisterEvent("QUEST_LOG_UPDATE")

	--Position Main Frame
	addon:SetPosition()
	
	--Show / Hide Window
	if (addon:IsOnQuest()) then
		addon.GPS_Frame:Show()
		addon:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
		addon:RegisterEvent("BAG_UPDATE_DELAYED")
		addon:RegisterEvent("UNIT_AURA")
		if not addon:IsHooked(GameTooltip, "OnShow") then
			addon:SecureHookScript(GameTooltip, "OnShow", "TooltipScraper")
		end
	else
		addon.GPS_Frame:Hide()
		addon:UnregisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
		addon:UnregisterEvent("BAG_UPDATE_DELAYED")
		addon:UnregisterEvent("UNIT_AURA")
		if addon:IsHooked(GameTooltip, "OnShow") then
			addon:Unhook(GameTooltip, "OnShow")
		end
	end
end

function addon:OnEnable()
	if TomTom then
		if TomTom.AddWaypoint then
			self.AddWaypoint = TomTom.AddWaypoint
		end
		if TomTom.RemoveWaypoint then
			self.RemoveWaypoint = TomTom.RemoveWaypoint
		end
	end
	addon._playerName = UnitName("player")
	addon._pingFrame:SetScale(self.db.profile.Scale)
	addon:InitFrame()
	addon:Print(L["|cff00ffff/fgps|r to position frame. Repeat the command to hide it."])
end

function addon:BAG_UPDATE_DELAYED(event, arg1)
	itemCount = GetItemCount(CurrentItem)
	local itemCountById = GetItemCount(addon.iteminfo[CurrentItem])
	if itemCountById > itemCount then itemCount = itemCountById end

	if (itemCount > 0) then
		addon:InitFrame(L["Item Acquired"])
		addon.GPS_Frame.North:Hide()
		addon.GPS_Frame.South:Hide()
	end
end

function addon:QUEST_LOG_UPDATE(event, ...)
	if (addon:IsOnQuest()) then
		addon.GPS_Frame:Show()
		addon:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
		addon:RegisterEvent("BAG_UPDATE_DELAYED")
		addon:RegisterEvent("UNIT_AURA")
		if not addon:IsHooked(GameTooltip, "OnShow") then
			addon:SecureHookScript(GameTooltip, "OnShow", "TooltipScraper")
		end
	else
		addon.GPS_Frame:Hide()
		addon:UnregisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
		addon:UnregisterEvent("BAG_UPDATE_DELAYED")
		addon:UnregisterEvent("UNIT_AURA")
		if addon:IsHooked(GameTooltip, "OnShow") then
			addon:Unhook(GameTooltip, "OnShow")
		end
	end
end

function addon:InitFrame(caption)
	addon.GPS_Frame.Image:SetBackdrop({
	  bgFile="Interface\\Addons\\"..addonName.."\\images\\finklestein",
	  edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
	  tile=0, tileSize=32, edgeSize=10,
	  insets={left=3, right=3, top=3, bottom=3}
	})
	if caption then
		addon.GPS_Frame.Caption:SetText(caption)
	else
		addon.GPS_Frame.Caption:SetText(addonLabel)
	end
end

function addon:ExpirationTimer()
	local name,icon,number,dispel,duration,expiration,source = AuraUtil.FindAuraByName(addon._expiring,"player","HARMFUL")
	if name then
		local now = GetTime()
		if expiration and expiration > now then
			addon.GPS_Frame.Caption:SetFormattedText("%s(%02ds)",addon._activeitem,(expiration-now))
		else
			addon.GPS_Frame.Caption:SetText(addonLabel)
			addon:CancelTimer(addon._timer)
		end
	else
		addon.GPS_Frame.Caption:SetText(addonLabel)
		addon:CancelTimer(addon._timer)
	end
end

function addon:Alert()
	local now = GetTime()
	if not addon._lastAlert or now - addon._lastAlert > ANIMATION_TIME then
		local scale = addon._pingFrame:GetEffectiveScale()
		local x, y = GetCursorPosition()
		x, y = x/scale, y/scale
		addon._pingFrame:ClearAllPoints()
		addon._pingFrame:SetPoint("BOTTOM",nil,"BOTTOMLEFT",x,y+20)
		addon._pingFrame:Show()
		PlaySoundFile(567574)
		addon._lastAlert = now
	end
end

function addon:TooltipScraper()
	if not CurrentItem or CurrentItem == "" then
		return
	end
	if GameTooltipTextLeft1 and GameTooltipTextLeft1.GetText then
		local name = GameTooltipTextLeft1:GetText()
		if name:match(CurrentItem) then
			addon:Alert()
		end
	end
end

function addon:UNIT_AURA(event, ...)
	local unit = ...
	if unit ~= "player" then return end
	for debuff, desc in pairs(addon.debuffinfo) do
		local name,icon,number,dispel,duration,expiration,source = AuraUtil.FindAuraByName(debuff,"player","HARMFUL")
		if name and name == debuff then
			addon._expiring = debuff
			addon._activeitem = desc
			CurrentItem = desc
			if locale ~= "enUS" then
				addon:CHAT_MSG_RAID_BOSS_WHISPER(_,desc,source,_,_,addon._playerName) -- lets 'fake' this for non english
			end
			if not addon._timer or addon:TimeLeft(addon._timer) <= 0 then
				addon._timer = addon:ScheduleRepeatingTimer("ExpirationTimer",1)
			end
		end
	end
end

function addon:CHAT_MSG_RAID_BOSS_WHISPER(event, msg, sourceName, _, _, targetName)
	if not (targetName == self._playerName) then return end -- not talking to us
	local item = msg:gsub("[%s]*![%s]*", "")-- gsub("!", "")
	local where_icon = addon.visualinfo[item]
	local where_info = addon.textinfo[item]
	if where_icon and where_info then
		local side_v = floor(where_icon / 100)
		local side_t = floor(where_info / 1000)
		local case = floor(where_info % 1000 / 100)
		local row = floor(where_info % 100 / 10)
		local num = where_info % 10
		local imagenumber = where_icon - (side_v*100)
		-- visual hint
		addon.GPS_Frame.North:Hide()
		addon.GPS_Frame.South:Hide()
		if (side_v == 1 or side_v == 3) then
			addon.GPS_Frame.North:Show()
		end
		if (side_v == 2) then
			addon.GPS_Frame.South:Show()
		end

		CurrentItem = item
		addon._activeitem = CurrentItem

		local image = "Interface\\Addons\\"..addonName.."\\images\\" .. imagenumber
		addon.GPS_Frame.Caption:SetText(CurrentItem)

		addon.GPS_Frame.Image:SetBackdrop({
		  bgFile=image,
		  edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
		  tile=0, tileSize=64, edgeSize=10,
		  insets={left=3, right=3, top=3, bottom=3}
		})
		-- directions
		if case > 0 then
			RaidNotice_AddMessage(RaidBossEmoteFrame, L["%s: %s side, Case %d, Row %d, Item %d"]:format(item, side_t == 1 and L["Left"] or L["Right"], case, row, num), ChatTypeInfo["RAID_WARNING"], 15)
			addon:Print(L["%s: %s side, Case %d, Row %d, Item %d"]:format(item, side_t == 1 and L["Left"] or L["Right"], case, row, num))
		else
			RaidNotice_AddMessage(RaidBossEmoteFrame, L["%s: %s side, %s on the Floor"]:format(item, side_t == 1 and L["Left"] or L["Right"], num == 1 and L["Sacks"] or num == 2 and L["Barrels"] or L["Crates"]), ChatTypeInfo["RAID_WARNING"], 15)
			addon:Print(L["%s: %s side, %s on the Floor"]:format(item, side_t == 1 and L["Left"] or L["Right"], num == 1 and L["Sacks"] or num == 2 and L["Barrels"] or L["Crates"]))
		end
		if self.AddWaypoint then
			local waypoint = side_t == 1 and addon.waypointInfo.left or addon.waypointInfo.right
			addon._waypoint = self.AddWaypoint(TomTom, unpack(waypoint))
		end
						
	end
	
	if (msg == L["No! The serum is ruined!"] or msg == L["Blast! You have failed me!"] or msg == L["You're too late. I must start again from the beginning...."]) then
			addon.GPS_Frame.Caption:SetText(L["Failed to acquire item"])
			if addon._waypoint and self.RemoveWaypoint then
				self.RemoveWaypoint(TomTom,addon._waypoint)
			end
			C_Timer.After(5,function()
				addon:InitFrame()
			end)
	end
end

function addon:IsOnQuest()
	return C_QuestLog.IsOnQuest(12541)
end

function addon:ChatCommand(input)
	local cmd = input:trim()
	if cmd ~="" then
	  if ACD.OpenFrames[addonName] then
	    ACD:Close(addonName)
	  else
	    ACD:Open(addonName)
	  end
  else
  	if addon.GPS_Frame then
  		if addon.GPS_Frame:IsVisible() then
  			addon.GPS_Frame:Hide()
  		else
  			addon.GPS_Frame:Show()
  		end
  	else
  		addon:SetupFrames():Show()
  	end
	end
end

function addon:ResetPositions()
	addon.db.profile.Point = "CENTER"
	addon.db.profile.RelativePoint = "CENTER"
	addon.db.profile.OffsetX = -170
	addon.db.profile.OffsetY = -30
	addon.db.profile.Scale = 1
	addon.db.profile.Alpha = 1
	addon:SetPosition()
	addon:SetupFrames():Show()
	
end

function addon:SetPosition()
	addon.GPS_Frame:ClearAllPoints()
	addon.GPS_Frame:SetPoint(self.db.profile.Point, "UIParent",self.db.profile.RelativePoint,self.db.profile.OffsetX,self.db.profile.OffsetY)
	addon.GPS_Frame:SetScale(self.db.profile.Scale)
	addon.GPS_Frame:SetAlpha(self.db.profile.Alpha)
end

function addon:SetScale(info,value)
	self.db.profile.Scale = value
	addon:SetPosition()
end

function addon:GetScale()
	return self.db.profile.Scale 
end

function addon:SetAlpha(info,value)
	self.db.profile.Alpha = value
	addon.GPS_Frame:SetAlpha(value)
end

function addon:GetAlpha()
	return self.db.profile.Alpha 
end

