--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.StartTimes = {}
STGamemodes.EndTimes = {}
STGamemodes.PauseTimes = {}

function CurTime2()
	return CurTime()
	-- return math.floor(CurTime())
end 

function STGamemodes.PlayerMeta:ResetTime()
	if !self:IsValid() then return end 
	STGamemodes.StartTimes[self:SteamID()] = nil 
	STGamemodes.EndTimes[self:SteamID()] = nil 
end 

function STGamemodes.PlayerMeta:SetStartTime(Time)
	if !self:IsValid() then return end 
	Time = tonumber(Time)
	STGamemodes.StartTimes[self:SteamID()] = Time or CurTime2()
end 

function STGamemodes.PlayerMeta:SetEndTime(Time)
	if !self:IsValid() then return end 
	Time = tonumber(Time)
	STGamemodes.EndTimes[self:SteamID()] = CurTime2()
end 

function STGamemodes.PlayerMeta:SetPauseTime(Time)
	if !self:IsValid() then return end 
	Time = tonumber(Time)
	STGamemodes.PauseTimes[self:SteamID()] = Time 
end 

function STGamemodes.PlayerMeta:UnPauseTime()
	if !self:IsValid() then return end 
	STGamemodes.PauseTimes[self:SteamID()] = nil 
end 

function STGamemodes.PlayerMeta:TimeIsPaused()
	if !self:IsValid() then return end 
	return STGamemodes.PauseTimes[self:SteamID()] and true or false 
end 

function STGamemodes.PlayerMeta:GetPauseTime()
	if !self:IsValid() then return end 
	return STGamemodes.PauseTimes[self:SteamID()]
end 

function STGamemodes.PlayerMeta:GetStartTime()
	if !self:IsValid() then return end 
	if !STGamemodes.StartTimes[self:SteamID()] then return nil end
	return STGamemodes.StartTimes[self:SteamID()]
end 

function STGamemodes.PlayerMeta:GetEndTime()
	if !self:IsValid() then return end 
	if !STGamemodes.EndTimes[self:SteamID()] then return nil end
	return STGamemodes.EndTimes[self:SteamID()]
end 

function STGamemodes.PlayerMeta:GetTotalTime(round)
	if !self:IsValid() then return end 
	if !self:GetStartTime() or !self:GetEndTime() then return nil end
	-- if self:GetStartTime() and !self:GetEndTime() then return self:GetStartTime() end
	if round then return math.floor(self:GetEndTime() - self:GetStartTime()) end
	return math.Round(self:GetEndTime() - self:GetStartTime(), 2)
end 

///////////////////////////////////////////////////////////////////////////////

function STGamemodes.PlayerMeta:StartTime(Reset)
	if !self:IsValid() then return end 

	local Time = (self:TimeIsPaused() and (CurTime2() - self:GetPauseTime()) or self:GetStartTime())
	self:UnPauseTime()
	if Reset then Time = CurTime2()end 
	self:ResetTime()
	self:SetStartTime(Time)
	-- umsg.Start("STGamemodes.Timer", self)
	-- 	umsg.Short(self:GetStartTime())
	-- umsg.End()

	self:SetNetworkedFloat("Timer", self:GetStartTime())
end 

function STGamemodes.PlayerMeta:EndTime()
	if !self:IsValid() then return end 

	self:SetEndTime(CurTime2())

	-- umsg.Start("STGamemodes.Timer", self)
	-- 	umsg.Short(0)
	-- umsg.End()

	
	self:SetNetworkedFloat("Timer", 0)
end 

function STGamemodes.PlayerMeta:PauseTime()
	if !self:IsValid() or !self:GetStartTime() then return end 

	self:EndTime()
	self:SetPauseTime(self:GetTotalTime())
	self:ResetTime()
end 