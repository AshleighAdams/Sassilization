--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Maps = {}

STGamemodes.Maps.MapList = {} // All maps
STGamemodes.Maps.MapRotation = {} // Maps in rotation
STGamemodes.Maps.TestMaps = {} // Maps not in rotation
STGamemodes.Maps.CurrentMap = string.Trim(string.lower(game.GetMap()))

STGamemodes.Maps.PlayedMaps = {}
STGamemodes.Maps.PlayedMapsDefaultDelay = 120 // In minutes!
STGamemodes.Maps.PlayedMapsFile = "playedmaps2.txt"

STGamemodes.Maps.NumVoteChoices = 6
STGamemodes.Maps.TimerEnd = 0
STGamemodes.Maps.Voting = false
STGamemodes.Maps.NextMap = false
STGamemodes.Maps.Extended = 0
STGamemodes.Maps.MaxExtensions = 2
STGamemodes.Maps.MapChangeTime = 15
STGamemodes.Maps.MapsVoteTime = STGamemodes.Maps.MapChangeTime - 5
STGamemodes.Maps.AlertInterval = 5
STGamemodes.Maps.AutoRepeatNumber = true

function STGamemodes.Maps:MapCheck()
	if !STGamemodes.ServerDirectory then 
		timer.Simple( 0.2, function() self:MapCheck() end )
		return 
	end 

	local MapList = self:GetMapRotation()
	
	local buff = "Maplist:"
	
	for k,v in pairs(MapList) do
		buff = buff.."\n\t"..v
		table.insert(self.MapList, v)
		
		if(!self:IsValid(v)) then -- Repaled not v with self:IsNotValid()
			buff = buff.." (Invaild Map, missing "..v..".bsp)"
		end
	end
	
	local Name = ""
	if(GM) then
		Name = GM.FolderName
	elseif(GAMEMODE) then
		Name = GAMEMODE.FolderName 
	end
	
	local info = file.Read("gamemodes/"..Name.."/"..string.lower(Name)..".txt", "MOD")
	local info = util.KeyValuesToTable(info) 
	local Patterns = {}
	if(info and info.mappattern) then
		for k, v in pairs(info.mappattern) do
			table.insert(Patterns, string.lower(v))
		end
	end
	
	if(table.Count(Patterns) > 0) then
		buff = buff.."\n\nValid Map Not In Maplist:"
		for k,v in pairs(self:GetMaps()) do
			v = string.lower(v)
			for k2,v2 in pairs(Patterns) do
				local Find = string.find(v, v2)
				if(Find) then
					local Fixed = string.sub(v, 1, string.len(v) - 4)
					local Prefix = string.sub(v, 1, Find - 1)
					if(!table.HasValue(MapList, Fixed) and Fixed != "gm_construct") then
						buff = buff.."\n\t"..Fixed
						table.insert(self.TestMaps, Fixed)
						table.insert(self.MapList, Fixed)
					end
					break
				end
			end
		end
	end
	
	buff = buff.."\n\nLua Map Not In Maplist:"
	
	for k,v in pairs(self:GetMapFiles(Name)) do
		local Map = string.Trim(string.lower(v))
		local Fixed = string.sub(Map, 1, string.len(Map) - 4)
		if(!table.HasValue(MapList, Fixed) and Fixed != "gm_construct") then
			buff = buff.."\n\t"..Fixed
			table.insert(self.TestMaps, Fixed)
			table.insert(self.MapList, Fixed)
		end
	end
	
	file.Write(STGamemodes.ServerDirectory.."/maps.txt", buff)
end

function STGamemodes.Maps:GetMapRotation()
	return self.MapRotation or {}
end

function STGamemodes.Maps:SetMapRotation(Table)
	self.MapRotation = Table
	self:OnMapRotationChanged()
end

function STGamemodes.Maps:CheckMapRotation()
	for k,v in pairs(self.MapRotation) do
		self.MapRotation[k] = string.lower(string.Trim(v))
		if(!self:IsValid(self.MapRotation[k])) then
			self.MapRotation[k] = nil
			return true
		end
	end
	return false
end

function STGamemodes.Maps:OnMapRotationChanged()
	self:MapCheck()
	while(self:CheckMapRotation()) do
	end
	-- if(self.AutoRepeatNumber) then
	-- 	self.PlayedMapsRepeatNumber = table.Count(self.MapRotation) - 5
	-- end
	-- if(table.Count(self.PlayedMaps) > self.PlayedMapsRepeatNumber) then
	-- 	local remove = table.Count(self.PlayedMaps) - self.PlayedMapsRepeatNumber
	-- 	for i=0,remove do
	-- 		table.remove(self.PlayedMaps, 1)
	-- 	end
	-- end
