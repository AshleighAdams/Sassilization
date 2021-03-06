AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_NONE)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:DrawShadow(false)
	self.Entity:SetNotSolid(true)
end

function ENT:Think()
	if(!STValidEntity(self.Entity:GetOwner())) then
		self.Entity:Remove()
	end
	self.Entity:NextThink(CurTime() + 10)
	return true
end