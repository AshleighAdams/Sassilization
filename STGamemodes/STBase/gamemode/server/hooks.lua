--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.LeftMessages = {}

function GM:Initialize()
	STGamemodes.FakeName:Load()
end

function GM:PostKeyValues()
	-- Runs before keyvalues are set
end

function GM:InitPostEntity()
	STGamemodes.TouchEvents:CheckAll()
	STGamemodes.Weapons:RunRemoveAllGuns()
	STGamemodes.Forums:UpdateMap(game.GetMap())
	STGamemodes.KeyValues:Run()
end

function GM:EntityRemoved(Ent)
	if(!STValidEntity(Ent)) then
		return
	end
	
	// PlayerDisconnected is called before remove
	if(Ent:IsPlayer() and !Ent:IsBot()) then
		if(Ent.Disconnected) then
			return
		end
		Ent.Disconnected = true
		
		Ent:SaveMoney()
		STGamemodes.Store:Save(Ent)
		STAchievements:Save(Ent)
	end
end

function GM:ShutDown()
	STGamemodes.Forums:Shutdown()
end

function GM:PlayerDisconnected(ply)
	if(!ply.Disconnected) then
		ply.Disconnected = true
		
		ply:SaveMoney()
		STGamemodes.Store:Save(ply)
		STAchievements:Save(ply)
		
		timer.Remove("SaveInfo."..ply:SteamID())
		
		STGamemodes:PrintAll( ply:CName().." has left the server" )
		STGamemodes:ConsolePrint( ply:CName().."(".. ply:SteamID() ..") has left the server", true )

		STGamemodes.Store:Debug( ply, "PlayerDisconnected Money: "..tostring(ply:GetMoney()).." - InitMoney: "..tostring(ply.InitMoney), true )
	end
end

concommand.Add("st_mac", function(ply, cmd, args)
	if(!ply.MacID) then
		return
	end
	if(ply.MacID == tonumber(args[1])) then
		STAchievements:Award(ply, "Handicap", true)
	end	
	ply.MacID = nil
end)

function GM:PlayerInitialSpawn(ply)
	if(STGamemodes.Bans:CheckMySQLBanned(ply:SteamID(), false, true, true)) then
		STGamemodes.SecretKick(ply, "You're banned from this server.")
		return
	end
	
	ply:PrecacheGetRank()
	
	local SteamID = ply:SteamID()
	timer.Create("SaveInfo."..SteamID, 180, 0, function()
		if(STValidEntity(ply)) then
			ply:SaveMoney()
			STGamemodes.Store:Save(ply)
			STAchievements:Save(ply)
		else
			timer.Remove("SaveInfo."..SteamID)
		end
	end)
	
	ply.MacID = math.random(100, 100000)
	timer.Simple(15, function()
		if(IsValid(ply)) then
			ply:SendLua([[if(ConVarExists("mac_cursorwarp")) then RunConsoleCommand("st_mac", "]]..tostring(ply.MacID)..[[") end]])
		end
	end)
	
	-- ply:SendLua([[TC=timer.Create PR=pairs TN=tonumber RC=RunConsoleCommand]])
	-- ply:SendLua([[local tab={{"voice_inputfromfile",0,1},{"sv_cheats",0,0},{"sv_scriptenforcer",]]..self.ScriptEnforcer..[[,0}} TC("Timer.Think",.5,0,function() for k,v in PR(tab) do if(TN(LocalPlayer():GetInfo(v[1]))!=v[2]) then if(v[3]==1) then RC(v[1], v[2]) end RC("st_timerthink") end end end)]])
	
	ply:SetCMuted(STGamemodes.Muted[SteamID])
	ply:SetGagged(STGamemodes.Gagged[SteamID])
	ply:AFKTimer()
	ply.SpecType = OBS_MODE_CHASE
	
	if(STGamemodes:WeaponMenuEnabled()) then
		ply.BuyWeapons = {"weapon_smg1", "weapon_pistol"}
	end
end

local min, max = Vector(-16, -16, 0), Vector(16, 16, 64)

