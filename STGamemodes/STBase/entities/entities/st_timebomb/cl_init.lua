--------------------
include("shared.lua")

ENT.AddPos = false
ENT.SpriteColor = Color(50, 100, 150, 255)
ENT.PickupMat = Material("effects/select_ring")

local QuadSize = 50
local CircleSize = 75

-- Based on weapon_spawn
-- ^ <3
function ENT:Draw()

	QuadSize = QuadSize + 10
	if QuadSize > 1000 then
		QuadSize = 50
		self.Entity:EmitSound( "buttons/blip2.wav", 511, 255 )
	end 

	self.Entity:SetAngles(Angle(0, RealTime() * 50, 0))
	
	self.Entity:SetColor( Color(255, 255, 255, 150 ))
	self.Entity:DrawModel()
	
	render.SetMaterial(self.PickupMat)
	render.DrawQuadEasy(self.Entity:GetPos()-Vector(0,0,75), vector_up, QuadSize, QuadSize, self.SpriteColor)
end

function ENT:DrawTranslucent()
	self:Draw()
end
