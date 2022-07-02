--------------------
-- STBase
-- By Spacetech
--------------------

AddCSLuaFile("cl_init.lua")

ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()
end

function ENT:SetupSphere(Radius, Function)

	self.Entity:SetMoveType(MOVETYPE_NONE)
	-- self.Entity:SetSolid(SOLID_VPHYSICS)
	
	self.Entity:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self.Entity:SetColor(Color(255, 255, 255, 0))

	self.Radius = Radius or 256 -- what's the point of this?
	
	local RVec = Vector(Radius, Radius, Radius)
	
	self.Entity:PhysicsInitSphere(Radius)
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
	
	self:SetOnTouch(Function)
	self:SetEndTouch(Function2)
end

function ENT:SetupBox(Min, Max, Function)

	self.Entity:SetMoveType(MOVETYPE_NONE)
	-- self.Entity:SetSolid(SOLID_VPHYSICS)
	
	self.Entity:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self.Entity:SetColor(Color(255, 255, 255, 0))
	
	local bbox = (Max - Min) / 2 -- determine actual boundaries from world vectors
	self.Entity:SetPos(self.Entity:GetPos() + bbox) -- set pos to midpoint of bbox
	
	self.Entity:PhysicsInitBox(-bbox, bbox)
	self.Entity:SetCollisionBounds(-bbox, bbox)
	
	self.Entity:SetTrigger(true)
	self.Entity:DrawShadow(false)
	self.Entity:SetNotSolid(true)
	self.Entity:SetNoDraw(true)
	
	self.Phys = self.Entity:GetPhysicsObject()
	if(self.Phys and self.Phys:IsValid()) then
		self.Phys:Sleep()
		self.Phys:EnableCollisions(false)
	end
	
	self:SetOnTouch(Function)
	self:SetEndTouch(Function2)
end

function ENT:SetOnTouch(Function)
	self.OnTouch = Function
end

function ENT:StartTouch(Ent)
	if(!Ent or !Ent:IsValid() or !Ent:IsPlayer() or !Ent:Alive()) then
		return
	end
	if(self.OnTouch) then
		local Work, Err = pcall(self.OnTouch, Ent)
		if(!Work) then
			ErrorNoHalt("TouchEvent Error: "..tostring(Err).."\n")
		end
	end
end

function ENT:SetEndTouch(Function)
	self.EndTouch = Function
end 

function ENT:EndTouch(Ent) 
	if(!Ent or !Ent:IsValid() or !Ent:IsPlayer() or !Ent:Alive()) then
		return
	end
	if(self.EndTouch) then
		local Work, Err = pcall(self.EndTouch, Ent)
		if(!Work) then
			ErrorNoHalt("TouchEvent Error(E): "..tostring(Err).."\n")
		end
	end
end 
