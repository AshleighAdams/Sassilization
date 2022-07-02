--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(2720, 10816, -224))

-- Makes the long boost pad near the end more powerful.
hook.Add("PostKeyValues", "KeyValueChanger", function()
	for k,v in pairs(ents.FindInSphere(Vector(-16, 10816, -1288), 1536)) do
		if(v:GetClass() == "func_door") then
			STGamemodes.KeyValues:AddChange( v, "speed", "700" )
		end
	end
end)

-- Moves the restart teleport so it doesn't protrude out of the door.
hook.Add("PostKeyValues", "TriggerMover", function()
	for k,v in pairs(ents.FindInSphere(Vector(2798, 10816, -112), 128)) do
		if(v:GetClass() == "trigger_teleport") then
			STGamemodes.KeyValues:AddChange( v, "origin", "2825 10816 -112" )
		end
	end
end)

-- Teleporter for the broken booster block at the end.
STGamemodes.TouchEvents:Setup(Vector(2460, 10780, -1472), Vector(2532, 10852, -1440), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(2656, 10816, -223))
		ply:SetEyeAngles(Angle(0, 0, 0))
	end
end)