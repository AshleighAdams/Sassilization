--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(4348, 1153, 15))

STGamemodes.TouchEvents:Setup(Vector(6433, -1353, 64), Vector(5721, -1217, 100), function(ply) 
	ply:SetPos(Vector(4070, 1148, 15)) 
	ply:SetEyeAngles(Angle(0, 0, 0)) 
end )