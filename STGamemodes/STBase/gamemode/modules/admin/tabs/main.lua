local GradientDown = surface.GetTextureID("gui/gradient_down")

local PANEL = {}
PANEL.LastThink = CurTime()

function PANEL:Init()
	
	self:SetWide( 300 )
	
	self.NoStretchX = true;
	self.NoStretchY = true;

	self.Paint = function()
		--surface.SetDrawColor(255,255,255,40)
		--surface.DrawRect(0,0,self:GetWide(), self:GetTall())
	end
	
	self.Select = vgui.Create("DButton", self)
	self.Select:SetText("Select...")
	self.Select.DoClick = function(btn)
		local Menu = DermaMenu()
		Menu:AddOption("All", function()
			for k, v in pairs(self.PanelList:GetItems()) do
				v:SetSelected(true)
			end
		end)
		Menu:AddOption("Admin", function()
			for k, v in pairs(self.PanelList:GetItems()) do
				if(v.Player and v.Player:IsValid()) then
					v:SetSelected(v.Player:IsAdmin())
				end
			end
		end)
		Menu:AddOption("Mod", function()
			for k, v in pairs(self.PanelList:GetItems()) do
				if(v.Player and v.Player:IsValid()) then
					v:SetSelected(v.Player:IsMod())
				end
			end
		end)
		Menu:AddOption("VIP", function()
			for k, v in pairs(self.PanelList:GetItems()) do
				if(v.Player and v.Player:IsValid()) then
					v:SetSelected(v.Player:IsVIP())
				end
			end
		end)
		Menu:AddOption("Muted", function()
			for k, v in pairs(self.PanelList:GetItems()) do
				if(v.Player and v.Player:IsValid()) then
					v:SetSelected(v.Player:IsCMuted())
				end
			end
		end)
		Menu:AddOption("Non VIP", function()
			for k, v in pairs(self.PanelList:GetItems()) do
				if(v.Player and v.Player:IsValid()) then
					v:SetSelected(!v.Player:IsVIP())
				end
			end
		end)
		Menu:AddOption("Non Admin", function()
			for k, v in pairs(self.PanelList:GetItems()) do
				if(v.Player and v.Player:IsValid()) then
					v:SetSelected(!v.Player:IsAdmin())
				end
			end
		end)
		gamemode.Call( "AddGamemodeSpecificSelectMethods", self, Menu )
		Menu:Open()
	end 

	self.Inverse = vgui.Create("DButton", self)
	self.Inverse:SetText("Invert")
	self.Inverse.DoClick = function()
		for k, v in pairs(self.PanelList:GetItems()) do
			v:SetSelected(!v:GetSelected())
		end
	end

	self.Sort = vgui.Create("DButton", self)
	self.Sort:SetText("Sort")
	self.Sort.DoClick = function()
		if(self.Sorted == nil) then
			self.Sorted = true
		end
		self.PanelList:SortByMember("Name", self.Sorted)
		self.Sorted = !self.Sorted
	end

	self.DeSelect = vgui.Create("DButton", self)
	self.DeSelect:SetText("DeSelect All")
	self.DeSelect.DoClick = function()
		for k, v in pairs(self.PanelList:GetItems()) do
			v:SetSelected(false)
		end
	end

	self.PanelList = vgui.Create("DPanelList", self)
	self.PanelList:SetSpacing(0)
	self.PanelList:EnableVerticalScrollbar(true)
	self.PanelList.Paint = function()
		w, h = self.PanelList:GetSize()
		--surface.SetDrawColor(255,255,255,10)
		--surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(255,255,255,50)
		surface.SetTexture(GradientDown)
		surface.DrawTexturedRect(0,0,w,h)
	end

	self.Slay = vgui.Create("DButton", self)
	self.Slay:SetText("Slay")
	self.Slay.DoClick = function()
		self:SlayPlayer(self:GetSelectedPlayers())
	end

	self.Muteall = vgui.Create("DButton", self)
	self.Muteall:SetText("Mute")
	self.Muteall.DoClick = function()
		self:MuteallPlayer(self:GetSelectedPlayers())
	end
	
	self.Kick = vgui.Create("DButton", self)
	self.Kick:SetText("Kick")
	self.Kick.DoClick = function()
		self:KickPlayer(self:GetSelectedPlayers())
	end
	
	if(LocalPlayer():IsAdmin() or STGamemodes.Admin) then
		self.Ban = vgui.Create("DButton", self)
		self.Ban:SetText("Ban")
		self.Ban.DoClick = function()
			self:BanPlayer(self:GetSelectedPlayers())
		end
	else
		self.Voteban = vgui.Create("DButton", self)
		self.Voteban:SetText("Vote Ban")
		self.Voteban.DoClick = function()
			self:VotebanPlayer(self:GetSelectedPlayers())
		end
	end
	
	self:PerformLayout()
	
end

