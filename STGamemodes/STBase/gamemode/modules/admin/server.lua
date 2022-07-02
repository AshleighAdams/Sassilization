--------------------
-- STBase
-- By Spacetech
--------------------

-- AddCSLuaFile("tabs/maps.lua")
AddCSLuaFile("tabs/main.lua")

STGamemodes.Bans = {}
STGamemodes.Bans.Banned = {}

function STGamemodes.Bans:LoadBanned()
	print("GateKeeper: Loading Bans")
	STGamemodes.Logs:ParseLog("GateKeeper: Loading Bans | %s", tostring(table.Count(self.Banned)))
	tmysql.query("SELECT * FROM bans", function(Res, Stat, Err)
		if(Err != 0 or !Stat) then
			print("GateKeeper: Error Loading Bans")
			STGamemodes.Logs:Event("GateKeeper: Error Loading Bans")
			timer.Simple(1, function() self:LoadBanned() end)
			return
		end
		if(Res) then
			self.Banned = {}
			for k,v in pairs(Res) do
				self.Banned[string.Trim(v.steamid)] = {
					Time = tonumber(v.expiretime) or 0,
					Reason = v.message
				}
			end
			print("GateKeeper: Loaded Bans", table.Count(self.Banned))
			STGamemodes.Logs:ParseLog("GateKeeper: Loaded Bans | %s", tostring(table.Count(self.Banned)))
		end
	end, 1)
end

local Unknown = {Time = 0, Reason = "Unknown SteamID"}

function STGamemodes.Bans:CheckMySQLBanned(SteamID, Check, Table, SuperCheck)
	-- if(SteamID == "STEAM_ID_UNKNOWN") then
		-- return Unknown
	-- end
	if(Table) then
		if(SuperCheck) then
			local Banned = self.Banned[SteamID]
			if(Banned) then
				if(Banned.Time and Banned.Time > 0 and Banned.Time <= os.time()) then
					self.Banned[SteamID] = nil
				end
			end
		end
		return self.Banned[SteamID]
	else
		tmysql.query("SELECT * FROM bans WHERE steamid='"..SteamID.."'", function(Res, Stat, Err)
			if(Res and Res[1]) then
				return Check(true, Res)
			end
			return Check(false)
		end)
	end
end

function STGamemodes.Bans:AddMySQLBan(SteamID, Time, PlayerName, Reason, Banner, OnBan, FailedBan)
	local Time = Time
	if(Time != 0) then
		Time = os.time() + Time
	end
	local PlayerName = PlayerName or "Unknown"
	local Reason = Reason or "Breaking Rules"
	local Banner = Banner or "Console"
	self:CheckMySQLBanned(SteamID, function(Banned)
		if(!Banned) then
			tmysql.query("SELECT playerid FROM sa_misc WHERE steamid='"..SteamID.."'", function(Res, Stat, Err)
				PlayerID = ""
				if (Res and Res[1]) then
					PlayerID = Res[1][1]
				end
				print("Bans: AddMySQLBan: "..SteamID)
				STGamemodes.Logs:ParseLog("Bans: AddMySQLBan: %s", tostring(SteamID))
				self.Banned[SteamID] = {
					Time = Time,
					Reason = Reason
				}
				tmysql.query("INSERT INTO bans (steamid, uniqueid, playername, expiretime, message, admin) VALUES ('"..SteamID.."', '"..PlayerID.."', '"..tmysql.escape(PlayerName).."', '"..Time.."', '"..tmysql.escape(Reason).."', '"..tmysql.escape(Banner).."')", function(Res, Stat, Err)
					if(Err != 0 or !Stat) then
						if FailedBan then FailedBan() end 
						STGamemodes.Logs:Event("Bans: AddMySQLBan Failed")
						ErrorNoHalt("AddMySQLBan - "..SteamID.." - "..tmysql.escape(PlayerName).." - "..tostring(Time).." - "..tmysql.escape(Reason).." - "..tmysql.escape(Banner), "\n")
						return
					end
					self:LoadBanned()
				end)
			end)
		else
			STGamemodes.Logs:ParseLog("Bans: Already Banned: %s", tostring(SteamID))
			if(!self.Banned[SteamID]) then
				STGamemodes.Logs:ParseLog("Bans: Fixing Error: %s", tostring(SteamID))
				self.Banned[SteamID] = {
					Time = Time,
					Reason = Reason
				}
			end
		end
		if(OnBan) then
			OnBan(!Banned)
		end
	end)
