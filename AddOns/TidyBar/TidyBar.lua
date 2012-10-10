-- config
local TidyBarScale = 1
local HideMainButtonArt = false
local HideExperienceBar = false

-- Localization
local locale = (GetLocale() == "zhCN" or GetLocale() == "zhTW") and GetLocale() or "default"

local L = {
	["zhCN"] = {
		"角色信息",
		"法术书和技能",
		"专精与天赋",
		"成就",
		"任务日志",
		"社交",
		"公会",
		"PvP",
		"地下城查找器",
		"坐骑与宠物",
		"客服支持",
		"日历",
		"地下城手册",
	},
	["zhTW"] = {
		"角色信息",
		"法術書和技能",
		"專精與天賦",
		"成就",
		"任務日誌",
		"社交",
		"公會",
		"PvP",
		"地城查找器",
		"坐騎與寵物",
		"客服支持",
		"日曆",
		"地城導覽",
	},
	["default"] = {
		"Character",
		"Spell book",
		"Talents",
		"Achievement",
		"Quest log",
		"Friends",
		"Guild",
		"PvP",
		"LFD",
		"Mount & Pet",
		"Help",
		"Calendar",
		"Dungeon Journal",
	},
}

local MenuButtonFrames = {
	"HelpMicroButton",
	"MainMenuMicroButton",
	"EJMicroButton",
	"CompanionsMicroButton",		-- Added for 5.x
	"LFDMicroButton",
	"PVPMicroButton",
	"GuildMicroButton",
	"QuestLogMicroButton",
	"AchievementMicroButton",
	"TalentMicroButton",
	"SpellbookMicroButton",
	"CharacterMicroButton",
}

-- Creating right click menu
local menuFrame = CreateFrame("Frame", "m_MinimapRightClickMenu", UIParent, "XUIDropDownMenuTemplate")
local menuList = {
    {text = L[locale][1],
	notCheckable = true,
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = L[locale][2],
	notCheckable = true,
    func = function() ToggleFrame(SpellBookFrame) end},
    {text = L[locale][3],
	notCheckable = true,
    func = function() if not PlayerTalentFrame then LoadAddOn("Blizzard_TalentUI") end ToggleFrame(PlayerTalentFrame) end},
    {text = L[locale][4],
	notCheckable = true,
    func = function() ToggleAchievementFrame() end},
    {text = L[locale][5],
	notCheckable = true,
    func = function() ToggleFrame(QuestLogFrame) end},
    {text = L[locale][6],
	notCheckable = true,
    func = function() ToggleFriendsFrame(1) end},
    {text = L[locale][7],
	notCheckable = true,
    func = function() ToggleGuildFrame() end},
    {text = L[locale][8],
	notCheckable = true,
    func = function() ToggleFrame(PVPFrame) end},
    {text = L[locale][9],
	notCheckable = true,
    func = function() PVEFrame_ToggleFrame('GroupFinderFrame', LFDParentFrame) end},
    {text = L[locale][10],
	notCheckable = true,
    func = function() TogglePetJournal() end},
    {text = L[locale][11],
	notCheckable = true,
    func = function() ToggleHelpFrame() end},
    {text = L[locale][12],
	notCheckable = true,
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
    {text = L[locale][13],
	notCheckable = true,
	func = function() ToggleEncounterJournal() end},
}

-- Click func
Minimap:SetScript("OnMouseUp", function(_, btn)
    if (btn=="RightButton") then
        XEasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 1)
	else
		local x, y = GetCursorPosition()
		x = x / Minimap:GetEffectiveScale()
		y = y / Minimap:GetEffectiveScale()
		local cx, cy = Minimap:GetCenter()
		x = x - cx
		y = y - cy
		if ( sqrt(x * x + y * y) < (Minimap:GetWidth() / 2) ) then
			Minimap:PingLocation(x, y)
		end
		Minimap_SetPing(x, y, 1)
	end
end) 

local Empty_Art = "Interface\\Addons\\TidyBar\\Empty"

local TidyBar = CreateFrame("Frame", "TidyBar", WorldFrame)

-- Event Delay
local DelayedEventWatcher = CreateFrame("Frame")
local DelayedEvents = {}

