--------------------
-- STBase
-- By Spacetech
--------------------

Jukebox.MinID = 1000
Jukebox.MaxID = 10000

Jukebox.Playing = {}
Jukebox.UniqueIDs = {}

function Jukebox:IsUID(ID)
	for k,v in pairs(self.UniqueIDs) do
		if(k == ID) then
			return true
		end
	end
	return false
end

function Jukebox:GenerateUID(ply)
	local ID = math.random(self.MinID, self.MaxID)
	while(self:IsUID(ID)) do
		ID = math.random(self.MinID, self.MaxID)
	end
	ply.JukeboxUniqueID = ID
	ply.JukeboxUniqueWaiting = true
	if(tmysql) then
		tmysql.query("UPDATE sa_misc SET jukebox_uid = '"..tostring(STGamemodes.Forums.ID)..tostring(ID).."' WHERE steamid = '"..ply:SteamID().."'")
	end
end

function Jukebox:SendUID(ply)
	if(!IsValid(ply)) then
		return
	end
	if(!ply.JukeboxUniqueWaiting) then
		return
	end
	umsg.Start("Jukebox.UID", ply)
		umsg.Short(ply.JukeboxUniqueID)
	umsg.End()
	timer.Simple(4, function() Jukebox.SendUID(Jukebox, ply) end)
end

function Jukebox.ConfirmUID(ply, cmd, args)
	if(!IsValid(ply)) then
		return
	end
	ply.JukeboxUniqueWaiting = nil
end
concommand.Add("jukebox_confirmuid", Jukebox.ConfirmUID)

hook.Add("PlayerInitialSpawn", "Jukebox:PlayerInitialSpawn", function(ply)
	if(!STGamemodes.Forums.ID) then
		return
	end
	Jukebox:GenerateUID(ply)
	Jukebox:SendUID(ply)
	
	timer.Simple(10, function()
		if(!Jukebox.DJMode or !IsValid(ply)) then
			return
		end
		
		for k,v in pairs(Jukebox.Playing) do
			if(v != true) then
				if(CurTime() >= v.StartTime) then -- It's playing / ended
					if(v.EndTime >= CurTime()) then -- It's playing
						umsg.Start("Jukebox.DJPlaySong", ply)
							umsg.Short(v.ID)
							umsg.String(v.Name)
							umsg.String(v.Genre)
							umsg.Short(v.EndTime - CurTime())
						umsg.End()
					else -- It ended
						Jukebox.Playing[k] = true
					end 
				else -- Didn't play yet so add the whole time
					umsg.Start("Jukebox.DJPlaySong", ply)
						umsg.Short(v.ID)
						umsg.String(v.Name)
						umsg.String(v.Genre)
						umsg.Short(v.Time)
					umsg.End()
				end
			end
		end
	end)
end)

function Jukebox.PrintAll(Message)
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid()) then
			v:ChatPrint(Message)
		end
	end
end

-- Done in STGamemodes:ChangeMap()
function Jukebox:Clean()
	if !STGamemodes or !STGamemodes.ServerName then return end 
	print( "Jukebox: Starting Clean..." )
	http.Fetch("http://server2.sassilization.com/jukebox/?p=Server&key=520fNz!&fol="..string.gsub(STGamemodes.ServerName, " ", "").."&clean", function() print("Jukebox: Finished Cleaning") end )
end
-- hook.Add("Initialize", "JukeBox:CleanShit", function() Jukebox:Clean() end )
-- hook.Add("ShutDown", "Jukebox:ShutDown", function()	Jukebox:Clean() end)

function Jukebox:UpdateDJMode(Bool)
	self.DJMode = Bool
	SetGlobalBool("DJMode", Bool)
	if(Bool) then
		Jukebox.PrintAll("Jukebox: DJ Mode has been turned on")
	else
		Jukebox.DJModePly = false
		Jukebox.PrintAll("Jukebox: DJ Mode has been turned off")
		self:Clean()
	end
