--------------------
-- STBase
-- By Spacetech
--------------------

local PANEL = {}

function PANEL:Paint()
    surface.SetDrawColor(54, 77, 106, 200)
    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	
    surface.SetDrawColor(154, 177, 206, 180)
    surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("STGamemodes.VGUI.BasePaint", PANEL, "DPanel")
