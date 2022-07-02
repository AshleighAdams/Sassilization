--------------------
-- STBase
-- By Spacetech
--------------------

local PMChatPrint = STGamemodes.PlayerMeta.ChatPrint
local PMPrintMessage = STGamemodes.PlayerMeta.PrintMessage

function STGamemodes.PlayerMeta:FixPrint(Text)
	if(Text and string.len(Text) > 240) then
		ErrorNoHalt("FixPrint: ", Text, "\n")
		return string.sub(Text, 1, 240)
	end
	return Text or ""
end

function STGamemodes.PlayerMeta:ChatPrint(Text)
	return PMChatPrint(self, self:FixPrint(Text))
end

function STGamemodes.PlayerMeta:PrintMessage(Type, Text)
	return PMPrintMessage(self, Type, self:FixPrint(Text))
end

function STGamemodes.PlayerMeta:Teleport(arg1, arg2)
	local params = {}
	
	if type(arg1) == "Vector" then
		params[1] = arg1
	elseif type(arg1) == "Entity" and IsValid(arg1) then
		params[1] = arg1:GetPos()
		params[2] = arg1:GetAngles()
	elseif type(arg1) == "string" then
		local ent = ents.FindByName(arg1)[1]
		if IsValid(ent) then
			params[1] = ent:GetPos()
			params[2] = ent:GetAngles()
		end
	end
	
	if type(arg2) == "Angle" then
		arg2.r = 0
		params[2] = arg2
	end
	
	self:SetPos(params[1])
	self:SetEyeAngles(params[2])
end

function STGamemodes.PlayerMeta:ChangeTeam(Team, Spawn)
	self:SetTeam(Team)
	if(Spawn != false) then
		self:Spawn()
	end
end

function STGamemodes.PlayerMeta:SetCMuted(Bool)
	self.Muted = Bool
	STGamemodes.Muted[self:SteamID()] = Bool
	self:SetNWBool("CMuted", Bool)
end

function STGamemodes.PlayerMeta:IsNearSpawn()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 75)) do
		if(v and v:IsValid() and (v:GetClass() == "info_player_start" or v:GetClass() == "info_player_terrorist" or v:GetClass() == "info_player_counterterrorist")) then
			return true
		end
	end
	return false
end

function STGamemodes.PlayerMeta:IsNearRealSpawn()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), STGamemodes.NearSpawnDistance or 75)) do
		if(v and v:IsValid()) then
			if(table.HasValue(team.GetSpawnPoint(self:Team()), v:GetClass())) then
				return true
			end
		end
	end
	return false
end

function STGamemodes.PlayerMeta:CanBuyWeapons()
	return self:Alive() && (self.IsInBuyzone || self:IsNearRealSpawn())
end

function STGamemodes.PlayerMeta:SeePosition(Pos)
	local Trace = {}
	Trace.start = self:GetPos() + Vector(0, 0, 50)
	Trace.endpos = Pos
	local tr = util.TraceLine(Trace)
	local HitPos = tr.HitPos
	if(HitPos == Pos or HitPos:Distance(Pos) <= 3) then
		return true
	end
	return false
end

function STGamemodes.PlayerMeta:ShouldPlayPainSound()
	return true
end

function STGamemodes.PlayerMeta:PlayPainSound(Damage)
	if(!self:ShouldPlayPainSound()) then
		return
	end
	if(Damage <= 0) then
		return
	end
	self.NextPainSound = self.NextPainSound or CurTime()
	if(CurTime() < self.NextPainSound) then
		return
	end
	self.NextPainSound = CurTime() + 0.2
	local Health = self:Health()
	if(self.Female) then
		if(Health > 68) then
			self:EmitSound(FemalePainSoundsLight[math.random(1, #FemalePainSoundsLight)])
		elseif(Health > 36) then
			self:EmitSound(FemalePainSoundsMed[math.random(1, #FemalePainSoundsMed)])
		else
			self:EmitSound(FemalePainSoundsHeavy[math.random(1, #FemalePainSoundsHeavy)])
		end
	else
		if(Health) > 68 then
			self:EmitSound(MalePainSoundsLight[math.random(1, #MalePainSoundsLight)])
		elseif(Health > 36) then
			self:EmitSound(MalePainSoundsMed[math.random(1, #MalePainSoundsMed)])
		else
			self:EmitSound(MalePainSoundsHeavy[math.random(1, #MalePainSoundsHeavy)])
		end
	end
end

function STGamemodes.PlayerMeta:PlayDeathSound()
	if(self.Female) then
		self:EmitSound(FemaleDeathSounds[math.random(1, #FemaleDeathSounds)])
	else
		self:EmitSound(MaleDeathSounds[math.random(1, #MaleDeathSounds)])
	end
end

function STGamemodes.PlayerMeta:GetJumpCount()
	if !self:IsValid() or not self.jumpCount then return 0 end 
	return self.jumpCount or 0
end

function STGamemodes.PlayerMeta:IncrementJumpCount()
	if (!self:IsValid() or self:IsWinner()) then return end 
	if not self.jumpCount then
		self.jumpCount = 0
	end
	self.jumpCount = self.jumpCount + 1
end

function STGamemodes.PlayerMeta:ResetJumpCount()
	if !self:IsValid() then return end
	self.jumpCount = 0
end

function STGamemodes.PlayerMeta:GetFailCount()
	if !self:IsValid() or not self.failCount then return 0 end 
	return self.failCount
end

function STGamemodes.PlayerMeta:IncrementFailCount()
	if !self:IsValid() then return end
	if not self.failCount then
		self.failCount = 0
	end
	self.failCount = self.failCount+1
end

function STGamemodes.PlayerMeta:ResetFailCount()
	if !self:IsValid() then return end
	self.failCount = 0
end
