--------------------
-- STBase
-- By Spacetech
--------------------

function GM:InitPostEntity()
	self.BaseClass.InitPostEntity(self)
	self.ServerStarted = true
	STGamemodes:RemoveEntities()
end

function GM:PlayerOnRank(ply, rank)
	self.BaseClass.PlayerOnRank(self, ply, rank)
	if(!STValidEntity(ply)) then
		return
	end
	ply:ChatPrint("Welcome to Gungame! Kill the other team to rank up and get better guns. Press F1 for more help.")
end

function GM:PlayerInitialSpawn(ply)
	self.BaseClass.PlayerInitialSpawn(self, ply)
	
	ply:GoTeam(TEAM_SPEC)
end

function GM:PlayerDisconnected(ply)
	self.BaseClass.PlayerDisconnected(self, ply)
end

function GM:PlayerSpawn(ply)
	self.BaseClass.PlayerSpawn(self, ply)
	
	ply:CrosshairEnable()
	
	self:InitSpeed(ply)
	
	ply:SetJumpPower(205)
	
	ply:SetVar("SpawnTime", CurTime())

	if (ply:Alive()) then
		ply:GGRefreshGun()	
	end

	timer.Simple(0.2, function()
		if(!ply or !ply:IsValid() or !ply:Alive()) then
			return
		end
		local Trace = {}
		Trace.start = ply:GetPos() + Vector(0, 0, 100)
		Trace.endpos = ply:GetPos() - Vector(0, 0, 100)
		Trace.filter = ply
		Trace.mask = MASK_SOLID_BRUSHONLY
		local tr = util.TraceLine(Trace) 
		if(tr.Hit) then
			ply:SetPos(tr.HitPos + Vector(0, 0, 20))
		end
	end)
	
	if(ply:Team() == TEAM_RED) then
		ply:SetColor(255, 0, 0, 255)
	elseif(ply:Team() == TEAM_BLUE) then
		ply:SetColor(0, 0, 254, 255)
	else
		ply:SetColor(255, 255, 255, 255)
	end
	
	STGamemodes.Spectater:Spawn(ply)
end

function GM:ShowSpare1(ply)
	if(ply:Alive()) then
		ply:ChatPrint("Your current level is "..(ply:GetGGLevel() or 0).." with a KD of "..(ply:Frags() or 0)..":"..(ply:Deaths() or 0))
	elseif(!table.HasValue(TEAM_BOTH, ply:Team())) then
		STGamemodes:ChooseTeam(ply, true)
	else
		ply:ChatPrint("You are already playing! Wait to be respawned!")
	end
end

function GM:PlayerDeathThink(ply)
	if(ply:GetVar("SpawnDelay", 0) > CurTime()) then
		return
	end
	ply:Spawn()
end

function GM:DoPlayerDeath(ply, Attacker, DmgInfo)
	self.BaseClass.DoPlayerDeath(self, ply, Attacker, DmgInfo)
	
	if(ply.Suicided) then
		ply.Suicided = false
		ply:SetVar("SpawnDelay", CurTime() + (self.DeadTime * 2))
	else
		ply:SetVar("SpawnDelay", CurTime() + self.DeadTime)
	end
	
	if(Attacker and Attacker:IsValid() and Attacker:IsPlayer()) then
		if(ply == Attacker) then
			Attacker:AddFrags(-1)
		elseif(ply:Team() != Attacker:Team()) then
			Attacker:AddFrags(1)
			local Money = self.KillMoney
			if(Attacker:IsVIP()) then
				Money = Money * 2
			end
			Attacker:GiveMoney(Money, "You have recieved %s dough for killing "..ply:CName()) -- , "You have recieved %s dough for killing "..ply:CName())
			Attacker:GGLevelUp()
			ply:GGLevelDown()
		end
	end
	
	if(STValidEntity(Attacker) and Attacker:IsPlayer()) then
		Attacker:AddFrags(1)
		timer.Simple(3, function() STGamemodes.Spectater:Spawn(ply, Attacker) end)
	else
		timer.Simple(3, function() STGamemodes.Spectater:Spawn(ply) end)
	end
	
	STGamemodes:AutoTeamBalance(ply)
end

function GM:CanPlayerSuicide(ply)
	if(ply:GetVar("NextSuicide", CurTime() - 5) >= CurTime()) then
		ply:ChatPrint("You can't suicide yet!")
		return false
	end
	ply.Suicided = true
	ply:SetVar("NextSuicide", CurTime() + self.SuicideTime)
	timer.Simple(0.1, function()
		if(STValidEntity(ply)) then
			umsg.Start("player_suicide_timer", ply)
			umsg.End()
		end
	end)
	return true
end
