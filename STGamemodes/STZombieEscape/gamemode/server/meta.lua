--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.PlayerMeta:Zombify()
	
	--self:SetVar( "ZombiePos", self:GetPos() )
	--self:SetVar( "ZombieEyeAngles", self:EyeAngles() )
	
	-- Zombies shouldn't be holding ZE map pickups
	local pickup = self:GetPickupEntity()
	if IsValid(pickup) then
		pickup:Remove()
	end
	
	self.bMotherZombie = false
	self:GoTeam(TEAM_ZOMBIES, true) -- respawning causes stuck issues
	GAMEMODE:ZombieSpawn(self)
	
	GAMEMODE:RoundChecks() -- check for winner

end

function STGamemodes.PlayerMeta:ZScream()
	self:EmitSound( GAMEMODE.ZombieScream )
	self.LastScream = CurTime()
end

function STGamemodes.PlayerMeta:ZMoan()
	self:EmitSound( GAMEMODE.ZombieMoan[math.random(1,#GAMEMODE.ZombieMoan)] )
	self.NextMoan = CurTime() + math.random(25,35)
end

function STGamemodes.PlayerMeta:IsMotherZombie()
	return self:IsZombie() and self.bMotherZombie
end

function STGamemodes.PlayerMeta:GetPickupEntity()
	return self.PickupEntity
end

function STGamemodes.PlayerMeta:GoTeam(Team, bNoRespawn)
	if(!self or !self:IsValid()) then
		return
	end
	local CurrentTeam = self:Team()
	if(Team and CurrentTeam == Team) then
		return
	end
	
	self:KillTrail()
	
	if(Team) then
		self:SetTeam(Team)
	end
	
	if !bNoRespawn then
		self:Spawn()
	end
end

local CurrentCanBuyWeapons = STGamemodes.PlayerMeta.CanBuyWeapons
function STGamemodes.PlayerMeta:CanBuyWeapons()
	return !self:IsZombie() && CurrentCanBuyWeapons(self)
end