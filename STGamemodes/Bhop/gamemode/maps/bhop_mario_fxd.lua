--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(5, -417, 64.03125))
STGamemodes.Weapons:Add(Vector(-6965, -2936, 13116.43125))

-- Weapons --
STGamemodes.TouchEvents:Setup(Vector(9927, 8856, -5400), 64, function(ply)
	if !ply:HasWeapon("weapon_sass_smg") then
		ply:Give("weapon_sass_smg")
	elseif ply:GetAmmoCount("SMG1") <= 100 then
		ply:GiveAmmo(50, "SMG1", false)
	end
end)

-- Teleports --
STGamemodes.TouchEvents:Setup(Vector(9890, 8643, -5444.97125), 64, function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(12094, 8856, -5416.98))
		ply:SetEyeAngles(Angle(0, 90, 0))
	end
end)