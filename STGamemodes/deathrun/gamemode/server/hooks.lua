--------------------
-- STBase
-- By Spacetech
--------------------

function GM:Initialize()
	self.BaseClass.Initialize(self)
	self.Restarting = false
end

function GM:InitPostEntity()
	self.BaseClass.InitPostEntity(self)
	self.ServerStarted = true
	-- ButtonThingy = ents.Create( "logic_attack_controller" )
end

function GM:OnRoundChange()
	-- ButtonThingy = ents.Create( "logic_attack_controller" )
end

function GM:PlayerDisconnected(ply)
	self.BaseClass.PlayerDisconnected(self, ply)
	self:RoundChecks()
end

function GM:PlayerInitialSpawn(ply)
	self.BaseClass.PlayerInitialSpawn(self, ply)
	ply:GoTeam(TEAM_DEAD)
end

function GM:PlayerSpawn(ply)
	self.BaseClass.PlayerSpawn(self, ply)
	
	-- ply:SetMaterial("")
	ply:LastManStanding(false)
	
	if(ply:Alive()) then
		ply:Freeze( true )
		ply.Frozen = true
		timer.Simple( 2, function() if ply:IsValid() then ply:Freeze( false ) ply.Frozen = false end end )
		ply:CrosshairEnable()
		if(ply:Team() == TEAM_DEATH) then
			ply:Give(self.DeathWeapon)
		elseif(self.RunnerWeapon) then
			ply:Give(self.RunnerWeapon)
		-- else
		--	ply:Give("f_sass_hands")
		end
		if(STGamemodes.OnPlayerSpawn) then
			STGamemodes:OnPlayerSpawn(ply, false)
		end
		ply.Ghost = false
	else
		ply:CrosshairDisable()
		if(ply:Team() == TEAM_DEAD and ply:CanGhost()) then
			STGamemodes.Ghost:Spawn(ply)
			ply.Ghost = true
		else
			STGamemodes.Spectater:Spawn(ply)
			ply.Ghost = false
		end
		if(STGamemodes.OnPlayerSpawn) then
			STGamemodes:OnPlayerSpawn(ply, true)
		end
	end
	
	self:RoundChecks()
end

function GM:GetFallDamage(ply, fspeed)		
    if !self.PickedUp and ply:Team() == TEAM_DEATH then		
        return false		
    end		
		
    if(fspeed >= 700) then		
        return math.Round(fspeed / 8)		
    end		
    return 10		
end
	

function GM:ShowSpare1(ply)
	-- if(game.SinglePlayer() or string.find(string.lower(GetGlobalString("ServerName"), "dev"))) then
		-- ply:ChatPrint("Development Spawn")
		-- ply:GoTeam(TEAM_DEAD, false, false)
		-- self:RoundStart()
		-- return
	-- end
	
	if(ply:Team() == TEAM_DEATH) then
		ply:ChatPrint("You can't switch teams!")
		return
	end
	if(ply:Team() == TEAM_RUN or ply:Team() == TEAM_DEAD) then
		ply:ChatPrint("You are already a runner! You will start playing next round")
		return
	end
	if(self.RoundStarted and self.RoundStarted >= CurTime() - 10 and !ply.SkipRound) then
		ply:GoTeam(TEAM_RUN)
		ply:ChatPrint("You have spawned as a runner!")
	else
		ply:GoTeam(TEAM_DEAD)
		ply:ChatPrint("You will spawn as a runner next round")
	end
end

local UseColor = Color(255, 0, 0)

function GM:PlayerUse(ply, Ent)
	if(ply:Alive()) then
		if(ply:Team() == TEAM_DEATH or ply:Team() == TEAM_RUN) then
			if(Ent:IsButton()) then
			
				local Claimer = Ent:CheckClaimed()
				
				if(Claimer and ply != Claimer) then
					return false
				end
				
				if(ply:Team() == TEAM_DEATH) then
					if(!Ent.Abused or Ent.Abused <= CurTime()) then
						Ent.Abused = CurTime() + 5
						local UseMsg = "[DEATH] ["..select(1, STGamemodes:SecondsToFormat(self:GetRoundTime())).."] "..ply:CName().." pressed a button"
						STGamemodes:ModMessage(UseMsg, UseColor)
						STGamemodes.Logs:Event("#"..UseMsg)
						-- ButtonThingy:Input( "SetAttacker", ply, Ent, {"idk"} )
						-- PrintTable(Ent:GetKeyValues())
						-- PrintTable(Ent:GetSaveTable())
					end
				end
				
				if(!ply.NextUse or ply.NextUse <= CurTime()) then
					ply.NextUse = CurTime() + 2
					STAchievements:AddCount(ply, "Button Pusher")
				end
			end
			
			return true
		end
	end
	return false
