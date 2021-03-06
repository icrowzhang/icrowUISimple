local M = icrowMedia
local i

-- helper function to remove elements
local function kill(f)
	if f.UnregisterAllEvents then
		f:UnregisterAllEvents()
	end
	f.Show = function() end
	f:Hide()
end

-- 干掉聊天菜单按钮
ChatFrameMenuButton:Hide()
ChatFrameMenuButton:SetScript("OnShow", kill)
-- 干掉社交按钮
FriendsMicroButton:Hide()
FriendsMicroButton:SetScript("OnShow", kill)

-- 隐藏翻页按钮(不在最后一行右下角显示翻页至底按钮)
local updateBottomButton = function(frame)
	local button = frame.buttonFrame.bottomButton
	if frame:AtBottom() then
		button:Hide()
	else
		button:Show()
	end
end
local bottomButtonClick = function(button)
	local frame = button:GetParent()
	frame:ScrollToBottom()
	updateBottomButton(frame)
end
for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame" .. i]
		frame:HookScript("OnShow", updateBottomButton)
		frame.buttonFrame:Hide()
		local up = frame.buttonFrame.upButton
                local down = frame.buttonFrame.downButton
                local minimize = frame.buttonFrame.minimizeButton
		local bottom = frame.buttonFrame.bottomButton
		bottom:SetParent(frame)
		bottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, 5)
		bottom:SetScript("OnClick", bottomButtonClick)
		bottom:SetAlpha(0.8)
                bottom:SetScale(0.7)
		updateBottomButton(frame)
                up.Show = up.Hide 
                up:Hide()
                down.Show = down.Hide 
                down:Hide()
                minimize:SetScale(.7)   
                minimize:ClearAllPoints()
                minimize:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 5, 5)
                minimize:SetScript('OnEnter', function(self) self:SetAlpha(1) end)
                minimize:SetScript('OnLeave', function(self) self:SetAlpha(0) end) 
end
hooksecurefunc("FloatingChatFrame_OnMouseScroll", updateBottomButton)