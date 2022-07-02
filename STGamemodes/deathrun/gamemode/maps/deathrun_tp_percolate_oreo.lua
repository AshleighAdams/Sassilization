--------------------
-- STBase
-- By Spacetech
--------------------

-- Prevents deaths from camping the runner teleport destination.
STGamemodes.TouchEvents:Setup(Vector(-256, 1424, 0), 128, function(ply)
	if(ply:Team() == TEAM_DEATH) then
		ply:SetPos(Vector(200, 1416, -63))
	end
end)