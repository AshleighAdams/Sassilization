--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(255.55, -1311.93, 449.03125))

-- Ladder teleport (some players having problems)
STGamemodes.TouchEvents:Setup(Vector(287.00, -3566.22, -345.00), Vector(217.00, -3566.22, -325.70), function(ply)
	ply:SetPos(Vector(253.48, -3501.26, -90.00))
	ply:SetEyeAngles(Angle(0,90,0))
end)

-- Bonus fix

STGamemodes.TouchEvents:Setup(Vector(-316, -4271, -900.97125), 32, function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(243, 133.5, 125.03125))
		ply:SetEyeAngles(Angle(0, 90, 0))
	end
end)

STGamemodes.TouchEvents:Setup(Vector(282.81, -5550.84, -900.0125), 128, function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(244, 134, 125.03125))
		ply:SetEyeAngles(Angle(0, 90, 0))
	end
end)