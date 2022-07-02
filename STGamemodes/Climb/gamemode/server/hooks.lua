--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.TeleportPos = {}

function GM:InitPostEntity()
	self.BaseClass.InitPostEntity(self)
	self.ServerStarted = true
	STGamemodes:RemoveEntities()
	STGamemodes:InitHostages()
end

function GM:PlayerOnRank(ply, rank)
	self.BaseClass.PlayerOnRank(self, ply, rank)
	if(!STValidEntity(ply)) then
		return
	end
	ply:ChatPrint("Welcome to Climb! Press F1 for help. You can earn more dough per hostage by completing a map without saving")
	ply:ChatPrint("If you are going to nosave the map, we recommend disabling saves by typing /nosave in chat")
	ply:ChatPrint("Press F3 to start climbing!")
end

function GM:PlayerInitialSpawn(ply)
	self.BaseClass.PlayerInitialSpawn(self, ply)
	
	ply:GoTeam(TEAM_SPEC)
	
	if(STGamemodes.Winners[ply:SteamID()]) then
		ply.Winner = true
		ply.CanHaveTrail = true
		ply:SetNWString("ScoreboardStatus", "Winner")
	end
end

function GM:PlayerSpawn(ply)
	self.BaseClass.PlayerSpawn(self, ply)
	
	ply:CrosshairEnable()
	
	self:InitSpeed(ply)
	
	ply:SetJumpPower(205) --195
	ply:SetGravity(1) -- Fixes spawning with low grav
	
	if(ply:Alive()) then
		ply:Give("weapon_crowbar")
	end
	-- ply:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE) TODO: Check if this works on players now

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
	
	STGamemodes.Spectater:Spawn(ply)

	timer.Destroy("LastPos-"..ply:SteamID())
	local TelePos = STGamemodes.TeleportPos[ply:SteamID()]
	if ply:Team() == TEAM_CLIMB and TelePos then 
		timer.Create("LastPos-"..ply:SteamID(), 0.5, 1, function()
			if !ply:IsValid() or !TelePos[1] then return end 
			ply:SetPos(TelePos[1])
			if TelePos[2] then ply:SetEyeAngles(TelePos[2]) end 
			if TelePos[3] then ply:SetGravity(TelePos[3]) end 
			ply:SetVelocity(Vector(0, 0, 0))
			ply:SetLocalVelocity(Vector(0, 0, 0))
			ply:ChatPrint("You have been teleported to your last known position!")
		end )
	end

	if(ply.Winner) then
		ply:Give("st_jetpack")
	end
end

function GM:ShouldDeleteSavePos(ply, Att)
	if STGamemodes.NoSaveBonus[ply:SteamID()] then return end 

	local GroundEntity = ply:GetGroundEntity()
	if(GroundEntity and GroundEntity != game.GetWorld()) then
		if(!IsValid(GroundEntity)) then
			STGamemodes.TeleportPos[ply:SteamID()] = nil
		end
	end 

	if Att and Att:IsValid() and Att:GetClass() == "trigger_hurt" then 
		STGamemodes.TeleportPos[ply:SteamID()] = nil 
	end 
end 

function GM:ShouldSaveCurrentPos(ply)
	-- return false 
	local GroundEntity = ply:GetGroundEntity()
	if(GroundEntity and GroundEntity != game.GetWorld()) then
		if(!IsValid(GroundEntity)) then
			return false
		end
		if GroundEntity:GetClass() == "func_door" or GroundEntity:GetClass() == "func_rotating" then 
			return false 
		end 
	elseif ply:Crouching() or !ply:Alive() then 
		return false 
	end 

	if STGamemodes.Maps.CurrentMap == "xc_toonrun2_gm" then 
		local Pos = ply:GetPos()
		if Pos.x <= -432 and Pos.x >= -596 then 
			if Pos.y >= -1481 and Pos.y <= 777 then 
				if Pos.z <= 1357 and Pos.z >= 1012 then 
					return false 
				end 
			end 
		end 
 	end 
	return true
end

function GM:OnSaveCurrentPos(ply, Pos, EyeAngle)
	STGamemodes.TeleportPos[ply:SteamID()] = {Pos, ply:EyeAngles(), Gravity}
end

hook.Add( "PlayerDisconnected", "PauseTimer", function( ply )
	ply:PauseTime()
	gamemode.Call( "ShouldDeleteSavePos", ply )
end )

function GM:OnSpec(ply)
	ply:PauseTime()
	gamemode.Call( "ShouldDeleteSavePos", ply )
end

function GM:ShowSpare1(ply)
	if(ply:Team() == TEAM_CLIMB) then
		umsg.Start( "STGamemodes.ClimbRestart", ply ) -- Ask if they want to restart.
		umsg.End()
		return
	end

	if(!ply.CanPlay) then
		ply:ChatPrint("Your profile is not loaded, you may not receive dough for winning.")
		-- ply:ChatPrint("Please wait until your profile loads!")
		-- return
	end

	ply:GoTeam(TEAM_CLIMB)
	ply:ChatPrint("You have spawned as a climber!")
	ply:PayoutMsg()
	ply:StartTime()
	
	if(!STGamemodes.Winners[ply:SteamID()]) then
		ply:SetNWString("ScoreboardStatus", "Playing") 
	end
end

function GM:Think()
	self.BaseClass.Think(self)
	STGamemodes.TouchEvents:CheckAll()
end

function GM:DoPlayerDeath(ply, Attacker, dmginfo)
	self.BaseClass.DoPlayerDeath(self, ply, Attacker, dmginfo)
	ply:SetVar("SpawnDelay", CurTime() + 6)

	gamemode.Call( "ShouldDeleteSavePos", ply, Attacker )
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
	if(ply:Alive()) then
		if(ent:IsNPC() and ent.UsedHostage and ply:Visible(ent)) then
			STGamemodes:OnWin(ply)
			STGamemodes:OnHostage(ply, ent)
		end
		return true
	end
	return false
end

function GM:CanPlayerSuicide(ply)
	if(ply:GetVar("NextSuicide", CurTime() - 5) >= CurTime()) then
		ply:ChatPrint("You can't suicide yet!")
		return false
	end
	ply:SetVar("NextSuicide", CurTime() + 10)
	return true
end

function GM:PlayerCanPickupWeapon(ply, Weapon)
	if(!ply.Winner) then
		if(STValidEntity(Weapon) and (Weapon:GetClass() == "weapon_crowbar" or Weapon:GetClass() == "weapon_frag")) then
			return true
		end
		return false
	end
	return true
end

hook.Add("EntityKeyValue", "PropFreezer", function(ent, key, value)
	if key == "spawnflags" then
		local flags = tonumber(value)
		if flags then
			local class = ent:GetClass()
			local isRagdoll = class == "prop_ragdoll"
			if class == "prop_physics" or class == "prop_physics_multiplayer" or isRagdoll then
				local motionFlag = isRagdoll and 16384 or 8
				if !(bit.band(flags, motionFlag)) then
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
