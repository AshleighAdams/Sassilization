--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.FindByPartial(Info)
	local Count = 0
	local FoundPlayer = false
	local Search = STGamemodes:ParseString(Info)
	for k,v in pairs(player.GetAll()) do
		if(v:EntIndex() == tonumber(Search) or tostring(v:EntIndex()) == Search) then
			return v
		end

		local Hits = {v:CName(), v:SteamID()}
		if SERVER then table.insert(Hits, v:IPAddress()) end 

		for k2,v2 in pairs(Hits) do
			if(FoundPlayer != v) then
				local UniqueInfo = STGamemodes:ParseString(v2)
				if(string.find(UniqueInfo, Search, 1, true)) then
					if(UniqueInfo == Search) then
						return v
					end
					Count = Count + 1
					FoundPlayer = v
				end
			end
		end
	end
	if(FoundPlayer) then
		if(Count > 1) then
			return "Too many people's name contain that!"
		end
		return FoundPlayer 
	end
	return "No ones name contains that!"
end

function STGamemodes:GetRealPlayers()
	local Teams = {}
	for k,v in pairs(team.GetAllTeams()) do
		if(v != TEAM_SPEC and v != TEAM_JOINING and v != TEAM_UNASSIGNED) then
			table.insert(Teams, v)
		end
	end
	return self:TeamAliveNum(Teams)
end

function player.GetAdmins()
	local admins = {}
	for _, pl in ipairs( player.GetAll() ) do
		if( pl:IsAdmin() ) then
			table.insert( admins, pl )
		end
	end
	return admins
end

function STGamemodes:GetNum(Teams)
	return table.Count(self:GetPlayers(Teams))
end

function STGamemodes:GetPlayers(Teams)
	local Players = {}
	for k,v in pairs(Teams) do
		table.Add(Players, team.GetPlayers(v))
	end
	return Players
end

function STGamemodes:TeamAliveNum(Teams)
	return table.Count(self:TeamAlive(Teams))
end

function STGamemodes:TeamAlive(Teams)
	local Players = {}
	for k,v in pairs(self:GetPlayers(Teams)) do
		if(v and v:IsValid() and v:Alive()) then
			table.insert(Players, v)
		end
	end
	return Players
end

function STGamemodes:FixString(String)
	return string.Trim(string.lower(String))
end

function STGamemodes:UpperCaseFirst(String)
	return string.upper(string.sub(String, 1, 1))..string.lower(string.sub(String, 2))
end

function STGamemodes:AdvRound(Number, Decimal) 
	local Decimal = Decimal or 0; 
	return math.Round(Number * (10 ^ Decimal)) / (10 ^ Decimal)
end

function STGamemodes:SecondsToFormat(Seconds, Decimals)
	if(!Seconds) then
		return "N/A"
	end
	local Original 	= tonumber(Seconds)
	if(!Original) then
		return "N/A"
	end
	local Hours 	= math.floor(Seconds / 3600)
	local Minutes 	= math.floor(( Seconds - Hours * 3600 ) / 60)
	local Seconds 	= math.floor(Seconds - Hours * 3600 - Minutes * 60)
	local Timeleft 	= ""
	local milli 	= ""

	if Decimals then 
		milli = tostring(Original) 
		milli = string.Explode(".", milli)[2]
		if milli and milli != "" then 
			milli = string.sub(milli, 1, 2) 
		else 
			milli = "00" 
		end 
	end 

	
	if Hours > 0 then
		Timeleft = Hours..":"
	end
	
	if Minutes < 10 and Hours > 0 then
		Timeleft = Timeleft.."0"..Minutes..":"
	elseif Hours == 0 and Minutes > 0 then
		Timeleft = Timeleft..Minutes..":"
	end

	if Seconds < 10 and (Minutes > 0 or Hours > 0) then
		Timeleft = Timeleft.."0"..Seconds
	else
		Timeleft = Timeleft..Seconds
	end
	if Decimals and milli then Timeleft = Timeleft.."."..milli end 
	
	return Timeleft, Original
end 

function STGamemodes:ParseString(String)
	return string.Trim(string.lower(tostring(String)))
end

function rpairs(t)
	math.randomseed(os.time())
	local keys = {}
	for k,_ in pairs(t) do
		table.insert(keys, k)
	end
	return function()
		if(#keys == 0) then
			return nil
		end
		local i = math.random(1, #keys)
		local k = keys[i]
		local v = t[k]
		table.remove(keys, i)
		return k, v
	end
end
