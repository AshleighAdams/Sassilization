--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.PlayerMeta:GoTeam(Team)
	if(!self or !self:IsValid()) then
		return
	end
	if(!Team) then
		return
	end
	local CurrentTeam = self:Team()
	if(CurrentTeam == Team) then
		return
	end
	self:KillTrail()
	self:SetTeam(Team)
	self:Spawn()
end

function STGamemodes.PlayerMeta:GetGGLevel()
	return self.gg_Level or 1
end

function STGamemodes.PlayerMeta:SetGGLevel(level)
	self.gg_Level = level
end

function STGamemodes.PlayerMeta:GGRefreshGun()
	local gun = GG_LEVELS[self:GetGGLevel()]
	self:StripWeapons()
	self:StripAmmo()

	self:Give(gun)
	
	local weapon = self:GetWeapon(gun)
	local ammotype = weapon:GetPrimaryAmmoType()

	self:GiveAmmo(500, ammotype, true)
	

	self:SelectWeapon(gun)
end

function STGamemodes.PlayerMeta:GGLevelUp()
	local maxLevel = #GG_LEVELS
	local newLevel = self:GetGGLevel() + 1
	if (self:GetGGLevel() + 1 < maxLevel) then
		self:SetGGLevel(newLevel)
	end
	self:GGRefreshGun()
end

function STGamemodes.PlayerMeta:GGLevelDown()
	local minLevel = 1
	local newLevel = self:GetGGLevel() - 1
	if (self:GetGGLevel() > minLevel) then
		self:SetGGLevel(newLevel)
	end
	self:GGRefreshGun()
end