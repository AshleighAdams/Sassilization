--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.UMsgWeaponMenu(um)
	local Weapons = {}
	for k,v in pairs(LocalPlayer():GetWeapons()) do
		if(IsValid(v)) then
			table.insert(Weapons, v:GetClass())
		end
	end
	
	local Type = um:ReadShort()
	if(STGamemodes.WeaponMenu and STGamemodes.WeaponMenu:IsValid()) then
		if(STGamemodes.WeaponMenu:IsVisible() and (Type == 0 or STGamemodes.WeaponMenu:GetType() == Type)) then
			STGamemodes.WeaponMenu:Close()
		else
			STGamemodes.WeaponMenu:SetupWeaponsType(Type, Weapons)
			STGamemodes.WeaponMenu:Show()
		end
	else
		STGamemodes.WeaponMenu = vgui.Create("STGamemodes.VGUI.WeaponMenu")
		STGamemodes.WeaponMenu:SetupWeaponsType(Type, Weapons)
		STGamemodes.WeaponMenu:MakePopup()
		STGamemodes.WeaponMenu:Show()
	end
end
usermessage.Hook("STGamemodes.WeaponMenu", STGamemodes.UMsgWeaponMenu)

local PANEL = {}
PANEL.GradientDown = surface.GetTextureID("gui/gradient_down")
function PANEL:Init()
	self:SetTitle("Weapon Menu")
	
	self:SetSize(560, 500)
	self:Center()
	
	self.WX = 10
	self.WY = 30
	self.Spacing = 10
	
	self.BuyType = 0

	self.ModelPanel = vgui.Create("STGamemodes.VGUI.Model", self)
	self.ModelPanel:SetPos(self.WX, self.WY)
	self.ModelPanel:SetSize(self:GetWide() - (self.WX * 2), 210)
	
	self.WX = 10
	self.WY = self.WY + self.ModelPanel:GetTall() + self.Spacing
	
	self.BuyButton = vgui.Create("DButton", self)
	self.BuyButton:SetText("Select")
	self.BuyButton:SetPos(self.WX, self.WY)
	self.BuyButton:SetSize(self:GetWide() - (self.WX * 2), 22)
	function self.BuyButton.DoClick()
		local Selected = self.Selected
		if(Selected) then
			local Item = Selected.Item
			if(Item) then
				RunConsoleCommand("st_buyweapon", Item)
			end
		end
	end
	
	self.WY = self.WY + self.BuyButton:GetTall() + self.Spacing
	
	self.OX = self.WX
	self.OY = self.WY
end

function PANEL:GetType()
	return self.BuyType
end

function PANEL:SetupWeaponsType(Type, Weapons)
	self.BuyType = Type
	if(self.WeaponPanels and table.Count(self.WeaponPanels) > 0) then
		for k,v in pairs(self.WeaponPanels) do
			if(v and v:IsValid()) then
				v:Remove()
			end
		end
	end
	self.WX = self.OX
	self.WY = self.OY
	self.WeaponPanels = {}
	
	local First = false
	local NextRow = false
	local Selected = false
	for k,v in pairs(STGamemodes.WeaponsMenu) do
		if(v.Type == Type) then
			local WeaponPanel = vgui.Create("STGamemodes.VGUI.MenuItem", self)
			WeaponPanel:SetPos(self.WX, self.WY)
			WeaponPanel:SetSize(100, 100)
			WeaponPanel:SetItem(k)
			self.WeaponPanels[k] = WeaponPanel
			if(table.HasValue(Weapons, k)) then
				Selected = true
				self:SetSelected(WeaponPanel)
			elseif(!First) then
				First = WeaponPanel
			end
			self.WX = self.WX + WeaponPanel:GetWide() + self.Spacing
			if(math.floor(self.WX + WeaponPanel:GetWide()) >= self:GetWide()) then
				self.WY = self.WY + WeaponPanel:GetTall() + self.Spacing
				NextRow = true
			end
		end
	end
	
	if(!Selected) then
		self:SetSelected(First)
	end
	
	if(!NextRow) then
		self.WY = self.WY + 100 + self.Spacing
	end
	self:SetTall(self.WY)
end

function PANEL:SetSelected(Panel)
	if !Panel then return end
	if(self.Selected and self.Selected:IsValid()) then
		self.Selected:SetSelected(false)
	end
	self.Selected = Panel
	self.SelectedItemTable = self.Selected.ItemTable
	self.Selected:SetSelected(true)
	self.ModelPanel:SetItem(Panel.Item)
end

vgui.Register("STGamemodes.VGUI.WeaponMenu", PANEL, "STGamemodes.VGUI.Base")

function STGamemodes:OnTeamChanged(Team)
	if(Team == TEAM_SPEC or Team == TEAM_DEAD or Team == TEAM_ZOMBIES) then
		if(STGamemodes.WeaponMenu and STGamemodes.WeaponMenu:IsValid() and STGamemodes.WeaponMenu:IsVisible()) then
			STGamemodes.WeaponMenu:Close()
		end
	end
end
