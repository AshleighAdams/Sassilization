--------------------
-- STBase
-- By Spacetech
--------------------

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(-1360, -5519, -107), Vector(-1349, -5463, -20), function(ply)
	if ply:Team() == TEAM_RUN then 
		if !ply:HasWeapon("weapon_crowbar") then
			ply:Give("weapon_crowbar")
		end 
		GAMEMODE:TimerEndRoundStart() 
	end 
end)

-- Gives crossbows for the AWP minigame.
STGamemodes.TouchEvents:Setup(Vector(-1360, -5643, -107), Vector(-1349, -5587, -20), function(ply)
	ply:Give("weapon_crossbow")
	if ply:Team() == TEAM_RUN then GAMEMODE:TimerEndRoundStart() end 
end)

STGamemodes.Buttons:SetupLinkedButtons(8)