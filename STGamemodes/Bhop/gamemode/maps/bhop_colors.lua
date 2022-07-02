--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(1495.5, -1786 , -805))

-- Teleporter from the spawn to the first stage.
STGamemodes.TouchEvents:Setup(Vector(932, -1656, -804), Vector(2059, -1653, -651), function(ply)
	ply:SetPos(Vector(848, -1652, -803))
	ply:SetEyeAngles(Angle(0, 90, 0))
end)