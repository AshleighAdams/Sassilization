--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.PlayerMeta:SetOnline(Number)
	if(!self.ID) then
		return
	end
	tmysql.query("UPDATE sa_misc SET online='"..tostring(Number).."', lastserver="..tostring(self.ID)..", lastlogin="..tostring(os.time()).." WHERE steamid='"..self:SteamID().."'")
end

function STGamemodes.Forums:UpdateMap(Map)
	if(!self.ID or !tmysql) then
		return
	end
	tmysql.query("UPDATE sa_servers SET map = '"..Map.."' WHERE sid = '"..self.ID.."'")
end

function STGamemodes.Forums:WhereQuery(Table)
	local Table = Table or false
	if(!Table or table.Count(Table) == 0) then
		return
	end
	Table = table.Copy(Table)
	for k,v in pairs(Table) do
		Table[k] = "steamid=\'"..v.."\'"
	end
	local Table = table.concat(Table, " OR ")
	if(!Table or Table == "") then
		return
	end
	return Table
end

function STGamemodes.Forums:SetOnline(Table, Number)
	local String = self:WhereQuery(Table)
	if(!String) then
		return
	end
	tmysql.query("UPDATE sa_misc SET online='"..tostring(Number).."', lastserver="..tostring(self.ID)..", lastlogin="..tostring(os.time()).." WHERE "..String)
end

function STGamemodes.Forums:UpdateOnlinePlayers(Onlines)
	self:SetOnline(Onlines, 1)
	tmysql.query("SELECT steamid FROM sa_misc WHERE online=1 AND (lastserver=0 OR lastserver='"..self.ID.."')", function(Tab, Stat, Err)
		if(Err != 0) then
			Error(Err)
		end
		local Offlines = {}
		for k,v in pairs(Tab) do
			if(!table.HasValue(Onlines, v[1])) then
				table.insert(Offlines, v[1])
			end
		end
		self:SetOnline(Offlines, 0)
	end)
end

function STGamemodes.Forums:UpdatePlayTimes(Table)
	local String = self:WhereQuery(Table)
	if(!String) then
		return
	end
	tmysql.query("UPDATE sa_misc SET playtime = playtime + 60 WHERE "..String)
end

function STGamemodes.Forums:Update()
	if(!self.ID) then
		return
	end
	self.Onlines = {}
	for k,v in pairs(player.GetAll()) do
		if(v:SteamID() != UGLY_STEAMID) then
			table.insert(self.Onlines, v:SteamID())
		end
		
		if(v.Playtime) then
			STAchievements:SetCount(v, "Novice", v.Playtime, true)
			STAchievements:SetCount(v, "Addicted", v.Playtime, true)
			STAchievements:SetCount(v, "Sassilization Life", v.Playtime, true)
			STAchievements:SetCount(v, "No Life", v.Playtime, true)
			v.Playtime = nil
		end
		
		STAchievements:AddCount(v, "Novice", 60)
		STAchievements:AddCount(v, "Addicted", 60)
		STAchievements:AddCount(v, "Sassilization Life", 60)
		STAchievements:AddCount(v, "No Life", 60)
	end
	self:UpdatePlayTimes(self.Onlines)
	self:UpdateOnlinePlayers(self.Onlines)
end

function STGamemodes.Forums:Shutdown()
	self:SetOnline(self.Onlines, 0)
end

if(!tmysql) then
	return
end

timer.Create("STGamemodes.Forums:Update", 60, 0, function()
	STGamemodes.Forums:Update()
end)
