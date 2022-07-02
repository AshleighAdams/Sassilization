--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(1031.3260498047, 754.92547607422, 4236.5805664063))

hook.Add("PostKeyValues", "TriggerMover", function()
	for k,v in pairs(ents.FindInSphere(Vector(-6112, 32, 7936), 4)) do
		if(v:GetClass() == "trigger_teleport") then
			STGamemodes.KeyValues:AddChange( v, "origin", "-6112 32 7932" )
		end
	end
end)

-- Prevents players from surfing on the side walls of the river in China.
STGamemodes:AddPitchArea(Vector(9934.94, 1663.96, 4993.33), 2048)