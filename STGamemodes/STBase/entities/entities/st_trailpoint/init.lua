--------------------
-- STBase
-- By Spacetech
--------------------

AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Trail = false

function ENT:SetTrail(Trail)
	self.Trail = Trail
end

function ENT:OnRemove()
	if(self.Trail and self.Trail:IsValid()) then
		self.Trail:Remove()
	end
end
