--------------------
-- STBase
-- By Spacetech
--------------------

--[[ hook.Add("OnRoundChange", "TrapDestroyer", function()
	for k,v in pairs(ents.FindInSphere(Vector(2925.4897460938, -496.20233154297, 0.03125), 256)) do
		if(v:GetClass() == "func_door") then
			v:Remove()
		end
	end
end) ]]

--[[ STGamemodes.TouchEvents:Setup(Vector(3198.5625, -402.65625, 51.65625), 64, function(ply)
	ply:SetPos(Vector(3232.8125, -1131.5625, 1.5))
end)

STGamemodes.TouchEvents:Setup(Vector(3237.71875, -402.75, 51.6875), 64, function(ply)
	ply:SetPos(Vector(3232.8125, -1131.5625, 1.5))
end) ]]

-- Prevents deaths from camping the final door.
STGamemodes.TouchEvents:Setup(Vector(-4399, -1096, 49.5), 128, function(ply)
	if ply:Team() == TEAM_DEATH then
		ply:SetPos(Vector(-4143, -1096, 1))
	end
end)

STGamemodes.Buttons:SetupLinkedButtons(16)