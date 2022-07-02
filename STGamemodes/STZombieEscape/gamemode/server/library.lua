--------------------
-- STBase
-- By Spacetech
--------------------

CVAR_ZHEALTH_MIN		= CreateConVar( "zombie_health_min", 3200, {FCVAR_REPLICATED}, "" )
CVAR_ZHEALTH_BONUS		= CreateConVar( "zombie_health_min", 4300, {FCVAR_REPLICATED}, "" )

CVAR_ZSPAWN_MIN			= CreateConVar( "zombie_timer_min", 10, {FCVAR_REPLICATED}, "Minimum time from the start of the round until picking the mother zombie(s)." )
CVAR_ZSPAWN_MAX 		= CreateConVar( "zombie_timer_max", 25, {FCVAR_REPLICATED}, "Maximum time from the start of the round until picking the mother zombie(s)." )
CVAR_ZSPAWN_TIMELIMIT	= CreateConVar( "zspawn_timelimit_time", 180, {FCVAR_REPLICATED}, "Time from the start of the round to allow late zombie spawning." )

GM.RoundCanEnd = true
GM.PlayerModelOverride = {}

function GM:RoundChecks(CallBack)
	timer.Simple(0.25, self.DeathCheck, self)
	timer.Simple(0.5, self.RoundRestart, self)
	if(CallBack) then
		timer.Simple(0.51, CallBack)
	end
end

function GM:ShouldStartRound()

	if self.RoundCanEnd and #player.GetAll() >= 2 then

		local numply = STGamemodes:GetNum({TEAM_HUMANS, TEAM_ZOMBIES, TEAM_DEAD})
		if numply >= 2 and ( STGamemodes:TeamAliveNum({TEAM_HUMANS}) == 0 or STGamemodes:TeamAliveNum({TEAM_ZOMBIES}) == 0 ) then
			return true
		end

	end

	return false

end

function GM:DeathCheck()
	if(self.Restarting) then
		return
	end
	
	local Restart = false
	local Message = false
	local WinnerTeam = false
	
	local HumansWon = false
	local Humans = 	STGamemodes:TeamAliveNum({TEAM_HUMANS})
	local Zombies = STGamemodes:TeamAliveNum({TEAM_ZOMBIES})
	if(Humans != 0 or Zombies != 0) then
		if(Humans == 0) then
			Restart = true
			WinnerTeam = {TEAM_ZOMBIES}
			Message = "Zombies won"
		else
			Restart = true
			HumansWon = true
			WinnerTeam = {TEAM_HUMANS, TEAM_DEAD}
			Message = "The Humans prevailed"
		end
	else -- no one is alive
		if !self.ServerStarted and (Humans == 0 and Zombies == 0) then -- all players died before round start..
			Restart = true
			WinnerTeam = {TEAM_ZOMBIES}
			Message = "Zombies won"
			self.RoundCanEnd = true
		end
	end
	
	if(Restart and Message) then

		self:RoundRestart(Message.."! ", function()

			if(WinnerTeam) then

				Update_Wins( HumansWon and "humans" or "zombies" ) -- Up the stat

				self:SendWinner(HumansWon,false) -- display texture

				local Money = HumansWon and 65 or 40
				local EmitIt = STGamemodes.WinSounds[math.random(1, table.Count(STGamemodes.WinSounds))]
				local WinningPlayers = STGamemodes:GetPlayers(WinnerTeam)
				for k,v in pairs(WinningPlayers) do

					if v:Alive() then

						v:AddFrags(1)

						if HumansWon then

							v:EmitSound(EmitIt, 500)
							if Humans == 1 then
								STAchievements:Award(v, "Last Man Standing", true)
							end

						end

						local RecieveMoney = v:IsVIP() and Money*2 or Money
						v:GiveMoney(RecieveMoney, "You have recieved %s dough for playing")

					end

				end

			end

		end)
	end
end

function GM:SendWinner( bHumansWon, bReset )
	umsg.Start("WinningTeam")
		umsg.Bool(bHumansWon)
		umsg.Bool(bReset)
	umsg.End()
end

GM.Restarting = false
function GM:RoundRestart(AddMessage, CallBack)
	if(self.Restarting) then
		return -1
	end
	if(!self.ForceRestart and !self:ShouldStartRound()) then
		return -2
	end
	
	self.Restarting = true
	self.ForceRestart = false
	self.RoundEndTime = false
	
	if(CallBack) then
		CallBack()
	end
	
	timer.Destroy("GM.NearSpawn")
	timer.Destroy("GM.TimerEndRoundEnd")
	
	local Time = 5
	if(self.ServerStarted) then
		self.ServerStarted = false
		Time = 15
	end
	
	timer.Simple(Time, self.RoundStart, self)
	STGamemodes:PrintAll((AddMessage or "").."A New Round will begin in "..tostring(Time).." seconds")
	
	return true
end