end

function STGamemodes.Bans:RemoveMySQLBan(SteamID)
	self.Banned[SteamID] = nil
	tmysql.query("DELETE FROM bans WHERE steamid='"..SteamID.."'", function()
		self:LoadBanned()
	end)
end

function STGamemodes.Bans:AddCommand(ply, args)
	if(ply and ply.SendLua and !ply:IsMod()) then
		return
	end
	
	local SteamID = args[1]
	local Time = args[2] or 0
	
	if(!SteamID or tonumber(Time) == nil) then
		return
	end
	
	if(ply and ply.SendLua and ply:IsMod() and !ply:IsAdmin() and args[5] != "MODD") then
		return
	end

	local PlayerName = args[3]
	local Reason = args[4]
	local Banner = "Console"
	local BannerSteam = "Console"
	if(ply and ply.SendLua) then
		Banner = ply:Name()
		BannerSteam = ply:SteamID()
	end
	
	-- Fix
	self.Banned[SteamID] = {
		Time = Time,
		Reason = Reason
	}

	self:AddMySQLBan(SteamID, tonumber(Time) * 3600, PlayerName, Reason, Banner, function(Banned)
		local Message = SteamID.." is already banned"
		if(Banned) then
			STGamemodes.Logs:ParseLog("%s banned %s for %s hours. Reason: %s", ply or Banner, SteamID, Time, Reason)
			if(tonumber(Time) == 0) then
				Message = SteamID.." has been banned forever"
			else
				Message = SteamID.." has been banned for "..Time.." hours"
			end
			if args[5] != "MODD" then STGamemodes:AddHistory( PlayerName, SteamID, Banner, BannerSteam, 'banned', Reason, Time*3600) end 
		end
		if(ply and IsValid(ply) and ply.ChatPrint) then
			ply:ChatPrint(Message)
		else
			print(Message)
		end
	end, function() 
		AppendLog("../data/Servers/failedbans", "AddMySQLBan Failed - "..SteamID..","..tostring(tonumber(Time)*3600)..","..PlayerName..","..Reason..","..Banner)
	end )
end

