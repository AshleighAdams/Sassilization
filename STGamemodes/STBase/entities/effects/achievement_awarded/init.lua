--------------------
-- STBase
-- By Spacetech
--------------------

-- Balloon pop without sound
-- + Some tweaks

function EFFECT:Init(data)
	local vOffset = data:GetOrigin()
	
	local Emitter = ParticleEmitter(vOffset, true)
	
	for i=1,64 do
		local Pos = Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1))
	
		local Particle = Emitter:Add("particles/balloon_bit", vOffset + (Pos * 4))
		if(Particle) then
			Particle:SetVelocity(Pos * 75)
			
			Particle:SetLifeTime(0)
			Particle:SetDieTime(3)
			
			Particle:SetStartAlpha(255)
			Particle:SetEndAlpha(255)
			
			local Size = math.Rand(1, 3)
			Particle:SetStartSize(Size)
			Particle:SetEndSize(0)
			
			Particle:SetRoll(math.Rand(0, 360))
			Particle:SetRollDelta(math.Rand(-2, 2))
			
			Particle:SetAirResistance(0)
			Particle:SetGravity(Vector(0, 0, -200))
			
			Particle:SetColor(math.random(255), math.random(255), math.random(255))
			
			Particle:SetCollide(true)
			
			Particle:SetAngleVelocity(Angle(math.Rand(-160, 160), math.Rand(-160, 160), math.Rand(-160, 160))) 
			
			Particle:SetBounce(1)
			Particle:SetLighting(true)
		end
	end
	
	Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