function GM:RoundStart()
	if(!self.Restarting) then
		return
	end
	
	self.RoundCanEnd = false
	self.RoundTime = CurTime()
	self.InfectionStarted = false
	
	self:CleanUpMap()
	
	-- Spawn all non-spectators as humans
	for _, ply in pairs(player.GetAll()) do
		if(IsValid(ply) and ply:Team() != TEAM_SPEC) then
			ply.CustomSpeed = nil
			ply:SetTeam(TEAM_HUMANS)
			ply:Spawn()
			
			if(ply:GetVar("SprayInfo", false)) then
				local ent = ents.Create("info_spray")
				ent:SetOwner(ply)
				ent:SetPos(ply:GetVar("SprayInfo", false).pos)
				ent:SetAngles(ply:GetVar("SprayInfo", false).ang)
				ent:Spawn()
				ent:Activate()
				ply:SetVar("Spray", ent)
			end
		end
	end
	
	gamemode.Call("OnRoundChange")
	
	self:SendWinner(false,true) -- Reset winner
	
	self.Restarting = false
	self.RoundStarted = CurTime()
	
	local scale = math.Clamp( 1 - (#STGamemodes:GetPlayers(TEAM_BOTH) / MaxPlayers()), 0, 1 )
	scale = (scale > 0.7) and 1 or scale -- only take effect with larger amount of players

	local Time = ZEMAPTIMES[STGamemodes.Maps.CurrentMap] or CVAR_ZSPAWN_MIN:GetInt() + (CVAR_ZSPAWN_MAX:GetInt() - CVAR_ZSPAWN_MIN:GetInt())*scale
	if !self.FirstSpawn then
		Time = Time + 3 -- additional time for players selecting their weapons
		self.FirstSpawn = true
	end
	
	timer.Simple(Time, function()
		math.randomseed(os.time())
		self:RandomInfect()
		self.InfectionStarted = true
	end)

	timer.Create("GM.NearSpawn", 30, 1, function() self.NearSpawn() end )
	
end

function GM:NearSpawn()
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid() and v:Team() == TEAM_HUMANS) then
			if(v:IsNearSpawn() and !STGamemodes:IsMoving(v)) then
				if(v:GetVar("AFKCheck", 0) <= (CurTime() - 10)) then
					v:SetAFK(true)
				end
			end
		end
	end
	self:RoundChecks()
end

function GM:RandomInfect()
	
	local ply
	
	-- Get random player to infect
	local Players = STGamemodes:GetPlayers({TEAM_HUMANS})
	for _, pl in RandomPairs(Players) do
		if IsValid(pl) then
			ply = pl
			break
		end
	end

	if !IsValid(ply) then
		ply = Players[1]
	end
	
	if IsValid(ply) then
		ply:GoTeam(TEAM_ZOMBIES)
		--ply.KnockbackMultiplier = 3.6 -- Mother zombies are more resistent to knockback affects
		ply.bMotherZombie = true
		ply:ChatPrint("You have been randomly selected to be a zombie.")
	end

	-- Max of 5 mother zombies, 1:7 zombies ratio
	local Zombies = STGamemodes:GetNum({TEAM_ZOMBIES})
	if(Zombies >= 5 or Zombies * 7 > STGamemodes:GetNum({TEAM_HUMANS, TEAM_DEAD})) then
		return Msg("Zombie selection finished: " .. tostring(Zombies))
	else
		if Zombies < 1 then
			return ErrorNoHalt("GM.RandomInfect: Failed to infect a zombie, no players?\n")
		end

		self:RandomInfect()
	end

end


local EntitiesToRemove = {
	--"player_speedmod",
	--"game_player_equip",
	--"weapon_*",
	"prop_ragdoll"
}
function GM:CleanUpMap()
	
	-- Zombie Escape maps save values in several
	-- entities, commonly used for difficulty levels
	game.CleanUpMap( false, {"func_brush","env_global"} )
	
	-- Fix broken entity collisions
	for _, ent in pairs(ents.FindByClass("func_physbox_multiplayer")) do
		ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	end
	for _, ent in pairs(ents.FindByClass("func_movelinear")) do
		if ent:HasSpawnFlags(8) then -- broken in gmod?
			ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		end
	end
	
	-- Respawn point_servercommand as new lua-based entity
	for _, v in pairs(ents.FindByClass("point_servercommand")) do
		local name = v.targetname
		if name then
			local ent = ents.Create("point_servercommand_new")
			ent:SetPos(v:GetPos())
			v:Remove()
			ent:SetKeyValue("targetname", name)
			ent:Spawn()
		else
			Msg("[ZE] " .. tostring(v) .. " targetname missing\n")
		end
	end
	
	-- Remove unwanted entities
	for _, class in pairs(EntitiesToRemove) do
		for _, ent in pairs(ents.FindByClass(class)) do
			 -- ents with targetnames are typically important
			if IsValid(ent) && !ent.OnPlayerPickup && ent:GetName() == "" then
				ent:Remove()
			end
		end
	end
	
	self:CheckDifficultySettings()
	
	CorrectLasers()
	
	--STGamemodes.Weapons:RemoveGuns()
	STGamemodes.TouchEvents:CheckAll()
	
end

function GM:ZombieSpawn( ply )
	local mdl = self.ZombieModels[math.random(1,#self.ZombieModels)]
	
	-- Map specific zombie models
	local override = self.PlayerModelOverride[TEAM_ZOMBIES]
	if override then
		mdl = override[math.random(1,#override)]
	end
	
	ply:SetModel(mdl)
	ply:SetFOV(110)

	local scale = math.Clamp( 1 - (#STGamemodes:GetPlayers(TEAM_BOTH) / MaxPlayers()), 0, 1 )
	scale = (scale > 0.7) and 1 or scale -- only take effect with larger amount of players

	local health = CVAR_ZHEALTH_MIN:GetInt() + CVAR_ZHEALTH_BONUS:GetInt()*scale
	ply:SetHealth(health)
	ply:SetMaxHealth(health)
	
	ply:Flashlight(false)
	ply:StripWeapons() -- zombies can't use guns, silly!
	ply:Give("zombie_arms")

	ply:ZScream()
	
	ply.NextHealthRegen = CurTime() + 5
	ply.NextMoan = CurTime() + math.random(25,45)
	ply.KnockbackMultiplier = 2.8


end

GM.ValidHumans = {"male14","male18","male12","male17","male13","male10","male16","male15","male11",
	"female8","female9","female10","female11","female12","female7"}
function GM:HumanModelCheck(ply)
	if STGamemodes.ModelTable[ply:SteamID()] then return end -- don't override custom models

	-- Map specific player models
	local override = self.PlayerModelOverride[TEAM_HUMANS]
	if override then
		ply:SetModel(override[math.random(1,#override)])
		STGamemodes:GenderCheck(ply, ply:GetModel())
		return
	end

	if !string.find(ply:GetModel(), "Group03") then
		local mdl = player_manager.TranslatePlayerModel( self.ValidHumans[math.random(1,#self.ValidHumans)] )
		ply:SetModel(mdl)
		STGamemodes:GenderCheck(ply, mdl)
	end
end

/*---------------------------------------------------------
	Sent from point_servercommand entities
---------------------------------------------------------*/
function GM:SendMapMessage(str)
	if self:ShouldIgnoreMessage(string.lower(str)) then return end
	STNotifications:Send(str, NOTIFY_HINT)
end

-- Messages may be found by enabling 'developer 2'
-- in SP or browsing a map's entity list
GM.MessagesToIgnore = {}
function GM:IgnoreMessages(tbl)
	for _, msg in pairs(tbl) do
		table.insert(self.MessagesToIgnore, string.lower(msg))
	end
end

function GM:ShouldIgnoreMessage(str)
	for _, msg in pairs(self.MessagesToIgnore) do
		if string.find(msg, str) then return true end
	end

	return false
end

/*---------------------------------------------------------
	Custom speed settings
	Desc: Used in events such as a zombie
	getting hurt by a grenade
---------------------------------------------------------*/
local function CheckCustomSpeed(ply)
	if(ply:IsZombie()) then
		if(ply:IsOnFire()) then
			if(ply.CustomSpeed) then
				if(ply:WaterLevel() >= 2) then
					ply:Extinguish()
				end
			else
				ply.CustomSpeed = math.Round(GAMEMODE.CSSSpeed * 0.5)
				GAMEMODE:InitSpeed(ply)
			end
		else
			if(ply.CustomSpeed) then
				ply.CustomSpeed = nil
				GAMEMODE:InitSpeed(ply)
			end
		end
	end
end

hook.Add("Think", "CustomSpeedThink", function()
	for k,v in pairs(player.GetAll()) do
		CheckCustomSpeed(v)
	end
end)

/*---------------------------------------------------------
	Zombie Think
		Moan every 25 to 35 seconds,
		Health Regen,
		Weapon check
---------------------------------------------------------*/
hook.Add("Think", "ZombieThink", function()
	for _, ply in pairs(STGamemodes:GetPlayers({TEAM_ZOMBIES})) do
		if IsValid(ply) && ply:Alive() then
			-- Zombie moan
			if (ply.NextMoan < CurTime()) then
				ply:ZMoan()
			end
			
			-- Health regeneration
			local health = ply:Health()
			if ply.NextHealthRegen < CurTime() && health < ply:GetMaxHealth() then
				local newhealth = math.Clamp( health + math.random(50, 150), 0, ply:GetMaxHealth() )
				ply:SetHealth( newhealth )
				ply.NextHealthRegen = CurTime() + math.random(2,3)
			end
			
			-- Weapon check
			if !ply:HasWeapon("zombie_arms") then
				ply:Give("zombie_arms")
				ply:SelectWeapon("zombie_arms")
			end
		end
	end
end)
