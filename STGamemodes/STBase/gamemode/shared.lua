--------------------
-- STBase
-- By Spacetech
--------------------

GM.Name			= "STBase"
GM.Author		= "Spacetech"
GM.Email 		= "Spacetech326@gmail.com"
GM.Website 		= "www.sassilization.com"
GM.TeamBased 	= true

STGamemodes = {}
STGamemodes.PlayerMeta = FindMetaTable("Player")
STGamemodes.EntityMeta = FindMetaTable("Entity")

TEAM_SPEC = 1
TEAM_JOINING = 0
TEAM_FORUMS = -1

GM.svAccelerate = 0
GM.svAirAccelerate = 100
GM.CSSSpeed = 250 -- 250 w/ knife | 260 / scout

function GM:CreateTeams()
	self:TeamSetupSpeed(TEAM_SPEC, self.CSSSpeed)
	
	team.SetUp(TEAM_SPEC, "Spec", Color(80, 80, 80, 255))
	team.SetSpawnPoint(TEAM_SPEC, "info_player_counterterrorist")
	
	team.SetUp(TEAM_JOINING, "Joining", Color(20, 20, 20, 255))
	team.SetSpawnPoint(TEAM_JOINING, "info_player_counterterrorist")
	
	team.SetUp(TEAM_FORUMS, "Forums", Color(20, 120, 120, 255))
	team.SetSpawnPoint(TEAM_FORUMS, "info_player_counterterrorist")
end

function GM:ShouldCollide(Ent1, Ent2)
	if Ent1:IsPlayer() and Ent2:IsPlayer() then
		if self.TeamCollisions then 
			return false 
		elseif Ent1:IsGhost() or Ent2:IsGhost() then
			return false 
		end 
		return (Ent1:Team() != Ent2:Team())
	-- elseif Ent1:IsPlayer() or Ent2:IsPlayer() then 
	-- 	if Ent1:IsGhost() or Ent2:IsGhost() then 
	-- 		if Ent1:GetClass() == "func_tracktrain" or Ent2:GetClass() == "func_tracktrain" then 
	-- 			return false 
	-- 		end 
	-- 	end 
	end 
	return true
end

function GM:GetGameDescription()
	return "STBase"
end

function GM:GetGamemodeDescription()
	return self:GetGameDescription()
end

function STGamemodes:Msg(Message)
	if(SERVER) then
		return
	end
	Msg(Message)
end

function STGamemodes:Print(Message)
	if(SERVER) then
		return
	end
	print(Message)
end

function STGamemodes:SetupServerDirectory( name )
	if (SERVER and (!self.GateKeeper or self.GateKeeper.DevMode == nil)) or (CLIENT and GetGlobalVar( "STGamemodes.DevMode",nil) == nil) then 
		if SERVER then self.GateKeeper:LoadDevMode( name ) end 
		timer.Simple(0.2, function() self:SetupServerDirectory(name) end )
		return 
	end 
	if CLIENT then 
		self.ServerDirectory = (GetGlobalVar( "STGamemodes.DevMode" ) and "Development" or name)
	else 
		self.ServerDirectory = "Servers/"..(self.GateKeeper.DevMode and "Development" or name)
		self.OriginalDirectory = name 
		self.ServerName = (self.GateKeeper.DevMode and "Development" or name)
		if !file.IsDir("Servers","") then file.CreateDir("Servers","") end 
		if !file.IsDir(self.ServerDirectory,"") then file.CreateDir(self.ServerDirectory,"") end 

		local ChangeMap = "Servers/"..self.ServerDirectory.."/changemap.txt"
		local Map = string.lower(string.Trim(game.GetMap()))

		if(file.Exists(ChangeMap, "DATA") and !self.GateKeeper.DevMode) then
			hook.Add("InitPostEntity", "CheckMap", function()
				local ChangeMapRead = string.lower(string.Trim(file.Read(ChangeMap)))
				if(string.find(Map, ChangeMapRead) == nil and string.find(ChangeMapRead, Map) == nil) then
					file.Delete(ChangeMap)
					ErrorNoHalt("CheckMap: ", Map, "-", ChangeMapRead, "\n")
					RunConsoleCommand("changelevel", ChangeMapRead)
					return 
				end 
			end )
		end 

		if self.GateKeeper.DevMode then 
			hook.Add("InitPostEntity", "AddABot", function()
				RunConsoleCommand("bot")
			end ) 
		end 
		STGamemodes.Maps:LoadPlayedMaps() 
	end 
end 

function STGamemodes:SetupModules()
	self.Modules = {}
	local Dir = self.ValidFileDir.."/modules"
	local files, dirs = file.Find(Dir.."/*", "LUA")
 	for k,v in pairs(dirs) do 
		if(!string.find(v, "svn") and !string.find(v, "git") and !string.find(v, "-off")) then
			table.insert(self.Modules, v)
		end
	end
