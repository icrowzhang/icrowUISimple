﻿local M = icrowMedia

local config = {
	enable = 1,
	spacing = 6,
	bpr = 10,
	bapr = 15,
	size = 30,
	scale = 1,
}

if (config.enable ~= 1) then return end

local togglemain, togglebank = 0,0
local togglebag

local bags = {
	bag = {
		CharacterBag0Slot,
		CharacterBag1Slot,
		CharacterBag2Slot,
		CharacterBag3Slot
	},
	bank = {
		BankFrameBag1,
		BankFrameBag2,
		BankFrameBag3,
		BankFrameBag4,
		BankFrameBag5,
		BankFrameBag6,
		BankFrameBag7
	}
}

function SetUp(framen, ...)
	local frame = CreateFrame("Frame", "bBag_"..framen, UIParent)
	frame:SetScale(config.scale)
	if framen == "bag" then 
		frame:SetWidth(((config.size+config.spacing)*config.bpr)+20-config.spacing)
	else
		frame:SetWidth(((config.size+config.spacing)*config.bapr)+20-config.spacing)
	end
	frame:SetPoint(...)
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(1)
	frame:RegisterForDrag("LeftButton","RightButton")
	frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	frame:Hide()
	M.CreateBG(frame)
	M.CreateSD(frame)
	frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:SetUserPlaced(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton","RightButton")
	
	local frame_bags = CreateFrame('Frame', "bBag_"..framen.."_bags")
	frame_bags:SetParent("bBag_"..framen)
	frame_bags:SetWidth(10)
	frame_bags:SetHeight(10)
	frame_bags:SetPoint("BOTTOMRIGHT", "bBag_"..framen, "TOPRIGHT", 0, 12)
	frame_bags:Hide()
	M.CreateBG(frame_bags)
	
	local frame_bags_toggle = CreateFrame('Frame')
	frame_bags_toggle:SetHeight(17)
	frame_bags_toggle:SetWidth(17)
	frame_bags_toggle:SetPoint("TOPRIGHT", "bBag_"..framen, "TOPRIGHT", -46, -4)
	frame_bags_toggle:SetParent("bBag_"..framen)
	frame_bags_toggle:EnableMouse(true)
	
	M.CreateBG(frame_bags_toggle, 0)
	M.CreateGradient(frame_bags_toggle)
	
	local frame_bags_toggle_text = frame_bags_toggle:CreateFontString("button")
	frame_bags_toggle_text:SetPoint("CENTER", frame_bags_toggle, "CENTER", 1, 0)
	frame_bags_toggle_text:SetFont(M.media.font, 11, "THINOUTLINE")
	frame_bags_toggle_text:SetText("B")
	frame_bags_toggle_text:SetTextColor(1,1,1)
	frame_bags_toggle:SetScript('OnMouseUp', function()
		if (togglebag ~= 1) then
			togglebag = 1
		else
			togglebag= 0
		end
		if togglebag == 1 then
			frame_bags:Show()
			frame_bags_toggle_text:SetTextColor(1,.1,.1)
		else
			frame_bags:Hide()
			frame_bags_toggle_text:SetTextColor(1,1,1)
		end
	end)
	frame_bags_toggle:SetScript('OnEnter', function() frame_bags_toggle_text:SetTextColor(1,.1,.1)end)
	frame_bags_toggle:SetScript('OnLeave', function() frame_bags_toggle_text:SetTextColor(1,1,1)end)
	
	local jp = CreateFrame('Frame')
	jp:SetHeight(17)
	jp:SetWidth(17)
	jp:SetPoint("LEFT", frame_bags_toggle, "RIGHT", 4, 0)
	jp:SetParent("bBag_"..framen)
	jp:EnableMouse(true)
	
	M.CreateBG(jp, 0)
	M.CreateGradient(jp)
	
	local jpt = jp:CreateFontString("button")
	jpt:SetPoint("CENTER", jp, "CENTER", 1, 0)
	jpt:SetFont(M.media.font, 11, "THINOUTLINE")
	jpt:SetText("P")
	jpt:SetTextColor(1,1,1)
	jp:SetScript('OnMouseUp', function()
	    JPack:Pack()
	end)
	jp:SetScript('OnEnter', function() jpt:SetTextColor(1,.1,.1)end)
	jp:SetScript('OnLeave', function() jpt:SetTextColor(1,1,1)end)
	
	local close = CreateFrame('Frame')
	close:SetHeight(17)
	close:SetWidth(17)
	close:SetPoint("LEFT", jp, "RIGHT", 4, 0)
	close:SetParent("bBag_"..framen)
	close:EnableMouse(true)
	
	M.CreateBG(close, 0)
	M.CreateGradient(close)
	
	local closet = close:CreateFontString("button")
	closet:SetPoint("CENTER", close, "CENTER", 1, 1)
	closet:SetFont(M.media.font, 14, "THINOUTLINE")
	closet:SetText("x")
	closet:SetTextColor(1,1,1)
	close:SetScript('OnEnter', function() closet:SetTextColor(1,.1,.1)end)
	close:SetScript('OnLeave', function() closet:SetTextColor(1,1,1)end)
	if (framen == "bag") then
		close:SetScript('OnMouseUp', function()
			CloseBackpack()
		end)
		for _, f in pairs(bags.bag) do
			local count = _G[f:GetName().."Count"]
			local icon = _G[f:GetName().."IconTexture"]
			f:SetParent(_G["bBag_"..framen.."_bags"])
			f:ClearAllPoints()
			f:SetWidth(24)
			f:SetHeight(24)
			if lastbuttonbag then
				f:SetPoint("LEFT", lastbuttonbag, "RIGHT", config.spacing, 0)
			else
				f:SetPoint("TOPLEFT", _G["bBag_"..framen.."_bags"], "TOPLEFT", 8, -8)
			end
			count.Show = function() end
			count:Hide()
			icon:SetTexCoord(0, 1, 0, 1)
			f:SetNormalTexture("")
			f:SetPushedTexture("")
			f:SetCheckedTexture("")
			lastbuttonbag = f
			_G["bBag_"..framen.."_bags"]:SetWidth((24+config.spacing)*(getn(bags.bag))+14)
			_G["bBag_"..framen.."_bags"]:SetHeight(40)
		end
	else
		close:SetScript('OnMouseUp', function()
			CloseBankFrame()
		end)
		for _, f in pairs(bags.bank) do
			local count = _G[f:GetName().."Count"]
			local icon = _G[f:GetName().."IconTexture"]
			f:SetParent(_G["bBag_"..framen.."_bags"])
			f:ClearAllPoints()
			f:SetWidth(24)
			f:SetHeight(24)
			if lastbuttonbank then
				f:SetPoint("LEFT", lastbuttonbank, "RIGHT", config.spacing, 0)
			else
				f:SetPoint("TOPLEFT", _G["bBag_"..framen.."_bags"], "TOPLEFT", 8, -8)
			end
			count.Show = function() end
			count:Hide()
			icon:SetTexCoord(0, 1, 0, 1)
			f:SetNormalTexture("")
			f:SetPushedTexture("")
			f:SetHighlightTexture("")
			lastbuttonbank = f
			_G["bBag_"..framen.."_bags"]:SetWidth((24+config.spacing)*(getn(bags.bank))+14)
			_G["bBag_"..framen.."_bags"]:SetHeight(40)
		end
	end
end

local function skin(index, frame)
      for i = 1, index do
        local bag = _G[frame..i]
		local count = _G[bag:GetName().."Count"]
		local f = _G[bag:GetName().."IconTexture"]
        bag:SetNormalTexture("")
        bag:SetPushedTexture("")
		M.CreateBG(bag, 0)
		count:SetFont("Fonts\\FRIZQT__.ttf", 10, "MONOCHROMEOUTLINE")
		count:SetPoint("BOTTOMRIGHT", bag, 2, 0)
        f:SetPoint("TOPLEFT", bag, 0, 0)
		f:SetPoint("BOTTOMRIGHT", bag, 0, 0)
        f:SetTexCoord(.1, .9, .1, .9)
		bag.border = bag
    end
end

for i = 1, 12 do
	_G["ContainerFrame"..i..'CloseButton']:Hide()
	_G["ContainerFrame"..i..'PortraitButton']:Hide()
	_G["ContainerFrame"..i]:EnableMouse(false)
	skin(36, "ContainerFrame"..i.."Item")
	for p = 1, 7 do
		select(p, _G["ContainerFrame"..i]:GetRegions()):SetAlpha(0)
    end
end

ContainerFrame1Item1:SetScript("OnHide", function() 
	_G["bBag_bag"]:Hide() 
	togglemain = 0 
end)
BankFrameItem1:SetScript("OnHide", function() 
	_G["bBag_bank"]:Hide()
	togglebank = 0
end)
BankFrameItem1:SetScript("OnShow", function() 
	_G["bBag_bank"]:Show()
end)
BankPortraitTexture:Hide()
for a = 1, 5 do
	select(a, BankFrame:GetRegions()):Hide()
end
BankFrame:EnableMouse(0)
BankFrameCloseButton:Hide()
BankFrame:SetSize(0,0)
BankFrame:DisableDrawLayer("BACKGROUND")
BankFrame:DisableDrawLayer("BORDER")
BankFrame:DisableDrawLayer("OVERLAY")

SetUp("bag", "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -97, 150)
SetUp("bank", "TOPLEFT", UIParent, "TOPLEFT", 7, -100)
skin(28, "BankFrameItem")
skin(7, "BankFrameBag")

BagItemSearchBox:SetScript("OnUpdate", function()
	BagItemSearchBox:ClearAllPoints()
	BagItemSearchBox:SetSize(4.5*(config.spacing+config.size),20)
	BagItemSearchBox:SetPoint("LEFT", ContainerFrame1MoneyFrame, "RIGHT", 5, 2)
end)
BankItemSearchBox:SetScript("OnUpdate", function()
	BankItemSearchBox:ClearAllPoints()
	BankItemSearchBox:SetSize(4.5*(config.spacing+config.size),20)
	BankItemSearchBox:SetPoint("LEFT", ContainerFrame2MoneyFrame, "RIGHT", 5, 2)
end)

function SkinEditBox(frame)
	if _G[frame:GetName().."Left"] then _G[frame:GetName().."Left"]:Hide() end
	if _G[frame:GetName().."Middle"] then _G[frame:GetName().."Middle"]:Hide() end
	if _G[frame:GetName().."Right"] then _G[frame:GetName().."Right"]:Hide() end
	if _G[frame:GetName().."Mid"] then _G[frame:GetName().."Mid"]:Hide() end
	
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(2)
	frame:SetWidth(200)
	
	local framebg = CreateFrame('frame', frame, frame)
	framebg:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, 0)
	framebg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
end

SkinEditBox(BagItemSearchBox)
SkinEditBox(BankItemSearchBox)

-- Centralize and rewrite bag rendering function
function ContainerFrame_GenerateFrame(frame, size, id)
	frame.size = size;
	for i=1, size, 1 do
		local index = size - i + 1;
		local itemButton = _G[frame:GetName().."Item"..i];
		itemButton:SetID(index);
		itemButton:Show();
	end
	frame:SetID(id);
	frame:Show()
	UpdateContainerFrameAnchors();
	
	local numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
	for bag = 1, 5 do
		local slots = GetContainerNumSlots(bag-1)
			for item = slots, 1, -1 do
				local itemframes = _G["ContainerFrame"..bag.."Item"..item]
				itemframes:ClearAllPoints()
				itemframes:SetWidth(config.size)
				itemframes:SetHeight(config.size)
				itemframes:SetFrameStrata("HIGH")
				itemframes:SetFrameLevel(2)
				ContainerFrame1MoneyFrame:ClearAllPoints()
				ContainerFrame1MoneyFrame:Show()
				ContainerFrame1MoneyFrame:SetPoint("TOPLEFT", _G["bBag_bag"], "TOPLEFT", 10, -10)
				ContainerFrame1MoneyFrame:SetFrameStrata("HIGH")
				ContainerFrame1MoneyFrame:SetFrameLevel(2)
				if bag==1 and item==16 then
					itemframes:SetPoint("TOPLEFT", _G["bBag_bag"], "TOPLEFT", 10, -30)
					lastrowbutton = itemframes
					lastbutton = itemframes
				elseif numbuttons==config.bpr then
					itemframes:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+config.size))
					itemframes:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+config.size))
					lastrowbutton = itemframes
					numrows = numrows + 1
					numbuttons = 1
				else
					itemframes:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+config.size), 0)
					itemframes:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+config.size), 0)
					numbuttons = numbuttons + 1
				end
				lastbutton = itemframes
			end
		end
		_G["bBag_bag"]:SetHeight(((config.size+config.spacing)*(numrows+1)+40)-config.spacing)
		local numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
		for bank = 1, 28 do
			local bankitems = _G["BankFrameItem"..bank]
			bankitems:ClearAllPoints()
			bankitems:SetWidth(config.size)
			bankitems:SetHeight(config.size)
			bankitems:SetFrameStrata("HIGH")
			bankitems:SetFrameLevel(2)
			ContainerFrame2MoneyFrame:Show()
			ContainerFrame2MoneyFrame:ClearAllPoints()
			ContainerFrame2MoneyFrame:SetPoint("TOPLEFT", _G["bBag_bank"], "TOPLEFT", 10, -10)
			ContainerFrame2MoneyFrame:SetFrameStrata("HIGH")
			ContainerFrame2MoneyFrame:SetFrameLevel(2)
			ContainerFrame2MoneyFrame:SetParent(_G["bBag_bank"])
			BankFrameMoneyFrame:Hide()
			if bank==1 then
				bankitems:SetPoint("TOPLEFT", _G["bBag_bank"], "TOPLEFT", 10, -30)
				lastrowbutton = bankitems
				lastbutton = bankitems
			elseif numbuttons==config.bapr then
				bankitems:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+config.size))
				bankitems:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+config.size))
				lastrowbutton = bankitems
				numrows = numrows + 1
				numbuttons = 1
			else
				bankitems:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+config.size), 0)
				bankitems:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+config.size), 0)
				numbuttons = numbuttons + 1
			end
			lastbutton = bankitems
		end
		for bag = 6, 12 do
			local slots = GetContainerNumSlots(bag-1)
			for item = slots, 1, -1 do
				local itemframes = _G["ContainerFrame"..bag.."Item"..item]
				itemframes:ClearAllPoints()
				itemframes:SetWidth(config.size)
				itemframes:SetHeight(config.size)
				itemframes:SetFrameStrata("HIGH")
				itemframes:SetFrameLevel(2)
				if numbuttons==config.bapr then
					itemframes:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+config.size))
					itemframes:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+config.size))
					lastrowbutton = itemframes
					numrows = numrows + 1
					numbuttons = 1
				else
					itemframes:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+config.size), 0)
					itemframes:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+config.size), 0)
					numbuttons = numbuttons + 1
				end
				lastbutton = itemframes
			end
		end
		_G["bBag_bank"]:SetHeight(((config.size+config.spacing)*(numrows+1)+40)-config.spacing)
	end

