--------------------
-- STBase
-- By Spacetech
--------------------

DIFFICULTY_NORMAL		= GM:AddDifficulty("Normal", "normaldifftrigger")
DIFFICULTY_HARD			= GM:AddDifficulty("Hard", "harddifftrigger")
DIFFICULTY_EXTREME		= GM:AddDifficulty("Extreme", "extreamdifftrigger")

GM:AddBoss("Tyrannosaurus Rex", "trex01model01", "trexphys")

-- ARTTeleport
STGamemodes.TouchEvents:Setup(Vector(-2678, -502, 576), 32, function(ply)
	if ply:IsDev() and !ply:IsMod() then
		ply:SetPos(Vector(-110, 4671, 92.04))
		ply:SetEyeAngles(Angle(0, 90, 0))
	end
end)