--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(4334.73, 3217.83, -567.97125))

hook.Add("PostKeyValues", "SpawnMover", function()
	for k,v in pairs(ents.FindByClass("info_player_counterterrorist")) do
		v:SetPos(v:GetPos() + Vector(0, 0, 128))
	end
end)