function OpenBag(id, fromb)
    if ( not CanOpenPanels() ) then
        if ( UnitIsDead("player") ) then
            NotWhileDeadError();
        end
        return;
    end
	
	if (fromb) then
		local size = GetContainerNumSlots(id);
		if ( size > 0 ) then
			local containerShowing;
			for i=1, NUM_CONTAINER_FRAMES, 1 do
				local frame = _G["ContainerFrame"..i];
				if ( frame:IsShown() and frame:GetID() == id ) then
					containerShowing = i;
				end
			end
			if ( not containerShowing ) then
				ContainerFrame_GenerateFrame(ContainerFrame_GetOpenFrame(), size, id);
			end
		end
	else
		ToggleAllBags()
	end
end

function UpdateContainerFrameAnchors() end
function OpenBackpack()
	if togglemain ~= 1 then
		togglemain = 1
		_G["bBag_bag"]:Show()
		OpenBag(0,1)
		for i=1, NUM_BAG_FRAMES, 1 do OpenBag(i,1) end
	end
end
function CloseBackpack()
	if (togglemain == 1) then
		togglemain = 0
		CloseBag(0,1)
		_G["bBag_bag"]:Hide()
		for i=1, NUM_BAG_FRAMES, 1 do CloseBag(i) end
	end
