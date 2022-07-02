--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-5866, 13348, -6668.97))
STGamemodes.Weapons:Add(Vector(-255, -698, -9917.97))

--[[STGamemodes.TouchEvents:Setup(Vector(-14344, 14300, 40), 64, function()
	STGamemodes:CustomChat("[MAP]", "Welcome! This map includes two bugbaits", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply)
		return !ply.Winner
	end)
end)

STGamemodes.TouchEvents:Setup(Vector(-6339, 13360, -5856), 32, function()
	STGamemodes:CustomChat("[MAP]", "First bugbait is ahead", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply)
		return !ply.Winner
	end)
end)

STGamemodes.TouchEvents:Setup(Vector(-5043, 13380, -6355), 32, function()
	STGamemodes:CustomChat("[MAP]", "Please note: You won't get a higher reward if you continue", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply)
		return !ply.Winner
	end)
end)

STGamemodes.TouchEvents:Setup(Vector(-254, 629, -9237), 64, function()
	STGamemodes:CustomChat("[MAP]", "Second bugbait is ahead", Color(0, 255, 0, 0), Color(0, 255, 0, 0), function(ply)
		return !ply.Winner
	end)
end)]]

-------------------------- Weapon --------------------------
--!! Never disable this if teleports below are disabled !!--
STGamemodes.TouchEvents:Setup(Vector(-15659, 14618, 85), 128, function(ply)
	if !ply:HasWeapon("weapon_crowbar") then
		ply:Give("weapon_crowbar")
	end
end)

--------------------------------- Teleports --------------------------------
--!! Never disable any of these if runners don't have a crowbar !!-- ~~Arcky

--[[STGamemodes.TouchEvents:Setup(Vector(-13079, 14000, -961), 64, function(ply)
	ply:SetPos(Vector(-12914, 14013, 125))
	ply:SetEyeAngles(Angle(0, 0, 0))
end)

STGamemodes.TouchEvents:Setup(Vector(-13692, 13219, -1210), 32, function(ply)
	ply:SetPos(Vector(-13693, 13119, -1234))
	ply:SetEyeAngles(Angle(0, 0, 0))
end)

STGamemodes.TouchEvents:Setup(Vector(-12272, 12193, -2714), 32, function(ply)
	ply:SetPos(Vector(-12213, 12182, -2954))
	ply:SetEyeAngles(Angle(0, 0, 0))
end)

STGamemodes.TouchEvents:Setup(Vector(-4974, 13405, -6450), 32, function(ply)
	ply:SetPos(Vector(-5951, 13222, -6641))
	ply:SetEyeAngles(Angle(0, 180, 0))
end)

STGamemodes.TouchEvents:Setup(Vector(-5388, 13509, -6637), 32, function(ply)
	ply:SetPos(Vector(-5951, 13222, -6641))
	ply:SetEyeAngles(Angle(0, 180, 0))
end)]]

--[[Under no circumstances disable the following teleports]]--
STGamemodes.TouchEvents:Setup(Vector(-14340, 14254, 40), 16, function(ply)
	ply:SetPos(Vector(-14354, 14035, 33))
	ply:SetEyeAngles(Angle(0, -90, 0))
end)

STGamemodes.TouchEvents:Setup(Vector(-6496, 13526, -5730), 16, function(ply)
	if ply:IsAdmin() then
		ply:SetPos(Vector(-254.50, 238, -9121))
		ply:SetEyeAngles(Angle(0, -90, 0))
	end
end)