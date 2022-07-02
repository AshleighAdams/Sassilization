--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(833, 89, -762))

STGamemodes.KeyValues:AddChange( "a", "target", "telee" )
STGamemodes.KeyValues:AddChange( "Fini", "origin", "2753 -1700 -6772" )
STGamemodes.KeyValues:AddChange( "Ramp11", "origin", "2752 1181 -6065" )

--[[ -- Surf ramp exploit prevention (stage 4).
STGamemodes.TouchEvents:Setup(Vector(1250, 2990, -6333.14), Vector(2211, 4248, -6269.14), function(ply) 
	ply:SetPos(Vector(1728, 4142, -6019.74)) 
	ply:SetEyeAngles(Angle(0, 269.972, 0)) 
end) ]]

-- Surf ramp exploit prevention (stage 7).
STGamemodes.TouchEvents:Setup(Vector(1668, 3965.15, -8654.74), Vector(1692, 4248, -8178.74), function(ply) 
	ply:SetPos(Vector(1341, 4126, -8171.74)) 
	ply:SetEyeAngles(Angle(0, 269.5, 0)) 
end)