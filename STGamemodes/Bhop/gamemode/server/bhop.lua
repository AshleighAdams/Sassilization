--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.EntityMeta:IsBlock()
	return self:GetClass() == "func_door"
end

function STGamemodes.EntityMeta:IsLevel()
	if self:GetClass() == 'trigger_teleport' then
		return self.isLevel or false
	else
		return false
	end
end

function STGamemodes.EntityMeta:SetLevel(bool)
	if self:GetClass() != 'trigger_teleport' then return end
	if bool then
		self.isLevel = true
	else
		self.isLevel = false
	end
end

GM.Blocks = {}
GM.KeyValues = {}
GM.PlayerInfo = {}
GM.Teleporters = {}
GM.AddVector = Vector(0, 0, 5)
GM.ZeroVector = Vector(0, 0, 0)
GM.IgnoreTeleporters = {}

function GM:Debug(...)
	if(false) then
		ErrorNoHalt(unpack({...}))
		ErrorNoHalt("\n")
	end
end

function GM:GetInfo(ply, Key, Default)
	return self.PlayerInfo[ply:SteamID()][Key] or Default
end

function GM:SetInfo(ply, Key, Value)
	ply[Key] = Value
	self.PlayerInfo[ply:SteamID()][Key] = Value
	return Value
end

function GM:SyncInfo(ply)
	for k,v in pairs(self.PlayerInfo[ply:SteamID()]) do
		ply[k] = v
		--print("SyncInfo", ply, k, v)
	end
end

function GM:EntityKeyValue(ent, key, value)
	if(!self.KeyValues[ent]) then
		self.KeyValues[ent] = {}
	end
	self.KeyValues[ent][key] = value
end

function GM:InitPostEntity()
	self.BaseClass.InitPostEntity(self)
	
	self:SetupBlocks(ents.FindByClass("func_door"))
	self:CacheTeleporters(ents.FindByClass("trigger_teleport"))
	self:CacheTeleportPositions(self.Blocks)
	
	STGamemodes:RemoveEntities()
	STGamemodes.Weapons:Spawn()
end

function GM:SetupBlocks(Blocks)
	for k,v in pairs(Blocks) do
		self.Blocks[v] = {
			Pos = v:GetPos(),
			Origin = v:GetPos()
		}
		
		-- if(v:GetPos():Distance(Vector(1808.59375, 4416.84375, -959.96875)) <= 512) then
			-- print("------------------------------------------")
			-- PrintTable(self.KeyValues[v])
			-- print("------------")
			-- PrintTable(v:GetKeyValues())
			-- print("------------------------------------------")
		-- end
		
		-- print("Next:")
		-- print(self.KeyValues[v].speed,  self.KeyValues[v].OnOpen)
		if(self.IgnoreSpeed or (!self.KeyValues[v].OnOpen and (!self.KeyValues[v].speed or tonumber(self.KeyValues[v].speed) <= (self.DownSpeed or 200)))) then
			v:SetKeyValue("spawnflags", "2048")
			-- print("Set Flags")
		end
	end
	print("Setup "..tostring(table.Count(self.Blocks)).." blocks")
end

function GM:CacheTeleporters(Teleporters)
	for k,v in pairs(Teleporters) do
	
		local KeyValues = v:GetKeyValues()
		
		local Ang = Angle(0, 0, 0)
		local Target = KeyValues.target
		if(Target) then
			local TargetEnt = ents.FindByName(Target)
			if(IsValid(TargetEnt[1])) then
				Target = TargetEnt[1]:GetPos()
				Ang = TargetEnt[1]:GetAngles()
			else
				Target = false
			end
		else
			Target = false
		end
		
		v.TelePos = Target
		v.TeleAng = Ang
		
		self.Teleporters[v] = {
			Pos = v:GetPos(),
			Min = v:LocalToWorld(v:OBBMins()),
			Max = v:LocalToWorld(v:OBBMaxs())
		}
	end
	print("Setup "..tostring(table.Count(self.Teleporters)).." teleporters")
end

function GM:InBetweenNumber(Value, Min, Max)
	if(Value < Min or Value > Max) then
		return false
	end
	return true
end

function GM:FindTeleporter(Pos)
	for k,v in pairs(self.Teleporters) do
		if(self:InBetweenNumber(Pos.x, v.Min.x, v.Max.x) and self:InBetweenNumber(Pos.y, v.Min.y, v.Max.y) and self:InBetweenNumber(Pos.z, v.Min.z, v.Max.z)) then
			return k
		end
	end
	return false
end

