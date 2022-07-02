--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.KeyValues:AddChange( "theallseeingeyelasersacrafice", "damage", "51" )

function STGamemodes:MassNPCRelationship(ply, Disposition)
	for k,v in pairs(ents.FindByClass("npc_*")) do
		if(v and IsValid(v) and v.AddEntityRelationship) then
			v:AddEntityRelationship(ply, Disposition, 99)
		end
	end
end

function STGamemodes:OnPlayerSpawn(ply, SpecGhost)
	if(SpecGhost) then
		self:MassNPCRelationship(ply, D_LI)
	else
		self:MassNPCRelationship(ply, D_HT)
	end
end

function STGamemodes:OnPlayerDeath(ply)
	self:MassNPCRelationship(ply, D_LI)
end

STGamemodes.Buttons:SetupLinkedButtons({Vector(64, 1640, -8), Vector(136, 1672, 0)})
STGamemodes.Buttons:SetupLinkedButtons({Vector(64, 1680, -8), Vector(136, 1712, 0)})
STGamemodes.Buttons:SetupLinkedButtons({Vector(64, 1720, -8), Vector(136, 1752, 0)})