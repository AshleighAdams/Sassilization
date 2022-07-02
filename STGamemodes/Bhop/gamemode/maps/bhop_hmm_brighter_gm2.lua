--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(2633.4143066406, -929.32696533203, 100.03125))

-- Side wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(2416, -2224, 224), Vector(4176, -2208, 752), function(ply)
	ply:SetPos(Vector(2288, -2488, 65))
end)

STGamemodes.TouchEvents:Setup(Vector(2160, -2768, 224), Vector(3920, -2752, 752), function(ply)
	ply:SetPos(Vector(2288, -2488, 65))
end)

STGamemodes.TouchEvents:Setup(Vector(2144, -2768, 224), Vector(2160, -2208, 752), function(ply)
	ply:SetPos(Vector(2288, -2488, 65))
end)
