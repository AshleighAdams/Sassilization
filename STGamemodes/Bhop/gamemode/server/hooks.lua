--------------------
-- STBase
-- By Spacetech
--------------------

function GM:PlayerOnRank(ply, rank)
	self.BaseClass.PlayerOnRank(self, ply, rank)
	if(!STValidEntity(ply)) then
		return
	end
	ply:ChatPrint("Welcome to Bunny Hop! Press F1 for help. Press F3 to play")
end

function GM:PlayerInitialSpawn(ply)
	self.BaseClass.PlayerInitialSpawn(self, ply)
	
	ply:GoTeam(TEAM_SPEC)
	
	if(self.PlayerInfo[ply:SteamID()]) then
		self:SyncInfo(ply)
		if(ply.Winner) then
			ply.CanHaveTrail = true
		end
		ply:SetNWInt("Level", ply.Level)
		ply:ChatPrint("Welcome back "..tostring(ply:GetName()))
	else
		self.PlayerInfo[ply:SteamID()] = {}
	end
end

hook.Add( "PlayerDisconnected", "StartTotalTimeSetInfo", function( ply )
	ply:PauseTime()
end )

function GM:OnSpec( ply )
	ply:PauseTime()
end

function GM:PlayerSpawn(ply)
	self.BaseClass.PlayerSpawn(self, ply)
	
	ply:CrosshairEnable()
	
	self:InitSpeed(ply)
	
	STGamemodes.Spectater:Spawn(ply)
	
	if(ply.Winner) then
		ply:Give("st_jetpack")
	end
	
	if(ply:Alive()) then
		ply:SetJumpPower(ply.CustomJumpPower or 205)
		
		-- ply:Give("weapon_crowbar")
		
		ply:Give("weapon_sass_hands")
		ply:SelectWeapon("weapon_sass_hands")
		
		if(ply.Col) then
			ply:SetColor(Color(ply.Col.r, ply.Col.g, ply.Col.b, ply.Col.a))
		end
		
		ply:StartTime()
		
		local TeleportPos = self:GetInfo(ply, "TeleportPos", false)
		if(TeleportPos) then
			local LastEyeAngles = ply.LastEyeAngles
			local LastGravity = ply.LastGravity
			timer.Create( "STGamemodes.Teleport."..ply:SteamID(), 0.5, 1, function()
				if(IsValid(ply)) then
					ply:SetPos(TeleportPos)
					if(LastEyeAngles) then
						ply:SetEyeAngles(LastEyeAngles)
					end 
					if(LastGravity) then 
						ply:SetGravity(LastGravity) 
					end 
					ply:ChatPrint("You have been teleported to your last known pos")
				end
			end)
		end
	end
end

function GM:ShowSpare1(ply)
	if(!ply.FullyLoaded) then
		ply:ChatPrint("Your profile is not loaded, you may not receive dough for winning.")
	end
	if(ply.Level) then
		if(ply:Team() == TEAM_BHOP) then
			if(ply.NextLevelSelect and ply.NextLevelSelect >= CurTime()) then
				ply:ChatPrint("You can't change your level that fast!")
				return
			end
			local Index = 2
			if(self:CompletedAll(ply)) then
				Index = 3
			elseif(ply.Winner) then
				Index = 1
			end
			if(Index) then
				umsg.Start("bhop_level_select", ply)
					umsg.Short(Index)
					umsg.Bool(false)
				umsg.End()
			end
		else
			ply:GoTeam(TEAM_BHOP)
			ply:ChatPrint("You have spawned as a bunny hopper!")
		end
	else
		umsg.Start("bhop_level_select", ply)
			umsg.Short(1)
			umsg.Bool(false)
		umsg.End()
	end
end

function GM:Think()
	self.BaseClass.Think(self)
	-- STGamemodes.TouchEvents:CheckAll()
end

function GM:DoPlayerDeath(ply, Attacker, dmginfo)
	self.BaseClass.DoPlayerDeath(self, ply, Attacker, dmginfo)
	ply:SetVar("SpawnDelay", CurTime() + 6)
end

function GM:GetFallDamage(ply, fspeed)
	return false
end

function GM:EntityTakeDamage(ent, dmginfo)
	if(ent:IsNPC()) then
		dmginfo:ScaleDamage(0)
	end
end

function GM:PlayerUse(ply, ent)
	if(ply:Alive() and !ply:IsGhost()) then
		return true
	end
	return false
end

function GM:CanPlayerSuicide(ply)
	if(ply:GetVar("NextSuicide", CurTime() - 5) >= CurTime()) then
		ply:ChatPrint("You can't suicide yet!")
		return false
	end
	ply:SetVar("NextSuicide", CurTime() + 5)
	return true
end

function GM:PlayerCanPickupWeapon(ply, Weapon)
	if(ply:IsGhost()) then
		return false
	end
	if(IsValid(Weapon)) then
		return true
	elseif(ply.Winner) then
		if(!ply:HasWeapon(STGamemodes.RunGun)) then
			return true
		end
	elseif(!ply:IsNearSpawn()) then
		self:OnWin(ply)
		return true
	end
	return false
end

hook.Add("EntityKeyValue", "PropFreezer", function(ent, key, value)
	if key == "spawnflags" then
		local flags = tonumber(value)
		if flags then
			local class = ent:GetClass()
			local isRagdoll = class == "prop_ragdoll"
			if class == "prop_physics" or class == "prop_physics_multiplayer" or isRagdoll then
				local motionFlag = isRagdoll and 16384 or 8
				if !(bit.band(motionFlag, flags) == motionFlag) then
					return bit.bor(flags, motionFlag) 
				end
			end
		else
			return 0
		end
	end
end)

function GM:KeyPress(ply,key)
	self.BaseClass.KeyPress(self,ply,key)
	if (key == IN_JUMP) and ply:OnGround() then
		ply:IncrementJumpCount()
	end
end