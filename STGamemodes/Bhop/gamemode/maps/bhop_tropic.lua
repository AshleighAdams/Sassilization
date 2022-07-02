--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(3108.0625, -2563.84375, 72.03125))

-- Moves the 7th platform on the "window" bit out of the way so that people don't accidentally teleport back.
hook.Add("PostKeyValues", "TriggerMover", function()
	for k,v in pairs(ents.FindInSphere(Vector(-8837, -6414, 2436), 24)) do
		if(v:GetClass() == "trigger_teleport") then
			STGamemodes.KeyValues:AddChange( v, "origin", "-8837 -6276 2436" )
		end
	end
end)

-- Moves the trigger that restarts the ending song every time it's touched.
hook.Add("PostKeyValues", "TriggerMover", function()
	for k,v in pairs(ents.FindInSphere(Vector(2781, -2825, 248), 128)) do
		if(v:GetClass() == "trigger_multiple") then
			STGamemodes.KeyValues:AddChange( v, "origin", "-6140 1664 117.5" )
		end
	end
end)

STGamemodes.KeyValues:AddChange( "square6", "origin", "-5870 248 161" )

--[[ STGamemodes.TouchEvents:Setup(Vector(-6586, -5801.53125, 2888.03125), 64, function(ply)
	ply:SetPos(Vector(-5849.71875, -5798.375, 2688.03125))
end) ]]

--[[ STGamemodes.TouchEvents:Setup(Vector(-8366, -6588, 2394), Vector(-8302, -6564, 2458), function(ply)
	ply:SetPos(Vector(4998, -5764, 171))
end) ]]

-- Prevents players from going behind the credits sign and crashing the server.
STGamemodes.TouchEvents:Setup(Vector(2769, -1919, 796), 96, function(ply)
	ply:SetPos(Vector(2775, -2833, 276))
	ply:SetEyeAngles(Angle(0, 0, 0))
end)