--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(566.3438, -320.6563, 16.0313))

-- Prevents players from using the drawbridge to jump over the wall that separates the spawn from the ending.
STGamemodes.TouchEvents:Setup(Vector(480, -496, 192), Vector(496, -144, 400), function(ply)
	ply:Kill()
end)

-- Prevents players from getting on top of the map's side walls by getting pushed up by the vertical pusher trap.
STGamemodes.TouchEvents:Setup(Vector(-1456, 1712, 240), Vector(-1024, 2128, 256), function(ply)
	ply:Kill()
end)

-- Prevents players from dropping from the side of the block before the lasers, thus avoiding the trap.
STGamemodes.TouchEvents:Setup(Vector(1664, 1344, -32), Vector(1680, 1776, 232), function(ply)
	ply:Kill()
end)