end

function STGamemodes:GetModules()
	return self.Modules
end

function STGamemodes:GetSideDirs()
	if(SERVER) then
		return {"shared", "server"}
	else
		return {"shared", "client", "client/vgui"}
	end
end

function STGamemodes:ValidDir(Dir)
	return file.IsDir(self.ValidFileDir.."/"..Dir, "LUA")
end

function STGamemodes:ValidFile(Dir, File)
	local Full = self.ValidFileDir.."/"..Dir.."/"..File
	return file.Exists(Full, "LUA") and !file.IsDir(Full, "LUA")
end

function STGamemodes:LoadFile(Dir, File, PreLoad)
	if(self:ValidFile(Dir, File)) then
		if(PreLoad) then
			PreLoad()
		end
		self:Msg("\tLoading "..File..":")
		include(Dir.."/"..File)
		self:Msg("Loaded Successfully\n")
	end
end

function STGamemodes:LoadMapFile()
	self:LoadFile("maps", game.GetMap()..".lua")
end

function STGamemodes:LoadDirectory(Dir, Prefix)
	self:Msg(Prefix or "Loading "..Dir.."...\n")
	for k,File in pairs(file.Find(self.LoaderDir.."/"..Dir.."/*.lua", "LUA")) do
		self:LoadFile(Dir, File)
	end
	self:Msg(Prefix or "Loaded Successfully\n")
end

function STGamemodes:LoadModule(Module)
	self:Msg("\tLoading "..Module.."...\n")
	local Dir = "modules/"..Module
	self:LoadFile(Dir, "shared.lua", function() self:Msg("\t") end)
	if(SERVER) then
		self:LoadFile(Dir, "server.lua", function() self:Msg("\t") end)
	else
		self:LoadFile(Dir, "client.lua", function() self:Msg("\t") end)
	end
	for k,Side in pairs(self:GetSideDirs()) do
		if(self:ValidDir(Dir.."/"..Side)) then
			self:LoadDirectory(Dir.."/"..Side, "\t")
		end
	end
	self:Msg("\tLoaded Successfully\n")
end

function STGamemodes:LoadModules()
	self:Msg("Loading Modules...\n")
	for k,Module in pairs(self:GetModules()) do
		self:LoadModule(Module)
	end
	self:Msg("Loaded Successfully\n")
end

function STGamemodes:AddCSLuaModules()
	self:Msg("AddCSLuaDirectory: Modules...\n")
	for k,Folder in pairs(self:GetModules()) do
		local Dir = "modules/"..Folder
		self:Msg("\tAddCSLuaDirectory: "..Folder.."...\n")
		if(self:ValidFile(Dir, "client.lua")) then
			self:Msg("\t\tAddCSLuaFile client.lua:")
			AddCSLuaFile(Dir.."/client.lua")
			self:Msg("Successful\n")
		end
		if(self:ValidFile(Dir, "shared.lua")) then
			self:Msg("\t\tAddCSLuaFile shared.lua:")
			AddCSLuaFile(Dir.."/shared.lua")
			self:Msg("Successful\n")
		end
		if(self:ValidDir(Dir.."/client")) then
			self:AddCSLuaDirectory(Dir.."/client")
		end
		if(self:ValidDir(Dir.."/shared")) then
			self:AddCSLuaDirectory(Dir.."/shared")
		end
		self:Msg("\tAddCSLuaDirectory: Successful\n")
	end
	self:Msg("AddCSLuaDirectory: Successful\n")
end

function STGamemodes:AddCSLuaDirectory(Dir)
	self:Msg("AddCSLuaDirectory: "..Dir.."...\n")
	for k,File in pairs(file.Find(self.LoaderDir.."/"..Dir.."/*.lua", "LUA")) do
		self:Msg("\tAddCSLuaFile "..File..":")
		AddCSLuaFile(Dir.."/"..File)
		self:Msg("Successful\n")
	end
	self:Msg("AddCSLuaDirectory: Successful\n")
end

function STGamemodes:AddCSLuaDirectorySmart(Dir)
	self:Msg("AddCSLuaDirectorySmart: "..Dir.."...\n")
	for k,File in pairs(file.Find(self.LoaderDir.."/"..Dir.."/*.lua", "LUA")) do
		if(string.sub(File, 1, 3) == "cl_" or string.sub(File, 1, 3) == "sh_" or string.sub(File, 1, 6) == "shared" or string.sub(File, 1, 7) == "player_") then
			self:Msg("\tAddCSLuaFile "..File..":")
			AddCSLuaFile(Dir.."/"..File)
			self:Msg("Successful\n")
		end
	end
	self:Msg("AddCSLuaDirectorySmart: Successful\n")
end

