--------------------
-- STBase
-- By Spacetech
--------------------

local Name = STGamemodes.PlayerMeta.Name
local Alive = STGamemodes.PlayerMeta.Alive

function STGamemodes.PlayerMeta:CName()
	if !self:IsValid() then return end 
	return (self:IsFake() and self:GetNWString("FakeName", false)) or Name(self)
end

function STGamemodes.PlayerMeta:IsFake()
	if !self:IsValid() then return end 
	if(self:GetNWString("FakeName", false) and self:GetNWString("FakeName", false) != "") then
		return true
	end
	return false
end

function STGamemodes.PlayerMeta:Alive()
	if !self:IsValid() then return end 
	local Team = self:Team()
	if(Team == TEAM_SPEC or Team == TEAM_JOINING or Team == TEAM_UNASSIGNED) then
		return false
	end
	return Alive(self)
end

function STGamemodes.PlayerMeta:IsCMuted()
	if(self and self:IsValid()) then
		return self.Muted or self:GetNWBool("CMuted", false)
	end
	return false
end

function STGamemodes.PlayerMeta:IsWinner()
	if !self:IsValid() then return end 
	if(SERVER) then
		return self:HasWeapon("st_jetpack")
	end
	for k,v in pairs(self:GetWeapons()) do
		if(v:GetClass() == "st_jetpack") then
			return true
		end
	end
	return false
end