--------------------
-- STBase
-- By Spacetech
--------------------

-- Override for the fan trap's push speed.
hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if ent:GetClass() == "trigger_push" and key == "speed" and value == "750" then
		return "550"
	end
end)

-- Removes the invalid runner spawns.
hook.Add("OnRoundChange", "SpawnDestroyer", function()
	for k,v in pairs(ents.FindByClass("info_player_counterterrorist")) do
		if v:GetPos():Distance(Vector(0, -128, 1)) > 136 then
			v:Remove()
		end
	end
end)

-- Prevents deaths from camping the runner teleport destination.
STGamemodes.TouchEvents:Setup(Vector(-1272, 344, -368), Vector(-1264, 424, -256), function(ply)
	ply:SetPos(Vector(-1152, 384, -367))
end)