--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(1168, 1504, 16))

-- Stage 9 stairs left wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(992, -896, 160), Vector(1024, -128, 416), function(ply)
	ply:SetPos(Vector(848, -784, 106))
	ply:SetEyeAngles(Angle(0, 180, 0))
end)

-- Stage 9 stairs right wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(672, -640, 160), Vector(704, -128, 416), function(ply)
	ply:SetPos(Vector(848, -784, 106))
	ply:SetEyeAngles(Angle(0, 180, 0))
end)

-- Stage 9 ramp left wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(160, -928, 160), Vector(992, -896, 416), function(ply)
	ply:SetPos(Vector(848, -784, 106))
	ply:SetEyeAngles(Angle(0, 180, 0))
end)

-- Stage 9 ramp right wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(160, -672, 160), Vector(672, -640, 416), function(ply)
	ply:SetPos(Vector(848, -784, 106))
	ply:SetEyeAngles(Angle(0, 180, 0))
end)