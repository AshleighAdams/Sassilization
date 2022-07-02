--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-15507.72, -10034.85, 758.30))
STGamemodes.Weapons:Add(Vector(-7679.67, 2016.44, 18.03))

--[[STGamemodes.TouchEvents:Setup(Vector(-15491, -11616, 40), 32, function()
	STGamemodes:CustomChat("[MAP]", "Welcome! There are 2 bugbaits on this map", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply) 
		return !ply.Winner
	end)
end)

STGamemodes.TouchEvents:Setup(Vector(-15348, -10280, 680), 64, function()
	STGamemodes:CustomChat("[MAP]", "First bugbait is ahead. You can skip it if you wish to do so", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply) 
		return !ply.Winner
	end)
end)

STGamemodes.TouchEvents:Setup(Vector(-15320, -10103, 880), 64, function()
	STGamemodes:CustomChat("[MAP]", "You won't get a higher reward for finishing the map completely", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply) 
		return !ply.Winner
	end)
end)

STGamemodes.TouchEvents:Setup(Vector(-11234, -2453, 310), 64, function()
	STGamemodes:CustomChat("[MAP]", "You are getting closer to the second bugbait", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply) 
		return !ply.Winner
	end)
end)]]

STGamemodes.TouchEvents:Setup(Vector(-15525, -11613, 60), 32, function(ply)
	ply:SetPos(Vector(-15404, -12031, 448.04))
	ply:SetEyeAngles(Angle(0, 90, 0))
end)