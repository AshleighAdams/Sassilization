--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-2303.99609375, -4715.673828125, -463.96875))

hook.Add("PostKeyValues", "SpawnMover", function()
	for k,v in pairs(ents.FindInSphere(Vector(32, 112, 16), 16)) do
		if(v:GetClass() == "info_player_terrorist") then
			STGamemodes.KeyValues:AddChange( v, "origin", "96 -208 16" )
		end
	end
end)