--------------------
-- STBase
-- By Spacetech
--------------------

function GM:Initialize()
	self.BaseClass.Initialize(self)
	self.Restarting = false
end

function GM:InitPostEntity()
	self.ServerStarted = true
	self:CleanUpMap()
end

function GM:OnRoundChange()
end

function GM:PlayerOnRank(ply, rank)
	self.BaseClass.PlayerOnRank(self, ply, rank)
	if(!STValidEntity(ply)) then
		return
	end

	ply:ChatPrint("Welcome to Zombie Escape! Press F1 for help.")
end

function GM:PlayerInitialSpawn(ply)
	self.BaseClass.PlayerInitialSpawn(self, ply)
	ply:GoTeam(TEAM_DEAD)
end

function GM:PlayerDisconnected(ply)
	self.BaseClass.PlayerDisconnected(self, ply)
	self:RoundChecks()
end

function GM:PlayerSpawn(ply)
	ply.CustomSpeed = nil
	
	self.BaseClass.PlayerSpawn(self, ply)
	
	if ply:GetVar("ZombiePos", false) then
		ply:SetTeam(TEAM_ZOMBIES)
	end
	
	if ply:Alive() then
		--ply:SetJumpPower(205)
		ply:RemoveAllAmmo()
	
		-- Display weapons menu on first spawn
		if !ply.BuyWeapons then
			timer.Simple(0.1, function()
				ply:WeaponMenu(WEAPON_PRIMARY)
			end)
		else
			ply:ChatPrint("Press F3 at spawn to open the weapon selection menu.")
		end
		
		if ply:IsZombie() then

			self:ZombieSpawn(ply)
			if(ply:GetVar("ZombiePos", false)) then
				timer.Simple(0.001, function()
					if(STValidEntity(ply)) then
						ply:SetPos(ply:GetVar("ZombiePos"))
						ply:SetVar("ZombiePos", false)
					end
				end)
				timer.Simple(0.11, function()
					if(STValidEntity(ply)) then
						ply:SetEyeAngles(ply:GetVar("ZombieEyeAngles"))
						ply:SetVar("ZombieEyeAngles", false)
					end
				end)
			end

			if(!self.RoundCanEnd) then
				self.RoundCanEnd = true
			end

		else -- is human

			self:HumanModelCheck(ply)
			self:PlayerLoadout(ply) -- Give humans crowbar, ammo, etc.

			if(ply.BuyWeapons and table.Count(ply.BuyWeapons) > 0) then
				for k,v in pairs(STGamemodes.WeaponsMenuTypes) do
					local Weapon = ply.BuyWeapons[v]
					if(Weapon) then
						STGamemodes:GiveWeapon(ply, Weapon)
					end
				end
			end

		end
	else
		STGamemodes.Spectater:Spawn(ply)
	end

	self:RoundChecks()
end

function GM:PlayerLoadout(ply)

	ply:Give("weapon_crowbar")
	ply:Give("weapon_frag")
	
	if !ply.BuyWeapons || !ply.BuyWeapons[WEAPON_PRIMARY] then
		ply:SelectWeapon("weapon_crowbar") -- prevent players throwing their grenade
	end
	
	local ammo = ply:IsVIP() and 1000 or 800
	for _, type in pairs({"smg1","pistol","357","ar2","buckshot","sniperround"}) do
		ply:GiveAmmo( ammo, type, true )
	end

end

function GM:PlayerSwitchFlashlight(ply)
	if !ply:Alive() or (ply:IsZombie() and !ply:FlashlightIsOn()) then
		return false
	end
	
	return true
end

