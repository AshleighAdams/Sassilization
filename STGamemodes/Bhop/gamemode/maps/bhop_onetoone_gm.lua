--------------------
-- STBase
-- By Spacetech
--------------------

-- Side wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(1688, -896, -320), Vector(1704, -832, -256), function(ply)
	ply:SetPos(Vector(1008, -864, -332))
	ply:SetEyeAngles( Angle( 0, 0, 0 ) )
end)

STGamemodes.TouchEvents:Setup(Vector(1560, -896, -320), Vector(1576, -832, -256), function(ply)
	ply:SetPos(Vector(1008, -864, -332))
	ply:SetEyeAngles( Angle( 0, 0, 0 ) )
end)

STGamemodes.TouchEvents:Setup(Vector(1432, -896, -320), Vector(1448, -832, -256), function(ply)
	ply:SetPos(Vector(1008, -864, -332))
	ply:SetEyeAngles( Angle( 0, 0, 0 ) )
end)

STGamemodes.TouchEvents:Setup(Vector(128, -872, -320), Vector(192, -856, -256), function(ply)
	ply:SetPos(Vector(-400, -864, -332))
	ply:SetEyeAngles( Angle( 0, 0, 0 ) )
end)

STGamemodes.TouchEvents:Setup(Vector(-104, -896, -320), Vector(-88, -832, -256), function(ply)
	ply:SetPos(Vector(-400, -864, -332))
	ply:SetEyeAngles( Angle( 0, 0, 0 ) )
end)

STGamemodes.Weapons:Add(Vector(1600.0012345678, 988.0012345678, -3839.45125))