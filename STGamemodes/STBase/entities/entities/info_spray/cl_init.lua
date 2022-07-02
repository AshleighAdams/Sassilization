include('shared.lua')

surface.CreateFont( "font_spray", {font="akbar", size=24, weight=600, antialias=true} )

local function DrawText( txt, x, y, col )
	if !txt then return end
	col = col or {r=255,g=255,b=255,a=255}
	surface.SetTextPos( x+2, y+2 )
	surface.SetTextColor( 0, 0, 0, 255 )
	surface.DrawText( txt )
	surface.SetTextPos( x, y )
	surface.SetTextColor( col.r, col.g, col.b, col.a )
	surface.DrawText( txt )
end

function ENT:Draw()
	
	local pl = LocalPlayer()
	if !STValidEntity( pl ) then return end
	if !(pl:IsAdmin() or pl:IsSuperAdmin()) then return end
	
	self.Nick = self.Nick or (STValidEntity(self:GetOwner()) and self:GetOwner():CName() or "")
	self.Steam = STValidEntity(self:GetOwner()) and self:GetOwner():SteamID() or "N/A"

	self.Entity:SetRenderBounds( Vector() * -64, Vector() * 64 )
	
	local ang = self:GetAngles()
	cam.Start3D2D(self:GetPos()+self:GetForward()*0.1+self:GetRight()*32+self:GetUp()*32,Angle( ang.r, ang.y + 90, ang.p + 90 ),0.1)
		surface.SetDrawColor(255,0,0,100)
		surface.DrawLine(0,0,640,0)
		surface.DrawLine(640,0,640,640)
		surface.DrawLine(0,0,0,640)
		surface.DrawLine(0,640,640,640)
		surface.SetFont( "font_spray" )
		local w1, h1 = surface.GetTextSize( self.Nick )
		DrawText( self.Nick, 630 - w1, 630 - h1 )
		local w2, h2 = surface.GetTextSize( self.Steam )
		DrawText( self.Steam, 630 - w2, 630 - h2 - h1 - 10 )
	cam.End3D2D()
	
end