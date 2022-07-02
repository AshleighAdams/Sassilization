--------------------
-- STBase
-- By Spacetech
--------------------

require("gatekeeper")

-- gatekeeper.ForceProtocol(18)

STGamemodes.GateKeeper = {}
STGamemodes.GateKeeper.Banned = {}
STGamemodes.GateKeeper.Allowed = {}
STGamemodes.GateKeeper.Loaded = false
STGamemodes.GateKeeper.MaxPlayer = 50

function STGamemodes.GateKeeper:LoadDevMode( name, Override) 
	if Override != nil then 
		if(Override) then
			file.Write(STGamemodes.GateKeeper.DevModeFile)
		else
			if(file.Exists(STGamemodes.GateKeeper.DevModeFile, "DATA")) then
				file.Delete(STGamemodes.GateKeeper.DevModeFile)
			end
		end
	end 

	STGamemodes.GateKeeper.DevModeFile = "devmode.txt"
	STGamemodes.GateKeeper.DevMode = (file.Exists(STGamemodes.GateKeeper.DevModeFile, "DATA") and !file.Exists("nodevmode.txt", "DATA")) //Bad arguements to these functions errored the code.
	SetGlobalVar( "STGamemodes.DevMode", STGamemodes.GateKeeper.DevMode ) 
	STGamemodes:SetupServerDirectory( name )
end 

function STGamemodes.GateKeeper:SetMaxPlayers(Max)
	self.MaxPlayer = Max
end

function STGamemodes.GateKeeper:Load()
	if(!gatekeeper) then
		ErrorNoHalt("GateKeeper Module Not Found!")
		return
	end
	print("GateKeeper: Initialized", self.MaxPlayer)
	RunConsoleCommand("sv_visiblemaxplayers", self.MaxPlayer)
	if(tmysql) then
		STGamemodes.GateKeeper:LoadAdmins()
	else
		print("GateKeeper: No tMySQL")
	end
end

function STGamemodes.GateKeeper:LoadAdmins()
	print("GateKeeper: Loading Admins")
	tmysql.query("SELECT steamid FROM sa_misc WHERE cast(rank as signed integer) >= '10'", function(Res, Stat, Err)
		if(Err != 0 or !Stat) then
			print("GateKeeper: Error Loading Admins")
			timer.Simple(1, function() self:LoadAdmins() end)
			return
		end
		if(Res) then
			self.Loaded = true
			print("GateKeeper: Loaded Admins")
			for k,v in pairs(Res) do
				if(v[1]) then
					table.insert(self.Allowed, string.Trim(tostring(v[1])))
				end
			end
		end
	end)
	/*
	if(STGamemodes.Mods) then
		for k,v in pairs(STGamemodes.Mods) do
			table.insert(self.Allowed, v)
		end
	end
	*/
end

function STGamemodes.GateKeeper:Allow(SteamID, Bool)
	if(Bool) then
		table.insert(self.Allowed, SteamID)
	else
		for k,v in pairs(self.Allowed) do
			if(v == SteamID) then
				self.Allowed[k] = nil
				return
			end
		end
	end
end

function STGamemodes.GateKeeper:IsAllowed(SteamID)
	if(!self.Loaded) then
		return false
	end
	return table.HasValue(self.Allowed, SteamID)
end

function STGamemodes.GateKeeper:SlotsOpen()
	return gatekeeper.GetNumClients().total < self.MaxPlayer 
end

function STGamemodes.GateKeeper:GenerateBanReason(Reason, Time)
	if(Time <= 0) then
		return "You're banned. | Reason: "..Reason.." | Permanently Banned"
	end
	return os.date("You're banned. | Reason: "..Reason.." | Until: %c %p - Server's Time", Time)
end

