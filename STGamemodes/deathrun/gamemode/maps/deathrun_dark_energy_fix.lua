--------------------
-- STBase
-- By Spacetech
--------------------

-- Prevents players from blocking the elevator by standing below the fence lintel.
STGamemodes.TouchEvents:Setup(Vector(9508, 2746, 441), Vector(9564, 2748, 442), function(ply)
	ply:Teleport(Vector(9536, 2592, 320), Angle(0, 90, 0))
end)

-- Prevents players from jumping onto the fence on the stasis field trap.
STGamemodes.TouchEvents:Setup(Vector(9312, -768, 201), Vector(10016, -64, 265), function(ply)
	if ply:GetPos() then
		ply:SetLocalVelocity((Vector(9664, -416, 128) - ply:GetPos()):Normalize() * 500)
	end
end)

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(8656, -3104, 128), Vector(8752, -3024, 320), function(ply)
	if !ply:HasWeapon("weapon_crowbar") then
		ply:Give("weapon_crowbar")
	end
end)

-- Gives grenades for the Kill minigame.
STGamemodes.TouchEvents:Setup(Vector(-1936, 832, 48), Vector(-1904, 960, 112), function(ply)
	if !ply:HasWeapon("weapon_frag") then
		ply:Give("weapon_frag")
	end
end)