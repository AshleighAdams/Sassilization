--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Remove(Vector(-2608.03125, 111.96875, -62.3125))

STGamemodes.TouchEvents:Setup(Vector(-2869.6802, 943.7489, 465.5313), 64, function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(-1021, 990, 320), 64, function(ply)
	ply:SetPos(Vector(-1232, 1442, 384.05))
	ply:SetEyeAngles(Angle(0, -90, 0))
end)
