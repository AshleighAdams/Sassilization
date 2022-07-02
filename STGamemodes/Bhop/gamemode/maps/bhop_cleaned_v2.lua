--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-96, -752, 160))

-- Side wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(1376, -256, 265), Vector(1888, -176, 329), function(ply)
	ply:SetLocalVelocity(Vector(0, 0, 0))
end)