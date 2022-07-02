--------------------
-- STBase
-- By Spacetech
--------------------

-- This map should die in a fire

GM.DownSpeed = 50

STGamemodes.Weapons:Add(Vector(-11285.875, 5781.875, -279.96875))

GM:AddIgnorePos(Vector(-11284,48,-381))
GM:AddIgnorePos(Vector(-12151,2968,69))
GM:AddIgnorePos(Vector(-13128,632,232))
GM:AddIgnorePos(Vector(-12160,2936,42))
GM:AddIgnorePos(Vector(-13056,392,172))
GM:AddIgnorePos(Vector(-12160,2832,-50))
GM:AddIgnorePos(Vector(-11144,1314,-310))
GM:AddIgnorePos(Vector(-13056,2784,-355.5))
GM:AddIgnorePos(Vector(-11296,-2096,-404.5))

STGamemodes.TouchEvents:Setup(Vector(-12159.875, 3638.75, 112.03125), 128, function(ply)
	ply:SetPos(Vector(-11283, -3832.625, -367.96875))
end)

STGamemodes.TouchEvents:Setup(Vector(-13048.15625, 1132.46875, 268.03125), 128, function(ply)
	ply:SetPos(Vector(-12174.21875, -2982.125, -39.96875))
end)
