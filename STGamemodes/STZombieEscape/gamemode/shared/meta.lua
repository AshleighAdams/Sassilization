--------------------
-- STBase
-- By Spacetech
--------------------

local Alive = STGamemodes.PlayerMeta.Alive

function STGamemodes.PlayerMeta:Alive()
	if(STValidEntity(self) and self:Team() == TEAM_DEAD) then
		return false
	end
	return Alive(self)
end

function STGamemodes.PlayerMeta:IsZombie()
	return self:Team() == TEAM_ZOMBIES
end
