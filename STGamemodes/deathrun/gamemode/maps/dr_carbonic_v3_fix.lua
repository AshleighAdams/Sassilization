--------------------
-- STBase
-- By Spacetech
--------------------

-- Precision walking trap floor kill volume.
STGamemodes.TouchEvents:Setup(Vector(2426, -384, -48), Vector(3342, 128, -32), function(ply)
	ply:Kill()
end)

-- Prevents players from passing all the way through the laser-barricaded room, thus skipping the vent section.
STGamemodes.TouchEvents:Setup(Vector(1851, -1792, 14), Vector(1860, -1538, 128), function(ply)
	ply:Kill()
end)

-- Makes sure that the players don't survive the airlock trap if they're sucked out.
STGamemodes.TouchEvents:Setup(Vector(276, -2112, 16), Vector(816, -1936, 240), function(ply)
	ply:Kill()
end)

STGamemodes.Buttons:SetupLinkedButtons(32)