--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-2752, 1600, -444))

STGamemodes.TouchEvents:Setup(Vector(-2511, 1024, 0.03), 32, function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(-2738, 531, -415.97))
		ply:SetEyeAngles(Angle(0, -180, 0))
	end
end)
