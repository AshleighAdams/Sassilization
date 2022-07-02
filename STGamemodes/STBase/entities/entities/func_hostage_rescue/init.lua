--------------------
-- STBase
-- By Spacetech
--------------------

ENT.Type = "brush"
ENT.Base = "base_brush"

function ENT:Initialize()
end

function ENT:StartTouch(ent)
	if(!ent:IsPlayer()) then
		return
	end
	if(ent.GaveDough) then
		return
	end
	ent.GaveDough = true
	ent:ChatPrint("You made it! You earned 500 dough!")
	-- TODO MAKE IT GIVE DOUGH
end

function ENT:EndTouch(ent)
end

function ENT:Touch(ent)
end

function ENT:PassesTriggerFilters(ent)
	return STValidEntity(ent) and ent:IsPlayer()
end
