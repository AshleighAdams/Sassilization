--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.KeyValues:AddChange( "pusher_pad", "blockdamage", "10" )

-- Prevents players from walking around the sides of the electric water trap.
STGamemodes.TouchEvents:Setup(Vector(240, -1040, 448), Vector(592, -880, 480), function(ply)
	ply:Kill()
end)

-- Prevents players from jumping around the crossing green lasers trap's frame.
STGamemodes.TouchEvents:Setup(Vector(408, -1280, 720), Vector(424, -1072, 848), function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(408, -848, 720), Vector(424, -640, 848), function(ply)
	ply:Kill()
end)

-- Prevents players from skipping a floor by jumping on the ball from trap 5.
STGamemodes.TouchEvents:Setup(Vector(-768, 128, 80), Vector(-640, 512, 128), function(ply)
	ply:Kill()
end)