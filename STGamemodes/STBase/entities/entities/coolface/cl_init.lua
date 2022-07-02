include('shared.lua')

local texCoolFace = surface.GetTextureID( "coolface/coolface" )

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize() end

function ENT:Draw()
	
	local pl = self:GetOwner()
	if !(ValidEntity(pl)) then return end
	
	self:SetRenderBounds( Vector()*-250, Vector()*250 )
	
	if (pl:IsValid() and pl:IsPlayer() and pl:Alive() and pl != LocalPlayer()) then
		local atch = pl:GetAttachment( pl:LookupAttachment( 'eyes' ) )
		local dir = pl:GetForward()
		
		dir.z = 0
		dir = dir:Angle()
		
		if atch then
			
			local scale = 0.57735
			cam.Start3D2D( atch.Pos+4*scale*pl:GetForward()+8*scale*pl:GetRight()+8*scale*pl:GetUp(), Angle( 0, dir.y+90, dir.p+90 ), scale*0.5 )
				surface.SetDrawColor(255,255,255,255)
				surface.SetTexture( texCoolFace )
				surface.DrawTexturedRect(0,0,48,48)
			cam.End3D2D()
			
		end
	end
	
end