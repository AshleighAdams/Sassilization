--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Remove(Vector(1187.96875, 482.59375, -196.53125))
STGamemodes.Weapons:Remove(Vector(780.375, 1363.625, -106.3125))
STGamemodes.Weapons:Remove(Vector(1995.25, 3498.03125, -960.96875))
STGamemodes.Weapons:Remove(Vector(872.90625, 3903.59375, -819.15625))

STGamemodes.TouchEvents:Setup(Vector(283.0625, -126.96875, -205.34375), 64, function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(-250.75, -70.59375, -264.96875), 64, function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(1187.96875, 482.59375, -196.53125), 64, function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(1187.96875, 482.59375, -196.53125), 64, function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(275.9688, -64.7188, -205.3438), 64, function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(-1232.5625, 2594.0313, -854.9375), 64, function(ply)
	ply:SetPos(Vector(-885.7813, 2611.6875, -907.8438))
end)
