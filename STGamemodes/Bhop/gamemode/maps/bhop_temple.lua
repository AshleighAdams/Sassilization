--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(10458.6, 393.19, 21.16))

hook.Add("PostKeyValues", "SpawnMover", function()
	for k,v in pairs(ents.FindByClass("info_player_counterterrorist")) do
		v:SetPos(v:GetPos() + Vector(0, 0, 128))
	end
end)

hook.Add("PostKeyValues", "TriggerDestroyer", function()
	for k,v in pairs(ents.FindInSphere(Vector(10545.5, 393, 31), 64)) do
		if v:GetClass() == "trigger_multiple" or v:GetClass() == "trigger_gravity" then
			v:Remove()
		end
	end
end)

local finished = false
STGamemodes.TouchEvents:Setup(Vector(10543, 329, -61), Vector(10545, 457, 123), function(ply)
	if !finished then
		ents.FindByName("spawn_box_break")[1]:Fire("Break")
		ents.FindByName("spawn_box_move")[1]:Fire("Open")
		finished = true
	end
end)