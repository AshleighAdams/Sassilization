--------------------
-- STBase
-- By Spacetech
--------------------

-- Removes the trigger that strips a death's scythe.
hook.Add("OnRoundChange", "TriggerDestroyer", function()
	for k,v in pairs(ents.FindInSphere(Vector(-928, 4608, 8), 32)) do
		if(v:GetClass() == "trigger_once") then
			v:Remove()
		end
	end
end)

STGamemodes.KeyValues:AddChange( "CTOld", "origin", "-976 4576 160" )

-- Prevents players from jumping onto the sides of the moving blades trap.
STGamemodes.TouchEvents:Setup(Vector(-8704, -1408, 24), Vector(-8688, -896, 104), function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(-7952, -1408, 24), Vector(-7936, -896, 104), function(ply)
	ply:Kill()
end)

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(5055, 9791, -2048), Vector(5185, 9921, -2015), function(ply)
	if ply:Team() == TEAM_RUN then 
		if !ply:HasWeapon("weapon_crowbar") then
			ply:Give("weapon_crowbar")
		end
		GAMEMODE:TimerEndRoundStart()
	end 
end)