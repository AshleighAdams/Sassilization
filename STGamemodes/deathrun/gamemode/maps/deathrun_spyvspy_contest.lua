--------------------
-- STBase
-- By Spacetech
--------------------

GM.RunnerWeapon = "weapon_crowbar"

-- Prevents players from avoiding the breaking floor trap in the second area by standing along its right edge.
STGamemodes.TouchEvents:Setup(Vector(-3712, 128, 112), Vector(-3456, 131, 113), function(ply)
	ply:SetLocalVelocity(Vector(0, -200, 0))
end)

-- Prevents runners and deaths from jumping up and hitting each other over the fence in the second area.
STGamemodes.TouchEvents:Setup(Vector(-3880, 0, 201), Vector(-3808, 384, 265), function(ply)
	ply:SetLocalVelocity(Vector(0, 0, 0))
end)

-- Prevents deaths from getting stuck in the teleport sorting zone.
STGamemodes.TouchEvents:Setup(Vector(-2816, 3696, 272), Vector(-2800, 3824, 352), function(ply)
	ply:SetPos(Vector(-2736, 3768, 273))
end)

STGamemodes.Buttons:SetupLinkedButtons(16)