end
function OpenAllBags()
	if togglemain ~= 1 then
		togglemain = 1
		_G["bBag_bag"]:Show()
		OpenBag(0,1)
		for i=1, NUM_BAG_FRAMES, 1 do OpenBag(i,1) end
	end
	if( BankFrame:IsShown() ) then
		if togglebank ~= 1 then
			togglebank = 1
			_G["bBag_bank"]:Show()
			BankFrame:Show()
			for i=1, NUM_CONTAINER_FRAMES, 1 do
				if (not IsBagOpen(i)) then OpenBag(i,1) end
			end
		end
	end
end
function ToggleAllBags()
	if (togglemain == 1) then
		if(not BankFrame:IsShown()) then 
			togglemain = 0
			CloseBag(0,1)
			_G["bBag_bag"]:Hide()
			for i=1, NUM_BAG_FRAMES, 1 do CloseBag(i) end
		end
	else
		togglemain = 1
		_G["bBag_bag"]:Show()
		OpenBag(0,1)
		for i=1, NUM_BAG_FRAMES, 1 do OpenBag(i,1) end
	end

	if( BankFrame:IsShown() ) then
		if (togglebank == 1) then
			togglebank = 0
			_G["bBag_bank"]:Hide()
			BankFrame:Hide()
			for i=NUM_BAG_FRAMES+1, NUM_CONTAINER_FRAMES, 1 do
				if ( IsBagOpen(i) ) then CloseBag(i) end
			end
		else
			togglebank = 1
			_G["bBag_bank"]:Show()
			BankFrame:Show()
			for i=1, NUM_CONTAINER_FRAMES, 1 do
				if (not IsBagOpen(i)) then OpenBag(i,1) end
			end
		end
	end
