--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-2544, 7117, 52.39125))
STGamemodes.Weapons:Add(Vector(-5978.0012345678, -1102.0012345678, -2439.97125))

------- Teleports ------
STGamemodes.TouchEvents:Setup(Vector(7150, 344, -6525), 32, function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(5521, 1632, -6540))
		ply:SetEyeAngles(Angle(0, 90, 0))
	end
end)

-------- Weapons -------
STGamemodes.TouchEvents:Setup(Vector(5512, 4222, -6520), 32, function(ply)
	if !ply:HasWeapon("weapon_sass_smg") then
		ply:Give("weapon_sass_smg")
	elseif (ply:GetAmmoCount("SMG1") <= 100) then
		ply:GiveAmmo(50, "SMG1", false)
	end
end)

STGamemodes.TouchEvents:Setup(Vector(9058, 1523, -7325), 256, function(ply)
	if !ply:HasWeapon("weapon_sass_smg") then
		ply:Give("weapon_sass_smg")
	elseif (ply:GetAmmoCount("SMG1") <= 100) then
		ply:GiveAmmo(50, "SMG1", false)
	end
end)

STGamemodes.TouchEvents:Setup(Vector(6798, 2187, -7110), 32, function(ply)
	if !ply:HasWeapon("weapon_sass_smg") then
		ply:Give("weapon_sass_smg")
	elseif (ply:GetAmmoCount("SMG1") <= 100) then
		ply:GiveAmmo(50, "SMG1", false)
	end
end)

STGamemodes.TouchEvents:Setup(Vector(11261, -14257, -10480), 64, function(ply)
	if !ply:HasWeapon("weapon_sass_smg") then
		ply:Give("weapon_sass_smg")
	elseif (ply:GetAmmoCount("SMG1") <= 100) then
		ply:GiveAmmo(50, "SMG1", false)
	end
end)