function GM:ShowSpare1(ply)

	if ply:Alive() then

		ply:WeaponMenu()

	elseif(!table.HasValue(TEAM_BOTH, ply:Team())) then -- Spectator or Dead
	
		local numply = #player.GetAll()
		if numply >= 2 && !self.Restarting then

			--local bDiedOnRound = (ply.DiedOnRound and ply.DiedOnRound == self.RoundStarted) -- can't respawn if player has already died in the round
			--local bWithinTimelimit = self.RoundStarted and ( self.RoundStarted + CVAR_ZSPAWN_TIMELIMIT:GetInt() ) > CurTime() -- player may spawn as zombie prior to timelimit
			
			if !self.InfectionStarted then -- pre-infection

				ply:GoTeam(TEAM_HUMANS)

			else -- post-infection

				if #team.GetPlayers(TEAM_ZOMBIES) < 1 then -- all zombies have died

					ply:GoTeam(TEAM_DEAD)
					ply:ChatPrint("You will start playing next round!")

				else

					ply:GoTeam(TEAM_ZOMBIES)

				end

			end
			
		else
		
			ply:GoTeam(TEAM_DEAD)
			ply:ChatPrint("You will start playing next round!")
			
		end
		
	else -- this shouldn't be called, but just in case..
	
		ply:GoTeam(TEAM_DEAD)
		ply:ChatPrint("You are already playing!")
		
	end
	
end