function STGamemodes.GateKeeper:PlayerPasswordAuth(Name, Pass, Steam, IP)
	if(Steam != UGLY_STEAMID) then
		STGamemodes.Logs:ParseLog("PlayerPasswordAuth | Name: %s | SteamID: %s | IP: %s", Name, Steam, IP)
	end


	local ValidPass = GetConVarString("sv_password")
	if ValidPass and ValidPass != "" then 
		if(ValidPass == Pass or (self:IsAllowed(Steam) and self.DevMode)) then
			STGamemodes:PrintAll(Name.." has connected")
			return true
		else 
			STGamemodes.Logs:Event("PlayerPasswordAuth | Invalid Password (".. Pass ..")")
			return "Invalid Password - You don't have permission to be here silly!"
		end 
	elseif(self:SlotsOpen()) then
		local Banned = STGamemodes.Bans:CheckMySQLBanned(Steam, false, true)
		if(Banned) then
			if(Banned.Time and Banned.Time > 0 and Banned.Time <= os.time()) then
				STGamemodes.Bans:RemoveMySQLBan(Steam)
				STGamemodes.Logs:Event("PlayerPasswordAuth | Ban Lifted")
			else
				STGamemodes.Logs:Event("PlayerPasswordAuth | Blocked Banned")
				return self:GenerateBanReason(Banned.Reason or "No Reason Specified", Banned.Time)
			end
		end
		return true
	end 
	
	return "Server is full"
end

if(game.SinglePlayer()) then
	return
end

concommand.Add("st_devmode", function(ply)
	if(ply.SendLua and !ply:IsSuperAdmin()) then
		return
	end

	STGamemodes.GateKeeper:LoadDevMode(STGamemodes.OriginalDirectory, !STGamemodes.GateKeeper.DevMode)

	if(ply.SendLua) then
		ply:ChatPrint("GateKeeper: DevMode: "..tostring(STGamemodes.GateKeeper.DevMode and "On" or "Off"))
	else
		print("GateKeeper: DevMode: "..tostring(STGamemodes.GateKeeper.DevMode and "On" or "Off"))
	end
end)

concommand.Add("st_allow", function(ply, cmd, args)
	if(ply.SendLua and !ply:IsSuperAdmin()) then
		return
	end
	local SteamID = args[1]
	local Allow = args[2] or false
	if(Allow) then
		if(Allow == "1") then
			Allow = true
		elseif(Allow == "0") then
			Allow = false
		end
	end
	if(!SteamID) then
		return
	end
	STGamemodes.GateKeeper:Allow(SteamID, Allow)
	ply:ChatPrint("GateKeeper: "..tostring(SteamID).." | "..tostring(Allow and "Allowed" or "Disallowed"))
end)

concommand.Add("st_setpassword", function(ply, cmd, args)
	if(!ply:IsSuperAdmin()) then
		return
	end
	
	local pass = args[1]
	if(!pass) then
		return
	end
	
	RunConsoleCommand("sv_password", pass)
	
	ply:ChatPrint("The password has been set to '"..pass.."'")
end)

---------------------------------------------------------------------------------------------------------

function parseargs(s)
	local arg = {}
	string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
		arg[w] = a
	end)
	return arg
end

