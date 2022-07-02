include('shared.lua');


function ENT:Think()
	
	self.Entity:SetSolid( SOLID_NONE )
	
	local col = Color( self.Entity:GetColor() )
	if col.a == 255 then return end
	if !self.startfade then self.startfade = CurTime() + 5 end
	col.a = 254 * math.max( (self.startfade - CurTime())/5, 0 )
	self.Entity:SetColor( col )
	
end

function ENT:Draw()
	--Near Clip
	if self.Entity:GetPos():Distance( LocalPlayer():EyePos() ) < 10 then return end
	self.Entity:DrawModel()
end