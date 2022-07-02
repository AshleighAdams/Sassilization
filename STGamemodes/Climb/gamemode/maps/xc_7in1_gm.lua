--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes:EnablePitchCheck(true)

STGamemodes:CreateHostage(Vector(-14050, 10975, 8.03), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-14025, 10975, 8.03), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-14000, 10975, 8.03), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-13975, 10975, 8.03), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-13950, 10975, 8.03), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-13925, 10975, 8.03), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-13900, 10975, 8.03), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-13875, 10975, 8.03), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-13850, 10975, 8.03), Angle(0, -90, 0))

-- Spikes fixes

STGamemodes.TouchEvents:Setup(Vector(-6733, 9832, 2110), Vector(-6664.01, 10343.97, 2111), function (ply)
	ply:SetPos(Vector(-6696, 10418, 2205))
end)

STGamemodes.TouchEvents:Setup(Vector(-7224, 9809, 2110), Vector(-6760.03, 9736.03, 2111), function (ply)
	ply:SetPos(Vector(-6696, 9770, 2205))
end)

hook.Add( "PostKeyValues", "RemoveHeliDoors", function()
	ents.FindByName('helidoor1')[1]:Remove()
	ents.FindByName('helidoor2')[1]:Remove()
end )