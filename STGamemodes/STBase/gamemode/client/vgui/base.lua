--------------------
-- STBase
-- By Spacetech
--------------------

local PANEL = {}

function PANEL:Init()
	self:SetTitle(GAMEMODE:GetGameDescription())
	ShowMouse()
	self:SetSkin("SassilizationSkin")
end

function PANEL:SetTitleEx(Title)
	self:SetTitle(GAMEMODE:GetGameDescription().." - "..Title)
end

function PANEL:ShowHide()
	if(self:IsVisible()) then
		self:Close()
	else
		self:Show()
	end
end

function PANEL:Show(Override)
	if(!self:IsVisible()) then
		if(!Override) then
			ShowMouse()
		end
		self:SetVisible(true)
	end
end

function PANEL:Close(Override)
	if(self:IsVisible()) then
		if(!Override) then
			HideMouse()
		end
		if(self.OnClose) then
			self:OnClose()
		end
		self:SetVisible(false)
	end
end

local matBlurScreen = Material( "pp/blurscreen" )
local bBlurEnabled = CreateClientConVar( "st_cl_blur", "1", true, false )
local fBlurAmount = CreateClientConVar( "st_cl_blur_amount", "3", true, false )

function PANEL:DrawBackgroundBlur()
    surface.SetMaterial( matBlurScreen )   
    surface.SetDrawColor( 255, 255, 255, 150 )

    local blurAmount = 1 / math.Clamp(math.abs(fBlurAmount:GetFloat()), 1, 10)
    local x, y = self:LocalToScreen( 0, 0 )
         
    for i=blurAmount, 1, blurAmount do
        matBlurScreen:SetFloat( "$blur", 5 * i )
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
    end
end

function PANEL:Paint()
	if bBlurEnabled:GetBool() then
		self:DrawBackgroundBlur()
	end

    surface.SetDrawColor(54, 77, 106, 200)
    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	
    surface.SetDrawColor(154, 177, 206, 180)
    surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	
	if(self.OnPaint) then
		self:OnPaint()
	end
end

vgui.Register("STGamemodes.VGUI.Base", PANEL, "DFrame")

-- function GM:ForceDermaSkin()
-- 	return "SassilizationSkin"
-- end