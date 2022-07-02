ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()

	self.Entity:SetMoveType(MOVETYPE_NONE)
	
	self.Entity:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self.Entity:SetColor(255, 255, 255, 0)
	
	local RVec = Vector() * 64
	
	self.Entity:PhysicsInitSphere(64)
	self.Entity:SetCollisionBounds(RVec * -1, RVec)
	
	self.Entity:SetTrigger(true)
	self.Entity:DrawShadow(false)
	self.Entity:SetNotSolid(true)
	self.Entity:SetNoDraw(true)
	
	self.Phys = self.Entity:GetPhysicsObject()
	if(self.Phys and self.Phys:IsValid()) then
		self.Phys:Sleep()
		self.Phys:EnableCollisions(false)
	end
	
end

function ENT:KeyValue( key, value )
	self:StoreOutput( key, value )
end

function ENT:Think()
	if !IsValid(self:GetOwner()) then return end
	if !self:GetOwner():Alive() then
		self:Remove()
	end
end

function ENT:Use(ent)
	if !IsValid(self:GetOwner()) || ent != self:GetOwner() then return end
	return true
end

function ENT:StartTouch( ent )
	if !IsValid(ent) || !ent:IsPlayer() || IsValid(self:GetOwner()) || IsValid(ent.PickupEntity) then return end
	if ent:IsZombie() then return end -- no zombies should pick up weapons, etc.
	Msg("OnPlayerPickup: " .. tostring(ent) .. " has picked up " .. tostring(self) .. "\n")
	
	self:TriggerOutput( "OnPlayerPickup", ent )
	
	local boneId = ent:LookupBone("ValveBiped.Bip01_Pelvis")
	local bonePos, boneAng = ent:GetBonePosition(boneId)
	
	self.Entity:SetPos(bonePos)
	self.Entity:SetAngles(ent:GetAngles())
	
	self.Entity:Fire("setparentattachmentmaintainoffset", "forward", 0)
	self.Entity:SetParent(ent)
	
	self:SetOwner(ent)
	ent.PickupEntity = self
end

function ENT:OnRemove()
	self:SetParent(NULL)
	if IsValid(self:GetOwner()) then
		self:GetOwner().PickupEntity = nil
	end
end