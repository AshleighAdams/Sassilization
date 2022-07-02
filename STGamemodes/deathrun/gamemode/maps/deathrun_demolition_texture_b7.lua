--------------------
-- STBase
-- By Spacetech
--------------------

-- Prevents deaths from prespeeding and exiting the teleporter room.
STGamemodes.TouchEvents:Setup(Vector(-640, -1328, 0), Vector(-624, -1232, 108), function(ply)
	if ply:Team() == TEAM_DEATH then
		ply:SetLocalVelocity(Vector(300, 0, 0))
	end
end)