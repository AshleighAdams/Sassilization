--------------------
-- STBase
-- By Spacetech
--------------------

-- Laser exploits
STGamemodes.TouchEvents:Setup(Vector(-670, -1631, 880), 32, function(ply)
	ply:SetPos(Vector(-286, -1506, 850.05))
	ply:SetEyeAngles(Angle(0, 180, 0))
end)

STGamemodes.TouchEvents:Setup(Vector(-670, -1380, 880), 32, function(ply)
	ply:SetPos(Vector(-286, -1506, 850.05))
	ply:SetEyeAngles(Angle(0, 180, 0))
end)

-- Noob Box
STGamemodes.TouchEvents:Setup(Vector(-1527, 997.97, 640), 16, function(ply)
	ply:Ignite(60)
end)