function STGamemodes.Bans:RemoveCommand(ply, args)
	if(ply and ply.SendLua and !ply:IsSuperAdmin()) then
		return
	end
	
	local SteamID = args[1]
	
	if(!SteamID) then
		return
	end

	local Reason, Start = "", 1
	for k,v in pairs(args) do
		if(k > Start and k != #args) then
			Reason = Reason..v.." "
		elseif(k > Start and k == #args)then 
			Reason = Reason..v
		end
	end
	
	self:CheckMySQLBanned(SteamID, function(Banned, PlayerTable)
		local Message = SteamID.." is not banned"
		if(Banned) then
			Message = SteamID.." has been unbanned"
			self:RemoveMySQLBan(SteamID)
			STGamemodes:AddHistory((PlayerTable[3] and PlayerTable[3]!= "") and PlayerTable[3] or "Unknown", SteamID, ply:Name(), ply:SteamID(), Reason)
			STGamemodes.Logs:ParseLog("%s unbanned %s (Reason: %s)", ((IsValid(ply) and ply.Name) and ply) or "Console", SteamID, Reason!="" and Reason or nil)
		end
		if(IsValid(ply) and ply.ChatPrint) then
			ply:ChatPrint(Message)
		else
			print(Message)
		end
	end)
end

concommand.Add("st_addban", function(ply, cmd, args)
	if(!ply:IsSuperAdmin()) then
		ply:ChatPrint("Only superadmins can use this command")
		return
	end
	STGamemodes.Bans:AddCommand(ply, args)
end)

concommand.Add("st_unban", function(ply, cmd, args)
	STGamemodes.Bans:RemoveCommand(ply, args)
end)

concommand.Add("st_kickbanned", function(ply, cmd, args)
	if(!ply:IsSuperAdmin()) then
		return
	end
	for k,v in pairs(player.GetAll()) do
		if(STGamemodes.Bans.Banned[v:SteamID()]) then
			STGamemodes.SecretKick(v, "You are banned")
		end
	end
end)

-- concommand.Add("st_mysqlbans", function(ply, cmd, args)
	-- if(!ply:IsSuperAdmin()) then
		-- return
	-- end
	-- for k,v in pairs(STGamemodes.Bans.Bans) do
		-- STGamemodes.Bans:AddMySQLBan(v.SteamID, v.Time, "Unknown", "Breaking Rules", "Console")
	-- end
-- end)

------------------------------------------------------------------------------------------------------------------------------------------------------------

function STGamemodes.CanUseCommand(ply)
	return ply.Spacetech or ply.GoodSuper or ply.DevMin or ply.Snoipa or ply.Sam
end

function STGamemodes.Slay(ply, cmd, args)
	if(!ply:IsMod()) then
		return
	end
	
	local PlayerName = args[1]
	
	if(!PlayerName or PlayerName == "") then
		ply:ChatPrint( "No player specified. (/slay PlayerName)" )
		return
	end

	local Start = 1
	local Reason = ""
	for k,v in pairs(args) do
		if(k > Start and k != #args) then
			Reason = Reason..v.." "
		elseif k > Start and k == #args then 
			Reason = Reason..v
		end
	end
	
	local Target = STGamemodes.FindByPartial(PlayerName)
	
	if(type(Target) == "string") then
		ply:ChatPrint(Target)
	else
		if(!ply:IsSuperAdmin() and Target:IsMod()) then
			ply:ChatPrint("You can't slay mods/admins!")
			if Target:IsSuperAdmin() then
				Target:ChatPrint(ply:CName().." tried to slay you.")
			end
		else
			local Text = STGamemodes.GetPrefix(ply).." "..ply:Name().." slayed "..Target:CName()
			if Reason and Reason != "" then 
				Text = Text .." (Reason: ".. Reason ..")" 
			end 

			Target:Kill()
			STGamemodes:PrintAll(Text)
			STGamemodes.Logs:ParseLog(Text)
			STGamemodes:AddHistory(Target:Name(), Target:SteamID(), ply:Name(), ply:SteamID(), "slayed", Reason)
		end
	end
end
concommand.Add("st_slay", STGamemodes.Slay)

function STGamemodes.Muteall(ply, cmd, args)
	if(!ply:IsMod()) then
		return
	end
	
	local PlayerName = args[1]
	
	if(!PlayerName) then
		ply:ChatPrint("Syntax: /muteall Name Time Reason")
		return
	end

	local Time = tonumber(args[2])
	local Start = Time and 2 or 1

	local Reason = ""
	for k,v in pairs(args) do
		if(k > Start and k != #args) then
			Reason = Reason..v.." "
		elseif k > Start and k == #args then 
			Reason = Reason..v
		end
	end
	
	-- if (!Reason or Reason == "") then
	-- 	Reason = "No reason was specified."
	-- end

	if (Reason:len() > 70) then
		ply:ChatPrint("Your reason was over 70 characters! Please stay under 70 characters.")
		return
	end
	
	local Target = STGamemodes.FindByPartial(PlayerName)
	
	if(type(Target) == "string") then
		ply:ChatPrint(Target)
	else
		if(!ply:IsSuperAdmin() and Target:IsMod()) then
			ply:ChatPrint("You can't mute mods/admins!")
			if Target:IsSuperAdmin() then
				Target:ChatPrint(ply:CName().." tried to mute you.")
			end
		else
			local Text = STGamemodes.GetPrefix(ply).." "..ply:Name().." muted "..Target:CName()

			if Time and Time > 0 then 
				Text = Text .." for ".. tostring(Time) .." seconds"
			end 
			if Reason and Reason != "" then
				Text = Text .." (Reason: "..Reason..")"
			end
			if(Target:IsCMuted()) then
				Text = STGamemodes.GetPrefix(ply).." "..ply:Name().." unmuted "..Target:CName()
				Target:SetCMuted(false)
				timer.Destroy( "UnMute-"..Target:SteamID() )
				STGamemodes.Logs:ParseLog("%s unmuted %s", ply, Target, Reason)
			else
				STGamemodes:AddHistory(Target:Name(), Target:SteamID(), ply:Name(), ply:SteamID(), "muted", Reason, Time)
				Target:SetCMuted(true)
				STGamemodes.Logs:ParseLog(Text)
				if Time and Time > 0 then 
					timer.Create( "UnMute-"..Target:SteamID(), Time, 1, function()
						if Target:IsValid() then 
							Target:SetCMuted(false)
							STGamemodes.Logs:ParseLog("%s auto unmuted (Timer Expired)", Target )
							STGamemodes:PrintAll( Target:CName() .." has been unmuted. (Time Expired)" )
						end 
					end )
				end 
			end
			STGamemodes:PrintAll(Text)
		end
	end
end
concommand.Add("st_muteall", STGamemodes.Muteall)

function STGamemodes.Voteban(ply, cmd, args)
	if(!ply:IsMod()) then
		return
	end
	
	local PlayerName = args[1]
	local Time = tonumber(args[2]) or 0

	local Reason, Start = "", 2
	for k,v in pairs(args) do
		if(k > Start and k != #args) then
			Reason = Reason..v.." "
		elseif k > Start and k == #args then 
			Reason = Reason..v
		end
	end
	
	if(!PlayerName or Reason == "" or (tonumber(args[2]) == nil and tostring(args[2]) != nil)) then
		ply:ChatPrint("Syntax: /voteban PlayerName Time Reason")
		return
	end
	
	if(Time <= 0) then
		ply:ChatPrint("You can't voteban people for a permaban")
		return
	end
	
	if(Time > 24) then
		ply:PrintMessage(HUD_PRINTTALK, "You can't voteban people for more than 24 hours!")
		return
	end
	
	local Target = STGamemodes.FindByPartial(PlayerName)
	
	if(type(Target) == "string") then
		ply:PrintMessage(HUD_PRINTTALK, Target)
	else
		if(!ply:IsSuperAdmin() and Target:IsMod()) then
			ply:PrintMessage(HUD_PRINTTALK, "You can't voteban mods/admins!")
			if Target:IsSuperAdmin() then
				Target:ChatPrint(ply:CName().." tried to voteban you.")
			end
		else
			local Name, Name2, AName, ASteamID = Target:CName(), Target:Name(), ply:Name(), ply:SteamID()
			local SteamID = Target:SteamID()
			STGamemodes.Vote:Start("Voteban '"..Target:CName().."' | Reason: "..Reason, {{"Yes", true}, {"No", false}},
				function()
					local Text = STGamemodes.GetPrefix(ply).." "..ply:Name().." has started a voteban on '"..Target:CName().."'"
					STGamemodes:PrintAll(Text)
					STGamemodes.Logs:ParseLog("[VOTEBAN] Started by %s on %s: %s", ply, Target, Reason)
				end,
				function(Success, Ply, Canceled)
					if Canceled then 
						STGamemodes:AddHistory(Name2, SteamID, AName, ASteamID, "canceled voteban", Reason, Time*3600)
						STGamemodes:PrintAll("Voteban: Canceled by Administrator")
					elseif Success then
						local Text = Name.." has been vote banned"
						
						if(!IsValid(Target)) then
							Target = STGamemodes.FindByPartial(SteamID)
						end
						
						if(type(Target) == "string") then
							Time = Time * 2
						else
							STAchievements:AddCount(Target, "Troll")
							STGamemodes.SecretKick(Target, Reason)
						end
						
						STGamemodes.Bans:AddCommand(ply, {SteamID, Time, Name, Reason, "MODD"})
						STGamemodes:PrintAll(Text)
						STGamemodes.Logs:ParseLog("[VOTEBAN] %s banned %s: %s", ply, type(Target) == "string" and Name or Target, Reason)
						STGamemodes:AddHistory(Name2, SteamID, AName, ASteamID, "votebanned", Reason, Time*3600)
					else
						STGamemodes:AddHistory(Name2, SteamID, AName, ASteamID, "failed voteban", Reason, Time*3600)
						STGamemodes:PrintAll("Voteban: Failed")
					end
				end
			)
			Target.Voted = true
		end
	end
end
concommand.Add("st_voteban", STGamemodes.Voteban)

function STGamemodes.Kick(ply, cmd, args)
	if(!ply:IsMod()) then
		return
	end
	
	local PlayerName = args[1]
	local Reason, Start = "", 1
	for k,v in pairs(args) do
		if(k > Start and k != #args) then
			Reason = Reason..v.." "
		elseif k > Start and k == #args then 
			Reason = Reason..v
		end
	end
	
	if(Reason == "" or !PlayerName) then
		ply:ChatPrint("Syntax: /kick PlayerName Reason")
		return
	end
	
	local Target = STGamemodes.FindByPartial(PlayerName)
	
	if(type(Target) == "string") then
		ply:ChatPrint(Target)
	else
		if(!ply:IsSuperAdmin() and Target:IsMod()) then
			ply:ChatPrint("You can't kick mods/admins!")
			if Target:IsSuperAdmin() then
				Target:ChatPrint(ply:CName().." tried to kick you.")
			end
		else
			local Text = STGamemodes.GetPrefix(ply).." "..ply:Name().." kicked "..Target:CName()..": "..Reason
			STGamemodes.SecretKick(Target, Reason)
			STGamemodes:PrintAll(Text)
			STGamemodes.Logs:ParseLog("%s kicked %s: %s", ply, Target, Reason)
			STGamemodes:AddHistory(Target:Name(), Target:SteamID(), ply:Name(), ply:SteamID(), "kicked", Reason, Time)
		end
	end
end
concommand.Add("st_kick", STGamemodes.Kick)

function STGamemodes.Ban(ply, cmd, args)
	if(!ply:IsAdmin()) then
		return
	end
	
	local PlayerName = args[1]
	local Time = tonumber(args[2]) or 0

	local Reason, Start = "", 2
	for k,v in pairs(args) do
		if(k > Start and k != #args) then
			Reason = Reason..v.." "
		elseif k > Start and k == #args then 
			Reason = Reason..v
		end
	end
	
	if(!PlayerName or Reason == "" or (Time == nil and Time != nil)) then
		ply:ChatPrint("Syntax: /ban PlayerName Time Reason")
		return
	end
	
	local Target = STGamemodes.FindByPartial(PlayerName)
	
	if(type(Target) == "string") then
		ply:ChatPrint(Target)
		if Target:IsSuperAdmin() then
			Target:ChatPrint(ply:CName().." tried to ban you.")
		end
	else
		if(!ply:IsSuperAdmin() and Target:IsMod()) then
			ply:ChatPrint("You can't ban mods/admins!")
		elseif(!ply:IsSuperAdmin() and Target:IsVIP() and Time <= 0) then
			ply:ChatPrint("You can't permaban vip's")
		else
			local Text = STGamemodes.GetPrefix(ply).." "..ply:Name().." banned "..Target:CName()..": "..Reason
			STGamemodes.Bans:AddCommand(ply, {Target:SteamID(), Time, Target:CName(), Reason})
			STAchievements:AddCount(Target, "Troll")
			STGamemodes:PrintAll(Text)
			STGamemodes.SecretKick(Target, Reason)
			STGamemodes.Logs:ParseLog("%s banned %s: %s", ply, Target, Reason)
			-- STGamemodes:AddHistory(Target:Name(), Target:SteamID(), ply:Name(), ply:SteamID(), "banned", Reason, Time*3600)
		end
	end
end
concommand.Add("st_ban", STGamemodes.Ban)
