--------------------
-- STBase
-- By Spacetech
--------------------

GM.Name		= "STZombieEscape"
GM.Author	= ""
GM.Email 	= ""
GM.Website 	= "www.sassilization.com"

DeriveGamemode("STBase")

TEAM_ZOMBIES = 2
TEAM_HUMANS = 3
TEAM_DEAD = 4

TEAM_BOTH = {TEAM_ZOMBIES, TEAM_HUMANS}

SCOREBOARD_ORDER = {}
SCOREBOARD_ORDER[TEAM_HUMANS] = 3
SCOREBOARD_ORDER[TEAM_ZOMBIES] = 2
SCOREBOARD_ORDER[TEAM_DEAD] = 1

function GM:CreateTeams()
	self.BaseClass.CreateTeams(self)
	
	self:TeamSetupSpeed(TEAM_HUMANS, self.CSSSpeed)
	team.SetUp(TEAM_HUMANS, "Humans", Color(20, 20, 200, 255))
	team.SetSpawnPoint(TEAM_HUMANS, "info_player_counterterrorist")
	
	self:TeamSetupSpeed(TEAM_ZOMBIES, self.CSSSpeed * 1.05)
	team.SetUp(TEAM_ZOMBIES, "Zombies", Color(0, 200, 0, 255))
	team.SetSpawnPoint(TEAM_ZOMBIES, "info_player_terrorist")
	
	self:TeamSetupSpeed(TEAM_DEAD, self.CSSSpeed)
	team.SetUp(TEAM_DEAD, "Dead", Color(125, 55, 145, 255))
	team.SetSpawnPoint(TEAM_DEAD, "info_player_counterterrorist")
end

function GM:GetGameDescription()
	return "Zombie Escape"
end

STGamemodes:SetupServerDirectory( "Zombie Escape" )
STGamemodes:LoadGamemode(GM.Name)
STGamemodes.Forums:SetID(10)

GM.VIPSpeed = false
GM.svAirAccelerate = 0
-- GM.SlowJumpLanding = true

STGamemodes.GhostDisabled = true

-- Remove default menu weapons
STGamemodes:RemoveWeaponMenuWeapon("weapon_stunstick")
STGamemodes:RemoveWeaponMenuWeapon("weapon_pistol")
STGamemodes:RemoveWeaponMenuWeapon("weapon_357")
STGamemodes:RemoveWeaponMenuWeapon("weapon_shotgun")
STGamemodes:RemoveWeaponMenuWeapon("weapon_ar2")
STGamemodes:RemoveWeaponMenuWeapon("weapon_smg1")
STGamemodes:RemoveWeaponMenuWeapon("weapon_crossbow")

-- Zombie Escape Weapon Selection
STGamemodes:AddWeaponMenu("weapon_p90", {
	Model = "models/weapons/w_smg_p90.mdl",
	Angles = Angle(0, 0, 0),
	Type = WEAPON_PRIMARY
})
STGamemodes:AddWeaponMenu("weapon_para", {
	Model = "models/weapons/w_mach_m249para.mdl",
	Angles = Angle(0, 0, 0),
	Type = WEAPON_PRIMARY
})
STGamemodes:AddWeaponMenu("weapon_mac10", {
	Model = "models/weapons/w_smg_mac10.mdl",
	Angles = Angle(0, 0, 0),
	Type = WEAPON_PRIMARY
})
STGamemodes:AddWeaponMenu("weapon_ak47", {
	Model = "models/weapons/w_rif_ak47.mdl",
	Angles = Angle(0, 0, 0),
	Type = WEAPON_PRIMARY
})

STGamemodes:AddWeaponMenu("weapon_cs_glock", {
	Model = "models/weapons/w_pist_glock18.mdl",
	Angles = Angle(0, 0, 0),
	Type = WEAPON_SECONDARY
})
STGamemodes:AddWeaponMenu("weapon_fiveseven", {
	Model = "models/weapons/w_pist_fiveseven.mdl",
	Angles = Angle(0, 0, 0),
	Type = WEAPON_SECONDARY
})
STGamemodes:AddWeaponMenu("weapon_cs_elite", {
	Model = "models/weapons/w_pist_elite.mdl",
	Angles = Angle(0, 0, 0),
	Type = WEAPON_SECONDARY
})
STGamemodes:AddWeaponMenu("weapon_deagle", {
	Model = "models/weapons/w_pist_deagle.mdl",
	Angles = Angle(0, 0, 0),
	Type = WEAPON_SECONDARY
})
