--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Remove(Vector(-1165, 1583, 415))

-- Prevents players from surfing up the side of a wall right before the shooting dollars trap.
STGamemodes.TouchEvents:Setup(Vector(-831, 1086, 576), Vector(-752, 1152, 704), function(ply)
	ply:SetPos(Vector(-929, 913, 577))
	ply:SetEyeAngles(Angle(0, 0, 0))
end)

-- Prevents players from jumping onto the side wall on the appearing dollar signs trap.
STGamemodes.TouchEvents:Setup(Vector(961, -130, 740), Vector(1025, 578, 804), function(ply)
	ply:SetPos(Vector(705, 223.5, 635))
	ply:SetEyeAngles(Angle(0, 270, 0))
end)

-- Prevents players from jumping from the last stage to the stools below.
STGamemodes.TouchEvents:Setup(Vector(-124.5, -1335, 539), Vector(387.5, -823, 603), function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(-2765, -1241, 699), Vector(-2300, -827, 763), function(ply)
	ply:Kill()
end)

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(1593, -1108, 776), Vector(1688, -1106, 915), function(ply)
	if ply:Team() == TEAM_RUN then 
		if !ply:HasWeapon("weapon_crowbar") then
			ply:Give("weapon_crowbar")
		end
		GAMEMODE:TimerEndRoundStart()
	end 
end)

--[[ -- Gives crossbows for the Old minigame.
STGamemodes.TouchEvents:Setup(Vector(1593, -1108, 776), Vector(1688, -1106, 915), function(ply)
	ply:Give("weapon_crossbow")
end) ]]

-- Prevents deaths from camping the runner spawn on the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(1414, 61, 993), 128, function(ply)
	ply:SetPos(Vector(1412.5, 564.5, 938))
end)

STGamemodes.Buttons:SetupLinkedButtons(48)