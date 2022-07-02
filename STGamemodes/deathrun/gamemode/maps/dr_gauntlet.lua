--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-416, 4720, 0))

hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if ent:GetClass() == "trigger_hurt" and key == "origin" and value == "1480 0 -176" then
		return "1480 0 -144"
	end
	if string.match(ent:GetName(), "f_%d_h") and key == "damage" then
		return "40"
	end
end)

hook.Add("OnRoundChange", "SpawnMover", function()
	for k,v in pairs(ents.FindByClass("info_player_terrorist")) do
		v:SetPos(v:GetPos() + Vector(128, 0, 0))
	end
end)

STGamemodes.KeyValues:AddChange( "enter", "dmg", "10" )

--[[ -- Prevents players from getting out of the kill pit on trap 1 by jumping onto some pipes.
STGamemodes.TouchEvents:Setup(Vector(16, -338, 14), Vector(240, -178, 30), function(ply)
	ply:SetLocalVelocity(Vector(0, 0, 0))
end) ]]

-- Prevents deaths from camping the runner teleport destination.
STGamemodes.TouchEvents:Setup(Vector(60, 544, 224), 128, function(ply)
	if ply:Team() == TEAM_DEATH then
		ply:SetPos(Vector(288, 544, 161))
	end
end)