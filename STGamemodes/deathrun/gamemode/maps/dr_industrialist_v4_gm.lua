--------------------
-- STBase
-- By Spacetech
--------------------

-- Push trap conveyor belt fix.
hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if ent:GetClass() == "trigger_push" and key == "speed" and value == "256" then
		return "300"
	end
end)

STGamemodes.KeyValues:AddChange( "DoomsDay_SecondHand", "dmg", "250" )

--[[ -- Kills players if they try jumping on top of the crusher trap.
STGamemodes.TouchEvents:Setup(Vector(3184, 1120, 294), Vector(3312, 1252, 415), function(ply)
	ply:Kill()
end) ]]

-- Prevents players from getting on top of the spinner trap's sides.
STGamemodes.TouchEvents:Setup(Vector(3072, 1936, 280), Vector(3424, 2210, 344), function(ply)
	ply:Kill()
end)

-- Prevents players from jumping around the roller water trap.
STGamemodes.TouchEvents:Setup(Vector(2976, 3056, 156), Vector(3520, 3072, 245), function(ply)
	ply:SetPos(Vector(3248, 2816, 195))
	ply:SetEyeAngles(Angle(0, 90, 0))
end)