function PANEL:PerformLayout()
	
	local SizeX = self:GetWide()
	local SizeY = self:GetTall()
	
	local Spacing = 12
	
	local PositionX = 5
	local PositionY = 28
	
	local ButtonSizeX = 60
	local ButtonSizeY = 20
	
	SizeY = SizeY - 50
	PositionY = 3
	
	self.Select:SetPos(PositionX, PositionY)
	self.Select:SetSize(ButtonSizeX, ButtonSizeY)
	
	PositionX = PositionX + self.Select:GetWide() + Spacing
	
	self.Inverse:SetPos(PositionX, PositionY)
	self.Inverse:SetSize(ButtonSizeX, ButtonSizeY)
	
	PositionX = PositionX + self.Inverse:GetWide() + Spacing
	
	self.Sort:SetPos(PositionX, PositionY)
	self.Sort:SetSize(ButtonSizeX, ButtonSizeY)
	
	PositionX = PositionX + self.Sort:GetWide() + Spacing
	
	self.DeSelect:SetPos(PositionX, PositionY)
	self.DeSelect:SetSize(ButtonSizeX + 5, ButtonSizeY)

	Spacing = 13
	PositionX = 5
	PositionY = 0
	SizeX = SizeX - 10
	SizeY = SizeY + 10
	
	self.PanelList:SetPos(5, PositionY + 25)
	self.PanelList:SetSize(SizeX, SizeY - 25)
	
	PositionY = self:GetTall() - 20
	
	self.Slay:SetSize(ButtonSizeX, ButtonSizeY)
	self.Slay:SetPos(PositionX, PositionY)
	
	PositionX = PositionX + self.Slay:GetWide() + Spacing
	
	self.Muteall:SetSize(ButtonSizeX, ButtonSizeY)
	self.Muteall:SetPos(PositionX, PositionY)
	
	PositionX = PositionX + self.Muteall:GetWide() + Spacing
	
	self.Kick:SetSize(ButtonSizeX, ButtonSizeY)
	self.Kick:SetPos(PositionX, PositionY)
	
	PositionX = PositionX + self.Kick:GetWide() + Spacing
	
	if(self.Ban) then
		self.Ban:SetSize(ButtonSizeX, ButtonSizeY)
		self.Ban:SetPos(PositionX, PositionY)
		
		PositionX = PositionX + self.Ban:GetWide() + Spacing
	else
		self.Voteban:SetSize(ButtonSizeX + 10, ButtonSizeY)
		self.Voteban:SetPos(PositionX, PositionY)
		
		PositionX = PositionX + self.Voteban:GetWide() + Spacing
	end
end

function PANEL:Paint()
	--surface.SetDrawColor(255,255,255,30)
	--surface.DrawRect(0,0,self:GetWide(), self:GetTall())
end

function PANEL:OnPaint()
end

function PANEL:Think()
	
	if(self.LastThink >= CurTime()) then
		return
	end
	
	self.LastThink = CurTime() + 1
	
	if( !self.PanelList ) then return end
	
	for k, v in pairs(self.PanelList:GetItems()) do
		if(!v.Player or !v.Player:IsValid()) then
			v:SetSelected(false)
			self.PanelList:RemoveItem(v)
			self.PanelList:Rebuild()
			self.PanelList:PerformLayout()
		end
	end
	
	self.PanelList:Rebuild()
	self.PanelList:PerformLayout()
	
	local Change = false
	
	for k, v in pairs(player.GetAll()) do
		if(v and v:IsValid() and !self:PlayerIsInTable(v)) then
		
			self:AddPlayerPanel( v )
			
			Change = true
		end
	end
	
	if(Change) then
		self.PanelList:Rebuild()
		self.PanelList:PerformLayout()
	end
	
end

function PANEL:AddPlayerPanel( ply )

	local DPanel = vgui.Create("DPanel")
	DPanel.Paint = function()
		w, h = DPanel:GetSize()
		if(DPanel:GetSelected()) then
			surface.SetDrawColor(0, 100, 255, 100)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(255,255,255,10)
			surface.SetTexture(GradientDown)
			surface.DrawTexturedRect(0,0,w, h)
		end
		if(DPanel.Hovered) then
			surface.SetDrawColor(0, 100, 255, 40)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(255,255,255,10)
			surface.SetTexture(GradientDown)
			surface.DrawTexturedRect(0,0,w, h)
		end
	end

	function DPanel:GetSelected()
		return DPanel.Selected
	end

	function DPanel:SetSelected(Bool)
		DPanel.Selected = Bool
	end

	function DPanel:OnMousePressed(MouseCode)
		if(DPanel:GetSelected()) then
			DPanel.Selected = false
		else
			DPanel.Selected = true
		end
	end

	DPanel.Rep = vgui.Create("DPanel", DPanel)
	DPanel.Rep:SetSize(32, 16)
	DPanel.Rep:SetPos(5, 5)
    DPanel.Rep:SetMouseInputEnabled(false)
	DPanel.Rep.Paint = function()
		if(DPanel.Player and DPanel.Player:IsValid()) then
			local Title = RepMat[DPanel.Player:GetRank()]
			if(Title) then
				surface.SetMaterial(Title)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(0, 0, DPanel.Rep:GetWide(), DPanel.Rep:GetTall())
			end
		end
	end

	DPanel.Label = vgui.Create("DLabel", DPanel)
	DPanel.Label:SetText(ply:CName())
	DPanel.Label:SetPos(DPanel.Rep:GetWide() + 10, 5)
	DPanel.Label:SetTextColor(color_white)
	//DPanel.Label:SetFont("DefaultBold")
	DPanel.Label:SizeToContents()

	DPanel.Muted = vgui.Create("DPanel", DPanel)
	DPanel.Muted.Mat = Material("icon16/exclamation.png")
	DPanel.Muted:SetSize(16, 16)
	DPanel.Muted:SetPos(self.PanelList:GetCanvas():GetWide() - DPanel.Muted:GetWide() - 20, 5)
	DPanel.Muted.Paint = function()
		if(DPanel.Player and DPanel.Muted.Mat and DPanel.Player:IsValid() and DPanel.Player:IsCMuted()) then
			surface.SetMaterial(DPanel.Muted.Mat)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(0, 0, DPanel.Muted:GetWide(), DPanel.Muted:GetTall())
		end
	end
	

	DPanel.DoClick = DPanel.OnMousePressed
	DPanel.Player = ply
	DPanel["Name"] = ply:CName()
	DPanel:SetSelected(false)
	
	self.PanelList:AddItem(DPanel)

