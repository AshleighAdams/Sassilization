--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(10819, 5504, 130.03))
STGamemodes.Weapons:Add(Vector(6913, 1535, -1277.97))

--[[STGamemodes.TouchEvents:Setup(Vector(5308, 1532, -1250), 64, function()
	STGamemodes:CustomChat("[MAP]", "Welcome! This map has two bugbaits", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply)
		return !ply.Winner
	end)
end)

STGamemodes.TouchEvents:Setup(Vector(10060, 2350, 150), 64, function()
	STGamemodes:CustomChat("[MAP]", "First bugbait is a level ahead", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply)
		return !ply.Winner
	end)
end)

STGamemodes.TouchEvents:Setup(Vector(10382, 5506, 150), 64, function()
	STGamemodes:CustomChat("[MAP]", "You won't get a higer reward if you continue", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply)
		return !ply.Winner
	end)
end)

STGamemodes.TouchEvents:Setup(Vector(2584, 9135, 2150), 64, function()
	STGamemodes:CustomChat("[MAP]", "You are getting closer to the second bugbait", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply)
		return !ply.Winner
	end)
end)]]