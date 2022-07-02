--------------------
-- STBase
-- By Spacetech
--------------------

require("hio")
-- require("slog")
-- require("gamedescription")
if(!game.SinglePlayer()) then
	require("tmysql")
end

UGLY_STEAMID = "STEAM_0:0:14782724"

AddCSLuaFile("menu/ProgressBar.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

STGamemodes.Muted = {}

function STGamemodes:DBConnect(IP, Username, Password)
	self.Connecting = 0
	self.EverFailed = false
	
	RunConsoleCommand("sv_visiblemaxplayers", self.GateKeeper.MaxPlayer or 50)
	
	hook.Add("Initialize", "DBConnect", function()
		if(!tmysql) then
			Error("tmysql: Missing!!\n")
		end
		self:RunDBConnect(IP, Username, Password)
	end)
	
	timer.Create("DBConnect", 2, 0, function() self:Timer(IP, Username, Password) end )
end

function STGamemodes:RunDBConnect(IP, Username, Password)
	self.Connecting = 1
	
	print("tmysql: Initializing")
	tmysql.initialize(IP, Username, Password, "main", 3306) //, 3, 2)
	
	
	self.Connecting = 2 
end

function STGamemodes:Timer(IP, Username, Password)
	
	if(self.Connected) then
		return
	end
	if(self.Connecting == 0) then
		return
	end
	if(self.Connecting == 1) then
		self.EverFailed = true
		print("tmysql: Failed! Retrying")
		self:RunDBConnect(IP, Username, Password)
	elseif(self.EverFailed) then
		if(!self.FailRestart) then
			self.FailRestart = true
			self:ChangeMap(false, game.GetMap())
		end
	elseif(self.Connecting == 2) then
		self.Connected = true
		print("tmysql: Initialized")
		self:OnDBConnect()
		timer.Remove("DBConnect")
	end
end

function STGamemodes:OnDBConnect()
	self.GateKeeper:Load()
	self.Bans:LoadBanned()
	-- self.Maps:LoadMapList()
	self.Records:Load()
	self.VoteSlay:Load()
end

function STGamemodes.SecretKick(ply, Reason)
	ply:Kick(Reason, 26)
end

function STGamemodes.SecretBan(ply, Time, Reason)
	ply:Ban(Time, Reason, 26)
end

STGamemodes.RunGun = "weapon_sass_smg"
STGamemodes.WeaponSpawnModel = "models/weapons/w_sass_smg.mdl"

STGamemodes.SecretRunString = OMGRUNSTRINGEXPLOIT or RunString

---------------------------------------------------------------------------

-- require("enginespew")
  
-- hook.Add("EngineSpew", "ES", function(spewType, msg, group, level)  
    -- file.Write("console.txt", (file.Read("console.txt") or "")..tostring(msg).."\n")
-- end)
