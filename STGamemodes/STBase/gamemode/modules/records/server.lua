--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes:AddChatCommand( "record", "st_record" )
STGamemodes:AddChatCommand( "records", "st_record" )
STGamemodes:AddChatCommand( "personal", "st_record" )
STGamemodes:AddChatCommand( "personalbest", "st_record" )
STGamemodes:AddChatCommand( "pb", "st_record" )
STGamemodes:AddChatCommand( "best", "st_record" )
STGamemodes:AddChatCommand( "wr", "st_top" )
STGamemodes:AddChatCommand( "top", "st_top" )
STGamemodes:AddChatCommand( "top10", "st_top" )
STGamemodes:AddChatCommand( "worldrecords", "st_top" )

function STGamemodes.Records:AwardFame( ply )
	timer.Simple( 5, function()
		if !ply:IsValid() then return end 
		if ply.AchievementFullyLoaded and GAMEMODE.Name then
			if STGamemodes.Records.Top and STGamemodes.Records.Top[1] then 
				--STAchievements:AddCount(ply, GAMEMODE.Name .." Hall Of Fame")
			end 
		else
			self:AwardFame( ply )
		end
	end )
end

function STGamemodes.Records:CheckFame( ply )
	if !ply:IsValid() then return end 
	if !self:GetEnabled() then return end 
	if !self.Top or !self.Top[1] then return end 
	for k,v in pairs(self.Top) do 
		if v[1] == ply:SteamID() then 
			self:AwardFame( ply )
		end 
	end 
end 
hook.Add( "PlayerInitialSpawn", "CheckFame", function(ply) STGamemodes.Records:CheckFame(ply) end )

function STGamemodes.Records:CheckNew(ply, time)
	if !ply:IsValid() or !time then return end 
	local Record, SteamFound, SteamID, time = 0, false, ply:SteamID(), tonumber(time)

	umsg.Start( "STGamemodes.Records:CheckPersonal", ply )
		umsg.Short( time )
	umsg.End()

	for k,v in pairs( STGamemodes.Records.Top ) do
		if v[3] then 
			if time < tonumber(v[3]) then
				Record = k
				break
			elseif v[1] == SteamID  then
				SteamFound = true
				break
			end 
		end 
	end

	if #STGamemodes.Records.Top < 10 and Record == 0 and !SteamFound and self.Loaded then
		Record = #STGamemodes.Records.Top + 1
	end

	local RecMessage = ply:CName().." achieved "..tostring(Record)..STNDRD(Record).." place on this map!"

	if Record > 0 then STGamemodes:PrintAll( RecMessage ) end 
	return (Record > 0)
end
