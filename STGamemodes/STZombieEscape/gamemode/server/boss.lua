/*---------------------------------------------------------
	Boss Object
---------------------------------------------------------*/
local BOSS = {}

BOSS_MATH		= 1
BOSS_PHYSBOX	= 2

function BOSS:Setup(name,modelEnt,counterEnt)

	local boss = {}
	
	setmetatable( boss, self )
	self.__index = self
	
	boss.Name = name
	boss.Type = -1
	boss.Entities = {}
	boss.Targets = {
		Model = modelEnt,
		Counter = counterEnt
	}
	
	return boss
	
end

function BOSS:IsValid()
	return ( IsValid(self:GetCounter()) and IsValid(self:GetClientModel()) )
end

function BOSS:HasCounter(ent)
	return self.Targets.Counter == ent:GetName()
end

function BOSS:Health()
	if self:GetType() == BOSS_MATH then
		return IsValid(self.Entities.Counter) and self.Entities.Counter:GetOutValue() or -1
	elseif self:GetType() == BOSS_PHYSBOX then
		if !IsValid(self.Entities.Counter) then return -1 end

		-- Update max health
		local health = self.Entities.Counter:Health()
		if !self._MaxHealth or health > self._MaxHealth then
			self._MaxHealth = health
		end

		return health
	end
end

function BOSS:MaxHealth()
	if self:GetType() == BOSS_MATH then
		return IsValid(self.Entities.Counter) and self.Entities.Counter.m_InitialValue or -1
	elseif self:GetType() == BOSS_PHYSBOX then
		return IsValid(self.Entities.Counter) and self._MaxHealth or self:Health()
	end
end

function BOSS:GetType()
	return self.Type
end

function BOSS:GetCounterTarget()
	return self.Targets.Counter
end

function BOSS:GetModelTarget()
	return self.Targets.Model
end

function BOSS:GetName()
	return self.Name
end

function BOSS:GetCounter()

	if !IsValid(self.Entities.Counter) then

		for _, v in pairs(ents.FindByName(self.Targets.Counter)) do
			if IsValid(v) and v:GetName() == self.Targets.Counter then
				self.Entities.Counter = v

				if v:GetClass() == "math_counter" then
					self.Type = BOSS_MATH
				elseif v:GetClass() == "func_physbox_multiplayer" then
					self.Type = BOSS_PHYSBOX
				end
			end
		end

	end

	return self.Entities.Counter
	
end

function BOSS:GetClientModel()
	
	if !IsValid(self.Entities.Model) then

		for _, v in pairs(ents.FindByName(self.Targets.Model)) do
			if IsValid(v) and v:GetName() == self.Targets.Model then
				self.Entities.Model = v
			end
		end

	end

	return self.Entities.Model
	
end


/*---------------------------------------------------------
	Bosses
---------------------------------------------------------*/
GM.Bosses = {}
-- AddBoss( name, model entity, math counter )
function GM:AddBoss(name, propEnt, healthEnt)

	local boss = BOSS:Setup(name,propEnt,healthEnt)
	table.insert(self.Bosses, boss)

end

-- return boss table
function GM:GetBoss(ent)

	for _, boss in pairs(self.Bosses) do
		if boss:HasCounter(ent) then
			return boss
		end
	end
	
	return nil

end


/*---------------------------------------------------------
	Boss Updates
---------------------------------------------------------*/
function GM:BossDamageTaken(ent, activator)

	if !IsValid(ent) then return end
	if self.LastBossUpdate && self.LastBossUpdate + 0.15 > CurTime() then return end -- prevent umsg spam

	local boss = self:GetBoss(ent)
	if boss then
		
		if !boss:IsValid() then return end

		if !boss.bInitialized then

			umsg.Start("BossSpawn")
				umsg.Short( boss:GetClientModel():EntIndex() )
				umsg.String( boss:GetName() )
			umsg.End()

			boss.bInitialized = true

		end

		umsg.Start("BossTakeDamage")
			umsg.Short( boss:GetClientModel():EntIndex() )
			umsg.Short( boss:Health() )
			umsg.Short( boss:MaxHealth() )
		umsg.End()
		
	end
	
	self.LastBossUpdate = CurTime()

end

function GM:BossDeath(ent, activator)

	if !IsValid(ent) then return end

	local boss = self:GetBoss(ent)
	if boss then
		
		if !boss:IsValid() or !boss.bInitialized then return end

		umsg.Start("BossDefeated")
			umsg.Short( boss:GetClientModel():EntIndex() )
		umsg.End()

		boss.bInitialized = false

		Msg("BOSS DEFEATED:\n")
		Msg("\tMath: " .. tostring(boss:GetCounter()) .. "\n")
		Msg("\tProp: " .. tostring(boss:GetClientModel()) .. "\n")
		Msg("\tActivator: " .. tostring(activator) .. "\n")

	end

end

function GM:MathCounterUpdate(ent, activator)
	self:BossDamageTaken(ent, activator)
end

function GM:MathCounterHitMin(ent, activator)
	self:BossDeath(ent, activator)
end

-- Physbox boss handling
hook.Add("EntityTakeDamage", "PhysboxTakeDamage", function(ent, inflictor, attacker, amount, dmginfo)
	GAMEMODE:BossDamageTaken(ent, attacker)
end)

hook.Add("EntityRemoved", "PhysboxRemoved", function(ent)
	GAMEMODE:BossDeath(ent, nil)
end)