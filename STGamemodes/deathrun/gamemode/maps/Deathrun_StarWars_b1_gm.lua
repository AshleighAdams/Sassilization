--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(2362, -1002, -625))
-- STGamemodes.Weapons:Add(Vector(4205.3486, 431.1343, 96.9433))

-- Removes the AFK killer.
hook.Add("OnRoundChange", "TrainDestroyer", function()
	for k,v in pairs(ents.FindInSphere(Vector(-818.51, 1299, 59.56), 64)) do
		if(v:GetClass() == "func_tanktrain") then
			v:Remove()
		end
	end
end)

--[[ STGamemodes.TouchEvents:Setup(Vector(4203.5034, 432.2567, 67.0313), 64, function(ply)
	if(ply:Team() == TEAM_RUN) then
		ply:SetPos(Vector(4094.6521, 274.8124, 94.1212))
	end
end) ]]

STGamemodes.Buttons:SetupLinkedButtons(16)