function GM:IsSpawnpointSuitable(ply, spawnpointent, bMakeSuitable)
	if(self.CheckSpawn) then
		local Pos = spawnpointent:GetPos()
		
		if(ply:Team() == TEAM_SPEC || ply:Team() == TEAM_JOINING) then
			return true
		end
		
		local Blockers = 0
		
		// Note that we're searching the default hull size here for a player in the way of our spawning.
		// This seems pretty rough, seeing as our player's hull could be different.. but it should do the job
		// (HL2DM kills everything within a 128 unit radius)
		for k,v in pairs(ents.FindInBox(Pos + min, Pos + max)) do
			if(IsValid(v) and v:GetClass() == "player" and v:Alive()) then
				Blockers = Blockers + 1
				if(bMakeSuitable) then
					v:Kill()
				end
			end
		end
		
		if(bMakeSuitable) then
			return true
		end
		
		if(Blockers > 0) then
			return false
		end
	end
	
	return true
end

function GM:PlayerSpawn(ply)
	local Health = (ply:IsVIP() and !self.NoHealthBonus) and 200 or 100
	ply.KillFreezeCam = false
	ply:SetNoCollideWithTeammates(true)
	ply:SetVar("SpawnDelay", 0)
	-- ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	ply:UnSpectate()
	-- ply:Spectate(OBS_MODE_NONE)

	self:InitSpeed(ply)
	
	ply:StripWeapons()
	ply:SetHealth(Health)
	ply:SetMaxHealth(Health)
	ply:SetJumpPower(205)
	ply:SetGravity(1)
	ply:GodDisable()
	ply:SetColor(Color(255, 255, 255, 255))
	ply:SetCustomCollisionCheck(true)
	
	STGamemodes:SetupPlayerModel(ply)
	timer.Simple(0.2, function()
		if(IsValid(ply)) then
			ply:SetupHat()
			ply:CreateTrail()
		end
	end)
end

-- function GM:PlayerSelectSpawn(ply)
	-- if(self.Spawns) then
		-- local Spawns = self.Spawns[ply:Team()]
		-- if(Spawns) then
			-- local Number = table.Count(Spawns)
			-- if(Number and Number > 0) then
				-- local SpawnEnt = Spawns[math.random(1, Number)]
				-- if(SpawnEnt and SpawnEnt:IsValid()) then
					-- return SpawnEnt
				-- end
			-- end
		-- end
	-- end
	-- return game.GetWorld()
-- end

function GM:PlayerNoClip(ply)
	if(game.SinglePlayer()) then
		return true
	end

	if ply:IsGhost() then return true end 

	if !ply:IsAdmin() and !ply:IsMapper() then return false end

	if !STGamemodes.GateKeeper.DevMode and !ply:IsSuperAdmin() then return false end 

	return ply:Alive()
end

function GM:ShowHelp(ply)
	ply:ConCommand("st_store help")
end

function GM:ShowTeam(ply)
	if(!ply.Stored and ply.FullyLoaded) then
		ply.Stored = true
		ply:ConCommand("st_store store")
	else
		ply:ConCommand("st_store")
	end
end

function GM:ShowSpare1(ply)
end

function GM:ShowSpare2(ply)
	-- ply:ChatPrint("The Jukebox is current down.  Try again later!")
	ply:ConCommand("jukebox_show")
end

function GM:Think()
	STGamemodes:PitchCheck()
	if(!self.LastThink) then
		self.LastThink = CurTime()+1
	end
	if(self.LastThink <= CurTime()) then
		return
	end
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid() and v:Alive() and v:OnGround()) then
			if(self:ShouldSaveCurrentPos(v)) then
				v.LastPos = v:GetPos()
				v.LastEyeAngles = v:EyeAngles()
				v.LastGravity = v:GetGravity()
				self:OnSaveCurrentPos(v, v.LastPos)
			end
		end
	end
end

function GM:ShouldSaveCurrentPos(ply)
	return true
end

function GM:OnSaveCurrentPos(ply, Pos, EyeAngle)
end

function GM:PlayerUse(ply, ent)
	return true
end

function GM:AllowPlayerPickup(ply, ent)
	return false
end

