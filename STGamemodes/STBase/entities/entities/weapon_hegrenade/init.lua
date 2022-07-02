ENT.Type = "point"

function ENT:Initialize()
	
	local ent = ents.Create( "weapon_frag" )
	ent:SetPos( self:GetPos() )
	ent:Spawn()
	ent:Activate()
	self:Remove()
	
end