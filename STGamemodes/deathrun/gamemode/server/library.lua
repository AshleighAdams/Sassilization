--------------------
-- STBase
-- By Spacetech
--------------------

function GM:RoundChecks(CallBack)
	timer.Simple(0.25, function() self:DeathCheck() end )
	timer.Simple(0.5, function() self:RoundRestart() end )
	if(CallBack) then
		timer.Simple(0.51, function() CallBack() end )
	end
end

function GM:ShouldStartRound()
	if(table.Count(player.GetAll()) >= 2) then
		if(STGamemodes:GetNum({TEAM_RUN, TEAM_DEATH, TEAM_DEAD}) >= 2 and (STGamemodes:TeamAliveNum({TEAM_RUN}) == 0 or STGamemodes:TeamAliveNum({TEAM_DEATH}) == 0)) then
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
	
	local DeathWon = false
	local Runners = STGamemodes:TeamAliveNum({TEAM_RUN})
	local Death = STGamemodes:TeamAliveNum({TEAM_DEATH})
	if(Runners != 0 or Death != 0) then
		if(Runners == 0) then
			DeathWon = true
			Restart = true
			WinnerTeam = {TEAM_DEATH}
			Message = "Death has triumphed"
		else
			Restart = true
			WinnerTeam = {TEAM_RUN, TEAM_DEAD}
			Message = "The Runners have prevailed"
		end
	end
	
	if(Runners == 1) then
		for k,v in pairs(STGamemodes:GetPlayers({TEAM_RUN})) do
			STAchievements:AddCount(v, "Living Hope")
		end
	end
	
	if(Restart and Message) then
		self:RoundRestart(Message.."! ", function()
			if(WinnerTeam) then
				local Money = 100
				if(DeathWon) then
					Money = 50
				end
				local EmitIt = STGamemodes.WinSounds[math.random(1, table.Count(STGamemodes.WinSounds))]
				for k,v in pairs(STGamemodes:GetPlayers(WinnerTeam)) do
					if(v:Alive()) then
						v:AddFrags(1)
						v:EmitSound(EmitIt, 500)
						local RecieveMoney = Money
						if(v:IsVIP()) then
							RecieveMoney = RecieveMoney * 2
						end
						if(v:GetVar("RecieveDough", false)) then
							v:GiveMoney(RecieveMoney, "You have recieved %s dough for winning the round")
						else
							v:GiveMoney(math.Round(RecieveMoney / 5), "You have recieved %s dough for surviving the round")
						end
						
						if(DeathWon) then
							STAchievements:AddCount(v, "Grim Reaper")
						else
							STAchievements:AddCount(v, "Trap Runner")
							
							if(v:Health() <= 10) then
								STAchievements:AddCount(v, "Lucky Survivor")
							end
						end
						
						STAchievements:AddCount(v, "Survivalist")
					end
				end
			end
		end)
	end
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
	
	self.PickedUp = false
	
	timer.Destroy("GM.NearSpawn")
	timer.Destroy("GM.TimerEndRoundEnd")
	
	local Time = 5
	if(self.ServerStarted) then
		self.ServerStarted = false
		Time = 15
	end
	
	timer.Simple(Time, function() self:RoundStartCache() end )
	STGamemodes:PrintAll((AddMessage or "").."A New Round will begin in "..tostring(Time).." seconds")
	
	if STGamemodes.Vote.Voting and STGamemodes.Vote.isVoteSlay then
		STGamemodes.Vote:Cancel()
		STGamemodes.Logs:ParseLog("[VOTESLAY] New round starting, vote has been canceled", ply)
		STGamemodes:PrintAll("[VOTESLAY] New round starting, vote has been canceled")
	end
	
	return true
end

function GM:RoundStartCache()
	if(!self.Restarting) then
		return
	end
	self:NewDeath()
	timer.Simple(0.25, function() self:RoundStart() end )
end

function GM:RoundStart()
	self.RoundTime = CurTime()
		
	for k,v in pairs(ents.FindByClass("weapon_*")) do
		if(v and v:IsValid()) then
			v:Remove()
		end
	end
	
	for k,v in pairs(ents.FindByClass("prop_ragdoll")) do
		if(v and v:IsValid()) then
			v:Remove()
		end
	end
	
	game.CleanUpMap()
	
	CorrectLasers()
	
	STGamemodes.Weapons:RemoveGuns()
	STGamemodes.Weapons:Spawn()
	STGamemodes.TouchEvents:CheckAll()
	STGamemodes.Buttons:RunNow()
	STGamemodes.KeyValues:Run()
	
	gamemode.Call("OnRoundChange")
	
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid()) then
			v:UnClaimButton()
			
			v:SetVar("WasDeath", false)
			v:SetVar("SkipRound", false)
			v:SetVar("RecieveDough", false)
			v:SetVar("RoundEndAlert", false)
			
			if(v:Team() != TEAM_SPEC and v:GetVar("ChangeTeam", false)) then
				v:SetTeam(v:GetVar("ChangeTeam", false))
				v:SetVar("ChangeTeam", false)
			end
			
			if(v:Team() == TEAM_DEAD) then
				v:SetTeam(TEAM_RUN)
			end
			
			if(v:Team() == TEAM_DEATH) then
				v:SetVar("DeathCount", v:GetVar("DeathCount", 0) + 1)
				v:SetVar("RecieveDough", true)
			end
			
			if(v:Team() == TEAM_RUN) then
				v:SetVar("DeathCount", 0)
			end
			
			v:Spawn()
			
			if(v:GetVar("SprayInfo", false)) then
				local ent = ents.Create("info_spray")
				ent:SetOwner(v)
				ent:SetPos(v:GetVar("SprayInfo", false).pos)
				ent:SetAngles(v:GetVar("SprayInfo", false).ang)
				ent:Spawn()
				ent:Activate()
				v:SetVar("Spray", ent)
			end
		end
	end
	
	self.Restarting = false
	self.RoundStarted = CurTime()
	
	timer.Create("GM.NearSpawn", 30, 1, function() self:NearSpawn() end )