function GM:PlayerDeathThink(ply)
	if(ply:GetVar("QuickSpawn", false)) then
		ply:SetVar("QuickSpawn", false)
		ply:Spawn()
		return
	end
	
	if(ply:GetVar("SpawnDelay", 0) > CurTime()) then
		return
	end
	
	if(ply.KillFreezeCam and ply.KillFreezeCam <= CurTime() and ply:GetObserverMode() == OBS_MODE_FREEZECAM) then
		STGamemodes.Spectater:Spawn(ply)
	end
	
	ply:Spawn()
end

function GM:DoPlayerDeath(ply, Attacker, dmginfo)
	ply:StopZooming(true)
	
	ply:PlayDeathSound()
	
	-- ply:CreateRagdoll()
	
	ply:AddDeaths(1)
	ply:Extinguish()
	ply:Flashlight(false)
	
	if(ply.Trail and ply.Trail:IsValid()) then
		ply.Trail:Remove()
	end
	
	if(!self.DisableFreezeCam and IsValid(Attacker) and Attacker:IsPlayer() and Attacker != ply) then
		ply.KillFreezeCam = CurTime() + 3
		ply:SpectateEntity(Attacker)
		ply:Spectate(OBS_MODE_FREEZECAM)
		
		STGamemodes:PlaySound(ply, "freeze_cam.wav")
	else
		ply.KillFreezeCam = false
	end
end

function GM:PlayerDeath(Victim, Inflictor, Attacker)
	Victim.LastDamage = nil
	Victim.NextSpawnTime = CurTime() + 2
	Victim.DeathTime = CurTime()
	
	if(Inflictor and Attacker and Inflictor == Attacker and (Inflictor:IsPlayer() or Inflictor:IsNPC())) then
		Inflictor = Inflictor:GetActiveWeapon()
		if(!Inflictor || Inflictor == NULL) then
			Inflictor = Attacker
		end
	end
	
	if(Attacker and IsValid(Attacker) and Attacker.GetAttacker and IsValid(Attacker:GetAttacker()) and Attacker:GetAttacker():IsPlayer()) then
		Attacker = Attacker:GetAttacker()
	end
	if Victim and Attacker and Victim:IsValid() and Attacker:IsValid() then 
		if(Attacker == Victim) then
			umsg.Start("PlayerKilledSelf")
				umsg.Entity(Victim)
			umsg.End()
			
			MsgAll(Attacker:CName().." suicided!\n")
		else 
			if Inflictor:IsValid() then 
				if(Attacker:IsPlayer()) then
					umsg.Start("PlayerKilledByPlayer")
						umsg.Entity(Victim)
						umsg.String(Inflictor:GetClass())
						umsg.Entity(Attacker)
					umsg.End()
					
					MsgAll(Attacker:CName().." killed "..Victim:CName().." using "..Inflictor:GetClass().."\n") 
				else
					umsg.Start("PlayerKilled")
						umsg.Entity(Victim)
						umsg.String(Inflictor:GetClass())
						umsg.String(Attacker:GetClass())
					umsg.End()
					
					MsgAll(Victim:CName().." was killed by "..Attacker:GetClass().."\n")
				end 
			end  
		end 
	end 
end

function GM:PlayerShouldTakeDamage(ply, Attacker)
	if(!ply:Alive() or ply:IsGhost()) then
		return false
	end
	if(Attacker and Attacker:IsValid() and ply != Attacker) then
		if(Attacker:IsPlayer()) then
			if(ply:Team() == Attacker:Team()) then
				return false
			end
			if(self.SpawnProtect) then
				if(ply:GetVar("SpawnTime", 0) + self.SpawnProtect >= CurTime()) then
					return false
				end
			end
		else
			local Owner = Attacker:GetOwner()
			if(Owner and Owner:IsValid() and Owner:IsPlayer()) then
				if(ply:Team() == Owner:Team()) then
					return false
				end
			end
		end
	end
	return true
end