end

function PANEL:PlayerIsInTable(ply)
	for k, v in pairs(self.PanelList:GetItems()) do
		if(v.Player == ply) then
			return true
		end
	end
	return false
end

function PANEL:GetSelectedPlayers()
	local Table = {}
	for k, v in pairs(self.PanelList:GetItems()) do
		if(v:GetSelected()) then
			table.insert(Table, v.Player)
		end
	end
	return Table
end

function PANEL:SlayPlayer(Table, Reason)
	for k, v in pairs(Table) do
		if(v and v:IsValid()) then
			RunConsoleCommand("st_slay", tostring(v:EntIndex()))
		end
	end
end

function PANEL:MuteallPlayer(Table, Reason)
	local Multiple = false
	if(!Reason and table.Count(Table) > 1) then
		Multiple = true
		Derma_StringRequest("Muting Multiple Players", "Mute Reason", "", 
		function(Text)
			self:MuteallPlayer(Table, Text)
		end,
		function(Text)
		end,
		"Mute", "Cancel")
	end
	if(Multiple) then
		return
	end
	for k, v in pairs(Table) do
		if(v and v:IsValid()) then
			if(Reason) then
				RunConsoleCommand("st_muteall", tostring(v:EntIndex()), tostring(Reason))
			else
				Derma_StringRequest("Muting: "..v:CName(), "Mute Reason", "", 
				function(Text)
					RunConsoleCommand("st_muteall", tostring(v:EntIndex()), Text)
				end,
				function(Text)
				end,
				"Mute", "Cancel")
			end
		end
	end
end

function PANEL:VotebanPlayer(Table)
	if(!Reason and table.Count(Table) > 1) then
		LocalPlayer():ChatPrint("You can only voteban one person at a time")
		return
	end
	for k, v in pairs(Table) do
		if(v and v:IsValid()) then
			Derma_StringRequest("Vote Ban: "..v:CName(), "Format: hours:reason", "1:Ban", 
			function(Text)
				local Table = string.Explode(":", Text)
				RunConsoleCommand("st_voteban", tostring(v:EntIndex()), Table[1], Table[2])
			end,
			function(Text)
			end,
			"Ban", "Cancel")
		end
	end
end

function PANEL:KickPlayer(Table, Reason)
	local Multiple = false
	if(!Reason and table.Count(Table) > 1) then
		Multiple = true
		Derma_StringRequest("Kicking Multiple Players", "Kick Reason", "", 
		function(Text)
			self:KickPlayer(Table, Text)
		end,
		function(Text)
		end,
		"Kick", "Cancel")
	end
	if(Multiple) then
		return
	end
	for k, v in pairs(Table) do
		if(v and v:IsValid()) then
			if(Reason) then
				RunConsoleCommand("st_kick", tostring(v:EntIndex()), tostring(Reason))
			else
				Derma_StringRequest("Kicking: "..v:CName(), "Kick Reason", "", 
				function(Text)
					RunConsoleCommand("st_kick", tostring(v:EntIndex()), Text)
				end,
				function(Text)
				end,
				"Kick", "Cancel")
			end
		end
	end
end

function PANEL:BanPlayer(Table)
	for k, v in pairs(Table) do
		if(v and v:IsValid()) then
			Derma_StringRequest("Banning: "..v:CName(), "Format: hours:reason", "1:Ban", 
			function(Text)
				local Table = string.Explode(":", Text)
				RunConsoleCommand("st_ban", tostring(v:EntIndex()), Table[1], Table[2])
			end,
			function(Text)
			end,
			"Ban", "Cancel")
		end
	end
end

vgui.Register("STGamemodes.VGUI.Admin.Main", PANEL, "DPanel")