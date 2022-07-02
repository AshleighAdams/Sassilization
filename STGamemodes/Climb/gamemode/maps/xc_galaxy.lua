--------------------
-- STBase
-- By Spacetech
--------------------

--[[ -- Ramp exploit fix.
STGamemodes.TouchEvents:Setup(Vector(2176, 3648, 576), 256, function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(480, 3520, 65))
		ply:SetEyeAngles(Angle(0, 0, 0))
	end
end) ]]

--[[ -- Boost pad exploit fix.
STGamemodes.TouchEvents:Setup(Vector(2408, 3712, 2176), Vector(2424, 5088, 3072), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(2612, 4896, 2209))
		ply:SetEyeAngles(Angle(0, -90, 0))
	end
end) ]]

-- Finish teleport.
STGamemodes.TouchEvents:Setup(Vector(740, 3544.64, 2684.64), 48, function(ply)
	ply:SetPos(Vector(1456, -2680, 1584))
	ply:SetEyeAngles(Angle(0, 90, 0))
end)

STGamemodes:CreateHostage(Vector(890, -2625, 1582), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(890, -2600, 1582), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(890, -2575, 1582), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(890, -2550, 1582), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(890, -2525, 1582), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(890, -2500, 1582), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(890, -2475, 1582), Angle(0, 0, 0))