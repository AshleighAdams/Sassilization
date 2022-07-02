--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.KeyValues:AddChange( "trap2", "blockdamage", "250" )
STGamemodes.KeyValues:AddChange( "trap3", "dmg", "250" )

-- Prevents players from jumping onto the side walls and deaths' window glass from the top of the spinner trap.
STGamemodes.TouchEvents:Setup(Vector(253, 767, 256.03), Vector(832, 783, 384), function(ply)
	ply:Kill()
end)

-- Prevents players from jumping onto the deaths' window glass from the top of the moving spike hammer trap.
STGamemodes.TouchEvents:Setup(Vector(-384, -704, 256.21), Vector(-383, 768, 257.21), function(ply)
	ply:Kill()
end)

--[[ STGamemodes.TouchEvents:Setup(Vector(545.1875, -369.09375, 514.75), 64, function(ply)
	ply:SetPos(Vector(267.1875, -13.75, 512.03125))
end) ]]