end

local numSlots,full = GetNumBankSlots();
local button;
	for i=1, NUM_BANKBAGSLOTS, 1 do
		button = _G["BankFrameBag"..i];
		if ( button ) then
			if ( i > numSlots ) then
				button:HookScript("OnMouseUp", function()
					StaticPopup_Show("BUY_BANK_SLOT")
				end)
			end
		end
	end

StaticPopupDialogs["BUY_BANK_SLOT"] = {
	text = CONFIRM_BUY_BANK_SLOT,
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		PurchaseSlot()
	end,
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, GetBankSlotCost())
	end,
	hasMoneyFrame = 1,
	timeout = 0,
	hideOnEscape = 1,
	preferredIndex = 3
}

local moneytext = {"ContainerFrame1MoneyFrameGoldButtonText", "ContainerFrame1MoneyFrameSilverButtonText", "ContainerFrame1MoneyFrameCopperButtonText", "ContainerFrame2MoneyFrameGoldButtonText", "ContainerFrame2MoneyFrameSilverButtonText", "ContainerFrame2MoneyFrameCopperButtonText"}
for i = 1, 6 do
	_G[moneytext[i]]:SetFont("Fonts\\FRIZQT__.ttf", 10, "MONOCHROMEOUTLINE")
end

MainMenuBarBackpackButton:Hide()