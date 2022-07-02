--------------------
-- STBase
-- By Spacetech
--------------------

-- Prevents players from jumping onto the side of the lava bucket trap, thus skipping it.
STGamemodes.TouchEvents:Setup(Vector(-820, 373, 177), Vector(-612, 400, 193), function(ply)
	ply:SetLocalVelocity(Vector(0, 0, 0))
end)

-- Prevents players from jumping onto the exploding gas tank's side pipe, thus skipping it.
STGamemodes.TouchEvents:Setup(Vector(750, -7206, 441), Vector(776, -7170, 457), function(ply)
	ply:SetLocalVelocity(Vector(0, 0, 0))
end)