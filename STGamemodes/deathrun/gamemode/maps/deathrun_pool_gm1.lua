--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.KeyValues:AddChange( "lockerpush", "forceclosed", "1" )
STGamemodes.KeyValues:AddChange( "wave", "dmg", "1000" )
STGamemodes.KeyValues:AddChange( "steamhurt", "damage", "50" )

-- Kills players if they get glitched into the hidden room behind the wave.
STGamemodes.TouchEvents:Setup(Vector(5294, 2208, -124), Vector(5424, 2528, 1), function(ply)
	ply:Kill()
end)

-- Prevents deaths from getting out of their zone by boosting themselves off the sloped buttons.
STGamemodes.TouchEvents:Setup(Vector(7552, 2672, 196), Vector(7704, 3120, 260), function(ply)
	ply:SetLocalVelocity(Vector(0, 0, 0))
end)