function GM:RecursiveDirectionalCheck(Block, Origin, Direction)
	local Tries = 0
	local Origin = Origin
	Block.Teleporter = self:FindTeleporter(Origin)
	while(!Block.Teleporter and Tries < 300) do
		Tries = Tries + 1
		Origin = Origin + Vector(0, 0, 2 * Direction)
		Block.Teleporter = self:FindTeleporter(Origin)
	end
end

function GM:CacheTeleportPositions(Blocks)
	local h_a, h_b, h_c = debug.gethook()
	debug.sethook(function() end, "", 0)
	for k,v in pairs(Blocks) do
		self:RecursiveDirectionalCheck(k, v.Origin, -1)
		if(!k.Teleporter) then
			self:RecursiveDirectionalCheck(k, v.Origin, 1)
		end
		if(!k.Teleporter) then
			self:Debug("No Teleporter: ", k, " | ", v.Origin)
		end
	end
	debug.sethook(function() end, h_b, h_c)
end

function GM:ShouldSaveCurrentPos(ply)
	if(ply.CurGroundEntity and ply.CurGroundEntity != game.GetWorld()) then
		if(IsValid(ply.CurGroundEntity) and ply.CurGroundEntity:IsBlock()) then
			return false
		end
	end
	return true
end

function GM:OnSaveCurrentPos(ply, Pos, EyeAngle)
	print("Saving", CurTime())
	self:SetInfo(ply, "TeleportPos", Pos)
end

local CurGroundEntity
local NewGroundEntity
function GM:OnMove(ply, Move)
	if(!ply:Alive()) then
		return
	end
	
	CurGroundEntity = ply.CurGroundEntity
	NewGroundEntity = ply:GetGroundEntity()
	
	-- ply:ChatPrint(tostring(CurGroundEntity).." - "..tostring(NewGroundEntity))
	if(CurGroundEntity == game.GetWorld()) then
		ply.LastBlock = nil
		ply.BlockLandTime = nil
	end
	
	if(CurGroundEntity == NewGroundEntity) then
		if(IsValid(CurGroundEntity) and CurGroundEntity:IsBlock()) then
			if(ply.BlockLandTime and ply.BlockLandTime < (CurTime() - ply.StayTime)) then
				if(IsValid(CurGroundEntity.Teleporter)) then
					-- ply:ChatPrint("ON BLOCK TOO LONG - ".. tostring(CurGroundEntity) .." - ".. tostring(ply.BlockLandTime) .." - ".. tostring((CurTime() - ply.StayTime)))
					self:SetPlayerPos(ply, CurGroundEntity.Teleporter.TelePos, CurGroundEntity.Teleporter.TeleAng, CurGroundEntity:GetPos())
				end
			end
		end
	else
		if(IsValid(NewGroundEntity) and NewGroundEntity:IsBlock()) then
			if(ply.LastBlock == NewGroundEntity) then
				if(IsValid(NewGroundEntity.Teleporter)) then
					-- ply:ChatPrint("NO DOUBLE JUMPING")
					self:SetPlayerPos(ply, NewGroundEntity.Teleporter.TelePos, NewGroundEntity.Teleporter.TeleAng, NewGroundEntity:GetPos())
				end
			else
				ply.BlockLandTime = CurTime()
				ply.LastBlock = NewGroundEntity
				STAchievements:AddCount(ply, "Block Jumper")
			end
		end
		ply.CurGroundEntity = NewGroundEntity
	end
	
	if(ply.ForcePos) then
		Move:SetVelocity(self.ZeroVector)
		Move:SetOrigin(ply.ForcePos)
		ply:SetGroundEntity(NULL)
		ply.ForcePos = nil
	end
	if(ply.ForceAng) then
		ply:SetEyeAngles(ply.ForceAng)
		ply.ForceAng = nil
	end
end

function GM:AddIgnorePos(Pos)
	self.IgnoreTeleporters[self:ParseIgnorePos(Pos)] = true
end

function GM:ParseIgnorePos(Pos)
	return tostring(Pos.x)..","..tostring(Pos.y)..","..tostring(Pos.z)
end

function GM:NightmareReset(ply)
	if(self:GetInfo(ply, "Level") == 6 and !self:GetInfo(ply, "Winner", false)) then
		ply.ForcePos = nil
		ply.ForceAng = nil
		ply:Kill()
		self:SetupLevel(ply, 6, true)
		ply:SetVar("QuickSpawn", true)
		ply:ResetJumpCount()
		ply:ResetFailCount()
		return true
	end
	return false
end

