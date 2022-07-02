--------------------
-- STBase
-- By Spacetech
--------------------

ENT.Type = "brush"
ENT.Base = "base_entity"
ENT.Team = 0

function ENT:Initialize()
	if(!STGamemodes.BuyzoneEntities) then
		STGamemodes.BuyzoneEntities = {}
	end
	table.insert(STGamemodes.BuyzoneEntities, self)
end


function ENT:KeyValue(k,v)
    if k == "TeamNum" then
        self.Team = tonumber(v)
    end
end


function ENT:StartTouch(ent)
	if !self:PassesTriggerFilters(ent) then return end
	ent.IsInBuyzone = true
end


function ENT:EndTouch(ent)
	if !self:PassesTriggerFilters(ent) then return end
	ent.IsInBuyzone = false
end


function ENT:PassesTriggerFilters(ent)
	if !self or !self:IsValid() or !self.Team or !ent or !ent:IsValid() or !ent:IsPlayer() then
		return false
	end 
	return ( self.Team == 0 || ent:Team() == self.Team )
end