end

function Jukebox.DJModeConCommand(ply, cmd, args)
	if(!IsValid(ply)) then
		return
	end
	if(!ply:IsDev() and !ply:IsRadio()) then
		return
	end
	if(Jukebox.DJMode) then
		Jukebox:UpdateDJMode(false)
		Jukebox.PrintAll("(DJ) "..ply:CName().." has turned DJ Mode off")
	else
		if(Jukebox.DJModeVote) then
			return
		end
		Jukebox.DJModeVote = true
		STGamemodes.Vote:Start("Enable DJ Mode?", {{"Yes", true}, {"No", false}},
			function()
				Jukebox.PrintAll("(DJ) "..ply:CName().." has started a DJ Mode vote")
			end,
			function(Success, Ply, Canceled)
				Jukebox.DJModeVote = false
				if Canceled then 
					Jukebox.PrintAll("Jukebox: The DJ Mode vote has been canceled by Administrator")
				elseif Success then
					Jukebox.DJModePly = ply
					Jukebox:UpdateDJMode(true)
				else
					Jukebox.PrintAll("Jukebox: The DJ Mode vote has failed!")
				end
			end
		)
	end
end
concommand.Add("jukebox_djmode", Jukebox.DJModeConCommand)

function Jukebox:ConfirmSongPurchase(ply, ID, Name, Genre, Time)
	if(!IsValid(ply)) then
		return
	end
	if(!ply.WaitingForConfirmation) then
		return
	end
	umsg.Start("Jukebox.PlaySong", ply)
		umsg.Short(ID)
		umsg.String(Name)
		umsg.String(Genre)
		umsg.Short(Time)
	umsg.End()
	timer.Simple(0.25, function() Jukebox:ConfirmSongPurchase( ply, ID, Name, Genre, Time) end)
end

function Jukebox.PlayConCommand(ply, cmd, args)
	if(!IsValid(ply)) then
		return
	end
	
	if(Jukebox.DJMode) then
		ply:ChatPrint("Jukebox: DJ Mode is on, only DJ's can play songs!")
		return
	end
	
	local ID = args[1]
	local Name = args[2]
	local Genre = args[3]
	local Time = args[4]
	
	if(!ID or !Name or !Genre or !Time) then
		return
	end
	
	if(!ply:IsVIP()) then
		local Money = ply:GetMoney()
		if(5 > Money) then
			ply:ChatPrint("Jukebox: You don't have enough dough to play that song (It's only 5 dough!)")
			return
		end
		ply:TakeMoney(5)
	end
	
	ply.WaitingForConfirmation = true
	Jukebox:ConfirmSongPurchase(ply, tonumber(ID), Name, Genre, tonumber(Time))
end
concommand.Add("jukebox_play", Jukebox.PlayConCommand)

function Jukebox.PlayConfirmConCommand(ply, cmd, args)
	if(!IsValid(ply)) then
		return
	end
	ply.WaitingForConfirmation = nil
end
concommand.Add("jukebox_playconfirm", Jukebox.PlayConfirmConCommand)

------------------------------------------------------------------------------------------------------------------------------------------

function Jukebox.DJReqConCommand(ply, cmd, args)
	if(!IsValid(ply)) then
		return
	end
	if(!Jukebox.DJMode) then
		return
	end
	
	if(ply.NextRequest and ply.NextRequest > CurTime()) then
		ply:ChatPrint("Please request slower")
		return
	end
	
	local Name = args[1]
	if(!Name) then
		return
	end
	
	ply.NextRequest = CurTime() + 60
	
	ply:ChatPrint("You have requested "..tostring(Name))
	STGamemodes:GroupChat(ply, "[REQ] "..tostring(Name), function(ply) return (ply:IsDev() or ply:IsRadio()) end, Color(255, 255, 0))
end
concommand.Add("jukebox_reqplay", Jukebox.DJReqConCommand)

