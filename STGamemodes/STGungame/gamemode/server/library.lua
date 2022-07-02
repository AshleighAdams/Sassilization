--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes:RoundStart()
	STGamemodes:AutoTeamBalance()
	
	game.CleanUpMap()
	
	CorrectLasers()
	
	STGamemodes.TouchEvents:CheckAll()
	
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid()) then
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
	
	timer.Create("STGamemodes:NearSpawn", 30, 1, function() self.NearSpawn() end )
end

function STGamemodes:RoundCheck()
	if(self.Restarting) then
		return
	end
	
	local Restart = false
	
	if(self:TeamAliveNum({TEAM_RED}) == 0) then
		Restart = true
		WinnerTeam = {TEAM_BLUE}
		Message = "The blue team won"
	elseif(self:TeamAliveNum({TEAM_BLUE}) == 0) then
		Restart = true
		WinnerTeam = {TEAM_RED}
		Message = "The red team won"
	end
	
	if(Restart and Message) then
		if(WinnerTeam) then
			local Money = 100
			local EmitIt = self.WinSounds[math.random(1, table.Count(STGamemodes.WinSounds))]
			for k,v in pairs(self:GetPlayers(WinnerTeam)) do
				if(v:Alive()) then
					v:AddFrags(1)
					v:EmitSound(EmitIt, 500)
					local RecieveMoney = 100
					if(v:IsVIP()) then
						RecieveMoney = RecieveMoney * 2
					end
					v:GiveMoney(20, "You have recieved %s dough for winning the round")
				end
			end
		end
		self:RoundRestart(Message.."! ")
	end
end

function STGamemodes:NearSpawn()
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid() and v:Alive()) then
			if(v:IsNearSpawn()) then
				if(!STGamemodes:IsMoving(v)) then
					if(v:GetVar("AFKCheck", 0) <= (CurTime() - 10)) then
						v:SetAFK(true)
					end
				end
			end
		end
	end
end

function STGamemodes:GetTeamInfo()
	return TEAM_RED, TEAM_BLUE, team.NumPlayers(TEAM_RED), team.NumPlayers(TEAM_BLUE)
end

function STGamemodes:ChooseTeam(ply, Message)
	local Team = ply:Team()
	local Team1, Team2, Team1Num, Team2Num = self:GetTeamInfo()
	
	if(Team == Team1) then
		Team1Num = Team1Num + 1
	elseif(Team == Team2) then
		Team2Num = Team2Num + 1
	end
	
	if(Team1Num > Team2Num) then
		Team = Team2
	elseif(Team2Num > Team1Num) then
		Team = Team1
	else
		Team = math.random(math.Min(Team1, Team2), math.Max(Team1, Team2))
	end
	
	ply:GoTeam(Team)
	
	if(Message) then
		ply:ChatPrint("You are now on the "..string.lower(team.GetName(Team)).." team!")
	end
end

function STGamemodes:AutoTeamBalance(DeadPlayer)
	local Team1, Team2, Team1Num, Team2Num = self:GetTeamInfo()
	
	if(math.abs(Team1Num - Team2Num) <= 1) then
		return
	end
	
	local ChangeTarget = false
	local BiggerTeam = false
	local SmallerTeam = false
	
	if(Team1Num > Team2Num) then
		BiggerTeam = Team1
		SmallerTeam = Team2
	end
	if(Team2Num > Team1Num) then
		BiggerTeam = Team2
		SmallerTeam = Team1
	end
	
	local PlayerSort = player.GetAll()
	
	table.sort(PlayerSort, function(a, b)
		return a:TimeConnected() > b:TimeConnected()
	end)
	
	if(DeadPlayer) then
		if(DeadPlayer:Team() == BiggerTeam) then
			ChangeTarget = DeadPlayer
		end
	else
		for k, v in pairs(PlayerSort) do
			if(v and v:IsValid() and v:Team() == BiggerTeam) then
				ChangeTarget = v
			end
		end
	end
	
	if(!ChangeTarget) then
		return
	end
	
	if(DeadPlayer == ChangeTarget) then
		ChangeTarget:SetTeam(SmallerTeam)
	else
		ChangeTarget:GoTeam(SmallerTeam)
	end
	ChangeTarget:ChatPrint("You are now on the "..string.lower(team.GetName(SmallerTeam)).." team!")
end
