--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.KeyValues:AddChange( "Xtrabtn4", "OnPressed", "XtraTrap4-killer,Close,,8.5,-1" )
STGamemodes.KeyValues:AddChange( "trap5-exp", "spawnflags", "10" )
STGamemodes.KeyValues:AddChange( "cage", "blockdamage", "10" )

hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if ent:GetClass() == "env_fire" and key == "health" then
		return "6"
	end
end)

-- Prevents players from getting onto the side walls by either boosting themselves off the crusher trap or using the steam trap as a lift.
STGamemodes.TouchEvents:Setup(Vector(-1120, -960, 420), Vector(1988, -384, 484), function(ply)
	ply:Kill()
end)

-- Prevents players from prespeeding and using the circular frame of the laser trap as a ramp to boost themselves up onto the side walls.
STGamemodes.TouchEvents:Setup(Vector(-752, 1016, 256), Vector(896, 1224, 448), function(ply)
	ply:Kill()
end)

--[[ -- Prevents players from skipping several traps by going through a teleport behind a wall ornament.
STGamemodes.TouchEvents:Setup(Vector(1376, 1028, 188), Vector(1632, 1376, 324), function(ply)
	ply:Kill()
end) ]]

--[[ -- Prevents players from getting out of the map by jumping onto a death's head (also server as a backup for the crusher/steam exploits).
STGamemodes.TouchEvents:Setup(Vector(-2112, -1440, 478), Vector(1728, 3424, 542), function(ply)
	ply:Kill()
end)]]

STGamemodes.Buttons:SetupLinkedButtons(32)