--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Vote = {}
STGamemodes.Vote.Votes = {}
STGamemodes.Vote.Choices = {}
STGamemodes.Vote.Voting = false
STGamemodes.Vote.Time = 30

function STGamemodes.Vote.CastVote(ply, cmd, args)
	if(!STGamemodes.Vote.Voting) then
		return
	end
		
	local Vote = args[1]
	
	if(!Vote) then
		-- if(!ply.Voted) then
			-- ply.Voted = true
			-- umsg.Start("STGamemodes.Vote.Voted", ply)
			-- umsg.End()
			-- ply:ChatPrint("You have ignored this vote")
			-- STGamemodes:ConsolePrint(ply:CName().." has ignored this vote")
		-- end
		return
	end
	
	Vote = tostring(Vote)
	
	-- if ply.OldVote and Vote == ply.OldVote then return end
	
	-- if(ply.Voted) then
		-- ply:ChatPrint("You already voted!")
		-- return
	-- end
	
	local Valid = false
	for k,v in pairs(STGamemodes.Vote.Choices) do
		if(Vote == v) then
			Valid = true
			break
		elseif(type(v) == "table") then
			if(v[1] == Vote) then
				Valid = true
				break
			end
		end
	end
	if(!Valid) then
		return
	end
	
	ply.Voted = true
	ply:ChatPrint( "You voted for \'".. Vote ..".\' Change your vote by using '/revote'" )
	
	umsg.Start("STGamemodes.Vote.Voted", ply)
		umsg.String(Vote)
	umsg.End()
	
	if(!STGamemodes.Vote.Votes[Vote]) then
		STGamemodes.Vote.Votes[Vote] = 0
	end
	
	local Add = 1
	if(ply:IsVIP() and !STGamemodes.Vote.Voteslay) then
		Add = Add + 1
	end
	STGamemodes.Vote.Votes[Vote] = STGamemodes.Vote.Votes[Vote] + Add
	if ply.OldVote then STGamemodes.Vote.Votes[ply.OldVote] = STGamemodes.Vote.Votes[ply.OldVote] - Add end
	
	ply.OldVote = Vote
	
	-- umsg.Start("STGamemodes.Vote.Set")
		-- umsg.String(Vote)
		-- umsg.Short(STGamemodes.Vote.Votes[Vote])
	-- umsg.End()
	
	-- ply:ChatPrint("You voted: "..Vote)
	-- STGamemodes:ConsolePrint(ply:CName().." has voted: "..Vote)
end
concommand.Add("st_vote_cast", STGamemodes.Vote.CastVote)

function STGamemodes.Vote:Start(Name, Choices, FuncStart, FuncEnd, Ply, CanCancel, isVoteSlay)
	if(!Name or !Choices or !FuncStart) then
		return
	end
	if(self.Voting) then
		timer.Simple(5, function() self:Start(Name, Choices, FuncStart, FuncEnd, Ply, CanCancel, isVoteSlay) end )
		return
	end
	
	self.Voting = true
	self.CanCancel = CanCancel
	self.isVoteSlay = isVoteSlay
	self.Canceled = false

	self.Name = Name 
	self.Choices = Choices
	self.FuncStart = FuncStart
	self.FuncEnd = FuncEnd
	self.Ply = Ply

	local minimize = false
	if self.isVoteSlay then
		if string.find(string.lower(Name),"spam") and (string.find(string.lower(Name),"trap") or string.find(string.lower(Name),"button")) then
			minimize = true
		else
			minimize = false
		end 
	end 
	
	if(Ply and !Ply:IsValid()) then
		return
	end
	
	local Name = Name
	if(Ply) then
		if(Ply and Ply:IsValid()) then
			Name = string.format(Name, Ply:CName())
		end
	end
	
	umsg.Start("STGamemodes.Vote.Start")
		umsg.String(Name)
	umsg.End()
	
	local Time = 0.1
	for k,v in pairs(Choices) do
		local Text, StartBool = v, false 
		if(type(Text) == "table") then
			Text = v[1]
		end
		if(!Choices[k + 1]) then
			StartBool = true
		end
		timer.Simple(Time, function()
			umsg.Start("STGamemodes.Vote.SendChoice")
				umsg.String(Text)
				umsg.Bool(StartBool)
			umsg.End()
		end)
		Time = Time + 0.2
	end
	
	timer.Simple(Time, function() FuncStart(Ply) end )
	timer.Create( "VoteEndTimer", minimize and 15 or self.Time, 1, function() self:End(Name, Choices, FuncStart, FuncEnd, Ply) end )
end

function STGamemodes.Vote:End(Name, Choices, FuncStart, FuncEnd, Ply)
	if(!self.Voting) then
		return
	end
	
	local Most = false
	local Winner = false
	
	for k,v in pairs(self.Votes) do
		if(!Most or Most < v) then
			Most = v
			Winner = k
		end
	end
	
	if(Ply and !Ply:IsValid()) then
		return
	end
	
	for k,v in pairs(Choices) do
		if(type(v) == "table") then
			if(v[1] == Winner) then
				Winner = v[2]
				break
			end
		end
	end
	
	FuncEnd(Winner, Ply, self.Canceled)

	self:Cancel()
end

function STGamemodes.Vote:Cancel()
	if !timer.Exists( "VoteEndTimer" ) or !self.Voting then return end
	timer.Destroy( "VoteEndTimer" )
	for k,v in pairs(player.GetAll()) do
		v.Voted = false
		v.OldVote = nil
		v:SendLua("STGamemodes.Vote:Reset()")
	end
	
	umsg.Start("STGamemodes.Vote.End")
	umsg.End()
	
	self.Votes = {}
	self.Voting = false
end

function STGamemodes.Vote:EndEarly() 
	self.Canceled = true 
	timer.Create( "VoteEndTimer", 0.5, 1, function() self:End(self.Name, self.Choices, self.FuncStart, self.FuncEnd, self.Ply) end ) 
end 
