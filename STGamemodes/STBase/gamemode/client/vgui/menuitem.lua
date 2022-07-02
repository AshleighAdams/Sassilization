--------------------
-- STBase
-- By Spacetech
--------------------

local PANEL = {}
PANEL.GradientDown = surface.GetTextureID("gui/gradient_down")

function PANEL:Init()
end

function PANEL:SetItem(Item)
	self.Item = Item
	self.ItemTable = STGamemodes.WeaponsMenu[Item]
	
	-- Attempt to set proper weapon name
	local weap = weapons.Get(Item)
	if weap && weap.PrintName then
		self.ItemFixed = weap.PrintName
	else
		self.ItemFixed = STGamemodes:UpperCaseFirst(string.gsub(Item, "weapon_", ""))
	end
	
	self.ModelPanel = vgui.Create("STGamemodes.VGUI.Model", self)
	self.ModelPanel:SetPos(0, 0)
	self.ModelPanel:SetSize(self:GetWide(), self:GetTall())
	self.ModelPanel:SetItem(Item)
end

function PANEL:SetPrice(Number)
	self.Price = Number
end

function PANEL:Paint()
	local RectCol = Color(0, 0, 0, 50)
	local OutlineRectCol = Color(0, 0, 0, 100)
	
	if(self.Selected) then
		OutlineRectCol = Color(0, 255, 0, 100)
	elseif(self.Hovered) then
		OutlineRectCol = Color(83, 124, 192, 100)
	end
	
	surface.SetDrawColor(255,255,255,40)
	surface.SetTexture(self.GradientDown)
	surface.DrawTexturedRect(0,0,self:GetWide(), self:GetTall())

	surface.SetDrawColor(RectCol.r, RectCol.g, RectCol.g, RectCol.a)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	
	surface.SetDrawColor(OutlineRectCol.r, OutlineRectCol.g, OutlineRectCol.b, OutlineRectCol.a)
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	
	local Text = tostring(self.ItemFixed) or "Loading..."
	surface.SetFont("ChatFont")
	local Width, Height = surface.GetTextSize(Text)
	surface.SetTextPos((self:GetWide() / 2) - (Width / 2) - 1, self:GetTall() - 24)
	surface.DrawText(Text)
end

function PANEL:SetSelected(Bool)
	self.Selected = Bool
end

function PANEL:OnCursorEntered()
	self.Hovered = true
end

function PANEL:OnCursorExited()
	self.Hovered = false
end

function PANEL:OnMouseReleased(MouseCode)
	self:GetParent():SetSelected(self)
end

vgui.Register("STGamemodes.VGUI.MenuItem", PANEL, "DPanel")
