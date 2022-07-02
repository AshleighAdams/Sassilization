--------------------
-- STBase
-- By Spacetech
--------------------

-- Extends the size of the red floor lift trap's kill volume.
STGamemodes.TouchEvents:Setup(Vector(534, 8, 644), Vector(1198, 768, 657), function(ply)
	ply:Kill()
end)

-- Prevents players from getting boosted up to the side wall on the red floor lift trap.
STGamemodes.TouchEvents:Setup(Vector(978, 529, 544), Vector(1198, 768, 644), function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(1182, 8, 544), Vector(1198, 529, 644), function(ply)
	ply:Kill()
end)

-- Prevents deaths from getting on top of and camping the window through which runners enter.
STGamemodes.TouchEvents:Setup(Vector(-534, 400, 572), Vector(-512, 489, 651), function(ply)
	if ply:Team() == TEAM_DEATH then
		ply:SetLocalVelocity(Vector(300, 0, 0))
	end
end)

-- Prevents deaths from getting out of their zone by boosting themselves off the sloped buttons.
STGamemodes.TouchEvents:Setup(Vector(-534, -534, 592), Vector(534, 218, 660), function(ply)
	if ply:Team() == TEAM_DEATH then
		ply:SetLocalVelocity(Vector(0, 0, 0))
	end
end)

STGamemodes.Buttons:SetupLinkedButtons(16)