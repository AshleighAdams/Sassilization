--------------------
-- STBase
-- By Spacetech
--------------------

function GM:PlayerInitialSpawn(ply)
	self.BaseClass.PlayerInitialSpawn(self, ply)
	ply:SetTeam(TEAM_BUILDER)
end

function GM:PlayerSpawn(ply)
	self.BaseClass.PlayerSpawn(self, ply)
	
	ply:CrosshairEnable()
	
	self:InitSpeed(ply)
	
	ply:SetJumpPower(205)
	
	ply:StripWeapons()
	ply:Give("gmod_tool")
	ply:Give("gmod_camera")
	ply:Give("laserPointer")
	ply:Give("weapon_physcannon")
	ply:Give("weapon_physgun")
	
	local DefaultWeapon = ply:GetInfo("cl_defaultweapon")
	if(ply:HasWeapon(DefaultWeapon)) then
		ply:SelectWeapon(DefaultWeapon) 
	end
end

function GM:DoPlayerDeath(ply, Attacker, dmginfo)
	self.BaseClass.DoPlayerDeath(self, ply, Attacker, dmginfo)
	
	ply:SetVar("SpawnDelay", CurTime() + 2)
	
	ply:CreateRagdoll()
end
