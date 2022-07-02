--------------------
-- STBase
-- By Spacetech
--------------------

-- Removed hostages

--[[ STGamemodes:CreateHostage(Vector(-4658.5, -554.71875, 1280.03125), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-4633.15625, -461.21875, 1280.03125), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-4651.875, -361.28125, 1280.03125), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-4079.625, -343.3125, 1280.03125), Angle(0, 180, 0))
STGamemodes:CreateHostage(Vector(-4083.25, -521.09375, 1280.03125), Angle(0, 180, 0)) ]]

STGamemodes:CreateHostage(Vector(-4081.5, -435.71875, 1280.03125), Angle(0, 180, 0))
STGamemodes:CreateHostage(Vector(-4085.15625, -616.5, 1280.03125), Angle(0, 180, 0))

-- Exploit fix

STGamemodes.TouchEvents:Setup(Vector(1681, -2398, 1214), 200, function(ply)
	if (!ply.Winner) then
		ply:SetPos(Vector(1683, -2838, 1320.03126))
		ply:SetEyeAngles(Angle(21.55, -0.66, 0))
		ply:ChatPrint(ply:CName()..", stop trying to exploit and finish the map legitly instead.")
	end
end)

STGamemodes.TouchEvents:Setup(Vector(2185, -2206, 652), Vector(2391, -2199, 653), function(ply)
	if (!ply.Winner) then
		ply:SetPos(Vector(1683, -2838, 1320.03126))
		ply:SetEyeAngles(Angle(21.55, -0.66, 0))
		ply:ChatPrint(ply:CName().. ", stop trying to exploit and finish the map legitly instead.")
	end
end)