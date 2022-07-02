--------------------
-- STBase
-- By Spacetech
--------------------

ENT.Type = "point"
ENT.Base = "base_point"

function ENT:Initialize()
	if(!STGamemodes.HostageEntities) then
		STGamemodes.HostageEntities = {}
	end
	table.insert(STGamemodes.HostageEntities, self)
end
