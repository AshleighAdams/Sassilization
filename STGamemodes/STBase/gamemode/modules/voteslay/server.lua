--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.VoteSlay = {}
STGamemodes.VoteSlay.Enabled = false
STGamemodes.VoteSlay.BlackList = {}
STGamemodes.VoteSlay.Queue = {}

function STGamemodes.VoteSlay:Load()
	if !GAMEMODE.Name then 
		timer.Simple(5, function() STGamemodes.VoteSlay:Load() end )
	end 
	if GAMEMODE.Name != "Deathrun" then 
		return
	end 
	self.Enabled = true

	tmysql.query( "SELECT steamid, reason FROM voteslay_blacklist", function(Res, Stat, Err)
		if(Err != 0 or !Stat) then
			print("GateKeeper: Error Loading VoteSlay Blacklist")
			return
		end
		if(Res) then
			for k,v in pairs(Res) do 
				self.BlackList[v[1]] = v[2]
			end
		end 
	end ) 
end 

function STGamemodes.VoteSlay.Blacklist(ply, cmd, args)
	if !ply:IsAdmin() then
		return
	end

	if true then 
		ply:ChatPrint("Use the website")
		return 
	end 

	local SteamID = string.Trim(args[1])
	table.remove(args, 1)

	local Reason = ""
	for k,v in pairs(args) do 
		if Reason == "" then 
			Reason = v 
		else 
			Reason = Reason .." ".. v 
		end
	end 

	if !SteamID or SteamID == "" or !string.Explode(":", SteamID)[3] or !Reason or Reason == "" then
		ply:ChatPrint("You seem to have an invalid SteamID or missing Reason.  Please use quotes.")
		ply:ChatPrint("Syntax: st_blacklist steamid reason")
		return 
	end

	if STGamemodes.VoteSlay.BlackList[SteamID] then
		ply:ChatPrint( SteamID .." is already blacklisted!" )
		return 
	end 

	tmysql.query("INSERT INTO voteslay_blacklist (steamid, reason, admin, adminid) VALUES ('".. SteamID .."','".. Reason .."','".. ply:Name() .."','"..ply:SteamID().."')")
	STGamemodes.VoteSlay.BlackList[SteamID] = Reason
	STGamemodes:PrintMod(STGamemodes.GetPrefix(ply) .." ".. ply:Name() .." blacklisted '".. SteamID .." (Reason: ".. Reason ..")")
	STGamemodes.Logs:ParseLog("[VOTESLAY] %s blacklisted %s (Reason: %s)", ply, SteamID, Reason )
	STGamemodes:AddHistory( nil, SteamID, ply:Name(), ply:SteamID(), "blacklisted", Reason )
end
concommand.Add("st_blacklist", STGamemodes.VoteSlay.Blacklist)
-- STGamemodes:AddChatCommand("blacklist", "st_voteslayblacklist")

function STGamemodes.VoteSlay.UnBlackList(ply, cmd, args)
	if !ply:IsSuperAdmin() then return end 

	if true then 
		ply:ChatPrint("Use the website")
		return 
	end 

	local SteamID = string.Trim(args[1])
	if !SteamID or SteamID == "" or !string.Explode(":", SteamID)[3] then
		ply:ChatPrint("Invalid SteamID: ".. SteamID)
		ply:ChatPrint("Syntax: st_unblacklist SteamID (Use quotes)")
		return
	end 

	if !STGamemodes.VoteSlay.BlackList[SteamID] then
		ply:ChatPrint(SteamID.." is not blacklisted!")
		return
	end 

	tmysql.query("DELETE FROM voteslay_blacklist WHERE steamid='".. SteamID .."'")
	STGamemodes.VoteSlay.BlackList[SteamID] = nil 
	STGamemodes:PrintAdmin(STGamemodes.GetPrefix(ply) .." ".. ply:Name() .." unblacklisted '".. SteamID .."'")
	STGamemodes.Logs:ParseLog("[VOTESLAY] %s unblacklisted %s", ply, SteamID )
	STGamemodes:AddHistory( nil, SteamID, ply:Name(), ply:SteamID(), "unblacklisted", Reason )
