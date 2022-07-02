--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-1310, -6007, -72))

STGamemodes.TouchEvents:Setup(Vector(7983,  -411, 152), Vector(8466, 501, 203), function(ply) 
	ply:SetPos(Vector(7712, 352, -31)) 
	ply:SetEyeAngles(Angle(0, 103, 0)) 
end )

-- Double surf stage side wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(1911, -4072, 152), Vector(2551, -1576, 203), function(ply) 
	ply:Teleport("8t2")
end)

STGamemodes.TouchEvents:Setup(Vector(-4168, -5562, 152), Vector(-4784, -6548, 180), function(ply) 
	ply:SetPos(Vector(-4476, -6674, -31)) 
	ply:SetEyeAngles(Angle(0,90,0)) 
end )

STGamemodes.TouchEvents:Setup(Vector(-3123, -6839, 152), Vector(-3652, -6894, 180), function(ply) 
	ply:SetPos(Vector(-4476, -6674, -31)) 
	ply:SetEyeAngles(Angle(0,90,0)) 
end )
