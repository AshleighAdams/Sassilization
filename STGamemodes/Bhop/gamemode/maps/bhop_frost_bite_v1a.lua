--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-815.5068359375, 1555.6892089844, 477.03125))

hook.Add("PostKeyValues", "SpawnMover", function()
	for k,v in pairs(ents.FindByClass("info_player_terrorist")) do
		v:SetPos(v:GetPos() + Vector(-16, 0, 0))
	end
end)