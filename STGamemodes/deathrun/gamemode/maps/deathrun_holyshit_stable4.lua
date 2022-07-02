--------------------
-- STBase
-- By Spacetech
--------------------

GM.RunnerWeapon = "weapon_crowbar"

-- Prevents players from jumping onto the invisible walkway leading up to the first flashbang.
STGamemodes.TouchEvents:Setup(Vector(80, 248, 256), 32, function(ply)
	ply:SetPos(Vector(384, -351.898, 193.14))
	ply:SetEyeAngles(Angle(0, 90, 0))
end)

-- Lowers the players' HP so they stand a chance of killing each other in the Deagle Roulette minigame.
STGamemodes.TouchEvents:Setup(Vector(4160, -1728, 32), Vector(4896, -832, 288), function(ply)
	ply:SetHealth(1)
end)

--[[ -- Gives crossbows for the AWP minigame.
STGamemodes.TouchEvents:Setup(Vector(4128, -4320, 32), Vector(4896, -1824, 288), function(ply)
	ply:Give("weapon_crossbow")
end) ]]

STGamemodes.Buttons:SetupLinkedButtons(32)