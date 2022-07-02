--------------------
-- STBase
-- By Spacetech
--------------------

DIFFICULTY_EASY 		= GM:AddDifficulty("Easy", "map_brush_1")
DIFFICULTY_HARD			= GM:AddDifficulty("Hard", "map_brush_2")
DIFFICULTY_EXTREME		= GM:AddDifficulty("Extreme", "map_brush_3")
DIFFICULTY_GODMODE		= GM:AddDifficulty("God Mode", "map_brush_4")
DIFFICULTY_IMPOSSIBLE	= GM:AddDifficulty("Impossible", "map_brush_5")


GM:AddBoss("Exorath", "boss_model", "boss_hitbox")
GM:AddBoss("Exorath Duplicate", "boss_dup_model", "boss_dup_hitbox")

STGamemodes.TouchEvents:Setup(Vector(-4840, 1120, -2242.5), 16, function(ply)
	if ply:Team() == TEAM_HUMANS then
		ply:SetHealth(200)
	end
end)

-- ARTTeleport
STGamemodes.TouchEvents:Setup(Vector(6341, -60, -200), 32, function(ply)
	if ply:IsDev() or ply:IsMod() then
		ply:SetPos(Vector(3525, 843, 785.04))
		ply:SetEyeAngles(Angle(0, 0, 0))
	end
end)
