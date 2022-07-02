--------------------
-- STBase
-- By Spacetech
--------------------

STAchievements = {}
STAchievements.Meta = {}
STAchievements.Order = {}
STAchievements.Achievements = {}
STAchievements.Players = {}

function STAchievements:Get(Name)
	return self.Achievements[Name]
end

function STAchievements:GetGoal(Name)
	return self:Get(Name):GetGoal()
end

function STAchievements:Check(ply, Name)
	if(SERVER) then
		if(!ply.AchievementFullyLoaded) then
			return false
		end
		if(!self.Players[ply:SteamID()]) then -- I don't know how this happens
			return false
		end
		if(!self.Players[ply:SteamID()][Name]) then
			self.Players[ply:SteamID()][Name] = {
				Achieved = false,
				Count = 0
			}
		end
	else
		if(!self.Players[Name]) then
			self.Players[Name] = {
				Achieved = false,
				Count = 0
			}
		end
	end
	return true
end

function STAchievements:Award(ply, Name, Check)
	if(Check and self:IsAchieved(ply, Name)) then
		return
	end
	
	if(!self:Check(ply, Name)) then
		return
	end
	
	self:SetInfo(ply, Name, "Achieved", true)
	self:SetInfo(ply, Name, "Count", self:GetGoal(Name))
	
	if(SERVER) then
		-- print("Updating", ply, Name, self:GetGoal(Name))
		self:Update(ply, Name, self:GetGoal(Name))
		
		self:AnnounceAward(ply, Name)
	end
end

function STAchievements:GetInfo(ply, Name, Info)
	if(!self:Check(ply, Name)) then
		return 0
	end
	if(SERVER) then
		return self.Players[ply:SteamID()][Name][Info]
	end
	return self.Players[Name][Info]
end

function STAchievements:SetInfo(ply, Name, Info, Set)
	if(!self:Check(ply, Name)) then
		return
	end
	if(SERVER) then
		self.Players[ply:SteamID()][Name][Info] = Set
	else
		self.Players[Name][Info] = Set
	end
end

function STAchievements:IsAchieved(ply, Name)
	if(!self:Check(ply, Name)) then
		return
	end
	return self:GetInfo(ply, Name, "Achieved")
end

function STAchievements:IsAchievement(Name)
	return STAchievements.Achievements[Name]
end 

function STAchievements:GetCount(ply, Name) -- Crazy function
	return self:GetInfo(ply, Name, "Count")
end

function STAchievements:SetCount(ply, Name, Count, Override)	
	if(!self:Check(ply, Name)) then
		return
	end
	
	if(!Override and self:IsAchieved(ply, Name)) then
		return
	end
	
	self:SetInfo(ply, Name, "Count", Count)
	
	if(self:GetGoal(Name) <= self:GetInfo(ply, Name, "Count")) then
		if(Override and self:IsAchieved(ply, Name)) then
			return
		end
		self:Award(ply, Name)
	elseif(SERVER) then
		if(self:IsAchieved(ply, Name)) then
			self:SetInfo(ply, Name, "Achieved", false)
		end
		self:Update(ply, Name, Count)
	end
end

--------------------------------------------------------------------------------

function STAchievements:New(Name, Description, TGA, Goal)
    local Table = {}
    setmetatable(Table, self.Meta)
    self.Meta.__index = self.Meta
	
    Table.Name = Name
	
	if((!TGA or TGA == true) and TGA != false) then
		Table.TGA = string.gsub(string.lower(Name), " ", "_")
	else
		if type(TGA) == "string" then 
			TGA = string.gsub(string.lower(TGA), " ", "_")
		end 
		Table.TGA = TGA
	end
	
    Table.Description = Description
	Table.Goal = Goal or 1
	
	STAchievements.Achievements[Table.Name] = Table
	STAchievements.Order[table.Count(STAchievements.Order) + 1] = Table.Name
	
    return Table
end

function STAchievements.Meta:GetName()
	return self.Name
end

function STAchievements.Meta:GetDescription()
	return self.Description
end

function STAchievements.Meta:GetGoal()
	return self.Goal
end

function STAchievements.Meta:HasTGA()
	if self.TGA == false then 
		return false 
	end 
	return true 
end 

function STAchievements.Meta:GetTGA()
	return self.TGA
end