function GM:ScalePlayerDamage(ply, HitGroup, DmgInfo)
	local Attacker = DmgInfo:GetAttacker()
	if(self:PlayerShouldTakeDamage(ply, Attacker, DmgInfo:GetInflictor())) then
		if(HitGroup == HITGROUP_HEAD) then
			DmgInfo:ScaleDamage(2.2)
		elseif(HitGroup == HITGROUP_CHEST) then
			DmgInfo:ScaleDamage(1.5)
		elseif(HitGroup == HITGROUP_STOMACH) then
			DmgInfo:ScaleDamage(1.5)
		end
		
		ply:PlayPainSound(DmgInfo:GetDamage())
		
		if(ply:IsPlayer() and Attacker:IsPlayer()) then
			if(STValidEntity(Attacker:GetActiveWeapon())) then
				if(Attacker:GetActiveWeapon():GetClass() == "weapon_shotgun") then
					DmgInfo:ScaleDamage(2.4)
				elseif(Attacker:GetActiveWeapon():GetClass() == "weapon_357") then
					DmgInfo:ScaleDamage(0.25)
				end
			end
		end
		
		return DmgInfo
	end
	
	DmgInfo:SetDamage(0)
	DmgInfo:ScaleDamage(0)
	
	return DmgInfo
end

function GM:PlayerTraceAttack(ply, dmginfo, dir, trace)
	local Attacker = dmginfo:GetAttacker()
	
	if(!IsValid(Attacker) or Attacker == ply) then
		return
	end
	
	if(self:ScalePlayerDamage(ply, trace.HitGroup, dmginfo)) then
		util.Decal("Blood", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
		if(Attacker:IsPlayer()) then
			self:OnPlayerDamage(ply, Attacker, dmginfo:GetDamage(), trace)
		end
		-- return true
	end
	
	return false
end

function GM:OnPlayerDamage(ply, Attacker, Damage, Trace)

end

function GM:EntityTakeDamage( ent, dmginfo )
	local Check = STGamemodes.DamageFilter:Check( ent, dmginfo )
	if Check then 
		dmginfo = Check 
	end

	if ent:IsPlayer() then ent.LastDamage = CurTime() end 
end 

function GM:PlayerDeathSound()
	return true
end

function GM:OnPlayerHitGround(ply, bInWater, bOnFloater, flFallSpeed)
	if(!ply:Alive()) then
		return true
	end
end

function GM:PlayerSwitchFlashlight(ply, SwitchOn)
	ply.LastFlashlight = ply.LastFlashlight or CurTime() - 1
	if(CurTime() <= ply.LastFlashlight or !ply:Alive() or ply:Team() == TEAM_SPEC) then
		return false
	end
	ply.LastFlashlight = CurTime() + 1
	return true
end

function GM:CanPlayerSuicide(ply)
	return false
end

function GM:KeyPress(ply, key)
	ply:AFKTimer()
	
	local Team = ply:Team()
	if(Team == TEAM_SPEC or (!ply:Alive() and !ply:IsGhost())) then
		if(self.SpecFix or ply:GetVar("SpawnDelay", 0) == 0) then
			STGamemodes.Spectater:KeyPress(ply, key)
		end
	end
end

function GM:PlayerCanPickupWeapon(ply, Weapon)
	return true
end

function GM:WeaponEquip(Weapon)
end

function GM:GetFallDamage(ply, fspeed)
	if(fspeed >= 700) then
		return math.Round(fspeed / 8)
	end
	return 10
end

function GM:PlayerCanHearPlayersVoice(Listener, Talker)
	if Talker:IsGagged() then return false
	elseif STGamemodes.Voice == 1 then return true
	elseif STGamemodes.Voice == 2 and Talker:IsVIP() then return true
	elseif STGamemodes.Voice == 3 and Talker:IsDev() then return true
	else return false end
end

function GM:PlayerShouldAct( ply, actname, actid )
	if(!ply or !ply:IsValid()) then
		return
	end
	
	if !ply.LastAct or ply.LastAct <= CurTime() then 
		ply.LastAct = CurTime() + 5
		if STGamemodes.Store:HasItem( ply, "Act ".. actname ) then
			ply:ChatPrint( "You're now ".. actname .."ing" )
			return true
		else 
			ply:ChatPrint( "You do not own this Act!  Purchase it in the store." )
			return false 
		end 
	else 
		return false 
	end 
end
