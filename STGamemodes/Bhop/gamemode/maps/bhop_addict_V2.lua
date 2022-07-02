--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-3634.0123456789, -2145.0123456789, -48.03125))

-- Teleport for the water on stage 8 (LJ).
STGamemodes.TouchEvents:Setup(Vector(-2138, 1868, -448), Vector(1776, 2879, -292), function(ply)
	ply:Teleport("ljbhop")
end)

-- Fix for the teleport exploit on stage 9.
STGamemodes.TouchEvents:Setup(Vector(654, 14, -785), Vector(1147, 708, -721), function(ply)
	ply:SetPos(Vector(5764.5, 107, 144))
	ply:SetEyeAngles(Angle(0, 183, 0))
end)

-- Fix for the wallsurf exploit on stage 10.
STGamemodes.TouchEvents:Setup(Vector(3050, -7104.5, -2060), Vector(3290, -4955.5, -1151), function(ply)
	ply:SetPos(Vector(2984, -7680, -1062))
	ply:SetEyeAngles(Angle(0, 143, 0))
end)

-- Prevents players from using the fan boost on stage 5 to boost themselves up its side and skip the stage.
STGamemodes.TouchEvents:Setup(Vector(-5599, 548, -1409), Vector(-5391, 564, 224), function(ply)
	ply:Teleport("pipelevel")
end)