function GM:SetPlayerPos(ply, Pos, Ang, EntPos)
	if(Pos) then
		if(!self.IgnoreTeleporters or (self.IgnoreTeleporters and !self.IgnoreTeleporters[self:ParseIgnorePos(EntPos)])) then
			self:SetInfo(ply, "NoTele", false)
			
			STAchievements:AddCount(ply, "Water Lover")
			
			if(!self:NightmareReset(ply)) then
				ply.ForcePos = Pos + self.AddVector
				ply.ForceAng = Ang
				ply:IncrementFailCount()
			end
			
			ply.LastBlock = nil
			ply.BlockLandTime = nil
			
			self:MonitorDebug(ply, Pos, EntPos, true)
		else
			self:MonitorDebug(ply, Pos, EntPos, false)
		end
	end
end

function GM:MonitorDebug(ply, Pos, EntPos, Passed)
	if(ply.MonitorTeleporters) then
		ply:ChatPrint("Pos: Vector("..self:ParseIgnorePos(Pos)..") EntPos: Vector("..self:ParseIgnorePos(EntPos)..") Passed: "..tostring(Passed))
	end
end

function GM:CanChooseLevel(ply, Level)
	local Table = self.Levels[Level]
	if(!Table) then
		return false
	end
	
	if(self:CompletedAll(ply)) then
		return true
	end
	
	local Levels = self:GetInfo(ply, "Levels", false)
	
	if(Levels) then
		for k,v in pairs(Levels) do
			if(v == true and k >= Level) then
				return false
			end
		end
	else
		Levels = {}
	end
	
	Levels[Level] = false
	
	self:SetInfo(ply, "Levels", Levels)
	
	return true
end

function GM:SetupLevel(ply, Level, nightmareReset)	
	local Table = self.Levels[Level]
	if(!Table) then
		return
	end
	local Reset = false
	umsg.Start("bhop_level_select", ply)
		umsg.Short(4)
		
	if(!ply.Level or (ply.Level and ply.Level <= Level) or self:CompletedAll(ply) or nightmareReset) then
		self:SetInfo(ply, "TeleportPos", false)
		Reset = true
		umsg.Bool(true)
		if ply.Level then
			ply:ChatPrint("Your time has been reset")
		end
	else
		umsg.Bool(false)
	end
	
	umsg.End()

	-- ply:StartTime(Reset and true or false)
	if Reset then 
		ply:ResetJumpCount()
		ply:ResetFailCount()
		ply:ResetTime() 
	end 
	
	if(ply.Winner) then
		ply:KillTrail()
		ply.CanHaveTrail = false
		self:SetInfo(ply, "TeleportPos", false)
	end
	
	ply:SetNWInt("Level", Level)
	
	self:SetInfo(ply, "NoTele", true)
	
	self:SetInfo(ply, "Level", Level)
	self:SetInfo(ply, "Winner", false)
	self:SetInfo(ply, "Col", Table.Col)
	self:SetInfo(ply, "StayTime", Table.StayTime)
	
	self:SetInfo(ply, "CustomSpeed", Table.Speed)
	self:SetInfo(ply, "CustomJumpPower", Table.JumpPower)
	
	if(self:CompletedAll(ply)) then
		self:SetInfo(ply, "WinMoney", 0)
	else
		self:SetInfo(ply, "WinMoney", self:CalcWinMoney(ply, Level))
	end
	
	timer.Destroy( "STGamemodes.Teleport.".. ply:SteamID() )
	
	if(!nightmareReset) then
		ply:GoTeam(TEAM_BHOP, true)
		ply:ChatPrint("You selected '"..tostring(Table.Name).."' as your level. You will receive "..tostring(self:GetInfo(ply, "WinMoney", -1)).." dough when you win.")
	end
end

concommand.Add("bhop_levelselect", function(ply, cmd, args)
	if(ply.NextLevelSelect and ply.NextLevelSelect >= CurTime()) then
		ply:ChatPrint("You can't change your level that fast!")
		return
	end
	-- ply.NextLevelSelect = CurTime() + 30
	
	local Level = args[1]
	if(!Level) then
		return
	end
	Level = tonumber(Level)
	if(Level == nil) then
		return
	end
	
	if(GAMEMODE:CanChooseLevel(ply, Level)) then
		GAMEMODE:SetupLevel(ply, Level)
	else
		ply:ChatPrint("You must choose a harder level!")
	end
end)

concommand.Add("bhop_monitor", function(ply, cmd, args)
	if(!ply:IsSuperAdmin()) then
		return
	end
	ply.MonitorTeleporters = !ply.MonitorTeleporters
	ply:ChatPrint("Monitor Teleporters: "..tostring(ply.MonitorTeleporters))
end)