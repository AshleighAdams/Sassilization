--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-452, 11388, -248))

-- Teleporter for the third surf ramp on the penultimate stage.
STGamemodes.TouchEvents:Setup(Vector(-5568, 9088, -256), 256, function(ply)
	ply:SetPos(Vector(-6116, 9728, -64))
	ply:SetLocalVelocity(Vector(0, 0, 0))
end)