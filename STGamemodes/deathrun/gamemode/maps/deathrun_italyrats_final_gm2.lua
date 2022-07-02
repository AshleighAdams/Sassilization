--------------------
-- STBase
-- By Spacetech
--------------------

-- Moves the grenade in the Knife minigame teleporter so it can't be picked up prior to the door breaking.
hook.Add("OnRoundChange", "WeaponMover", function()
	for k,v in pairs(ents.FindByClass("weapon_hegrenade")) do
		STGamemodes.KeyValues:AddChange( v, "origin", "-2352.58 660.57 -784" )
	end
end)

-- Prevents players from getting on top of the map's sides by strafeclimbing the secret ladder.
STGamemodes.TouchEvents:Setup(Vector(-1280, 2816, -144), 64, function(ply)
	ply:SetPos(Vector(-1280, 2288, -799))
	ply:SetEyeAngles(Angle(0, 90, 0))
end)

-- Prevents people from jumping around the upward pusher fan trap.
STGamemodes.TouchEvents:Setup(Vector(224, 1296, -800), Vector(400, 1312, -688), function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(784, 1296, -800), Vector(960, 1312, -688), function(ply)
	ply:Kill()
end)

-- Kills players if they try skipping several traps by going onto the roof via the upward pusher fan trap.
STGamemodes.TouchEvents:Setup(Vector(976, -1488, -32), Vector(2992, 2256, 353), function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(2320, 720, 544), Vector(2896, 1296, 641), function(ply)
	ply:Kill()
end)

-- Fix for the secret teleporter on the giant door.
STGamemodes.TouchEvents:Setup(Vector(928, -81, -224), Vector(976, -80, -32), function(ply)
	ply:SetPos(Vector(640, -864, -800))
	ply:SetEyeAngles(Angle(0, 180, 0))
end)

STGamemodes.Buttons:SetupLinkedButtons(16)