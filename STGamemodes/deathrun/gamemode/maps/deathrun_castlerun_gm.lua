--------------------
-- STBase
-- By Spacetech
--------------------

GM.RunnerWeapon = "weapon_crowbar"

-- Kill volume for the bottom of the map.
STGamemodes.TouchEvents:Setup(Vector(-2190, -2533, -1277.71), Vector(4002, 3405, -1213.71), function(ply)
	ply:Kill()
end)

STGamemodes.Buttons:SetupLinkedButtons(32)