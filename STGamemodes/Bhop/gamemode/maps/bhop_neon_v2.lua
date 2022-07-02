--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(6814, 680, 10.03125))

-- Challenges
STGamemodes.TouchEvents:Setup(Vector(-2265.03, 2889.86, 750.03), Vector(-4281, 2932, 1138), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(-1110, -1688, 943))
		ply:SetEyeAngles(Angle(0, 90, 0))
	end
end)

STGamemodes.TouchEvents:Setup(Vector(-89.03, 2889.86, 750.03), Vector(-2104, 2932, 1138), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(1078, -1674, 943))
		ply:SetEyeAngles(Angle(0, 90, 0))
	end
end)

STGamemodes.TouchEvents:Setup(Vector(2087, 2889.86, 750.03), Vector(71, 2932, 1138), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(3309, -1674, 943))
		ply:SetEyeAngles(Angle(0, 90, 0))
	end
end)

STGamemodes.TouchEvents:Setup(Vector(4263, 2889.86, 750.03), Vector(2247, 2932, 1138), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(3256, 1849, 62.03125))
		ply:SetEyeAngles(Angle(0, -90, 0))
	end
end)



