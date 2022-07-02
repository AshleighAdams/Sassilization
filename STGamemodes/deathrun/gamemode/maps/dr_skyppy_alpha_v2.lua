--------------------
-- STBase
-- By Spacetech
--------------------

-- Prevents players from jumping around the "PRO/NOOB" doors.
STGamemodes.TouchEvents:Setup(Vector(-3140, -1536, 64), Vector(-3116, -1280, 232), function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(-3140, -1024, 64), Vector(-3116, -768, 232), function(ply)
	ply:Kill()
end)

-- Kills players if they try using the blades on the falling blades trap to get onto the trap's roof.
STGamemodes.TouchEvents:Setup(Vector(-1856, -256, 256), Vector(-1488, 0, 320), function(ply)
	ply:Kill()
end)

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(-4368, -2016, -1728), Vector(-4334, -1854, -1534), function(ply)
	if !ply:HasWeapon("weapon_crowbar") then
		ply:Give("weapon_crowbar")
	end
end)

STGamemodes.Buttons:SetupLinkedButtons(32)