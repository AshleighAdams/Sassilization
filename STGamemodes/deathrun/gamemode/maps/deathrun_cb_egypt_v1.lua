--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.KeyValues:AddChange( "trap09_hurt", "damagetype", "0" )

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(7664, -5392, 96), Vector(7696, -5360, 168), function(ply)
	if(ply:Team() == TEAM_RUN) then
		GAMEMODE:TimerEndRoundStart()
		if !ply:HasWeapon("weapon_crowbar") then 
			ply:Give("weapon_crowbar")
		end 
	end
end)

STGamemodes.Buttons:SetupLinkedButtons(32)