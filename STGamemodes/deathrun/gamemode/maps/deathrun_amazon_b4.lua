--------------------
-- STBase
-- By Spacetech
--------------------

-- Prevents players from standing on the edges of the face trap's rising wall, thus avoiding death.
STGamemodes.TouchEvents:Setup(Vector(-2151, -1399, 80), Vector(-2131, -1383, 246), function(ply)
	ply:SetLocalVelocity(Vector(0, -200, 0))
end)

STGamemodes.TouchEvents:Setup(Vector(-2152, -1113, 80), Vector(-2131, -1097, 246), function(ply)
	ply:SetLocalVelocity(Vector(0, 200, 0))
end)

-- Prevents players from running along the edge of the spinning fan trap's wall cover, thus skipping it.
STGamemodes.TouchEvents:Setup(Vector(-2361, 735, 1030), Vector(-1962, 736, 1031), function(ply)
	ply:SetLocalVelocity(Vector(0, -200, 0))
end)

STGamemodes.Buttons:SetupLinkedButtons(16)