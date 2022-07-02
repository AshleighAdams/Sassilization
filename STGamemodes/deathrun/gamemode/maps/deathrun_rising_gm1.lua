--------------------
-- STBase
-- By Spacetech
--------------------

-- Fix for the health power-up.
STGamemodes.TouchEvents:Setup(Vector(-212.37, -264, 44), 16, function(ply)
	if ply:Team() == TEAM_DEATH then
		ply:SetHealth(ply:Health() + 50)
	end
end)

-- Gives Sass SMGs for the left minigame.
STGamemodes.TouchEvents:Setup(Vector(6800, 1023, -6079), Vector(6848, 1024, -5982), function(ply)
	ply:Give(STGamemodes.RunGun)
end)

-- Gives crossbows for the right minigame.
STGamemodes.TouchEvents:Setup(Vector(6944, 1023, -6079), Vector(6992, 1024, -5982), function(ply)
	ply:Give("weapon_crossbow")
end)