function collect(s)
	local stack = {}
	local top = {}
	table.insert(stack, top)
	local ni,c,label,xarg, empty
	local i, j = 1, 1
	
	while true do
		ni,j,c,label,xarg, empty = string.find(s, "<(%/?)(%w+)(.-)(%/?)>", i)
		
		if not ni then break end
		
		local text = string.sub(s, i, ni-1)
		
		if not string.find(text, "^%s*$") then
			table.insert(top, text)
		end
		
		if empty == "/" then  -- empty element tag
			table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
		elseif c == "" then   -- start tag
			top = {label=label, xarg=parseargs(xarg)}
			table.insert(stack, top)   -- new level
		else  -- end tag
			local toclose = table.remove(stack)  -- remove top
			top = stack[#stack]
			if #stack < 1 then
				error("nothing to close with "..label)
			end
			if toclose.label ~= label then
				error("trying to close "..toclose.label.." with "..label)
			end
			table.insert(top, toclose)
		end
		i = j+1
	end
	
	local text = string.sub(s, i)
	if not string.find(text, "^%s*$") then
		table.insert(stack[#stack], text)
	end
	
	if #stack > 1 then
		error("unclosed "..stack[stack.n].label)
	end
	return stack[1]
end

local JetboomFriends = {}

-- http.Get("http://steamcommunity.com/id/jetboom/friends?xml=1", "", function(Content, Size)
	-- if(!Content or !Size or Content == "") then
		-- return
	-- end
	-- local xmlTable = collect(Content)
	-- if(xmlTable) then
		-- for k,v in pairs(xmlTable) do
			-- if(v.label == "friendsList") then
				-- for k2,v2 in pairs(v) do
					-- if(v2.label == "friends") then
						-- for k3,v3 in pairs(v2) do
							-- if(v3.label == "friend") then
								-- JetboomFriends[v3[1]] = true
							-- end
						-- end
					-- end
				-- end
			-- end
		-- end
	-- end
	-- file.Write("xml.txt", util.TableToKeyValues(xmlTable))
-- end)

---------------------------------------------------------------------------------------------------------

local function SteamIDtoCommunityID(SteamID)
	local stSteamID = string.Explode(":", SteamID)
	return tonumber(stSteamID[3]) * 2 + 76561197960265728 + tonumber(stSteamID[2])
end

function STGamemodes.CheckJetboom(SteamID)
	return JetboomFriends[SteamIDtoCommunityID(SteamID)]
end

hook.Add("PlayerPasswordAuth", "STGamemodes.PlayerPasswordAuth", function(Name, Pass, Steam, IP)
	-- if(STGamemodes.CheckJetboom(Steam)) then
		-- STGamemodes.Logs:Event("PlayerPasswordAuth | Blocked Jetboom Friend | Name: %s | SteamID: %s | IP: %s", Name, Steam, IP)
		-- return "You're friends with Jetboom"
	-- end
	return STGamemodes.GateKeeper:PlayerPasswordAuth(Name, Pass, Steam, IP)
end)

------------------------------------------------------------------------------------------------------

if(true) then
	return
end

print("TRANQ IS LOADED")

TranqUsers = {}
TranqNextThink = CurTime()
TranqEnabled = true // we assume we're connected to steam when we launch

// how long to wait for an approval callback before kicking the client
// 10 can be too short (it's proven too short on GMT, at least)
// but in my experience most clients are approved within seconds of joining
TranqTimeout = CreateConVar("at_timeout", "30", FCVAR_NOTIFY)

local function KickUser(steam, reason)
	local tranqTable = TranqUsers[steam] // tranqTable should never be nil	
	if(!tranqTable) then
		-- ErrorNoHalt("KickUser: ", steam, " | ", reason, "\n")
		return
	end
	
	local userId = gatekeeper.GetUserByAddress(tranqTable.IP)
	
	if userId then
		gatekeeper.Drop(userId, "SteamID validation failed (" .. tostring( reason ) .. ")\n")
		STGamemodes.Logs:ParseLog("%s - Validation Failed - %s", steam, reason)
	end
	
	TranqUsers[steam] = nil
end

// this hook is called when the server (re)connects to steam
hook.Add("GSSteamConnected", "AntiTranqConnected", function()
	TranqEnabled = true
	
	Msg("Connected to Steam! Anti-Tranquility enabled.\n")
end)

// this hook gets called when the server loses it's connection to steam
hook.Add("GSSteamDisconnected", "AntiTranqDisconnected", function(reason)
	TranqEnabled = false
	TranqUsers = {}
	
	-- Msg("Disconnected from Steam: ", reason, ", Anti-Tranquility disabled.\n")
end)

// client is approved by the backend
// this is called within a few seconds for valid clients
// and isn't called at all for clients spoofing their authentication data
hook.Add("GSClientApprove", "AntiTranqApprove", function( steam )
	-- Msg("Approved: ", steam, "\n")
	
	TranqUsers[steam] = nil
end )

// client was denied by the backend
// this isn't called right away
// in my tests, this was called approximately 5 minutes after a spoofed client connected
// it's best to handle the lack of an approval callback, but this is a Just In Case scenario
hook.Add("GSClientDeny", "AntiTranqDeny", function(steam, reason, msg)
	-- Msg("Denying ", steam, " (Reason: ", reason , "): ", msg, "\n")
	
	KickUser(steam, reason)
end)

// this hook is called when a player connects to the server
// this is similar to gatekeeper's PlayerPasswordAuth callback, except it does not expect a return value to disconnect the client
hook.Add("GSPlayerAuth", "AntiTranqConnect", function(name, pass, steam, ip)
	if tonumber(steam) then return end
	
	-- Msg("Auth: ", steam, "\n")
	
	TranqUsers[steam] = {
		IP = ip,
		ConnectTime = CurTime(),
	}
end)

hook.Add("Think", "AntiTranqThink", function()
	if TranqNextThink >= CurTime() or not TranqEnabled then return end

	for k,v in pairs( TranqUsers ) do	
		local diff = CurTime() - v.ConnectTime
		
		if diff > (TranqTimeout:GetInt() or 30) then
			
			-- KickUser(k, "timeout") // no approval after the timeout, boot them out
		end		
	end
	
	TranqNextThink = CurTime() + 1
end)
