--------------------
-- STBase
-- By Spacetech
--------------------

-- Side wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(5424, -816, 192), Vector(5456, -704, 304), function(ply)
	ply:SetPos(Vector(160, 160, 101))
end)

STGamemodes.TouchEvents:Setup(Vector(5824, -1120, 192), Vector(5856, -1008, 304), function(ply)
	ply:SetPos(Vector(160, 160, 101))
end)

STGamemodes.TouchEvents:Setup(Vector(5424, 592, 192), Vector(5456, 704, 304), function(ply)
	ply:SetPos(Vector(160, 160, 101))
end)

STGamemodes.TouchEvents:Setup(Vector(5824, 288, 192), Vector(5856, 400, 304), function(ply)
	ply:SetPos(Vector(160, 160, 101))
end)

STGamemodes.TouchEvents:Setup(Vector(6960, 592, 192), Vector(6992, 704, 304), function(ply)
	ply:SetPos(Vector(160, 160, 101))
end)

STGamemodes.TouchEvents:Setup(Vector(7360, 288, 192), Vector(7392, 400, 304), function(ply)
	ply:SetPos(Vector(160, 160, 101))
end)

STGamemodes.Weapons:Add(Vector(-371.69641113281, -418.3489074707, 64.03125))