function Jukebox:DJPlaySong(ply, ID, Name, Genre, Time)
	local TotalStartTime = CurTime()
	
	for k,v in pairs(self.Playing) do
		if(v != true) then
			if(CurTime() >= v.StartTime) then -- It's playing / ended
				if(v.EndTime >= CurTime()) then -- It's playing
					TotalStartTime = TotalStartTime + (v.EndTime - CurTime()) + 3
				else -- It ended
					self.Playing[k] = true
				end 
			else -- Didn't play yet so add the whole time
				TotalStartTime = TotalStartTime + v.Time + 3
			end
		end
	end
	
	table.insert(self.Playing, {
		ID = tonumber(ID),
		Name = Name,
		Genre = Genre,
		Time = tonumber(Time),
		StartTime = TotalStartTime,
		EndTime = TotalStartTime + Time + 3 
	})
	
	umsg.Start("Jukebox.DJPlaySong")
		umsg.Short(tonumber(ID))
		umsg.String(Name)
		umsg.String(Genre)
		umsg.Short(tonumber(Time))
	umsg.End()
	
	Jukebox.PrintAll("(DJ) "..ply:CName().." has added "..base64:dec(Name).." to the jukebox")
	print("http://server2.sassilization.com/jukebox/?p=Server&s="..tostring(ID).."&key=520fNz!&fol="..string.gsub(STGamemodes.ServerName, " ", "").."&start")
	http.Fetch("http://server2.sassilization.com/jukebox/?p=Server&s="..tostring(ID).."&key=520fNz!&fol="..string.gsub(STGamemodes.ServerName, " ", "").."&start", function() end)
end

function Jukebox.DJPlayConCommand(ply, cmd, args)
	if(!IsValid(ply)) then
		return
	end
	if(!Jukebox.DJMode or (!ply:IsDev() and !ply:IsRadio())) then
		return
	end
	local ID = args[1]
	local Name = args[2]
	local Genre = args[3]
	local Time = args[4]
	if(!ID or !Name or !Genre or !Time) then
		return
	end
	Jukebox:DJPlaySong(ply, ID, Name, Genre, Time)
end
concommand.Add("jukebox_djplay", Jukebox.DJPlayConCommand)

function Jukebox.DJVotePlayConCommand(ply, cmd, args)
	if(!IsValid(ply)) then
		return
	end
	if(!Jukebox.DJMode or (!ply:IsDev() and !ply:IsRadio())) then
		return
	end
	if(Jukebox.DJSongVote) then
		return
	end
	local ID = args[1]
	local Name = args[2]
	local Genre = args[3]
	local Time = args[4]
	if(!ID or !Name or !Genre or !Time) then
		return
	end
	STGamemodes.Vote:Start("Play "..tostring(base64:dec(Name)).."?", {{"Yes", true}, {"No", false}},
		function()
			Jukebox.DJSongVote = true
			Jukebox.PrintAll("(DJ) "..ply:CName().." has started a song vote")
		end,
		function(Success, Ply, Canceled)
			Jukebox.DJSongVote = false
			if Canceled then 
				Jukebox.PrintAll("Jukebox: The song vote has been canceled by Administrator")
			elseif Success then
				if(IsValid(ply)) then
					Jukebox:DJPlaySong(ply, ID, Name, Genre, Time)
				end
			else 
				Jukebox.PrintAll("Jukebox: The song vote has failed!")
			end
		end
	)
end
concommand.Add("jukebox_djvoteplay", Jukebox.DJVotePlayConCommand)

timer.Create("JukeboxDJModeCheck", 5, 0, function()
	if(!Jukebox.DJMode) then
		return
	end
	if(IsValid(Jukebox.DJModePly)) then
		return
	end
	for k,v in pairs(player.GetAll()) do
		if(v:IsDev()) then
			Jukebox.DJModePly = v
			return
		end
	end
	Jukebox.DJModePly = false
	Jukebox:UpdateDJMode(false)
end)
