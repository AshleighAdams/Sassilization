--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(6139.9345703125, -4049.7902832031, 1104.03125))

-- Surf side wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(2416, -2224, 224), Vector(4176, -2208, 752), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(2288, -2488, 65))
	end
end)

STGamemodes.TouchEvents:Setup(Vector(2160, -2768, 224), Vector(3920, -2752, 752), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(2288, -2488, 65))
	end
end)

STGamemodes.TouchEvents:Setup(Vector(2144, -2768, 224), Vector(2160, -2208, 752), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(2288, -2488, 65))
	end
end)

-- Last level side wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(2160, -3968, 224), Vector(3920, -3952, 752), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(2288, -3696, 65))
	end
end)

STGamemodes.TouchEvents:Setup(Vector(2160, -3440, 224), Vector(4176, -3424, 752), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(2288, -3696, 65))
	end
end)