end 
concommand.Add("st_unblacklist", STGamemodes.VoteSlay.UnBlackList)
-- STGamemodes:AddChatCommand("unblacklist", "st_voteslayunblacklist")

function STGamemodes.VoteSlay.Cmd(ply, cmd, args)
	if((!STGamemodes.VoteSlay.Enabled and !ply:IsMod()) or !ply:IsVIP()) then
		return
	end

	if STGamemodes.VoteSlay.BlackList[ply:SteamID()] then
		ply:PrintMessage(HUD_PRINTTALK, "You are blacklisted. (Reason: ".. STGamemodes.VoteSlay.BlackList[ply:SteamID()] ..")" )
		return
	end
	
	local Info = args[1]
	local Reason = ""
	for k,v in pairs(args) do
		if(k > 1 and k != #args) then
			Reason = Reason..v.." "
		elseif k > 1 then
			Reason = Reason..v
		end
	end
	
	if !Info or Reason == "" then
		return
	end
	
	local Target = STGamemodes.FindByPartial(Info)
	
	if(type(Target) == "string") then
		ply:PrintMessage(HUD_PRINTTALK, Target)
	else
		if(!ply:IsSuperAdmin() and Target:IsMod()) then
			ply:PrintMessage(HUD_PRINTTALK, "You can't slay mods/admins!")
		-- elseif ply == Target and !ply:IsMod() then
		-- 	ply:PrintMessage(HUD_PRINTTALK, "You can't slay yourself!")
		elseif !Target:Alive() then
			ply:PrintMessage(HUD_PRINTTALK, "You can't slay dead people!")
		elseif STGamemodes.VoteSlay.Queue[Target:SteamID()] and STGamemodes.Vote.Voting then
			ply:PrintMessage(HUD_PRINTTALK, "Your Target already has a voteslay in the queue!")
		else
			local Name, SteamID, AName, ASteamID
			STGamemodes.Vote:Start("Slay: '"..Target:CName().."' | Reason: "..Reason, {{"Yes", true}, {"No", false}},
				function()
					local Text = "[VOTESLAY] "..ply:CName().." has started a voteslay on '"..Target:CName().."'"
					STGamemodes:PrintAll(Text)
					STGamemodes.Logs:ParseLog("[VOTESLAY] Started by %s on %s (Reason: %s)", ply, Target, Reason)
					STGamemodes.VoteSlay.Queue[Target:SteamID()] = true
					Name, SteamID, AName, ASteamID = Target:Name(), Target:SteamID(), ply:Name(), ply:SteamID()
				end,
				function(Success, Ply, Canceled)
					if Canceled then 
						STGamemodes:PrintAll("[VOTESLAY] Vote Canceled by Administrator")
						STGamemodes:AddHistory( Name, SteamID, AName, ASteamID, "canceled voteslay", Reason )
						STGamemodes.Logs:ParseLog("[VOTESLAY] Canceled by Administrator")
					elseif Success then
						STGamemodes:AddHistory( Name, SteamID, AName, ASteamID, "voteslayed", Reason )
						local Text = ""
						if Target:IsValid() then 
							Text = "[VOTESLAY] ".. Name .." has been slayed (Reason: ".. Reason ..")"
							STGamemodes.Logs:ParseLog("[VOTESLAY] %s slayed %s (Reason: %s)", ply, Target, Reason)
							Target:Kill() 
						else
							Text = "[VOTESLAY] Vote Success, but user has left the server." 
						end 
						STGamemodes:PrintAll(Text)
					else
						STGamemodes:PrintAll("[VOTESLAY] Vote Failed")
						STGamemodes:AddHistory( Name, SteamID, AName, ASteamID, "failed voteslay", Reason )
					end
					STGamemodes.VoteSlay.Queue[SteamID] = nil
				end
			, nil, true, true )
		end
	end
end
concommand.Add("st_voteslay_confirmed", STGamemodes.VoteSlay.Cmd)
STGamemodes:AddChatCommand("voteslay", "st_voteslays")