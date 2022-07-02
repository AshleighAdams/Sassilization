--------------------
-- STBase
-- By Spacetech
--------------------

-- Kills players if they go into the secret room beside the spinning boulder trap.
STGamemodes.TouchEvents:Setup(Vector(-1188, 256, -974), Vector(-1016, 400, -832), function(ply)
	ply:Kill()
end)

-- Prevents players from jumping around the exploding chamber trap's sides.
STGamemodes.TouchEvents:Setup(Vector(-996, -22, -940), Vector(-916, -6, -815), function(ply)
	ply:Kill()
end)

STGamemodes.TouchEvents:Setup(Vector(-688, -22, -940), Vector(-608, -6, -815), function(ply)
	ply:Kill()
end)

STGamemodes.Buttons:SetupLinkedButtons(16)