/*---------------------------------------------------------
	Infection process, zombie hurts human, etc.
---------------------------------------------------------*/
function GM:PlayerShouldTakeDamage(ply, attacker, inflictor)
	
	-- Make sure attacker is valid
	if IsValid(attacker) && attacker:IsPlayer() && ply != attacker then
		
		-- Friendly fire is disabled
		if ply:Team() == attacker:Team() then
			return false
		end
		
		-- Zombie attacked human player
		if attacker:IsZombie() && !ply:IsZombie() then
		
			-- Hacky fix for zombie infection via grenade
			if attacker.GrenadeOwner then
				return false
			end
		
			-- Award money
			local Money = attacker:IsVIP() and 80 or 60
			attacker:GiveMoney(Money, "You received %s dough for infecting a human")
			attacker:SetHealth( attacker:Health() + ply:Health() ) -- zombies receive victim's health
			STAchievements:AddCount(attacker, "Zombie Overlord")
			
			ply:Zombify()
			
			-- Inform players of infection
			if ply:IsValid() and attacker:IsValid() then 
				umsg.Start( "PlayerKilledByPlayer" )
					umsg.Entity( ply )
					umsg.String( "zombie_arms" )
					umsg.Entity( attacker )
				umsg.End()
			end 
			
			return false
			
		elseif ply:IsZombie() && !attacker:IsZombie() then -- Human attacked zombie
		
			-- 8% chance a zombie will emit a pain sound upon taking damage
			if math.random() < 0.08 then
				ply:EmitSound( self.ZombiePain[math.random(1,#self.ZombiePain)] )
			end
		
		end
		
	end
	
	-- Friendly entity owner detection, etc.
	if IsValid(attacker) and !attacker:IsPlayer() then
		local owner = attacker:GetOwner()
		if IsValid(owner) and owner:IsPlayer() then
			if ply:Team() == owner:Team() then
				return false
			end
		end
	end
	
	-- Props shouldn't hurt the player
	local attclass = attacker:GetClass()
	if(string.sub(attclass, 1, 5) == "prop_") then
		return false
	end
	
	return true

end

function GM:PlayerDeathThink(ply)
	ply:Spawn()
end

/*---------------------------------------------------------
	Award dough upon death
---------------------------------------------------------*/
function GM:DoPlayerDeath(ply, Attacker, DmgInfo)
	self.BaseClass.DoPlayerDeath(self, ply, Attacker, DmgInfo)
	
	if !IsValid(ply) then return end

	local Respawn = false 

	-- Humans should drop their weapons upon death
	local Weapon = ply:GetActiveWeapon()
	if !ply:IsZombie() and IsValid(Weapon) then
		ply:DropWeapon(Weapon)
	end
	
	if IsValid(Attacker) and Attacker:IsPlayer() then

		if ply == Attacker then -- suicide

			Attacker:AddFrags(-1)

		elseif ply:Team() != Attacker:Team() then -- pvp kill

			-- should only be human killed zombie
			if Attacker:IsZombie() then
				ErrorNoHalt("ERROR: Zombie killed player! " .. tostring(ply) .. ", " .. tostring(Attacker))
			end

			Attacker:AddFrags(1)

			local Money = Attacker:IsVIP() and 150 or 100
			Attacker:GiveMoney(Money, "You received %s dough for killing a zombie")
			STAchievements:AddCount(Attacker, "Enemy of the Undead")

			ply:EmitSound( self.ZombieDeath[math.random(1,#self.ZombieDeath)] )
			if ply:IsZombie() then Respawn = true end 
		end

	end
	
	-- Prevent respawning
	if self.RoundStarted then
		ply.DiedOnRound = self.RoundStarted
	end
	if Respawn then 
		ply:GoTeam(TEAM_ZOMBIES)
	else 
		ply:SetTeam(TEAM_DEAD)
	end 
	
	self:RoundChecks()
end

/*---------------------------------------------------------
	Suicide is disabled
---------------------------------------------------------*/
function GM:CanPlayerSuicide(ply)
	if ply:IsZombie() and !ply:IsMotherZombie() then
		return true -- in case a zombie gets stuck
	end
	
	return false
end

/*---------------------------------------------------------
	Player must be alive and a human or zombie
	to use buttons, etc.
---------------------------------------------------------*/
function GM:PlayerUse(ply, ent)
	if ply:Alive() && (ply:Team() == TEAM_HUMANS || ply:Team() == TEAM_ZOMBIES) then
		return true
	end
	
	return false
end


/*---------------------------------------------------------
	Key Value Fixes
---------------------------------------------------------*/
function GM:EntityKeyValue(ent, key, value)

	-- Fixes point_servercommand targetname keys
    if ent:GetClass() == "point_servercommand" then
        if key == "targetname" then
            ent.targetname = value
            ent:SetKeyValue("targetname", value)
        end
    end
	
	-- Mark pickup function weapons to not be removed
	if key == "OnPlayerPickup" then
		ent.OnPlayerPickup = value
	end
	
	-- Replace map message spam
	if ent:GetClass() == "logic_relay" && key == "OnTrigger" then
		for _, msg in pairs(self.MessagesToIgnore) do
			if string.find(value, msg) then
				return ""
			end
		end
	end
	
end

/*---------------------------------------------------------
	Zombies should not pickup any weapons
---------------------------------------------------------*/
function GM:PlayerCanPickupWeapon(ply, wep)
	if !wep or !wep:IsValid() then return false end 
	
	local bZombieArms = (wep:GetClass() == "zombie_arms")
	if ply:IsZombie() then
		if bZombieArms then return true end
		return false
	else
		if bZombieArms then return false end
	end
	
	return true
end


/*---------------------------------------------------------
	Sends damage done to zombie to player for
	displaying on screen, also checks for zombies
	infecting via grenades
---------------------------------------------------------*/
function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
	
	if !IsValid(ent) || !ent:IsPlayer() then return end
	
	if IsValid(inflictor) then
		-- Send damage display to players
		if inflictor:IsPlayer() && !inflictor:IsZombie() && ( !inflictor.LastDamageNote || inflictor.LastDamageNote < CurTime() ) && ent:IsZombie() then --|| self:IsValidBossDmg(ent) ) then
			local offset = Vector(math.random(-8,8), math.random(-8,8), math.random(-8,8))
			umsg.Start("DamageNotes", inflictor)
				umsg.Float(math.Round(amount))
				umsg.Vector(ent:GetPos() + offset)
			umsg.End()
			
			inflictor.LastDamageNote = CurTime() + 0.15 -- prevent spamming of damage notes
		end
		
		-- Damage delt to player by grenade
		if !IsValid(attacker) then return end
		if inflictor:GetClass() == "npc_grenade_frag" then
			attacker.GrenadeOwner = true -- fix for zombies throwing grenade prior to infection
			
			-- Human has grenaded a zombie
			local dmgblast = (DMG_BLAST & dmginfo:GetDamageType() == DMG_BLAST)
			if ent:IsZombie() && attacker:IsPlayer() && !attacker:IsZombie() && dmgblast then
				ent:Ignite(math.random(3, 5), 0)
				STAchievements:AddCount(attacker, "Let 'Em Burn")
			end
		else
			attacker.GrenadeOwner = nil
		end
	end
	
end