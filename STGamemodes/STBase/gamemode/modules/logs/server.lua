--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Logs = {}
STGamemodes.Logs.MaxLines = false
STGamemodes.Logs.FileNameNumber = 1
STGamemodes.Logs.FileName = false
-- STGamemodes.Logs.FileName = GAMEMODE:GetGameDescription().."/"..string.gsub(os.date("%x"), "/", "-").." ("..tostring(STGamemodes.Logs.FileNameNumber)..")" --.txt"

function STGamemodes.Logs:GetFileName()
	local Date = string.gsub(os.date("%x"), "/", "-")
	local FileName = STGamemodes.ServerDirectory .."/Logs"
	if !file.IsDir(FileName, "DATA") then file.CreateDir(FileName) end 
	FileName = FileName.."/"..Date
	return FileName
end

function STGamemodes.Logs:Event(Text)
	if(!AppendLog) then
		return
	end
	if (self.FileName == false) then 
		if STGamemodes.ServerDirectory then 
			self.FileName = self:GetFileName()
		else 
			timer.Simple( 0.1, function() self:Event(Text) end ) 
			return  
		end 
	end 
	AppendLog(self.FileName..".txt", "("..os.date("%X")..") "..Text..".\n")
end

function STGamemodes.Logs:CheckLines(FileName)
	if(self.MaxLines) then
		if(table.Count(string.Explode("\n", file.Read(FileName) or "")) >= self.MaxLines) then
			self.FileNameNumber = self.FileNameNumber + 1
			self.FileName = self:GetFileName().." ("..tostring(self.FileNameNumber)..")"
		end
	end
end

function STGamemodes.Logs:ParseLog(Event, ...)
	local EventArgs = {}
	for k,v in pairs({...}) do
		if(STValidEntity(v)) then
			if(v:SteamID() == UGLY_STEAMID) then
				return
			end
			table.insert(EventArgs, v:CName().." ("..v:SteamID()..")")
		else
			table.insert(EventArgs, tostring(v))
		end
	end
	self:Event("#"..string.format(Event, unpack(EventArgs)))
end

function STGamemodes.Logs.PlayerSay(ply, text)
	local FixedName = STGamemodes:FixString(ply:CName())
	
	for k,v in pairs(player.GetAll()) do
		if(v != ply and FixedName == STGamemodes:FixString(v:CName())) then
			STGamemodes.Logs:Event(ply:CName().." ("..ply:SteamID().."): "..text)
			return
		end
	end
	STGamemodes.Logs:Event(ply:CName()..": "..text)
end

function STGamemodes.Logs.PlayerInitialSpawn(ply)
	STGamemodes.Logs:ParseLog("%s has connected", ply)
end

function STGamemodes.Logs.PlayerDisconnected(ply)
	STGamemodes.Logs:ParseLog("%s has disconnected", ply)
end

function STGamemodes.Logs.Initialize()
	STGamemodes.Logs:Event("#The server has started")
end

function STGamemodes.Logs.ShutDown()
	STGamemodes.Logs:Event("#The server has shutdown")
end

hook.Add("PlayerSay", "STGamemodes.Logs.PlayerSay", STGamemodes.Logs.PlayerSay)
hook.Add("PlayerInitialSpawn", "STGamemodes.Logs.PlayerInitialSpawn", STGamemodes.Logs.PlayerInitialSpawn)
hook.Add("PlayerDisconnected", "STGamemodes.Logs.PlayerDisconnected", STGamemodes.Logs.PlayerDisconnected)
hook.Add("Initialize", "STGamemodes.Logs.Initialize", STGamemodes.Logs.Initialize)
hook.Add("ShutDown", "STGamemodes.Logs.ShutDown", STGamemodes.Logs.ShutDown)