end

function GM:DoPlayerDeath(ply, Attacker, dmginfo)
	self.BaseClass.DoPlayerDeath(self, ply, Attacker, dmginfo)
	
	ply:SetVar("SkipRound", false)
	ply:SetVar("SpawnDelay", CurTime() + 3)
	
	local Weapon = ply:GetActiveWeapon()
	if(Weapon and Weapon:IsValid() and Weapon:GetClass() != self.RunnerWeapon and Weapon:GetClass() != self.DeathWeapon) then
		ply:DropWeapon(Weapon)
	end
	
	if(Attacker and Attacker:IsValid() and Attacker:IsPlayer()) then
		if(ply == Attacker) then
			Attacker:AddFrags(-1)
		elseif(ply:Team() != Attacker:Team()) then
			if(ply:Team() != TEAM_DEAD and Attacker:Team() != TEAM_DEAD) then
				Attacker:AddFrags(1)
				local Money = 120
				if(Attacker:Team() == TEAM_DEATH) then
					Money = 150
					STAchievements:AddCount(Attacker, "Anti-Runner")
				else
					STAchievements:AddCount(ply, "Deadlier")
				end
				
				if(Attacker:IsVIP()) then
					Money = Money * 2
				end
				Attacker:GiveMoney(Money, "You have recieved %s dough for killing "..ply:CName())
			end
		end
		if(ply:Team() == TEAM_DEATH) then
			ply:SetVar("ChangeTeam", TEAM_RUN)
			Attacker:SetVar("ChangeTeam", TEAM_DEATH)
		end
	end
	
	if(ply:Team() == TEAM_DEATH) then
		ply:SetVar("WasDeath", true)
	end
	
	ply:SetTeam(TEAM_DEAD)
	ply:LastManStanding(false)
	
	STAchievements:AddCount(ply, "Loser")
	
	if(STGamemodes.OnPlayerDeath) then
		STGamemodes:OnPlayerDeath(ply)
	end
	
	self:RoundChecks()
end

function GM:OnPlayerDamage(ply, Attacker, Damage, Trace)
	if(ply:Team() == Attacker:Team()) then
		return
	end
	if(!Attacker:GetVar("RecieveDough", false)) then
		Attacker:SetVar("RecieveDough", true)
	end
end

function GM:PlayerCanPickupWeapon(ply, Weapon)
	if(!Weapon or !Weapon:IsValid()) then
		return true
	end
	
	local Class = string.Trim(string.lower(Weapon:GetClass()))
	
	if(ply:HasWeapon(Class)) then
		return false
	end
	
	-- All-in-one if check
	if(Class == self.Weapon or Class == self.RunnerWeapon or Class == self.DeathWeapon or Class == "weapon_physgun") then
		return true
	end
	
	-- This is handled by WeaponEquip
	--[[ timer.Simple(0.25, function()
		if(ply and ply:IsValid() and Weapon and Weapon:IsValid() and ply:HasWeapon(Class)) then
			ply:SelectWeapon(Class)
		end
	end) ]]
	
	if(!self.PickedUp) then
		self.PickedUp = true
		self:TimerEndRoundStart()
	end
	
	ply:SetVar("RecieveDough", true)
	if(ply:Team() == TEAM_RUN) then
		if(!ply:HasWeapon(self.Weapon)) then
			ply:Give(self.Weapon)
		end
		if(STGamemodes:TeamAliveNum({TEAM_RUN}) == 1) then
			ply:LastManStanding(true)
		end
	end
	local AmmoType = Weapon:GetPrimaryAmmoType()
	if(AmmoType) then
		ply:GiveAmmo(90, AmmoType)
	end
	
	return true
end

function GM:WeaponEquip(Weapon)
	timer.Simple(0, function()
		if(Weapon and Weapon:IsValid()) then
			local ply = Weapon:GetOwner()
			if(ply and ply:IsValid() and ply:Alive()) then
				ply:SelectWeapon(Weapon:GetClass())
			end
		end
	end)
end