local function CheckDelayedEvent(self)
	local pendingEvents, currentTime = 0, GetTime()
	for functionToCall, timeToCall in pairs(DelayedEvents) do
		if currentTime > timeToCall then
			DelayedEvents[functionToCall] = nil
			functionToCall()
		end
	end
	-- Check afterward to prevent missing a recall
	for functionToCall, timeToCall in pairs(DelayedEvents) do pendingEvents = pendingEvents + 1 end
	if pendingEvents == 0 then DelayedEventWatcher:SetScript("OnUpdate", nil) end
end

local function DelayEvent(functionToCall, timeToCall)
	DelayedEvents[functionToCall] = timeToCall
	DelayedEventWatcher:SetScript("OnUpdate", CheckDelayedEvent)
end

local function ForceTransparent(frame) 
	frame:Hide()
	frame:SetAlpha(0)
end

local function RefreshMainActionBars()
	local anchor
	local anchorOffset = 4
	local repOffset = 0
	local initialOffset = 32
	
	-- Hides Rep Bars
	if HideExperienceBar == true then
		MainMenuExpBar:Hide()
		ReputationWatchBar:Hide()
	end
	
	if MainMenuExpBar:IsShown() then repOffset = 9 end
	if ReputationWatchBar:IsShown() then repOffset = repOffset + 9 end
		
	if MultiBarBottomLeft:IsShown() then
		anchor = MultiBarBottomLeft
		anchorOffset = 4
	else
		anchor = ActionButton1;
		anchorOffset = 8 + repOffset
	end
	
	if MultiBarBottomRight:IsShown() then
		--print("MultiBarBottomRight")
		MultiBarBottomRight:ClearAllPoints()
		MultiBarBottomRight:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, anchorOffset )
		anchor = MultiBarBottomRight
		anchorOffset = 4
	end
	
	-- PetActionBarFrame, PetActionButton1
	if PetActionBarFrame:IsShown() then
		--print("PetActionBarFrame")
		PetActionButton1:ClearAllPoints()
		PetActionButton1:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT",  initialOffset, anchorOffset)
		anchor = PetActionButton1
		anchorOffset = 4
		for i = 1, 10 do
			local cd = _G["PetActionButton"..i.."Cooldown"]
			cd:ClearAllPoints()
			cd:SetPoint("TOPLEFT", 1, -1)
			cd:SetPoint("BOTTOMRIGHT", -1, 1)
		end
	end
	
	-- StanceBarFrame
	if StanceBarFrame:IsShown() then
		--print("StanceBarFrame")
		StanceButton1:ClearAllPoints();
		StanceButton1:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, anchorOffset);
		anchor = StanceButton1
		anchorOffset = 4
	end

	-- PossessBarFrame, PossessButton1
	PossessBarFrame:ClearAllPoints();
	PossessBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, anchorOffset);		
end

local function RefreshPositions()
	if InCombatLockdown() then return end 
	-- Change the size of the central button and status bars
    MainMenuBar:SetWidth(512);
	MainMenuExpBar:SetWidth(512);
    ReputationWatchBar:SetWidth(512);
    MainMenuBarMaxLevelBar:SetWidth(512);
    ReputationWatchStatusBar:SetWidth(512);
	
	-- Hide backgrounds
	ForceTransparent(SlidingActionBarTexture0)
	ForceTransparent(SlidingActionBarTexture1)
	-- Shapeshift, Aura, and Stance
    ForceTransparent(StanceBarLeft)
    ForceTransparent(StanceBarMiddle)
    ForceTransparent(StanceBarRight)
	
    ForceTransparent(PossessBackground1)
    ForceTransparent(PossessBackground2)

    RefreshMainActionBars()
	
	for i, name in pairs(MenuButtonFrames) do
		_G[name]:Hide()
		_G[name.."_Update"] = function() end
	end
end

	
-- Event Handlers
local events = {}

function events:UNIT_EXITED_VEHICLE() RefreshPositions() end	-- Echos the event to verify positions
events.PLAYER_ENTERING_WORLD = RefreshPositions
events.UPDATE_INSTANCE_INFO = RefreshPositions	
events.PLAYER_TALENT_UPDATE = RefreshPositions
events.PLAYER_LEVEL_UP = RefreshPositions
events.ACTIVE_TALENT_GROUP_CHANGED = RefreshPositions
events.SPELL_UPDATE_USEABLE = RefreshPositions
events.PET_BAR_UPDATE = RefreshPositions
events.UNIT_ENTERED_VEHICLE = RefreshPositions
events.UPDATE_BONUS_ACTIONBAR = RefreshPositions
events.UPDATE_MULTI_CAST_ACTIONBAR = RefreshPositions
events.CLOSE_WORLD_MAP = RefreshPositions
events.PLAYER_LEVEL_UP = RefreshPositions

