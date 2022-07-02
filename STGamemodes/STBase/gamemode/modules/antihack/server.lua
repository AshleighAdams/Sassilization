--------------------
-- STBase
-- By Spacetech
--------------------

------------------------------------------------------------------------------------

-- include("sn3/sn3_stripip.lua")

local function SethHackCheck( ply, Nick, SteamID, IP ) 
	if !ply:IsValid() then return end 

	STGamemodes:CustomChat("SethHack", "Player "..Nick.." | SteamID: "..SteamID.." | Banned", Color(0, 190, 255, 255), Color(0, 190, 255, 255), function(v) return v:IsDev() end)
	-- AppendLog("../data/sethhackbans", "SethHack Banned: ".. Nick .." (".. SteamID ..") [".. IP .."]\n")
	STGamemodes.Bans:AddCommand(nil, {SteamID, 0, Nick, "Running SethHack"})
	STGamemodes.SecretKick(ply, "Running Sethhack")
	STGamemodes.Logs:ParseLog("%s was banned for using SethHack", ply)
end 

concommand.Add("st_adminpanel", function(ply)
	-- if(!SethHack[ply:SteamID()]) then
		-- return
	-- end
	-- SethHack[ply:SteamID()] = false
	STGamemodes:CustomChat("BotCheck", "Player "..ply:Nick().." | SteamID: "..ply:SteamID().." | AdminPanel", Color(0, 190, 255, 255), Color(0, 190, 255, 255), function(v) return v:IsSuperAdmin() end)
	AppendLog("../data/Servers/adminpanel", ply:Nick().." ("..ply:SteamID()..")\n")
end)

concommand.Add("st_rendergame", function(ply)
	-- if(!SethHack[ply:SteamID()]) then
		-- return
	-- end
	-- SethHack[ply:SteamID()] = false
	STGamemodes:CustomChat("BotCheck", "Player "..ply:Nick().." | SteamID: "..ply:SteamID().." | RenderGame", Color(0, 190, 255, 255), Color(0, 190, 255, 255), function(v) return v:IsSuperAdmin() end)
	AppendLog("../data/Servers/rendergame", ply:Nick().." ("..ply:SteamID()..")\n")
end)
local sethhackcommands = {
	"__seth_is_a_fegget_so_am_i_banme__",
	"____ima_hacker_fagget_____________",
	"__idiot_hacker_here_move_aside____",
	"______dumbass_hacker_here_________",
	"___i_hack_like_the_fagget_i_am____",
	"_banme_please_please_please_please",
	"_________iusesethhack_____________",
	"_______ihackonsassilization_______",
	"_i_fail_because_i_hack_with_seth__",
	"___seth_is_9_i_use_his_hack_______",
	"sassilization_hates_sethhack_users",
	"___ima_fagget_who_uses_sethhack___",
	"_ban_me_please_i_use_seth_hack____"
}

concommand.Add( table.Random(sethhackcommands), function(ply, cmd, args) 
	SethHackCheck(ply, ply:Nick(), ply:SteamID(), ply:IPAddress())
end )

if(true) then
	return
end

local SethHack = {}
local SpawnIndex = {}
local SethHackCheck = {}

function SethHackMissing(ply)
	SethHack[ply:SteamID()] = false
end

concommand.Add("sh_runscripts", function(ply)
	if(!SethHack[ply:SteamID()]) then
		return
	end
	SethHack[ply:SteamID()] = false
	-- STGamemodes:CustomChat("BotCheck", "Player "..ply:Nick().." | SteamID: "..ply:SteamID().." | Scripts", Color(0, 190, 255, 255), Color(0, 190, 255, 255), function(v) return v:IsSuperAdmin() end)
end)

concommand.Add("st_openmenu", function(ply)
	if(SethHackCheck[ply:SteamID()]) then
		return
	end
	SethHackCheck[ply:SteamID()] = true
end)

function SethHackCheckBan(ply, Nick, SteamID, CurrentIndex)
	if(SpawnIndex[SteamID] != CurrentIndex) then
		return
	end
	timer.Remove("SHCheck."..SteamID)
	if(SethHack[SteamID]) then
		AppendLog("../data/sethcheck", Nick.." ("..SteamID..") "..tostring(SethHackCheck[SteamID] and "Check Success" or "Check Failed").."\n")
		if(SethHackCheck[SteamID]) then
			STGamemodes:CustomChat("BotCheck", "Player "..Nick.." | SteamID: "..SteamID.." | Check Success", Color(0, 190, 255, 255), Color(0, 190, 255, 255), function(v) return v:IsSuperAdmin() end)
			-- STGamemodes.Bans:AddCommand(nil, {SteamID, 0, Nick, "Running Sethhack"})
			-- if(IsValid(ply)) then
				-- STGamemodes.SecretKick(ply, "Running Sethhack")
				-- STGamemodes.Logs:ParseLog("%s was banned for using sethhack", ply)
			-- else
				-- STGamemodes.Logs:ParseLog("%s was banned for using sethhack", Nick.." ("..SteamID..")")
			-- end
		else
			STGamemodes:CustomChat("BotCheck", "Player "..Nick.." | SteamID: "..SteamID.." | Check Failed", Color(0, 190, 255, 255), Color(0, 190, 255, 255), function(v) return v:IsSuperAdmin() end)
		end
	end
end

