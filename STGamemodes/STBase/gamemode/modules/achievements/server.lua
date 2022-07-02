--------------------
-- STBase
-- By Spacetech
--------------------

STAchievements.Offset = Vector(0, 0, 72)

STAchievements.AwardNameCol = Color(252, 241, 213)
STAchievements.AwardTextCol = Color(151, 198, 56)

local DelayTime = 0.15

STAchievements.PlayersQueueLoad = {}

function STAchievements:Load(ply)
	local SteamID = ply:SteamID()
	
	tmysql.query("SELECT st_achievements from sa_misc WHERE steamid=\'"..SteamID.."\'", function(result, stat, err)
		if(!ply or !ply:IsValid()) then
			return
		end
		
		if(err != 0 or !stat) then
			timer.Simple(1, function()
				if(STValidEntity(ply)) then
					self:Load(ply)
				end
			end)
			ErrorNoHalt("STAchievements.Load - "..ply:SteamID().." - "..ply:CName().." - "..tostring(err).." - "..tostring(stat).." - Timer Reloading")
			return
		end
		
		if(!result[1] or !result[1][1]) then
			return
		end
		
		local Achievements = result[1][1]
		if(!Achievements or string.Trim(Achievements) == "" or Achievements == "NULL") then
			Achievements = {}
		else
			Achievements = Json.Decode(Achievements)
		end
		
		self.Players[SteamID] = Achievements or {}
		
		STAchievements:SendAll(ply, SteamID)
	end)
end

function STAchievements:Save(ply)
	if(STGamemodes.EverFailed) then
		return
	end
	if(ply.Guest or !ply.AchievementFullyLoaded) then
		return
	end
	if(!self.Players[ply:SteamID()]) then
		return
	end
	-- self:Debug(ply, "Save - "..tostring(table.Count(self.Players[ply:SteamID()])), true)
	local Encode = Json.Encode(self.Players[ply:SteamID()])
	if(Encode) then
		-- print("Saving...")
		tmysql.query("UPDATE sa_misc SET st_achievements=\'"..tmysql.escape(Encode).."\' WHERE steamid=\'"..ply:SteamID().."\'", function(data, stat, err)
			-- print("Saved Achievements!")
			if(err != 0 or !stat) then
				if(ply and ply:IsValid()) then
					ErrorNoHalt("STAchievements:Save - "..ply:SteamID().." - "..ply:CName().." - "..tostring(err).." - "..tostring(stat), "\n")
				end
			end
		end)
	else
		ErrorNoHalt("STAchievements:Save - Encode Failed - ("..ply:SteamID()..") - "..ply:CName(), "\n")
	end
end

function STAchievements:SendAll(ply, SteamID)
	local SteamID = SteamID or ply:SteamID()
	
	-- print("Loading Achievements: "..tostring(ply))
	
	ply:ChatPrint("Achievements: Loading")
	
	umsg.Start("STAchievements.UserMessage.Start", ply)
	umsg.End()
	
	local Time = DelayTime
	
	self.PlayersQueueLoad[SteamID] = {}
	
	for k,v in pairs(table.Copy(self.Players[SteamID])) do
		if(self:Get(k)) then
			self.PlayersQueueLoad[SteamID][k] = {CurTime() + Time, v.Count}
			timer.Simple(Time, function() self:SendAchievement(ply, k, v.Count) end )
			Time = Time + DelayTime
		end
	end
	
	local TimerName = "AchievementLoading"..SteamID
	timer.Create(TimerName, DelayTime, 0, function() self:CheckLoaded(ply, SteamID, TimerName) end )
end

function STAchievements:CheckLoaded(ply, SteamID, TimerName)
	if(!ply or !ply:IsValid()) then
		timer.Remove(TimerName)
		return
	end
	
	for k,v in pairs(self.PlayersQueueLoad[SteamID]) do
		if(v[1] <= CurTime() - 1) then
			self:SendAchievement(ply, k, v[2])
			self.PlayersQueueLoad[SteamID][k][1] = CurTime() + 2
		end
		return
	end
	
	self.PlayersQueueLoad[SteamID] = nil
	
	ply.AchievementFullyLoaded = true
	
	ply:ChatPrint("Achievements: Loaded Successfully!")
	
	-- print("Loaded Achievements Successfully!: "..tostring(ply))
	
	ply:SendLua([[STAchievements.Loading = false]])
	
	umsg.Start("STAchievements.UserMessage.End", ply)
	umsg.End()
	
	timer.Remove(TimerName)
	
	if(IsValid(SASSAFRASS) and !SASSAFRASS:IsFake()) then
		if(ply.Sassafrass) then
			for k,v in pairs(player.GetAll()) do
				STAchievements:Award(v, "Sassafrass Who?", true)
			end
		else
			self:Award(ply, "Sassafrass Who?", true)
		end
	end
end

function STAchievements:SendAchievement(ply, Name, Count)
	if(!ply or !ply:IsValid()) then
		return
	end
	umsg.Start("STAchievements.UserMessage.Load", ply)
		umsg.String(Name)
		umsg.Long(Count or self:GetCount(ply, Name)) -- GetCount only works when fully loaded
	umsg.End()
end

concommand.Add("st_achievement_loaded", function(ply, cmd, args)
	if(!STAchievements.PlayersQueueLoad[ply:SteamID()]) then
		return
	end
	local Achievement = args[1]
	if(!Achievement) then
		return
	end
	STAchievements.PlayersQueueLoad[ply:SteamID()][Achievement] = nil
end)

function STAchievements:AnnounceAward(ply, Name)
	if(ply:Alive()) then
		local Effect = EffectData()
		Effect:SetOrigin(ply:GetPos() + self.Offset)
		util.Effect("achievement_awarded", Effect, true, true)
	end
	
	STGamemodes:CustomChat(ply:CName().." has achieved", Name, self.AwardNameCol, self.AwardTextCol)
end

function STAchievements:Update(ply, Name, Count)
	self:SendAchievement(ply, Name, Count)
end

function STAchievements:AddCount(ply, Name, Count)
	self:SetCount(ply, Name, self:GetCount(ply, Name) + (Count or 1))

	if self:IsAchievement(Name.." (Tier 2)") then 
		Name = Name.." (Tier 2)"
		self:SetCount(ply, Name, self:GetCount(ply, Name) + (Count or 1))
	end 
end