function STGamemodes:AddCSLuaDirectoryRecursive(Dir)
	self:Msg("AddCSLuaDirectoryRecursive: "..Dir.."...\n")
	local Files, Dirs = file.Find(self.LoaderDir.."/"..Dir.."/*", "LUA")
	for k,File in pairs(Files) do
		local Full = Dir.."/"..File
		if(string.find(File, ".lua", 1, true) != nil) then
			self:Msg("\tAddCSLuaFile "..File..":")
			AddCSLuaFile(Full)
			self:Msg("Successful\n")
		end
	end
	for k,File in pairs(Dirs) do 
		local Full = Dir.."/"..File 
		if(self:ValidDir(Full)) then
			self:AddCSLuaDirectoryRecursive(Full)
		end 
	end 
	self:Msg("AddCSLuaDirectoryRecursive: Successful\n")
end

function STGamemodes:AddResourceDirectory(Dir)
	self:Msg("AddResourceDirectory: "..Dir.."...\n")
	local FoundDir = false
	local Files, Dirs = file.Find('gamemodes/'..self.ResourceDir.."/"..Dir.."/*", "MOD")
 	for k,v in pairs(Files) do
		local File = Dir.."/"..v
		if(!string.find(v, ".bz2") and !string.find(v, ".bat") and v != "info.txt" and !string.find(File, "-off")) then
			self:Msg("\tresource.AddFile "..File..":")
			resource.AddFile(File)
			self:Msg("Successful\n")
		end
 	end
 	for k,v in pairs(Dirs) do 
 		local File = Dir.."/"..v
 		if(file.IsDir(self.ResourceDir.."/"..File, "LUA")) then
			FoundDir = true
			self:AddResourceDirectory(File) 
		end 
	end 

	if(!FoundDir) then
		self:Msg("AddResourceDirectory: Successful\n")
	end
end

function STGamemodes:PrecacheDirectory(Dir)
	self:Msg("PrecacheDirectory: "..Dir.."...\n")
	local FoundDir = false
	local Files, Dirs = file.Find(Dir.."/*", "GAME")
 	for k,v in pairs(Files) do
		local File = Dir.."/"..v
		if(util.IsValidModel(File)) then
			self:Msg("\tutil.PrecacheModel "..v.."\n")
			util.PrecacheModel(File)
		elseif(string.find(File, ".wav", 1, true) or string.find(File, ".mp3", 1, true)) then
			self:Msg("\tutil.PrecacheSound "..v.."\n")
			util.PrecacheSound(File)
		end
 	end

 	for k,v in pairs(Dirs) do 
 		local File = Dir.."/"..v
 		if(file.IsDir(File, "GAME")) then
			FoundDir = true
			self:PrecacheDirectory(File) 
		end 
	end 

	if(!FoundDir) then
		self:Msg("PrecacheDirectory: Successful\n")
	end
end

function STGamemodes:LoadGamemode(Dir, SecondDir)
	self.LoaderDir = Dir.."/gamemode"
	self.ResourceDir = Dir.."/content"	
	self.ValidFileDir = self.LoaderDir


	-- if(CLIENT) then
	-- 	self.ValidFileDir = self.ValidFileDir
	-- 	-- self:PrecacheDirectory("models")
	-- 	-- self:PrecacheDirectory("sound")
	-- end
	
	self:Print("###############################################")
	self:Print("# "..Dir.." by Spacetech")
	
	self:SetupModules()
	
	if(SERVER) then
		self:Print("# Start: Sending Resources to Client")
		self:AddResourceDirectory("sound")
		self:AddResourceDirectory("models")
		self:AddResourceDirectory("materials")
		self:AddResourceDirectory("resources")
		self:Print("# End: Sending Resources to Client")

		self:Print("# Start: AddCSLua LUA Files")
		self:AddCSLuaDirectory("client")
		self:AddCSLuaDirectory("client/vgui")
		self:AddCSLuaDirectory("shared")
		self:AddCSLuaModules()
		AddCSLuaFile("achievements.lua")
		self:Print("# End: AddCSLua LUA Files")
	end
	
	self:Print("# Start: Loading LUA Files")
	for k,Side in pairs(self:GetSideDirs()) do
		self:LoadDirectory(Side)
	end
	self:LoadModules()
	
	self:Msg("Loading Achievement File...\n")
	include("achievements.lua")
	
	if(SERVER) then
		self:LoadMapFile()
	else 
		self:LoadFile("maps", game.GetMap().."_cl.lua")
	end

	
	self:Print("# End: Loading LUA Files")
	self:Print("###############################################")
end

function STGamemodes:IsValid(obj)
	if not obj then return false end
	local t = string.lower(type(obj))
	if t == 'entity' or t == 'player' or t == 'npc' then
		return IsValid(obj)
	end
	return true
end

STGamemodes:LoadGamemode("STBase")
