--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(1598.1468505859, 4091.7885742188, 1410.03125))

-- Fifth stage winner teleport exploit fix.
hook.Add("PostKeyValues", "TriggerMover", function()
	for k,v in pairs(ents.FindInSphere(Vector(-672.5, 2203, 242.5), 64)) do
		if(v:GetClass() == "trigger_teleport") then
			STGamemodes.KeyValues:AddChange( v, "origin", "-672.5 2203 290.5" )
		end
	end
end)

-- Side wall exploit prevention (surf ramp on the second stage).
STGamemodes.TouchEvents:Setup(Vector(1307, -1153, 316), Vector(2183, 318, 380), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(759, -898, 353.027))
		ply:SetEyeAngles(Angle(0, 0, 0))
	end
end)

STGamemodes.TouchEvents:Setup(Vector(512, -384, 316), Vector(1307, 318, 380), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(759, -898, 353.027))
		ply:SetEyeAngles(Angle(0, 0, 0))
	end
end)

-- Side wall exploit prevention (surf ramp on the third stage).
STGamemodes.TouchEvents:Setup(Vector(-1157, 1014, 520), Vector(2305, 1658, 584), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(176, -200, 89))
		ply:SetEyeAngles(Angle(0, 178.5, 0))
	end
end)

-- Side wall exploit prevention (surf ramp on the fifth stage).
STGamemodes.TouchEvents:Setup(Vector(-1136, 1682, 330), Vector(2289, 1685, 517), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(176, -200, 89))
		ply:SetEyeAngles(Angle(0, 178.5, 0))
	end
end)

STGamemodes.TouchEvents:Setup(Vector(-1159, 2213, 238), Vector(2305, 2237, 583), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(176, -200, 89))
		ply:SetEyeAngles(Angle(0, 178.5, 0))
	end
end)

-- Side wall exploit prevention (jumping around the player clips on stage six).
STGamemodes.TouchEvents:Setup(Vector(-1111, 1721, 659), Vector(-1065, 1839, 953.544), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(176, -200, 89))
		ply:SetEyeAngles(Angle(0, 178.5, 0))
	end
end)

STGamemodes.TouchEvents:Setup(Vector(-1111, 2115, 659), Vector(-1065, 2223, 953.544), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(176, -200, 89))
		ply:SetEyeAngles(Angle(0, 178.5, 0))
	end
end)

-- Side wall exploit prevention (surf ramp on the tenth stage).
STGamemodes.TouchEvents:Setup(Vector(3072, -1224, 1572), Vector(5460, 2368, 1636), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(176, -200, 89))
		ply:SetEyeAngles(Angle(0, 178.5, 0))
	end
end)

-- Side wall exploit prevention (surf ramp on the eleventh stage).
STGamemodes.TouchEvents:Setup(Vector(-4136, -1525, 1457), Vector(-2245, 2477, 1521), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(176, -200, 89))
		ply:SetEyeAngles(Angle(0, 178.5, 0))
	end
end)