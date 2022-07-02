--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-72, -387.97, 375.03125))

-- Prevents players from using the first trap fan's blades to jump onto the side roof and reach the ending.
STGamemodes.TouchEvents:Setup(Vector(280, -48, 107), 36, function(ply)
	ply:Kill()
end)

-- Prevents players from walking along some walls and skipping the barrels if they climb onto the second trap's crusher.
STGamemodes.TouchEvents:Setup(Vector(696, 840, 244), 64, function(ply)
	if ply:Team() == TEAM_RUN then
		ply:Kill()
	end
end)

--[[ STGamemodes.TouchEvents:Setup(Vector(-382.96875, 733.03125, 32.03125), 64, function(ply)
	ply:SetPos(Vector(-846.875, 704.40625, 27))
end) ]]

-- Prevents deaths from hurting the runners passing through the vent trap.
STGamemodes.DamageFilter:Add(Vector(-592, 732, -302), 384, DMG_SLASH)

STGamemodes.Buttons:SetupLinkedButtons(16)