end

function STGamemodes.Maps:GetTimeLeft(Decimal)
	local Involved = (self.TimerEnd - CurTime()) / 60
	if(!Decimal) then
		Involved = math.Round(Involved)
	end
	return Involved
end

function STGamemodes.Maps:GetExtends()
	return self.Extended
end

function STGamemodes.Maps:GetMaxExtends()
	return self.MaxExtensions
end

function STGamemodes.Maps:GetSecondsLeft()
	return self.TimerEnd - CurTime()
end

function STGamemodes.Maps:IsValid(Map)
	return file.Exists("maps/"..tostring(Map)..".bsp","MOD")
end

function STGamemodes.Maps:GetMaps()
	return file.Find("maps/*.bsp", "MOD")
end

function STGamemodes.Maps:MapFileIsValid(Map)
	return file.Exists("/gamemodes/"..GAMEMODE.Name.."/gamemode/maps/"..Map..".lua","MOD")
end

function STGamemodes.Maps:GetMapFiles(Gamemode)
	return file.Find("gamemodes/"..Gamemode.."/gamemode/maps/*.lua", "MOD")
end

function STGamemodes.Maps:StartMaps(Forced)	
	self.Maps = {}
	
	if(self.Extended < self.MaxExtensions) then
		table.insert(self.Maps, "Extend")
	end
	
	local maprotcount, mapplaycount = #self:GetMapRotation()-8, #self.PlayedMaps
	for k,v in rpairs(self:GetMapRotation()) do
		-- if(table.Count(self.Maps) < self.NumVoteChoices and v != self.CurrentMap and (!self.PlayedMaps[v] or (#self.PlayedMaps > (#self:GetMapRotation()-8)))) then
		-- 	table.insert(self.Maps, v)
		-- end
		v = string.Trim(string.lower(v))
		if(table.Count(self.Maps) < self.NumVoteChoices) then 
			if v != self.CurrentMap then 
				if (!self.PlayedMaps[v] or (mapplaycount > maprotcount)) then 
					table.insert(self.Maps, v) 
				end 
			end 
		else 
			break 
		end 
	end
	
	STGamemodes.Vote:Start("Votemap", self.Maps,
		function()
			STGamemodes:PrintAll("Vote for the next map now!")
			timer.Destroy("STGamemodes.MapAlert")
		end,
		function(Choice, Ply, Canceled )
			if Canceled then 
				STGamemodes:PrintAll( "Votemap Canceled by Administrator" )
			else 
				timer.Destroy("STGamemodes.MapAlert")
				timer.Destroy("STGamemodes.Votemap")
				timer.Destroy("STGamemodes.ChangeMap")
				self.NextMap = false 
				self:EndMaps(Choice, Forced) 
			end 
		end
	)
end

function STGamemodes.Maps:EndMaps(Map, Forced)
	self.Maps = {}
	self.Voting = false
	if(!Map or Map == "Extend" or Map == self.CurrentMap) then
		self.Extended = self.Extended + 1
		STGamemodes:PrintAll("This map has been extended")
		self:InitMaps(self.MapsVoteTime, self.MapChangeTime)
	elseif(Map) then
		self.NextMap = Map
		timer.Create( "STGamemodes.ChangeMap", (self.AlertInterval * 60) - 30, 1, function() self:ChangeMap() end) --self.TimerEnd - self.TimerStart
		if(Forced) then
			self:ChangeMap()
			STGamemodes:PrintAll("Voting Finished! The next map is "..self.NextMap..". The map is changing now!")
		else
			STGamemodes:PrintAll("Voting Finished! The next map is "..self.NextMap..". The map will change in "..tostring(math.Round(self.AlertInterval)).." minutes")
		end
	end
end

function STGamemodes.Maps:MapAlert()
	STGamemodes:PrintAll("Next Votemap in "..tostring(self:GetTimeLeft() - 5).." minutes")
end

function STGamemodes.Maps:ChangeMap()
	local Map = self.NextMap
	if(Map) then
		self:AddPlayedMaps(self.CurrentMap)
		STGamemodes:ChangeMap(false, Map)
	end
end

function STGamemodes.Maps:InitMaps(Votemap, ChangeTime)
	self.TimerStart = CurTime()
	self.TimerEnd = self.TimerStart + (ChangeTime * 60)
	timer.Create("STGamemodes.MapAlert", (self.AlertInterval * 60) + 5, math.floor(Votemap / self.AlertInterval), function() self:MapAlert() end )
	timer.Create("STGamemodes.Votemap", Votemap * 60, 1, function() self:StartMaps() end )
end

function STGamemodes.Maps:Reset(omg)
	local List = self:GetMapRotation()
	local Index = omg or false
	if(!Index) then
		for k,v in pairs(List) do
			if(string.Trim(string.lower(v)) == self.CurrentMap) then
				Index = k
			end
		end
	end
	local NextMap = false
	if(Index) then
		NextMap = List[Index + 1]
	end
	if(!NextMap) then
		Index = 1
		NextMap = List[Index]
	end
	if(!self:IsValid(NextMap)) then
		self:Reset(Index + 1)
		return
	end
	STGamemodes:ChangeMap(false, NextMap)
end

timer.Create( "STGamemodes.OMG", STGamemodes.Maps.MapChangeTime * 300, 1, function() STGamemodes.Maps:Reset() end )

function STGamemodes.Maps:SetUp(Time, MapDelay, MaxExtensions, FirstMapTime)
	self.MapChangeTime = Time
	self.MapsVoteTime = Time - 5
	self.MaxExtensions = MaxExtensions or 2
	self.PlayedMapsDefaultDelay = MapDelay or 240
	
	local VoteTime = self.MapsVoteTime
	if(FirstMapTime) then
		VoteTime = FirstMapTime - 5
	end
	timer.Simple(5, function() self:InitMaps(VoteTime, (FirstMapTime or self.MapChangeTime)) end )
end

function STGamemodes.Maps:AddPlayedMaps(Map)
	self.PlayedMaps[string.lower(string.Trim(Map))] = os.time() + self.PlayedMapsDefaultDelay * 60
	self:SavePlayedMaps()
end

function STGamemodes.Maps:SavePlayedMaps()
	-- local Buffer = ""
	-- for k,v in pairs(self.PlayedMaps) do
	-- 		Buffer = Buffer.."\n"..k..","..v
	-- end 
	-- file.Write(self.PlayedMapsFile, Buffer)
	-- PrintTable(self.PlayedMaps)
	-- self.PlayedMapsFile = STGamemodes.ServerDirectory .."/".. self.PlayedMapsFile ..".txt"
	-- print(STGamemodes.ServerDirectory .."/".. self.PlayedMapsFile)
	file.Write(STGamemodes.ServerDirectory .."/".. self.PlayedMapsFile, Json.Encode(self.PlayedMaps))
end

function STGamemodes.Maps:LoadPlayedMaps()
	self.PlayedMaps = {}
	-- self.PlayedMapsFile = STGamemodes.ServerDirectory .."/".. self.PlayedMapsFile ..".txt"
	if(file.Exists(STGamemodes.ServerDirectory .."/".. self.PlayedMapsFile, "DATA")) then 
		local File = file.Read(STGamemodes.ServerDirectory .."/".. self.PlayedMapsFile,"") 
		if File and File != "" then 
			self.PlayedMaps2 = Json.Decode(File)
			for k,v in pairs(self.PlayedMaps2) do 
				if v > os.time() then 
					self.PlayedMaps[k] = v 
				end 
			end 
			-- for k,v in pairs(string.Explode("\n", file.Read(self.PlayedMapsFile) or "")) do 
			-- 	local Info = string.Explode(",",string.Trim(string.lower(v)))
			-- 	if Info and Info[1] and Info[2] then 
			-- 		Info[2] = tonumber(Info[2])
			-- 		if Info[2] > os.time() then
			-- 			self.PlayedMaps[Info[1]] = Info[2] 
			-- 		end 
			-- 	end 
			-- end 
		end 
	end 
end
-- STGamemodes.Maps:LoadPlayedMaps()

/* This doesn't work the way it should
function STGamemodes.Maps:LoadMapList()

	if( #STGamemodes.Maps.MapList > 0 ) then return end
	
	tmysql.query("SELECT mapname,enabled from sa_maplist WHERE sid="..tostring(STGamemodes.Forums:GetID() or 0), function(Res, stat, err)
		if( Res ) then
			STGamemodes.Maps.MapList = {}
			STGamemodes.Maps.Maps = {}
			for k, v in ipairs( Res ) do
				if( tonumber( v[2] ) != 0 ) then
					table.insert(STGamemodes.Maps.MapList, string.Trim(string.lower(v[1])))
				else
					table.insert(STGamemodes.Maps.Maps, v[1])
				end
			end
			timer.Simple( 5, function() hook.Call("OnMapListLoaded", STGamemodes.Maps) end )
			self:OnMapListChanged()
		end
	end )
	
end

function STGamemodes.Maps:OnMapListLoaded()
	
	-- ErrorNoHalt( "Map List Loaded!\n" )
	
	local RF = RecipientFilter()
	for _, pl in ipairs( player.GetAdmins() ) do
		
		RF:AddPlayer( pl )
		
	end
	
	for i, map in ipairs( STGamemodes.Maps.MapList ) do
		if( map:lower() != "extend" ) then
			umsg.Start( "STGamemodes.VGUI.Admin.Maps.Add", RF )
				umsg.String( map )
				umsg.Bool( true )
				umsg.Bool( false )
			umsg.End()
		end
	end
	
	for i, map in ipairs( STGamemodes.Maps.Maps ) do
		umsg.Start( "STGamemodes.VGUI.Admin.Maps.Add", RF )
			umsg.String( map )
			umsg.Bool( false )
			umsg.Bool( false )
		umsg.End()
	end
	
end

hook.Add( "PlayerOnRank", "STGamemodes.Maps.PlayerOnRank", function( pl, rank ) 
	
	if( pl:IsAdmin() ) then
		
		for i, map in ipairs( STGamemodes.Maps.MapList ) do
			if( map:lower() != "extend" ) then
				umsg.Start( "STGamemodes.VGUI.Admin.Maps.Add", pl )
					umsg.String( map )
					umsg.Bool( true )
					umsg.Bool( false )
				umsg.End()
			end
		end
		
		for i, map in ipairs( STGamemodes.Maps.Maps ) do
			umsg.Start( "STGamemodes.VGUI.Admin.Maps.Add", pl )
				umsg.String( map )
				umsg.Bool( false )
				umsg.Bool( false )
			umsg.End()
		end
		
	end
	
end )

concommand.Add( "st_maplist_add", function( pl, cmd, args )
	if( !pl:IsAdmin() ) then return end
	
	local mapname = args[1]
	if( mapname:lower() == "extend" ) then return end
	
	for i, map in ipairs( STGamemodes.Maps.Maps ) do
		if( map == mapname ) then
			pl:ChatPrint( "Adding map to rotation..." )
			tmysql.query( "UPDATE sa_maplist SET enabled=1 WHERE sid="..tostring(STGamemodes.Forums:GetID() or 0).." AND mapname='"..tostring(map).."'", function( res, stat, err )
				
				if(err == 0 and stat) then
					table.remove( STGamemodes.Maps.Maps, i )
					table.insert( STGamemodes.Maps.MapList, string.Trim(string.lower(mapname)))
					self:OnMapListChanged()
					
					local RF = RecipientFilter()
					for _, p in ipairs( player.GetAdmins() ) do
						if( p != pl ) then
							RF:AddPlayer( p )
						end
					end
					umsg.Start( "STGamemodes.VGUI.Admin.Maps.Add", pl )
						umsg.String( map )
						umsg.Bool( true )
						umsg.Bool( true )
					umsg.End()
					umsg.Start( "STGamemodes.VGUI.Admin.Maps.Add", RF )
						umsg.String( map )
						umsg.Bool( true )
						umsg.Bool( false )
					umsg.End()
					pl:ChatPrint( "Successfully added map!" )
				else
					pl:ChatPrint( "Failed to add map! Err: "..tostring(err).." Status:"..tostring(stat) )
				end
				
			end )
			return;
		end
	end
	
end )

concommand.Add( "st_maplist_remove", function( pl, cmd, args )
	if( !pl:IsAdmin() ) then return end
	
	local mapname = args[1]
	if( mapname:lower() == "extend" ) then return end
	
	for i, map in ipairs( STGamemodes.Maps.MapList ) do
		if( map == mapname ) then
			pl:ChatPrint( "Removing map from rotation..." )
			tmysql.query( "UPDATE sa_maplist SET enabled=0 WHERE sid="..tostring(STGamemodes.Forums:GetID() or 0).." AND mapname='"..tostring(map).."'", function( res, stat, err )
				
				if(err == 0 and stat) then
					table.remove( STGamemodes.Maps.MapList, i )
					self:OnMapListChanged()
					
					table.insert( STGamemodes.Maps.Maps, mapname )
					local RF = RecipientFilter()
					for _, p in ipairs( player.GetAdmins() ) do
						if( p != pl ) then
							RF:AddPlayer( p )
						end
					end
					umsg.Start( "STGamemodes.VGUI.Admin.Maps.Add", pl )
						umsg.String( map )
						umsg.Bool( false )
						umsg.Bool( true )
					umsg.End()
					umsg.Start( "STGamemodes.VGUI.Admin.Maps.Add", RF )
						umsg.String( map )
						umsg.Bool( false )
						umsg.Bool( false )
					umsg.End()
					pl:ChatPrint( "Successfully removed map!" )
				else
					pl:ChatPrint( "Failed to add map! Err: "..tostring(err).." Status:"..tostring(stat) )
				end
				
			end )
			return;
		end
	end
	
end )
*/