local function EventHandler(frame, event) 
	if events[event] then 
		--print(GetTime(), event)
		events[event]() 
	end 
end

-- Set Event Monitoring
for eventname in pairs(events) do 
	TidyBar:RegisterEvent(eventname)
end

-----------------------------------------------------------------------------
-- Menu Menu and Artwork
do
	-- Call Update Function when the default UI makes changes
	hooksecurefunc("UIParent_ManageFramePositions", RefreshPositions);
	-- Required in order to move the frames around
	UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomRight"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["PetActionBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["ShapeshiftBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["MultiCastActionBarFrame"] = nil
	
	-- Scaling
	MainMenuBar:SetScale(TidyBarScale)
	MultiBarRight:SetScale(TidyBarScale)
	MultiBarLeft:SetScale(TidyBarScale)

	-- Adjust the fill and endcap artwork
	MainMenuBarTexture0:SetPoint("LEFT", MainMenuBar, "LEFT", 0, 0);
    MainMenuBarTexture1:SetPoint("RIGHT", MainMenuBar, "RIGHT", 0, 0);
 	MainMenuBarLeftEndCap:SetPoint("RIGHT", MainMenuBar, "LEFT", 32, 0);
    MainMenuBarRightEndCap:SetPoint("LEFT", MainMenuBar, "RIGHT", -32, 0); 
	
	-- Hide 'ring' around the stance/shapeshift button
	for i = 1, 10 do
		_G["StanceButton"..i.."NormalTexture2"]:SetTexture(Empty_Art)
	end
	
	-- Hide Unwanted Art
	MainMenuBarPageNumber:Hide();
    ActionBarUpButton:Hide();
    ActionBarDownButton:Hide();
	-- Experience Bar
	MainMenuBarTexture2:SetTexture(Empty_Art)
	MainMenuBarTexture3:SetTexture(Empty_Art)
	MainMenuBarTexture2:SetAlpha(0)
	MainMenuBarTexture3:SetAlpha(0)
	for i=1,19 do _G["MainMenuXPBarDiv"..i]:SetTexture(Empty_Art) end
	
	-- Max-level Rep Bar
	MainMenuMaxLevelBar0:SetAlpha(0)
	MainMenuMaxLevelBar1:SetAlpha(0)
	MainMenuMaxLevelBar2:SetAlpha(0)
	MainMenuMaxLevelBar3:SetAlpha(0)
	-- Rep Bar Bubbles (For the Rep Bar)
	ReputationWatchBarTexture0:SetAlpha(0)
	ReputationWatchBarTexture1:SetAlpha(0)
	ReputationWatchBarTexture2:SetAlpha(0)
	ReputationWatchBarTexture3:SetAlpha(0)
	-- Rep Bar Bubbles (for the XP bar)
	ReputationXPBarTexture0:SetAlpha(0)
	ReputationXPBarTexture1:SetAlpha(0)
	ReputationXPBarTexture2:SetAlpha(0)
	ReputationXPBarTexture3:SetAlpha(0)
	
	if HideMainButtonArt == true then
		-- Hide Standard Background Art
		MainMenuBarTexture0:Hide()
		MainMenuBarTexture1:Hide()
		MainMenuBarLeftEndCap:Hide()
		MainMenuBarRightEndCap:Hide()
	end
	
	MainMenuBar:HookScript("OnShow", function() 
		--print("Showing")
		RefreshPositions() 
	end)
end

-- Start Tidy Bar
TidyBar:SetScript("OnEvent", EventHandler);
TidyBar:SetFrameStrata("TOOLTIP")
TidyBar:Show()

SLASH_TIDYBAR1 = '/tidybar'
SlashCmdList['TIDYBAR'] = RefreshPositions;

local function GetMouseoverFrame() 
	local frame = EnumerateFrames(); -- Get the first frame
	while frame do
	  if ( frame:IsVisible() and MouseIsOver(frame) ) then
		print(frame:GetName() or string.format("[Unnamed Frame: %s]", tostring(frame)), frame.this);
	  end
	  if frame and frame.GetObjectType then frame = EnumerateFrames(frame); -- Get the next frame
	  else frame = nil end
	end
end;

SLASH_GETMOUSEOVERFRAME1 = '/getmouseoverframe'
SlashCmdList['GETMOUSEOVERFRAME'] = GetMouseoverFrame