hook.Add("PlayerInitialSpawn", "BaconBotPlayerInitialSpawn", function(ply)
	if(ply:IsBot()) then
		return
	end
	
	local SteamID = ply:SteamID()
	
	if(SpawnIndex[SteamID]) then
		SpawnIndex[SteamID] = SpawnIndex[SteamID] + 1
	else
		SpawnIndex[SteamID] = 1
	end
	
	SethHack[SteamID] = true
	
	-- timer.Create("SHCheck."..SteamID, 2, 0, function()
		-- if(IsValid(ply)) then
			-- if(SethHack[SteamID] or !SethHackCheck[SteamID]) then
				-- ply:SendLua([[LocalPlayer():ConCommand("sh_runscripts;st_openmenu")]])
			-- end
		-- end
	-- end)
	
	-- timer.Simple(300, SethHackCheckBan, ply, ply:Nick(), SteamID, SpawnIndex[SteamID])
end)

function STGamemodes.Commands.BotCheck(ply, cmd, args)
	if(!ply.BotCheck) then
		ply.BotCheck = 0
	end
	if(ply.BotCheck >= 20) then
		return
	end
	ply.BotCheck = ply.BotCheck + 1
	STGamemodes.Logs:ParseLog("%s BotCheck for "..tostring(args[1]), ply)
	AppendLog("../data/botcheck", ply:IPAddress().." ["..ply:SteamID().."] "..tostring(ply:Nick()).." "..tostring(args[1]).."\n")
	if(args[1] == "sql" or args[1] == "find" or args[1] == "RunString" or args[1] == "GetLevel" or args[1] == "print") then
		-- ply:ChatPrint("I banned you")
		STGamemodes.Logs:ParseLog("%s was banned for using baconbot", ply)
		STGamemodes.Bans:AddCommand(nil, {ply:SteamID(), 0, ply:CName(), "Running Baconbot"})
		STGamemodes.SecretKick(ply, "Running Baconbot")
	else
		STGamemodes.Logs:ParseLog("%s has BaconBot Installed", ply)
		STGamemodes:CustomChat("BotCheck", "Player "..ply:Nick().." has BaconBot Installed | SteamID: "..ply:SteamID(), Color(0, 190, 255, 255), Color(0, 190, 255, 255), function(v) return v:IsAdmin() end)
	end
end
concommand.Add("st_ghosting", STGamemodes.Commands.BotCheck)

------------------------------------------------------------------------------------

AntiHack = {}
AntiHack.Enabled = false
AntiHack.JumpTime = 0.04
AntiHack.JumpCount = 10

function AntiHack:JumpKeyPress(ply)
	if(!self.Enabled) then
		return
	end
	
	if(!ply.Jumps) then
		ply.Jumps = {}
	end
	
	local Check = false
	
	if(table.Count(ply.Jumps) >= self.JumpCount) then
		Check = true
		table.remove(ply.Jumps, 1)
	end
	table.insert(ply.Jumps, CurTime())
	
	local Average = 0
	local TimeSave = false
	for k,v in pairs(ply.Jumps) do
		if(TimeSave) then
			Average = Average + (v - TimeSave)
		end
		TimeSave = v
	end
	Average = Average / self.JumpCount
	
	if(Check) then
		if(Average <= self.JumpTime) then
			STGamemodes.Commands.JumpSpam(ply)
		end
	end
end

if(true) then
	return
end

AntiHack.Kicked = {}
AntiHack.CrashTime = 6
AntiHack.MinMoveNum = 150
AntiHack.AverageCalc = false

local Collect = RealTime()
local Lag, Count, TotalMoveNum, Message

function AntiHack.PlayerInitialSpawn(ply)
	ply.MoveNum = 0
	ply.CrashTime = 0
	AntiHack.Kicked[ply:SteamID()] = nil
end
hook.Add("PlayerInitialSpawn", "AntiHack.PlayerInitialSpawn", AntiHack.PlayerInitialSpawn)

function AntiHack.Move(ply, MoveData)
	if(AntiHack.AverageCalc and STGamemodes.AntiHack) then
		if(ply.MoveNum > (AntiHack.AverageCalc + 160) and ply.MoveNum > AntiHack.MinMoveNum) then
			if(!AntiHack.Kicked[ply:SteamID()]) then
				AntiHack.Kicked[ply:SteamID()] = true
				Message = "("..ply:SteamID()..") "..ply:CName().." had a MoveNum of "..tostring(ply.MoveNum).." while AverageCalc was "..tostring(AntiHack.AverageCalc)
				STGamemodes:CustomChat("AntiHack", Message, Color(0, 0, 0), Color(255, 255, 255), function(v) return v:IsSuperAdmin() end)
				AppendLog("../data/Antihack", Message.."\n")
				STGamemodes.SecretKick(ply, "Speed Hacking")
			end
		end
	end
	ply.MoveNum = ply.MoveNum + 1
end
hook.Add("Move", "AntiHack.Move", AntiHack.Move)

function AntiHack.Think()
	if(RealTime() < Collect + 1) then
		return
	end
	
	Lag = RealTime() - Collect
	
	Count = 0
	TotalMoveNum = 0
	
	for k,v in pairs(player.GetAll()) do
		if(Lag < 1.5) then
			if(v.MoveNum == 0) then
				if(v.CrashTime == 0) then
					v.CrashTime = RealTime()
				elseif(RealTime() - v.CrashTime > AntiHack.CrashTime and !v:IsGhost() and !v:InVehicle()) then
					v:SetAFK(true)
				end
			elseif(v.CrashTime != 0) then
				v.CrashTime = 0
			end
		end
		if(v:Alive()) then
			Count = Count + 1
			TotalMoveNum = TotalMoveNum + v.MoveNum
		end
		v.MoveNum = 0
	end
	
	AntiHack.AverageCalc = TotalMoveNum / Count
	
	Collect = Collect + 1
end
hook.Add("Think", "AntiHack.Think", AntiHack.Think)
