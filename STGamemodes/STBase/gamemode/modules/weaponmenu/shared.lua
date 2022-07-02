--------------------
-- STBase
-- By Spacetech
--------------------

WEAPON_PRIMARY = 1
WEAPON_SECONDARY = 2
WEAPON_ADDON = 3

STGamemodes.WeaponsMenu = {}
STGamemodes.WeaponsMenuTypes = {
	WEAPON_PRIMARY,
	WEAPON_SECONDARY,
	WEAPON_ADDON
}

function STGamemodes:AddWeaponMenu(Class, Table)
	self.WeaponsMenu[Class] = Table
end

function STGamemodes:RemoveWeaponMenuWeapon(Class)
	self.WeaponsMenu[Class] = nil
end

STGamemodes:AddWeaponMenu("weapon_stunstick", {
	Model = "models/weapons/w_stunbaton.mdl",
	Angles = Angle(0, 0, 0),
	Type = WEAPON_SECONDARY
})

STGamemodes:AddWeaponMenu("weapon_pistol", {
	Model = "models/weapons/w_pistol.mdl",
	Angles = Angle(0, 0, 0),
	Ammo = 256,
	Type = WEAPON_SECONDARY
})

STGamemodes:AddWeaponMenu("weapon_357", {
	Model = "models/weapons/w_357.mdl",
	Angles = Angle(0, 0, 0),
	Ammo = 32,
	Type = WEAPON_SECONDARY
})

STGamemodes:AddWeaponMenu("weapon_shotgun", {
	Model = "models/weapons/w_shotgun.mdl",
	Angles = Angle(0, 0, 0),
	Ammo = 64,
	Type = WEAPON_PRIMARY
})

STGamemodes:AddWeaponMenu("weapon_ar2", {
	Model = "models/weapons/w_irifle.mdl",
	Angles = Angle(0, 0, 0),
	Ammo = 256,
	Type = WEAPON_PRIMARY
})

STGamemodes:AddWeaponMenu("weapon_smg1", {
	Model = "models/weapons/w_smg1.mdl",
	Angles = Angle(0, 0, 0),
	Ammo = 1000,
	Type = WEAPON_PRIMARY
})

STGamemodes:AddWeaponMenu("weapon_crossbow", {
	Model = "models/weapons/w_crossbow.mdl",
	Angles = Angle(0, 0, 0),
	Ammo = 16,
	Type = WEAPON_PRIMARY
})

-- STGamemodes:AddWeaponMenu("weapon_rpg", {
	-- Model = "models/weapons/w_rocket_launcher.mdl",
	-- Angles = Angle(0, 0, 0),
	-- Ammo = 0,
	-- Type = WEAPON_PRIMARY
-- })

STGamemodes:AddWeaponMenu("weapon_frag", {
	Model = "models/weapons/w_grenade.mdl",
	Angles = Angle(0, 0, 0),
	Ammo = 2,
	Type = WEAPON_ADDON
})