end

function GM:TimerEndRoundStart()
	if(self.Restarting or self.RoundEndTime) then
		return
	end
	
	self.RoundEndTime = CurTime() + 60
	
	umsg.Start("DeathrunEndRoundTimer")
		umsg.Long(self.RoundEndTime)
	umsg.End()
	
	timer.Create("GM.TimerEndRoundEnd", 2, 0, function() self:TimerEndRoundEnd() end )
end

function GM:TimerEndRoundEnd()
	if(self.RoundEndTime <= CurTime()) then
		self.ForceRestart = true
		self:RoundRestart("Nobody won! ", function()
			for k,v in pairs(player.GetAll()) do
				if(v:Alive()) then
					v:Kill()
				end
			end
		end, true)
	else
		local rp = RecipientFilter()
		for k,v in pairs(player.GetAll()) do
			if(!v:GetVar("RoundEndAlert", false)) then
				rp:AddPlayer(v)
			end
		end
		umsg.Start("DeathrunEndRoundTimer", rp)
			umsg.Long(self.RoundEndTime)
		umsg.End()
	end
end

concommand.Add("st_roundend_confirm", function(ply)
	if(!GAMEMODE.RoundEndTime or !ply:GetVar("RoundEndAlert", false)) then
		return
	end
	ply:SetVar("RoundEndAlert", true)
end)

function GM:GetRoundTime()
	if(self.RoundTime) then
		return CurTime() - self.RoundTime
	end
	return false
end

function GM:NearSpawn()
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid() and v:Team() == TEAM_RUN) then
			if(v:IsNearSpawn()) then
				if(!STGamemodes:IsMoving(v)) then
					if(v:GetVar("AFKCheck", 0) <= (CurTime() - 10)) then
						v:SetAFK(true)
					end
				end
			end
		end
	end
	self:RoundChecks()
end

function GM:NewDeath(FuncCount)
	local Death = 0
	local FuncCount = FuncCount or 1
	
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid()) then
			if(v:Team() == TEAM_DEATH or v:GetVar("ChangeTeam", false) == TEAM_DEATH) then
				if(v:GetVar("DeathCount", 0) >= 1) then
					v:SetVar("DeathCount", 0)
					v:SetVar("WasDeath", true)
					v:SetTeam(TEAM_DEAD)
					-- v:ChatPrint("You have been death long enough. You are now a runner!")
				else
					Death = Death + 1
				end
			end
		end
	end
	
	if(Death >= 4 or Death * 7 > STGamemodes:GetNum({TEAM_RUN, TEAM_DEAD})) then
		return
	end
	
	local Players = STGamemodes:GetPlayers({TEAM_RUN, TEAM_DEAD})
	
	local Count = table.Count(Players)
	
	if(Count == 0) then
		return
	end
	
	-- math.randomseed(os.time())
	local ply = Players[math.random(1, Count)]

	if(ply:GetVar("ChangeTeam", false) != TEAM_DEATH) then
		ply:SetVar("ChangeTeam", TEAM_DEATH)
		ply:ChatPrint("You've been randomly selected to be Death")
		ply:ChatPrint("TIP: You can right click to claim buttons!")
		
		if(ply:GetVar("WasDeath", false)) then
			STAchievements:Award(ply, "Random or Not?", true)
		end
	end
	
	if(FuncCount >= 100) then
		return
	end
	
	return self:NewDeath(FuncCount + 1)
end

concommand.Add("st_roundstart", function(ply)
	if(!ply:IsSuperAdmin()) then
		return
	end
	GAMEMODE:RoundStart()
end)

////////////////////////////////////////////////////////////

function STGamemodes:MassNPCRelationship(ply, Disposition)
	for k,v in pairs(ents.FindByClass("npc_*")) do
		if(v:IsNPC()) then
			v:AddEntityRelationship(ply, Disposition, 99)
		end
	end
end

function STGamemodes:OnPlayerSpawn(ply, SpecGhost)
	if(SpecGhost) then
		self:MassNPCRelationship(ply, D_LI)
	else
		self:MassNPCRelationship(ply, D_HT)
	end
end

function STGamemodes:OnPlayerDeath(ply)
	self:MassNPCRelationship(ply, D_LI)
end

timer.Create("ClaimChecker", 0.25, 0, function()
	for k,v in pairs(ents.FindByClass("func_button")) do
		v:CheckClaimed()
	end
	for k,v in pairs(ents.FindByClass("func_rot_button")) do
		v:CheckClaimed()
	end
end)
