--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-1216, 3584, 0.03125))

-- Makes the pushing wall trap stick out a bit so that players can't walk along the edge.
hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if key == "origin" and value == "4448 640 64" then
		return "4447 640 64"
	end
end)

STGamemodes.KeyValues:AddChange( "trap16", "lip", "1" )

-- Allows players to pass the moving wall trap without it having to be used first.
STGamemodes.TouchEvents:Setup(Vector(2480, 1472, 0), Vector(2496, 1600, 128), function(ply)
	ply:SetPos(Vector(2592, 1536, 1))
	ply:SetEyeAngles(Angle(0, 0, 0))
end)

--[[ -- Prevents players from running along the edge of the pushing wall trap, thus avoiding death.
STGamemodes.TouchEvents:Setup(Vector(4241, 512, 0), Vector(4257, 768, 128), function(ply)
	ply:SetLocalVelocity(Vector(-200, 0, 0))
end) ]]

STGamemodes.Buttons:SetupLinkedButtons(16)