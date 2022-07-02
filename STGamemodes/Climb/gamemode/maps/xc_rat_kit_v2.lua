--------------------
-- STBase
-- By Spacetech
--------------------

timer.Create("TestRatsFix", 30, 0, function()
	STGamemodes.TouchEvents:RemoveAll()
	
	STGamemodes.TouchEvents:Setup(Vector(92.71875, 1215.96875, 1720.03125), 64, function(ply)
		ply:SetPos(Vector(776.59375, 1215.96875, 1720.03125))
	end)

	STGamemodes.TouchEvents:Setup(Vector(-119.96875, -87.5, 1200.03125), 64, function(ply)
		ply:SetPos(Vector(-119.96875, -273.84375, 1200.03125))
	end)

	STGamemodes.TouchEvents:Setup(Vector(-625, 432.34375, 56.03125), 64, function(ply)
		ply:SetPos(Vector(-643.40625, 1167.96875, 136.03125))
	end)

	STGamemodes.TouchEvents:Setup(Vector(2023.96875, 1051.0625, 1200.03125), 64, function(ply)
		ply:SetPos(Vector(2093.125, 782.53125, 1185.59375))
	end)

	STGamemodes.TouchEvents:Setup(Vector(1911.96875, -56.90625, 1656.03125), 64, function(ply)
		ply:SetPos(Vector(1049.75, 58.6875, 1766.28125))
	end)
	
	STGamemodes.TouchEvents:Setup(Vector(2118.52, 136.15, 1666.57125), Vector(2246.27, 92.42, 1666.57125), function (ply)
		if !ply.Winner then 
			ply:SetPos(Vector(2389.90, 520.91, 1728.10))
			ply:SetEyeAngles(Angle(0, -90, 0))
		end
	end)
	
	STGamemodes.TouchEvents:Setup(Vector(-463.97, -495.97, 476.03125), Vector(-434.03, 79.97, 512.03125), function (ply)
		ply:SetPos(Vector(-344.88, -360.97, 636.03))
	end)

	STGamemodes.TouchEvents:Setup(Vector(-86.49, -274.19, 1692.26125), Vector(-495.97, 275.19, 1826.45125), function(ply)
		if !ply.Winner then
			ply:SetPos(Vector(-253.73, 1009.27, 1693.03125))
			ply:SetEyeAngles(Angle(0, 0, 0))
		end
	end)
end)

STGamemodes:CreateHostage(Vector(-14050, 560, -14265), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(-14075, 560, -14265), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(-14100, 560, -14265), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(-14125, 560, -14265), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(-14150, 560, -14265), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(-14175, 560, -14265), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(-14200, 560, -14265), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(-14225, 560, -14265), Angle(0, 90, 0))
