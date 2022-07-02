--------------------
-- STBase
-- By Spacetech
--------------------

-- Makes the starting trigger increase the deaths' speed 4 times instead of 1.5.
hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if key == "OnTrigger" and value == "speed,ModifySpeed,1.50,0,-1" then
		return "speed,ModifySpeed,4,0,-1"
	end
end)

hook.Add("OnRoundChange", "EntityHandler", function()
	STRTD:CreateSpeedMod(true)
	
	-- Makes the env_beams fatal.
	for k,v in pairs(ents.FindByClass("env_beam")) do
		v:SetKeyValue("TouchType", "1")
		v:SetKeyValue("OnTouchedByEntity", "!activator,SetHealth,0,0,-1")
	end
end)

STGamemodes.KeyValues:AddChange( "trap5", "dmg", "20" )
STGamemodes.KeyValues:AddChange( "fun_desct", "origin", "4416 2324 0" )
STGamemodes.KeyValues:AddChange( "fun_dest", "origin", "4416 2284 0" )

-- Strips the deaths of their speed in the Kill minigame.
STGamemodes.TouchEvents:Setup(Vector(3616, 1600, -60), 32, function(ply)
	if ply:Team() == TEAM_DEATH then
		ply:ModSpeed(1.5)
	end
end)