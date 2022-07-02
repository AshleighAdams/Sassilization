--------------------
-- STBase
-- By Spacetech
--------------------

-- Prevents players from crouching up against the shooting boxes trap, thus avoiding damage.
STGamemodes.TouchEvents:Setup(Vector(1008, -1920, 0), Vector(1024, -1664, 64), function(ply)
	ply:SetLocalVelocity(Vector(-400, 0, 0))
end)

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(2048, -1920, 0), Vector(2816, -1216, 256), function(ply)
	if(ply:Team() == TEAM_RUN and !ply:HasWeapon("weapon_crowbar")) then
		ply:Give("weapon_crowbar")
	end
end)

-- Easy minigame glass bug bypass.
STGamemodes.TouchEvents:Setup(Vector(2248, -1144, 8), Vector(2360, -968, 15), function(ply)
	ply:SetPos(Vector(2232, -1056, 16))
end)

STGamemodes.Buttons:SetupLinkedButtons(16)