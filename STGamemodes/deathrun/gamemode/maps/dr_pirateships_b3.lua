--------------------
-- STBase
-- By Spacetech
--------------------

-- Avoids deaths/runners getting over the fence.

STGamemodes.TouchEvents:Setup(Vector(-189, 644, 935), 128, function(ply)
	if ply:Team() == TEAM_RUN then
		ply:SetPos(Vector(-222, 925, 672.03126))
		ply:SetEyeAngles(Angle(4, 32, 0))
		
	elseif ply:Team() == TEAM_DEATH then
		ply:SetPos(Vector(197, 498, 672.03126))
		ply:SetEyeAngles(Angle(2.2, 19.5, 0))
	end
end)

-- Stops deaths from using the secret to get to Runners' side.

STGamemodes.TouchEvents:Setup(Vector(-484, 630, 712), 128, function(ply)
	if (ply:Team() == TEAM_DEATH) then
		ply:SetPos(Vector(158, 525, 672.03126))
		ply:SetEyeAngles(Angle(0, 0, 0))
	end
end)