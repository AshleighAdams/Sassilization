--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.KeyValues:AddChange( "oldtdt", "origin", "3102 2051 -1945" )

-- Prevents players from jumping around the sides of the fan trap.
STGamemodes.TouchEvents:Setup(Vector(2732, -1637, 16), Vector(3032, -1621, 112), function(ply)
	ply:Kill()
end)

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(4226, -2168, -2324), Vector(4274, -2166, -2276), function(ply)
	if ply:Team() == TEAM_RUN then 
		if !ply:HasWeapon("weapon_crowbar") then
			ply:Give("weapon_crowbar")
		end
		GAMEMODE:TimerEndRoundStart()
	end 
end)