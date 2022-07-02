--------------------
-- STBase
-- By Spacetech
--------------------

local LevelIndex = 0
local LevelSelect = false
STGamemodes.LevelSelect = LevelSelect

local PANEL = {}

function PANEL:Init()
	self:SetTitle("Level Select")
	self:ShowCloseButton(false)
	self.btnClose:SetVisible(true)
	self.btnClose:SetSize(8,8)
	self.btnClose:SetAlpha(100)
	self.btnClose:SetPos( self:GetWide() - 20, 5)
	self:SetWide(110)
	
	local Y = 30
	
	self.LevelComboBox = vgui.Create("DListView", self)
	self.LevelComboBox:SetPos(5, Y)
	self.LevelComboBox:SetWide(100)
	self.LevelComboBox:SetMultiSelect(false)
	self.LevelComboBox:SetHideHeaders(true)
	self.LevelComboBox:AddColumn('Level');
	self.LevelComboBox:SetTooltip("VIP's receive 25% more dough\n25% is already added onto the calculated amount if you're a VIP")
	
	if(self.LevelComboBox.VBar) then
		self.LevelComboBox.VBar:Remove()
		self.LevelComboBox.VBar = nil
	end
	
	for k,v in pairs(GAMEMODE.Levels) do
		local Item = self.LevelComboBox:AddLine(v.Name)
		Item.Col = v.Col
		Item.LevelID = k
		if(LocalPlayer():GetNWInt("Level", 0) == k and LocalPlayer():IsWinner()) then
			self.LevelComboBox:SelectItem(Item, true)
		end
	end
	
	//self.LevelComboBox:Rebuild()
	self.LevelComboBox:SetTall(self.LevelComboBox.pnlCanvas:GetTall()+80 )
	self.LevelComboBox.pnlCanvas:SetPos(0, 0)
	
	Y = Y + self.LevelComboBox:GetTall() + 5
	
	self.LevelLabel = vgui.Create("DLabel", self)
	self.LevelLabel:SetTextColor(Color(255, 255, 255, 255))
	self.LevelLabel:SetPos(5, Y)
	self.LevelLabel:SetText("Select a Level")
	self.LevelLabel:SizeToContents()
	self.LevelLabel:CenterHorizontal()
	
	Y = Y + self.LevelLabel:GetTall() + 5
	
	self.LevelButton = vgui.Create("DButton", self)
	self.LevelButton:SetText("Select Level")
	self.LevelButton:SetPos(5, Y)
	self.LevelButton:SetSize(100, 22)
	self.LevelButton.DoClick = function(Panel)
		local Items = self.LevelComboBox:GetSelected()
		if(Items and Items[1] and ((self.LevelLabel.Money and self.LevelLabel.Money != "N/A") or LevelIndex == 3)) then
			local Level = Items[1].LevelID
			if(LevelIndex == 2 and LocalPlayer():GetNWInt("Level", 0) <= Level) then
				Derma_QueryFixed("Changing your level will reset your position and time. Are you sure you want to change the level?", "Confirmation",
					"Yes", function()
						RunConsoleCommand("bhop_levelselect", Level)
					end, 
					"No", function()
					end
				)
			else
				RunConsoleCommand("bhop_levelselect", Level)
			end
		end
	end
	
	Y = Y + self.LevelButton:GetTall() + 5
	
	self:SetTall(Y)
	
	self:Center()
end

function PANEL:OnClose()
	ChangeTooltip(false)
end

function PANEL:Think()
	DFrame.Think(self)
	
	local Items = self.LevelComboBox:GetSelected()
	if(Items and Items[1]) then
		if(self.LevelLabel.Level != Items[1].LevelID or self.LevelLabel.LevelIndex != LevelIndex) then
			self.LevelLabel.Level = Items[1].LevelID
			self.LevelLabel.LevelIndex = LevelIndex
			if(LevelIndex == 3) then
				self.LevelLabel.Money = "0"
			else
				self.LevelLabel.Money = tostring(GAMEMODE:CalcWinMoney(LocalPlayer(), self.LevelLabel.Level))
			end
			self.LevelLabel:SetText("Win Amount: "..self.LevelLabel.Money)
			self.LevelLabel:SetTextColor(Items[1].Col)
			self.LevelLabel:SizeToContents()
			self.LevelLabel:CenterHorizontal()
		end
	end
end

vgui.Register("STGamemodes.VGUI.BunnyHopLevel", PANEL, "STGamemodes.VGUI.Base")

usermessage.Hook("bhop_level_select", function(um)
	LevelIndex = um:ReadShort()
	StartTimer = um:ReadBool()
	if(StartTimer) then
		GAMEMODE.DrawStartTimer = CurTime()
	end
	if(LevelIndex != -1) then
		if(LevelIndex == 4) then
			if(ValidPanel(LevelSelect)) then
				LevelSelect.LevelComboBox:SetTooltip(false)
				LevelSelect:Close()
				LevelSelect:Remove()
			end
			LevelSelect = false
		elseif(ValidPanel(LevelSelect)) then
			LevelSelect:Show()
			STGamemodes.LevelSelect = LevelSelect
		else
			LevelSelect = vgui.Create("STGamemodes.VGUI.BunnyHopLevel")
			LevelSelect:Show()
			STGamemodes.LevelSelect = LevelSelect
		end
	end
end)

usermessage.Hook( "STGamemodes.TimerStart", function(um)
	STGamemodes.DrawStartTimer = um:ReadFloat()
end )

usermessage.Hook( "STGamemodes.TimerStop", function()
	STGamemodes.DrawStartTimer = false
end )






